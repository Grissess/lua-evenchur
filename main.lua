package.path = "./?.lua;" .. package.path
math.randomseed(os.time())
local evenchur = require('evenchur')

while true do
	print(evenchur.print_status())
	io.write(evenchur.colors.prompt .. evenchur.state.mode .. "> ")
	local line = io.read()
	if line == nil then
		print('\x1b[1;37;41mIn a rare turn of events, your sword decides to fall on you. Better luck next time!\x1b[m')
		break
	end
	line = line:gsub("\n", "")
	print(evenchur.colors.reset .. evenchur.exec(line:gsub("\n", "")))
	local res = evenchur.game.post_tick()
	if res then print(res) end
	if evenchur.state.finished ~= nil then
		if type(evenchur.state.finished) == "string" then
			print(evenchur.state.finished)
		else
			print("The game is over. Goodbye!")
		end
		break
	end
end
