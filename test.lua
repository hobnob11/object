local Object = require "Object"

assert(Object)
assert(Object.extends)
assert(Object.new)

local object = Object()

assert(object)
assert(object:is(Object))
assert(not object:is(Child))
assert(not object:is(GrandChild))
assert(not object:is(Sibling))
assert(not object:is(Meta))
assert(not object:is(MetaChild))

local Child = Object:extends()
local GrandChild = Child:extends()

function Child:new (a)
	self.a = a
end
function GrandChild:new (b, a)
	self.__super.new(self, a)
	self.b = b
end

Child.NUMBER = 3
GrandChild.NUMBER = 11

local a = 10
local b = 15
local child = Child(a)
local grandChild = GrandChild(b, a)

assert(child:is(Object))
assert(child:is(Child))
assert(not child:is(GrandChild))

assert(grandChild:is(Object))
assert(grandChild:is(Child))
assert(grandChild:is(GrandChild))

assert(child.NUMBER == Child.NUMBER)
assert(not (child.NUMBER == GrandChild.NUMBER))
assert(not (grandChild.NUMBER == Child.NUMBER))
assert(grandChild.NUMBER == GrandChild.NUMBER)

assert(child.a == a)
assert(grandChild.a == a and grandChild.b == b)

assert(GrandChild.__class == GrandChild)
assert(GrandChild.__super == Child)
assert(grandChild.__class == GrandChild)
assert(grandChild.__super == Child)
assert(grandChild.__class.__super == Child)
assert(grandChild.__super.__super == Object)

local Sibling = Object:extends()

function Sibling:new (p)
	self.p = p ^ 2
end

local p = 6
local sibling = Sibling(p)

assert(not sibling.NUMBER)
assert(sibling.p == p ^ 2)

local Meta = Object:extends()

function Meta:new (x, y)
	self.x = x
	self.y = y
end
function Meta.__add (self, op)
	return self.__class(self.x + op.x, self.y + op.y)
end

local x = 5
local y = -2
local meta = Meta(x, y)
local meta2 = Meta(x, y)

assert(rawget(getmetatable(meta), "__add"))

local sum = meta + meta2

assert(sum:is(Meta))
assert((sum.x == meta.x + meta2.x) and (sum.y == meta.y + meta2.y))

io.write("\27[1;32;40mSuccess\27[0m\n")
io.flush()
return true
