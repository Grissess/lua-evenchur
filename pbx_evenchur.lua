local evenchur = require('evenchur')
local espeak = require('espeak')

for k, _ in pairs(evenchur.colors) do
	evenchur.colors[k] = ""
end

evenchur.state.debug = false

local function go_north() return "go north" end
local function go_west() return "go west" end
local function go_east() return "go east" end
local function go_south() return "go south" end

local function choose_inv(...)
	local invs = {...}
	local things = {}
	for i, inv in ipairs(invs) do
		for k, v in pairs(inv) do
			table.insert(things, k)
		end
	end
	if #things == 0 then
		espeak("there's nothing you can do that to")
		return
	end
	for i, k in ipairs(things) do
		espeak("dial " .. tostring(i) .. " for " .. tostring(k))
	end
	app.read("inv", "" , 1)
	local num = tonumber(channel.inv:get())
	return things[num]
end

local function take()
	local thing =  choose_inv(evenchur.state.get_room():get_inv())
	if thing ~= nil then
		return "take " .. thing
	end
end

local function put()
	local thing =  choose_inv(evenchur.state.inv)
	if thing ~= nil then
		return "put " .. thing
	end
end

local function look()
	local thing = choose_inv(evenchur.state.get_room():get_inv(), evenchur.state.inv)
	if thing ~= nil then
		return "look " .. thing
	end
end

local function use()
	local thing = choose_inv(evenchur.state.inv)
	if thing ~= nil then
		return "use " .. thing
	end
end

local bad_menu_func = {
	["1"] = take,
	["2"] = use,
	["3"] = look,
	["4"] = put,
}
local bad_menu_say = {
	take = 1,
	use = 2,
	look = 3,
	put = 4,
}
local function bad_menu()
	for k, v in pairs(bad_menu_say) do
		espeak("To " .. k .. "............... dial " .. tostring(v))
	end
	app.read("bad", "", 1)
	local num =channel.bad:get()
	local f = bad_menu_func[num]
	if f == nil then
		espeak("bad menu number")
		return
	end
	return f()
end


local function good_help()
	espeak("To move, use 2, 4, 6, or 8 to go north, west, east, or south, respectively.")
	espeak("To take or put, use 1 or 3, respectively.")
	espeak("To use, dial 5; to look, dial 7.")
end

local bad_moves = {north = 1, west = 2, east = 3, south = 4}
local function bad_help()
	for k, v in pairs(bad_moves) do
		espeak("To go " .. k .. ", dial " .. tostring(v))
	end
	espeak("For the mmenu with all the other options, dial 6")
end

local commands = {
	good = {
		["0"] = good_help,
		["1"] = take,
		["2"] = go_north,
		["3"] = put,
		["4"] = go_west,
		["5"] = use,
		["6"] = go_east,
		["7"] = look,
		["8"] = go_south,
	},
	bad = {
		["0"] = bad_help,
		["1"] = go_north,
		["2"] = go_west,
		["3"] = go_east,
		["4"] = go_south,
		["6"] = bad_menu,
	},
}

function run_game_with(cmds)
	espeak("Welcome to COSI evenchur. Dial 0 for help.")
	channel.TIMEOUT('response'):set(30)
	while evenchur.state.finished == nil do
		espeak(evenchur.print_status())
		app.read("num", "", 1)
		local num = channel.num:get()
		if num == "" or num == nil then
			app.hangup()
			return  -- hung up
		end
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
	end
	espeak("The game is over. Goodbye.")
	app.hangup()
end

return function(ctx, misc)
	misc.help.adventure = function()
		espeak('dial 600 or 601')
	end

	ctx['600'] = function() run_game_with(commands.good) end
	ctx['601'] = function() run_game_with(commands.bad) end
end

