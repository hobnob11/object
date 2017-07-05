local extends

--- Metatable used for each class created.
-- `__call` is an instance constructor.
-- `__index` and `_index` are used when accessing variables inside of class and its hierarchy when accessing class itself.
local metaclass do
	local function _index (self, key)
		local super = rawget(self, "__super")
		if super then
			local value = rawget(super, key)
			if value ~= nil then
				return value
			end
			return _index(super, key)
		end
	end
	metaclass = {
		__index = function (self, key)
			if key == "extends" then
				return extends
			end
			return _index(self, key)
		end,
		__call = function (self, ...)
			local o = setmetatable({}, self)
			self.new(o, ...)
			return o
		end
	}
end

--- Method for checking if instance is of selected class.
-- Usage: `instance:is(Object)`.
-- Also works with classes: `Object:is(Object)`.
local is do
	local function _is (self, class)
		if self then
			if self == class then
				return true
			end
			return _is(rawget(self, "__super"), class)
		end
	end
	function is (self, class)
		local mt = getmetatable(self)
		if mt ~= metaclass then
			return _is(mt, class)
		end
		return _is(self, class)
	end
end

--- Indexing metamethod for instances.
local index do
	local function _index (self, key)
		if self then
			local value = rawget(self, key)
			if value ~= nil then
				return value
			end
			return _index(rawget(self, "__super"), key)
		end
	end
	function index (self, key)
		return _index(getmetatable(self), key)
	end
end

--- Class creation/extension function.
-- Class table is used as metatable for instance of that class. `Metaclass` table is used as metatable for classes.
function extends (parent)
	local self = setmetatable({}, metaclass)
	rawset(self, "__class", self)
	rawset(self, "__index", index)
	rawset(self, "__super", parent)
	return self
end

--- Base class used as root for class hierarchy.
local Object = extends(nil)
rawset(Object, "new", function () end)
rawset(Object, "is", is)
return Object
