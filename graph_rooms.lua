package.path = "./?.lua;" .. package.path
local evenchur = require('evenchur')

print('digraph {')
for name, rm in pairs(evenchur.game.rooms) do
	print('', name, '[label="\\N\\n' .. rm.name .. '"]')
	for dir, rem in pairs(rm.links) do
		print('', '', name, '->', rem, '[label="' .. dir .. '"]')
	end
end
print('}')
