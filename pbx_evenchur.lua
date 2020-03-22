local evenchur = require('evenchur')
local espeak = require('espeak')

for k, _ in pairs(evenchur.colors) do
	evenchur.colors[k] = ""
end

local function go_north() return "go north" end
local function go_west() return "go west" end
local function go_east() return "go east" end
local function go_south() return "go south" end

local function good_help()
	espeak("To move, use 2, 4, 6, or 8 to go north, west, east, or south, respectively.")
end

local bad_moves = {north = 1, west = 2, east = 7, south = "*"}
local function bad_help()
	for k, v in pairs(bad_moves) do
		espeak("To go " .. k .. ", dial " .. tostring(v))
	end
end

local commands = {
	good = {
		["0"] = good_help,
		["2"] = go_north,
		["4"] = go_west,
		["6"] = go_east,
		["8"] = go_south,
	},
	bad = {
		["0"] = bad_help,
		["1"] = go_north,
		["2"] = go_west,
		["7"] = go_east,
		["*"] = go_south,
	},
}

function run_game_with(cmds)
	while evenchur.state.finished == nil do
		espeak(evenchur.print_status())
		app.read("num", "", 1)
		local num = channel.num:get()
		local func = cmds[num]
		if func ~= nil then
			local cmd = func()
			if cmd then
				espeak(evenchur.exec(cmd))
				local res = evenchur.game.post_tick()
				if res then
					espeak(res)
				end
			end
		else
			espeak("That number is not valid. Dial 0 for help.")
		end
	end
	if type(evenchur.state.finished) == "string" then
		espeak(evenchur.state.finished)
	else
		espeak("The game is over. Goodbye.")
	end
	app.hangup()
end

return function(ctx, misc)
	misc.help.adventure = function()
		espeak('dial 600 or 601')
	end

	ctx['600'] = function() run_game_with(commands.good) end
	ctx['601'] = function() run_game_with(commands.bad) end
end

