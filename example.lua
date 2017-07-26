local Object = require "Object"

local Point = Object:extends() -- creating new class by extending basic class
function Point:new (x, y) -- defining function called by constructor for newly created class
	self.x = x -- instance created by constructor is `self`
	self.y = y
end -- no returns needed

Point.NUMBER = 10 -- setting some global values for class

function Point:__tostring () -- metamethod used with `tostring()`
	return "Point<" .. self.x .. ", " .. self.y .. ">"
end

local a = Point(3, 2) -- create new instance by calling class
print(tostring(a))

assert(a:is(Point))  -- you can also check if object is instance of class
assert(a:is(Object)) -- use `is()` method for it

local Foo = Point:extends() -- you can extend whatever class you want
function Foo:new (str, x, y)
	Foo.__super.new(self, x, y) -- call super constructor first
	self.str = str -- do whatever else is left to be done
end

function Foo:__tostring () -- metamethods are not inherited
	return "Foo(" .. self.str .. ")<" .. self.x .. ", " .. self.y .. ">"
end

local b = Foo("lorem", 7, -1)
print(tostring(b))
