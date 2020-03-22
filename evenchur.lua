local Inv = {}
Inv.mt = {
	__index = Inv,
}

local colors = {
	reset = "\x1b[m",
	prompt = "\x1b[1;37m",
	item = "\x1b[1;36m",
	status = "\x1b[32m",
	problem = "\x1b[33m",
	error = "\x1b[1;31m",
	extreme = "\x1b[1;37;45;5m",
	debug = "\x1b[34m",
	npc = {
		good = "\x1b[1;32m",
		bad = "\x1b[1;35m",
	}
}
colors.big_problem = colors.error

local dup_success = {
	"Your stack of $OBJECT grows.",
	"You have another $OBJECT.",
	"You get another $OBJECT.",
}

local mat_success = {
	"You suddenly find yourself in possession of $A $OBJECT.",
	"$A $OBJECT appears on your person.",
	"$A $OBJECT materializes out of thin air.",
}

local trans_empty = {
	"Where do you want to go?",
	"Where are you going?",
}

local mark_no_wb = {
	"You don't see any whiteboards for you to use this on.",
	"You don't see an appopriate drawing surface for this.",
}

local go_fail = {
	"You cannot go $DIRECTION.",
	"Your passage $DESCR is blocked.",
	"A wall greets you $DESCR.",
	"The path $DESCR is impassible.",
}

local go_empty = {
	"Go where?",
	"Go which direction?",
	"Where are you going?",
}

local go_immobile = {
	"You find that you can't move.",
	"You can't move!",
	"For some reason, you can't move.",
}

local use_empty = {
	"Use what?",
	"Use which?",
	"What will you use?",
}

local bad_name = {
	"I'm not sure what $A $OBJECT is.",
	"What's $A $OBJECT?",
	"I don't know what $A $OBJECT is.",
}

local not_in_inv = {
	"You don't have $A $OBJECT.",
	"You have no $OBJECT.",
	"You don't find $A $OBJECT on your person.",
}

local use_not_useful = {
	"The $OBJECT doesn't seem useful.",
	"You can't find out how to use the $OBJECT.",
}

local use_ext_not_useful_except_inv = {
	"It seems like the $OBJECT would be more useful if you were lugging it around.",
	"How do you use $A $OBJECT from across the room?",
	"Maybe you should try picking up the $OBJECT."
}

local use_ext_not_useful = {
	"The $OBJECT doesn't seem useful.",
	"You can't find out how to use the $OBJECT.",
}

local use_ext_not_useful_stupid = {
	"Please find the nearest real-world instance of $A $OBJECT, and ask somebody how to use it.",
	"Maybe you should read an instruction manual for $A $OBJECT.",
	"You know, maybe you're going about this the wrong way.",
	"Have you ever seen $A $OBJECT used in real life?",
}

local use_no_used = {
	"Use what on that?",
	"What are you using on that?",
	"What will you use on that?",
}

local used_empty = {
	"What do you want to use this on?",
	"What thing do you want to use this with?",
}

local take_empty = {
	"Take what?",
	"Take which?",
	"What are you taking?",
}

local take_room_empty = {
	"There is nothing here.",
	"You can't take anything because there's nothing here.",
	"There is nothing here for you to take.",
}

local take_no_item = {
	"There are no $OBJECTs here.",
	"You can't find $A $OBJECT in here.",
	"Not a single $OBJECT can be found.",
}

local take_success = {
	"You take $A $OBJECT.",
	"You take a single $OBJECT.",
}

local take_object_static = {
	"The $OBJECT is fixed to the floor.",
	"The $OBJECT is stuck.",
	"You can't budge the $OBJECT.",
	"The $OBJECT won't move.",
}

local take_too_heavy = {
	"You can't carry the $OBJECT because it's too heavy.",
	"You can't carry $A $OBJECT; you're already carrying too much.",
	"You're already holding too much to carry the $OBJECT.",
}

local put_empty = {
	"Put what?",
	"Put which?",
	"What are you putting down?",
}

local put_no_dest = {
	"You can't find $A $OBJECT to put that into.",
	"There's no $OBJECT for you to put that into.",
}

local put_no_inv = {
	"The $OBJECT doesn't have any space for you to put that.",
	"The $OBJECT can't accept that.",
	"There's no place in the $OBJECT for you to put that.",
}

local put_success = {
	"You put the $OBJECT down.",
	"You place the $OBJECT in the room.",
}

local put_success_into = {
	"You put the $OBJECT into the $DEST.",
	"You place the $OBJECT into the $DEST.",
	"You gently shove the $OBJECT into the $DEST.",
}

local cs_names = {
	"THE MAINFRAME OF EXISTENCE EMITS INCOMPREHENSIBLE MELODIES WHICH BEGIN THE UNIVERSE." ,
	"THE VERY FABRIC OF BEING BENDS TO YOUR BECK AND CALL.",
	"THE AIR IS HEAVY WITH THE SCENT OF OMNISCIENCE.",
	"YOU FEEL THE TOUCH OF ANOTHER UNIVERSE SPINNING INTO EXISTENCE. IT IS RIGHT AND GOOD.",
}

local cs_err = {
	"YOU IMPUGN THE NATURE OF BEING WITH YOUR BROKEN PROGRAMS. IT TELLS YOU THAT YOU SHOULD BE ASHAMED. YOU ARE NOW ASHAMED.",
	"THE BENEVOLENT CONSTITUENTS OF EVERYTHING GLADLY ASSIST YOU IN PRETENDING THAT YOU NEVER WROTE SUCH ERRANT CODE.",
	"YOU WHISPER SWEET IMPOSSIBILITIES OF LOGIC INTO THE VOID OF PURE NOTHING, WHERE THEY HARMLESSLY VANISH INSTEAD OF TEARING THE UNIVERSE ASUNDER.",
}

local cs_success = {
	"YOU WHISPER TO THE UNIVERSE, AND IT WHISPERS BACK TO YOU: $RESULT",
	"AS IF IT HAD BEEN A FACT OF EXISTENCE THE ENTIRE TIME, A $RESULT POPS INTO YOUR MIND.",
	"AN INFINITE HIERARCHY OF STRUCTURE BEARS DOWN UPON THEE AND CALLS $RESULT INTO EXISTENCE.",
}

local hd_empty = {
	"You stare blanky at the " .. colors.item .. "hammerdrill" .. colors.reset .. " in $RAWROOM.",
	"The " .. colors.item .. "hammerdrill" .. colors.reset .. " beckons from within $RAWROOM.",
	"You're in $RAWROOM, holding a " .. colors.item .. "hammerdrill" .. colors.reset .. ".",
}

local hd_no_name = {
	"As much as you'd like to, you cannot fathom breaking this wall into a nameless room.",
	"You hesitate, thinking about the name of the room you're about to break into.",
	"A room on the other side of the wall beckons your drill, but you might want to give it a name.",
}

local hd_wrong_name_type = {
	"You're pretty sure you can only give one name to a room.",
	"It seems odd that a room would have multiple names.",
	"That room probably doesn't have that many names.",
}

local hd_no_dir = {
	"You're not sure which wall to drill.",
	"Which direction do you want to go?",
	"What direction are you drilling in?",
}

local hd_wrong_dir_type = {
	"You're pretty sure you can't drill in multiple directions at once.",
	"Choose one, and only one, direction to drill in.",
	"Out of those, which singular direction do you actually want to drill in?",
}

local hd_bad_reverse = {
	"You would carve a link $DESC, but you can't figure out what the reverse direction would be (try 'norvs true' or 'noreverse true').",
	"You can't figure out what the opposite of $DIR is (try 'norvs true' or 'noreverse true').",
}

local hd_success = {
	"You smash through the wall and find $ROOM on the other side.",
	"After some loud drilling, you create a passage to $ROOM.",
	"As the chips of concrete fall and the dust subsides, $ROOM peeks through the new hole.",
}

local tino_kills = {
	"administers a Tino exam!",
	"hits you with a log!",
	"summons a dragon!",
	"pulverizes you!",
	"measures you!",
}

local shell_no_code = {
	"You look dumbly at the terminal. A Lua prompt blinks dumbly back at you.",
	"The Lua prompt doesn't know what to run.",
}

local shell_syntax_err = {
	"Before it can even run, Lua flatly responds: $ERROR",
	"The Lua prompt looks at you, unmoved, and says $ERROR.",
	"With a total lack of comprehension, the Lua prompt only manages: $ERROR",
}

local shell_runtime_err = {
	"The Lua you wrote was malignant, due to $ERROR.",
	"Lua tried your program, but crashed with $ERROR.",
	"All looked well until $ERROR happened.",
}

local shell_success = {
	"The shell dutifully responds to you: $RESULT",
	"Almost immediately, the Lua prompt spits $RESULT back at you.",
	"A $RESULT is made available to you.",
}

local vowel = {
	a = true,
	e = true,
	i = true,
	o = true,
	u = true,
}

local link_alias = {
	n = "north",
	s = "south",
	e = "east",
	w = "west",
	u = "up",
	d = "down",
}

local link_reverse = {
	north = "south",
	south = "north",
	east = "west",
	west = "east",
	up = "down",
	down = "up",
}

local link_desc = setmetatable({
	north = "to the north",
	south = "to the south",
	east = "to the east",
	west = "to the west",
	up = "above you",
	down = "below you",
}, {__index = function(s, k)
	local v = 'to the ' .. k
	s[k] = v
	return v
end})

local prepositions = {
	on = true,
	["in"] = true,
	with = true,
	from = true,
}

local function to_key_values(rest)
	local ret = {}
	local k = nil
	for idx, word in ipairs(rest) do
		if word == "and" then
			-- pass
		else
			if k ~= nil then
				if ret[k] ~= nil then
					if type(ret[k]) ~= "table" then
						ret[k] = {ret[k]}
					end
					table.insert(ret[k], word)
				else
					ret[k] = word
				end
				k = nil
			else
				k = word
			end
		end
	end
	return ret
end

local game

function Inv.new()
	return setmetatable({}, Inv.mt)
end

setmetatable(Inv, {__call = function(...) return Inv.new() end})

function Inv:clone()
	local new = Inv()
	for k, v in pairs(self) do new[k] = v end
	return new
end

function Inv:get(item)
	local amt = self[item]
	if amt == nil then amt = 0 end
	return amt
end

function Inv:add(item, num)
	local amt = self:get(item)
	amt = amt + num
	if amt <= 0 then
		self[item] = nil
	else
		self[item] = amt
	end
end

function Inv:is_empty()
	return next(self) == nil
end

function Inv:total_weight()
	local sum = 0
	for k, v in pairs(self) do
		local obj = game.objects[k]
		if obj ~= nil and obj.weight ~= nil then
			sum = sum + obj.weight * v
		end
	end
	return sum
end

local Room = {}
Room.mt = {
	__index = Room,
}

function Room.from(obj)
	if obj == nil then return nil end
	return setmetatable(obj, Room.mt)
end
setmetatable(Room, {__call = function(_room, obj) return Room.from(obj) end})

function Room:get_inv()
	if self.inv == nil then self.inv = Inv() end
	return self.inv
end

function Room:get_links()
	if self.links == nil then self.links = {} end
	return self.links
end

function detect_inv_cycle(obj, seen)
	if obj.inv then
		for oname, amt in pairs(obj.inv) do
			local iobj = game.objects[oname]
			if seen[iobj] then return true end
			seen[iobj] = true
			if detect_inv_cycle(iobj, seen) then return true end
		end
	end
	return false
end

function describe_npc(npc)
	return colors.npc[npc.dispos] .. npc.name .. colors.reset
end

local state = {
	inv = Inv(),
	room = "COSI",
	carry_limit = 30,
	debug = true,
	mode = "evenchur",
	cs_err_cnt = 0,
}

function ai_wander(self)
	local links = state.get_room(self.room):get_links()
	if next(links) == nil then return false end
	local dirs = {}
	for dir, _ in pairs(links) do
		table.insert(dirs, dir)
	end
	local which = dirs[1 + math.floor(math.random() * #dirs)]
	self.room = links[which]
	--print(colors.debug .. self.name .. " moves to " .. self.room .. colors.reset)
	return true
end

game = {
	rooms = {
		COSI = {
			name = "COSI",
			links = {
				south = "SC3Hall",
				east = "ITL"
			},
			inv = Inv.clone({
				fridge = 1,
				chair = 1,
				fire_extinguisher = 1,
				dumbbell = 1,
				vacuum = 1,
			}),
		},
		ITL = {
			name = "the ITL",
			desc = "There is a class here right now. People are staring at you.",
			links = {
				south = "SC3Hall",
				west = "COSI",
			},
		},
		ServerRoom = {
			name = "the server room",
			desc = "It is loud and noisy in here; the primary occupants are humming busily.",
			links = {
				south = "ITL",
			},
			on_fire = true,
			inv = Inv.clone({
				duplicator = 1,
				materializer = 1,
				transporter = 1,
				flamethrower = 1,
			}),
		},
		SC3Hall = {
			name = "a hallway outside COSI",
			desc = "The Science Center's 3rd floor hallway stretches out afore and behind you.",
			links = {
				north = "COSI",
				west = "Concrete",
				south = "SC3MBathroom",
				east = "SC3Collins",
				down = "SC2EastStairwell",
			},
		},
		SC3MBathroom = {
			name = "the men's restroom near COSI",
			desc = "Despite the vigilant efforts of Carol, the room has a noticeable odor.",
			links = {
				north = "SC3Hall",
			},
		},
		SC3JankLanding = {
			name = "a small annex with an elevator door",
			desc = "You find your yourself in a small room with an open connection to a nearby hallway. You see some equipment no doubt used by the maintainance personnel and, perhaps most importantly, an elevator door.",
			links = {
				north = "Concrete"
			}
		},
		Concrete = {
			name = "Concrete Cafe",
			desc = "The Cafe is closed right now. Everything is spotless, except for the pockmark from where a brick crashed through the skylight. A stairwell is tucked behind a corner.",
			links = {
				east = "SC3Hall",
				down = "SC2WestStairwell",
				south = "SC3JankLanding",
			},
			inv = Inv.clone({
				fork = 1,
				spoon = 1,
			}),
		},
		Outside = {
			name = "the outside world",
			desc = "It is an overcast, Potsdam day; the clouds are threatening snow, despite being quite warm.",
			links = {
				north = "Concrete",
			},
		},
		SC3Collins = {
			name = "A hallway near Tony Collins' office",
			desc = "The hallway corners north and west.",
			links = {
				west = "SC3Hall",
				north = "SC3North",
			},
			inv = Inv.clone({
				key = 1,
			}),
		},
		Collins = {
			name = "Tony Collins' office",
			desc = "Tony Collins is here; he is looking at you, slightly perplexed as to how you got here.",
			links = {
				west = "SC3Collins",
			},
			inv = Inv.clone({
				collins = 1,
			}),
		},
		SC3North = {
			name = "a hallway near the Chairwell",
			desc = "This is the northernmost part of the Science Center's 3rd-floor hallway.",
			links = {
				south = "SC3Collins",
				west = "ChairwellBottom",
			},
		},
		ChairwellBottom = {
			name = "the bottom of the Chairwell",
			desc = "The ramp goes up to the north.",
			links = {
				north = "ChairwellTop",
				east = "SC3North",
			},
		},
		ChairwellTop = {
			name = "the top of the Chairwell",
			desc = "The ramp goes down to the south.",
			links = {
				south = "ChairwellBottom",
			},
		},
		SC2EastStairwell = {
			name = "the area one floor below COSI",
			desc = "There are stairs going up and down a floor. A poster labelled \"Chemistry\" is on the wall.",
			links = {
				up = "SC3Hall",
				down = "SC1EastStairwell",
				east = "OutsidePeplOffice",
				west = "SC2Hallway",
			},
		},
		OutsidePeplOffice = {
			name = "Outside Peploski's Office",
			desc = "You are in the part of Science Center ouside Peploski's Office. There is a door outside, but it's frozen shut.",
			links = {
				west = "SC2EastStairwell",
				south = "PeplOffice",
			},
		},
		PeplOffice = {
			name = "Peploski's Office",
			desc = "The room is a standard office for a professor. Stochiometry is written on the whiteboard.",
			links = {
				north = "OutsidePeplOffice",
			},
			inv = Inv.clone({
				whiteboard = 1,
				marker = 1,
				strange_flask = 1,
			}),
		},
		ComputationalSingularity = {
			name = "the Core of the Computational Singularity",
			desc = colors.extreme .. cs_names[1] .. colors.reset,
			links = {
				up = "ServerRoom",
			},
		},
		FreshmenPhysLab = {
			name = "the Freshmen Physics Lab",
			desc = "There is a lab session currently being held. The TA looks at you while the students work on their labs.",
			links = {
				north = "SC2WestStairwell",
			},
		},
		SC2WestStairwell = {
			name = "the area one floor below Concrete Cafe",
			desc = "There are stairs going up and down a floor.",
			links = {
				south = "FreshmenPhysLab",
				up = "Concrete",
				east = "SC2Hallway"
			}
		},
		SC2Hallway = {
			name = "the hallway between the stairwells",
			desc = "", -- Description pending
			links = {
				south = "ThomasOffice",
				west = "SC2WestStairwell",
				east = "SC2EastStairwell",
			},
		},
		ThomasOffice = {
			name = "Thomas's Office",
			desc = "The room is a standard office for a professor. Physics problems are written out on the whiteboard.",
			links = {
				north = "SC2Hallway",
			},
			inv = Inv.clone({
				whiteboard = 1,
				marker = 1,
				peculiar_gizmo = 1,
			}),
		},
		SC1EastStairwell = {
			name = "the area two floors below COSI",
			desc = "There are stairs going up a floor. There are leaves scattered everywhere from a nearby door.",
			links = {
				up = "SC2EastStairwell",
				west = "OutsideFreshmenChemLab",
			},
		},
		OutsideFreshmenChemLab = {
			name = "outside the Freshmen Chemistry Lab and Chemistry TA office",
			desc = "You are in a typical Science Center hallway. Funny comics dot the walls.",
			links = {
				south = "FreshmenChemLab",
				east = "SC1EastStairwell",
			},
		},
		FreshmenChemLab = {
			name = "the Freshmen Chemistry Lab",
			desc = "You see some general chemistry being conducted in the room before you. Interesting lab material is drawn on the whiteboard",
			links = {
				north = "OutsideFreshmenChemLab",
			},
			inv = Inv.clone({
				whiteboard = 1,
				marker = 1,
			}),
		},
	},
	objects = {
		fridge = {name = "refrigerator", desc = "A cold box usually filled with refreshing beverages and tasty victuals.", inv = Inv.clone({moxie = 1}), weight = 20},
		moxie = {
			name = "Moxie soda",
			desc = "The bright orange can's fizzy liquid contents beckon to your parched throat.",
			weight = 0.1,
			use = function()
				state.inv:add("movie", -1)
				state.inv:add("empty_moxie", 1)
				return "You quaff the sparkling, anise-flavored beverage."
			end,
		},
		empty_moxie = {
			name = "empty Moxis soda",
			desc = "It is still bright orange, but now an empty, frail can.",
		},
		fire_extinguisher = {
			name = "fire extinguisher",
			desc = "It's a full and rather-heavy red cylinder with a nozzle, handle, and safety pin.",
			weight = 5,
			use = function()
				state.inv:add("fire_extinguisher", -1)
				state.inv:add("empty_fire_extinguisher", 1)
				local res = "You empty the canister all over yourself. You choke up the white dust.\n"
				if state.fireproof then
					res = res .. "You are still fireproof."
				else
					state.fireproof = true
					res = res .. "You are now fireproof."
				end
				state.get_room().extinguished = true
				return res
			end,
		},
		empty_fire_extinguisher = {
			name = "empty fire extinguisher",
			desc = "It's a slightly-less-heavy red cylinder wiht a nozzle and handle, covered in a fine white powder.",
			weight = 3,
			use = function()
				state.inv:add("empty_fire_extinguisher", -1)
				state.inv:add("fire_extinguisher", 1)
				return "Because you need it, and definitely not because some programmer was lazy, Richard Stallman descends from the heavens and refills your fire extinguisher."
			end,
		},
		vacuum = {
			name = "vacuum",
			desc = "It's a canister model with a small red bin and a long black hose ending in a brush head. It has a long cord, and is quite loud.",
			weight = 3,
			use = function()
				local room = state.get_room()
				if room.extinguished then
					room.extinguished = nil
					return "You clean the white dust from the room. " .. colors.problem .. "It is now vulnerable to flames again." .. colors.reset
				elseif state.fireproof then
					state.fireproof = nil
					return "You clean the white dust from yourself. " .. colors.problem .. "You are vulnerable to the flames again." .. colors.reset
				else
					if math.random() < 0.05 then
						local inv = room:get_inv()
						local k = next(inv)
						if k ~= nil then
							local oname, tpl, obj = get_obj_params(k)
							inv:add(oname, -1)
							return colors.big_problem .. "While tidying the room, you accidentally suck up " .. tpl.A .. " " .. tpl.OBJECT .. colors.big_problem .. "." .. colors.reset
						end
					end
					return "You tidy the place a bit, without much effect."
				end
			end,
		},
		key = {
			name = "Sargent key",
			desc = "It's a small, brass key with careful bitting, labeled `J`.",
			weight = 0.02,
			use = function()
				local roomf = game.objects.key.per_room[state.room]
				if roomf ~= nil then
					return roomf()
				end
				return "You can't seem to find a place to use this."
			end,
			per_room = {
				SC3Collins = function()
					state.get_room("SC3Collins"):get_links().east = "Collins"
					return "You feel the key turn smoothly in the office door."
				end,
				Concrete = function()
					state.get_room("Concrete"):get_links().south = "Outside"
					return "The key turns in the air. A portage in the game opens to the south."
				end,
				COSI = function()
					state.get_room("COSI"):get_links().north = "ServerRoom"
					return "With a click, the dead bolt retracts from the server room door."
				end,
				ITL = function()
					state.get_room("ITL"):get_links().north = "ServerRoom"
					return "With a click, the dead bolt retracts from the server room door."
				end,
			},
		},
		chair = {
			name = "green swivel chair",
			desc = "It has a back and a lift lever, and rolls across the carpet with ease.",
			weight = 2,
			inv = Inv.new(),
			use = function()
				if state.room == "ChairwellTop" then
					local ret = "You ride down the chairwell. Wheeeeee!"
					if game.objects.chair.inv:total_weight() >= 25 then
						ret = ret .. colors.big_problem .. "\nYou quickly find that the chair is too heavy to stop. You crash through the wall into the...server room?" .. colors.reset
						state.room = "ServerRoom"
						state.get_room("ServerRoom"):get_links().north = "ChairwellBottom"
						state.get_room("ChairwellBottom"):get_links().south = "ServerRoom"
						state.get_room("ITL"):get_links().north = "ServerRoom"
						state.get_room("COSI"):get_links().north = "ServerRoom"
						if game.objects.chair.inv:get("fridge") > 0 and game.objects.fridge.inv:get("fork_bomb") > 0 then
							ret = ret .. colors.extreme .. "\nA SINGULARITY APPEARS WITHIN THE CONFINES OF THE SERVER ROOM." .. colors.reset
							state.get_room("ServerRoom"):get_links().down = "ComputationalSingularity"
						end
					else
						state.room = "ChairwellBottom"
					end
					return ret
				end
				return "You stare blankly at the chair. " .. colors.problem .. "It stares back." .. colors.reset
			end,
		},
		collins = {
			name = "Tony Collins",
			desc = "He is a dapper Australian university president.",
			use = function()
				return "He turns and glares at you."
			end,
		},
		duplicator = {
			name = "Duplicator",
			desc = "It appears to be made of bits.",
			weight = 0.1,
			use = function(rest)
				if #rest < 1 then
					return choose(used_empty)
				end
				local oname, tpl, obj = get_obj_params(rest[1])
				if obj == nil then
					return template(choose(bad_name), tpl)
				end
				if state.inv:get(oname) < 1 then
					return template(choose(not_in_inv), tpl)
				end
				state.inv:add(oname, 1)
				return template(choose(dup_success), tpl)
			end,
		},
		materializer = {
			name = "Materializer",
			desc = "It appears to be made of bits.",
			weight = 0.1,
			use = function(rest)
				if #rest < 1 then
					return choose(used_empty)
				end
				local oname, tpl, obj = get_obj_params(rest[1])
				if obj == nil then
					return template(choose(bad_name), tpl)
				end
				state.inv:add(oname, 1)
				return template(choose(mat_success), tpl)
			end,
		},
		transporter = {
			name = "Transporter",
			desc = "It appears to be made of bits.",
			weight = 1.5,
			use = function(rest)
				if #rest < 1 then return choose(trans_empty) end
				state.room = rest[1]
				return colors.problem .. "Whoosh!" .. colors.reset
			end,
		},
		shell = {
			name = "Shell",
			desc = "It appears to be made of bits.",
			weight = 0.1,
			use = function(rest)
				if #rest < 1 then
					return colors.problem .. choose(shell_no_code) .. colors.reset
				end
				local ex = table.concat(rest, " ")
				if ex:sub(0, 1) == "=" then ex = "return " .. ex:sub(2) end
				local chunk, err = load(ex, "=(shell.use)", 'bt', _ENV)
				if chunk == nil then
					return colors.problem .. template(choose(shell_syntax_err), {ERROR = colors.big_problem .. tostring(err) .. colors.problem}) .. colors.reset
				end
				local ok, res = pcall(chunk)
				if not ok then
					return colors.problem .. template(choose(shell_runtime_err), {ERROR = colors.big_problem .. tostring(res) .. colors.problem}) .. colors.reset
				end
				return template(choose(shell_success), {RESULT = colors.item .. tostring(res) .. colors.reset})
			end,
		},
		flamethrower = {
			name = "Flamethrower",
			desc = "It has a tank and a pilot light which is lit.",
			weight = 10,
			use = function()
				local room = state.get_room()
				if room.extinguished then
					return "A spray of liquid fire spews forth, but the room is already fireproof."
				end
				state.get_room().on_fire = true
				return colors.problem .. "A spray of liquid fire spews forth, covering the room in flame." .. colors.reset
			end,
		},
		dumbbell = {
			name = "Dumbbell",
			desc  = "It's a solid iron bar with large weights on either side.",
			weight = 6.8,
		},
		fork = {
			name = "fork",
			desc = "It's a small white biodegradable plastic fork.",
			weight = 0.03,
			use = function(rest)
				if #rest < 1 then return choose(used_empty) end
				if rest[1] ~= "duplicator" then
					return "You can't quite figure out how to do that."
				end
				if state.inv:get("duplicator") < 1 then
					return colors.problem .. "You don't have it yet." .. colors.reset
				end
				state.inv:add("fork", -1)
				state.inv:add("duplicator", -1)
				state.inv:add("fork_bomb", 1)
				return colors.big_problem .. "You create the " .. colors.item .. "fork_bomb" .. colors.big_problem .. "." .. colors.reset
			end,
		},
		fork_bomb = {
			name = "Fork Bomb",
			desc = colors.big_problem .. "It radiates with unimaginable power." .. colors.reset,
			weight = 0.13,
			use = function()
				state.fork_bombing = 3
				return colors.big_problem .. "What have you done?!" .. colors.reset
			end,
		},
		spoon = {
			name = "spoon",
			desc = "It's a small white biodegradable plastic spoon.",
			weight = 0.04,
			use = function(rest)
				if #rest < 1 then return choose(used_empty) end
				if rest[1] ~= "duplicator" then
					return "You can't quite figure out how to do that."
				end
				if state.inv:get("duplicator") < 1 then
					return colors.problem .. "You don't have it yet." .. colors.reset
				end
				state.inv:add("spoon", -1)
				state.inv:add("duplicator", -1)
				state.inv:add("spoon_bomb", 1)
				return colors.status .. "You create the " ..colors.item .. "spoon_bomb" .. colors.status .. "." .. colors.reset
			end,
		},
		spoon_bomb = {
			name = "Spoon Bomb",
			desc = colors.status .. "It radiates with imaginable power." .. colors.reset,
			weight = 0.13,
			use = function()
				state.spoon_bombing = 3
				return colors.status .. "...What have you done?" .. colors.reset
			end,
		},
		whiteboard = {
			name = "Whiteboard",
			desc = "Nothing is written on it.",
			weight = 0.1,
		},
		marker = {
			name = "Whiteboard marker",
			desc = "It is a black `Expo' dry-erase marker.",
			weight = 0.02,
			use = function(rest)
				if state.inv:get("whiteboard") < 1 and state.get_room():get_inv():get("whiteboard") < 1 then
					return choose(mark_no_wb)
				end
				if state.room == 'ComputationalSingularity' then
					local ex = table.concat(rest, " ")
					if ex:sub(0, 1) == "=" then ex = "return " .. ex:sub(2) end
					local chunk, err = load(ex, '=(marker.use)', 'bt', _ENV)
					if chunk == nil then
						if state.debug then
							print(colors.debug .. "The error is: " .. tostring(err) .. colors.reset)
						end
						state.cs_err_cnt = state.cs_err_cnt + 1
						if state.cs_err_cnt >= 3 then game.npcs.tino.room = "ComputationalSingularity" end
						return colors.extreme .. choose(cs_err) .. colors.reset
					end
					local ok, result = pcall(chunk)
					if not ok then
						if state.debug then
							print(colors.debug .. "The error is: " .. tostring(result) .. colors.reset)
						end
						state.cs_err_cnt = state.cs_err_cnt + 1
						if state.cs_err_cnt >= 3 then game.npcs.tino.room = "ComputationalSingularity" end
						return colors.extreme .. choose(cs_err) .. colors.reset
					end
					return colors.extreme .. template(choose(cs_success), {RESULT = colors.item .. tostring(result) .. colors.extreme}) .. colors.reset
				end
				local was_written = (game.objects.whiteboard.desc ~= "Nothing is written on it.")
				if #rest >= 1 then
					local msg = "`" .. colors.item .. table.concat(rest, " ") .. colors.reset .. "'"
					game.objects.whiteboard.desc = "It says " .. msg .. "."
					if was_written then
						return "You wipe away the old text with your sleeve, and carefully pen in " .. msg .. "."
					else
						return "You mark upon the clean surface, " .. msg .. "."
					end
				else
					game.objects.whiteboard.desc = "Nothing is written on it."
					if was_written then
						return "You wipe the text away with your sleeve, and leave it blank."
					else
						return "You contemplate how you might write nothing on a blank whiteboard, and discover that you've already succeeded."
					end
				end
			end,
		},
		core = {
			name = "Computational Core",
			desc = colors.extreme .. "IT IS THE CENTER OF ALL WORLDS." .. colors.reset,
			weight = 5,
			on_put = function(rest)
				if state.room ~= 'ComputationalSingularity' then
					state.finished = colors.extreme .. "You have been deleted from the universe! Better luck next time." .. colors.reset
					return colors.extreme .. "Our world was not meant to hold such a powerful object! " .. game.rooms[state.room].name .. " is deleted from the space-time continuum!" .. colors.reset
				end
			end,
		},
		strange_flask = {
			name = "Strange Flask",
			desc = "An Erlenmeyer flask with a funky liquid in it.",
			weight = 0.5,
			use = function(rest)
				if state.room == 'FreshmenPhysLab' then
					if not game.rooms[state.room].shenanigans then
						state.inv:add("strange_flask", -1)
						state.inv:add("empty_flask", 1)
						game.rooms[state.room].shenanigans = true
						game.rooms[state.room].desc = "The wrecked lab is before you. Scrap from broken machinery is all over the room, and the strange chemicals you spilled earlier still float in the room."
						return "You open the strange flask and throw its contents into the room.\n" .. colors.big_problem .. "The chemicals, instead of falling to the ground, float in the air! This is a violation of physics!! Every computer in the lab simultaneously kernel panics. The remaining devices in the room explode like metallic popcorn. The physics TA and other students run around frantically, avoiding the still floating chemicals.\n" .. colors.problem .. "You are sure that you have lived up to \"Defy Convention\" and \"Ignite\"." .. colors.reset
					else
						return "You spill the chemicals again, but they don't have any further effect."
					end
				else
					return "You don't see a particularly good use for this right now"
				end
			end,
		},
		empty_flask = {
			name = "Empty Flask",
			desc = "An empty Erlenmeyer flask",
			weight = 0.2,
			use = function(rest)
				return "Empty glass labware doesn't seem all that useful here."
			end,
			on_put = function(rest)
				if state.room == 'PeplOffice' then
					game.rooms.PeplOffice.inv:add("empty_flask", -1)
					game.rooms.PeplOffice.inv:add("strange_flask", 1)
					return "Peploski notices the empty flask and refills it with a strange concoction."
				end
			end,
		},
		peculiar_gizmo = {
			name = "Peculiar Gizmo",
			desc = "An odd device the size of your palm that feels super heavy for its size and full of physical things.",
			weight = 9.81,
			use = function(rest)
				if state.room == 'FreshmenChemLab' then
					if not game.rooms[state.room].shenanigans then
						game.rooms[state.room].shenanigans = true
						game.rooms[state.room].desc = "The lab is covered in a rainbow dust as a result of your shenanigans. You wonder how many two weeks it will take to finish cleaning this."
						return "You turn on the peculiar gizmo. It whirs quietly as mechanics inside it run\n" .. colors.big_problem .. "Eventually, sparks and arcs fly from the gizmo. It's producing its own energy, for free! This is a violation of thermodynamics!! All of the chemistry labs proceed in the opposite direction they are supposed to before exploding into a shower of sparkles. Everyone in the room is panicing while the TA tries to use the fire extinguisher, which is instead spraying silly string that for some reason still works.\n" .. colors.problem .. "You are sure that you have lived up to \"Defy Convention\" and \"Ignite\"." .. colors.reset
					else
						return "You power on the gizmo again, but it doesn't have any further effect."
					end
				else
					return "You don't see a particularly good use for this right now"
				end
			end,
		},
		parse_debugger = {
			name = "Parse Debugger",
			desc = "It appears to be made of bits.",
			weight = 0.1,
			use = function(rest)
				local kv = to_key_values(rest)
				for k, v in pairs(kv) do
					if type(v) == "table" then
						print(k)
						for _, i in ipairs(v) do
							print("", i)
						end
					else
						print(k, v)
					end
				end
				return "Done."
			end,
		},
		hammerdrill = {
			name = "Hammer Drill",
			desc = "It's a drill that is also a hammer.",
			weight = 3,
			use = function(rest)
				if #rest == 0 then
					return template(choose(hd_empty), {RAWROOM = state.room})
				end
				local kv = to_key_values(rest)
				local name = kv.name
				if name == nil then return choose(hd_no_name) end
				if type(name) ~= "string" then return choose(hd_wrong_name_type) end
				local dir = kv.direction or kv.dir
				if dir == nil then return choose(hd_no_dir) end
				if type(dir) ~= "string" then return choose(hd_wrong_dir_type) end
				if link_alias[dir] ~= nil then
					dir = link_alias[dir]
				end
				local norvs = kv.noreverse or kv.norvs
				local rvsdir = nil
				if not norvs then
					rvsdir = link_reverse[dir]
					if rvsdir == nil then
						return template(choose(hd_bad_reverse), {DIR = dir, DESC = link_desc[dir]})
					end
				end
				local rm = game.rooms[name]
				if rm ~= nil then
					state.get_room():get_links()[dir] = name
					if not norvs then
						rm.links[rvsdir] = state.room
					end
					return template(choose(hd_success), {HERE = state.get_room().name, ROOM = rm.name})
				end
				local roomobj = {name = name, desc = kv.description or kv.desc, links = {}, inv = Inv()}
				if not norvs then
					roomobj.links[rvsdir] = state.room
				end
				local ldir, lname = kv.link, kv.to
				if ldir ~= nil and lname ~= nil then
					if type(ldir) == "string" then ldir = {ldir} end
					if type(lname) == "string" then lname = {lname} end
					local maxidx = math.min(#ldir, #lname)
					for idx = 1, maxidx do
						roomobj.links[ldir[idx]] = lname[idx]
						if not norvs then
							rvsdir = link_reverse[dir]
							if rvsdir == nil then
								return template(choose(hd_bad_reverse), {DIR = dir, DESC = link_desc[dir]})
							end
							state.get_room(lname[idx]):get_links()[rvsdir] = name
						end
					end
				end
				local withs = kv.with
				if withs ~= nil then
					if type(withs) == "string" then withs = {withs} end
					for _, with in ipairs(withs) do
						roomobj.inv:add(with, 1)
					end
				end
				game.rooms[name] = roomobj
				state.get_room():get_links()[dir] = name
				return template(choose(hd_success), {ROOM = name})
			end,
		},
	},
	npcs = {
		tino = {
			name = "Tino",
			desc = "He is a living quantum computer.",
			dispos = "bad",
			room = "Concrete",
			think = function(self)
				if self.room == state.room then
					if self.room == 'ComputationalSingularity' then
						state.finished = describe_npc(self) .. colors.big_problem .. " has decided to destroy you for finding the secrets of his vast power. Better luck next time!" .. colors.reset
						return describe_npc(self) .. colors.big_problem .. " " .. choose(tino_kills) .. colors.reset
					end
				end
				ai_wander(self)
				if self.room == state.room then
					return describe_npc(self) .. " happens upon you, but is ambivalent to your existence."
				end
				return ""
			end,
		},
	},
	post_tick = function()
		local ret, torem = '', {}
		for name, room in pairs(game.rooms) do
			room = Room.from(room)
			if room.extinguished and room.on_fire then room.on_fire = nil end
			if room.on_fire then
				for dir, rname in pairs(room:get_links()) do
					local rm = state.get_room(rname)
					if math.random() < 0.1 then
						rm.on_fire = true
						if state.debug then ret = ret .. colors.debug .. rm.name .. " is now on fire.\n" .. colors.reset end
					end
				end
			end
			local inv = room:get_inv()
			if state.fork_bombing == 0 then
				inv:add("fork_bomb", inv:get("fork_bomb"))
			end
			if state.spoon_bombing == 0 then
				local amt = inv:get("spoon_bomb")
				if amt > 0 then inv:add("spoon_bomb", 1) end
			end
			if inv:total_weight() > 1000000 then
				torem[name] = true
				if state.room == name then
					ret = ret .. colors.problem .. "Reeling from the items inside, " .. room.name .. " collapses into itself!\n" .. colors.reset
					state.finished = colors.big_problem .. "Unfortunately, the collapsing room took you with it! Better luck next time!" .. colors.reset
				else
					ret = ret .. colors.problem .. "In the distance, from somewhere near " .. room.name .. ", you think you hear something loud, and then...silence.\n" .. colors.reset
				end
			end
		end
		for n, rm in pairs(game.rooms) do
			rm = Room.from(rm)
			local links = rm:get_links()
			for dir, lnk in pairs(links) do
				if torem[lnk] then links[dir] = nil end
			end
		end
		for k, _ in pairs(torem) do game.rooms[k] = nil end
		if not game.rooms.ComputationalSingularity then
			state.finished = colors.extreme .. "FOR A BRIEF MOMENT, ALL OF REALITY FRACTURES INTO COUNTLESS CATERWAULING FRAGMENTS, A SCREECH OF FOREBODING DEMISE FLOODING TO THE FURTHEST CORNERS OF EXISTENCE, AND THEN..." .. colors.reset
			return ret
		end
		game.rooms.ComputationalSingularity.desc = colors.extreme .. choose(cs_names) .. colors.reset
		if state.fork_bombing == 0 then
			state.inv:add("fork_bomb", state.inv:get("fork_bomb"))
		end
		for oname, obj in pairs(game.objects) do
			if state.fork_bombing == 0 and obj.inv ~= nil then
				obj.inv:add("fork_bomb", obj.inv:get("fork_bomb"))
			end
		end
		if state.spoon_bombing == 0 then
			if state.inv:get("spoon_bomb") > 0 then state.inv:add("spoon_bomb", 1) end
		end
		for oname, obj in pairs(game.objects) do
			if state.spoon_bombing == 0 and obj.inv ~= nil then
				if obj.inv:get("spoon_bomb") > 0 then obj.inv:add("spoon_bomb", 1) end
			end
		end
		if state.fork_bombing ~= nil and state.fork_bombing > 0 then
			ret = ret .. colors.big_problem .. "\nYou have " .. tostring(state.fork_bombing) .. " seconds before things get ugly.\n" .. colors.reset
			state.fork_bombing = state.fork_bombing - 1
		end
		if state.spoon_bombing ~= nil and state.spoon_bombing > 0 then
			ret = ret .. colors.status .. "\nYou have " .. tostring(state.spoon_bombing) .. " seconds before things get interesting?\n" .. colors.reset
			state.spoon_bombing = state.spoon_bombing - 1
		end
		if state.get_room("Collins").extinguished then
			state.finished = colors.big_problem .. "Tony Collins has decided to expel you from the university in thanks for the new powder coating in his room. Better luck next time!" .. colors.reset
		end
		if state.get_room().on_fire then
			if state.fireproof then
				ret = ret .. "The room appears to be on fire, but you're fireproof.\n"
			elseif not state.smoked then
				ret = ret .. colors.big_problem .. "Everything appears to be on fire! You cough and choke for air.\n" .. colors.reset
				state.smoked = true
			else
				ret = ret .. colors.big_problem .. "You gasp a little bit more before everything fades to black...\n" .. colors.reset
				state.finished = colors.big_problem .. "You have passed out from smoke halation [sic]. Better luck next time!" .. colors.reset
			end
		else
			state.smoked = nil
		end
		for dir, rname in pairs(state.get_room():get_links()) do
			local room = state.get_room(rname)
			if room.on_fire then
				ret = ret .. colors.problem .. "You see some smoke coming out of " .. room.name .. " " .. link_desc[dir] .. ".\n" .. colors.reset
			end
		end
		for oname, obj in pairs(game.objects) do
			if detect_inv_cycle(obj, {}) or (obj.inv ~= nil and obj.inv:total_weight() >= 75) then
				ret = ret .. colors.big_problem .. "The " .. colors.item .. oname .. colors.big_problem .. " collapses into itself, destroying everything inside.\n" .. colors.reset
				obj.inv = Inv.new()
				if state.inv:get(oname) > 0 then
					state.finished = colors.big_problem .. "Unfortunately, the collapsing " .. colors.item .. oname .. colors.big_problem .. " took you with it. Better luck next time!" .. colors.reset
					return ret
				end
			end
		end
		local sw = state.inv:total_weight()
		if sw >= 250 then
			state.finished = colors.big_problem .. "You are crushed under the weight of the things you are carrying! Better luck next time!" .. colors.reset
		elseif sw >= 100 then
			ret = ret .. colors.problem .. "The things you're carrying are too heavy for you to move.\n" .. colors.reset
			state.immobile = true
		else
			state.immobile = false
		end
		for nm, npc in pairs(game.npcs) do
			local s = npc.think(npc)
			if string.len(s) > 0 then
				ret = ret .. "\n" .. s
			end
		end
		return ret
	end,
}

function state.get_room(rm)
	if rm == nil then rm = state.room end
	if game.rooms[rm] == nil then
		game.rooms[rm] = {name = rm, desc = "(This room wasn't in the content files!)", links = {up = "COSI"}}
	end
	return Room(game.rooms[rm])
end

function choose(seq)
	if type(seq) ~= "table" then
		return "[bad choice over " .. tostring(seq) .. "]"
	end
	return seq[1 + math.floor(math.random() * #seq)]
end

function template(str, temps)
	for name, repl in pairs(temps) do
		str = str:gsub("%$" .. name, repl)
	end
	return str
end

function describe_item(oname, amt)
	local phrase = tostring(amt) .. " " .. colors.item .. oname .. colors.reset .. "s"
	local a = "a"
	if vowel[oname:sub(1, 1)] then a = "an" end
	if amt == 1 then
		phrase = a .. " " .. colors.item .. oname .. colors.reset
	end
	local weight = ""
	local obj = game.objects[oname]
	if obj ~= nil and obj.weight ~= nil then
		if amt == 1 then
			weight = " (" .. tostring(obj.weight) .. "kg)"
		else
			weight = " (" .. tostring(obj.weight) .. "kg each, " .. tostring(obj.weight * amt) .. "kg total)"
		end
	end
	local copula = "are"
	if amt == 1 then
		copula = "is"
	end
	return phrase .. weight, copula
end

function get_obj_params(oname)
	local a = "a"
	local c = oname:sub(1, 1)
	if vowel[c] then a = "an" end
	local tpl = {OBJECT = colors.item .. oname .. colors.reset, A = a}
	local obj = game.objects[oname]
	return oname, tpl, obj
end

local commands
commands = {
	go = function(rest)
		if state.get_room().on_go then
			c, out = state.get_room().on_go(rest)
			if c then return out end
		end
		if #rest < 1 then return choose(go_empty) end
		if state.immobile then return choose(go_immobile) end
		local dir = rest[1]
		if link_alias[dir] ~= nil then dir = link_alias[dir] end
		local new_room = state.get_room():get_links()[dir]
		if new_room ~= nil then
			state.room = new_room
			return "You move to " .. state.get_room(new_room).name .. "."
		end
		return template(choose(go_fail), {DIRECTION = dir, DESCR = link_desc[dir]})
	end,
	use = function(rest)
		if #rest < 1 then return choose(use_empty) end
		if rest[1] == "on" then
			return template(choose(use_no_used), tpl)
		end
		local level = 1
		local isinroom = nil
		local curobj = state
		local oname, tpl, obj
		while level <= #rest do
			if prepositions[rest[level]] then break end
			oname, tpl, obj = get_obj_params(rest[level])
			if obj == nil then
        return template(choose(bad_name), tpl)
			end
			local amt = curobj.inv:get(oname)
			if amt < 1 then
				amt = state.get_room():get_inv():get(oname)
				if level == 1 and amt >= 1 then
					isinroom = true
					curobj = obj
				else
					return template(choose(not_in_inv), tpl)
				end
			end
			curobj = obj
			level = level + 1
		end
		if isinroom then
			if obj.ext_use == nil then
				if obj.use ~= nil then return template(choose(use_ext_not_useful_except_inv), tpl) end
				return template(choose(use_not_useful), tpl)
			end
			return obj.ext_use({table.unpack(rest, level + 1)})
		else
			if obj.use == nil then
				return template(choose(use_not_useful), tpl)
			end
		end
		return obj.use({table.unpack(rest, level + 1)})
	end,
	take = function(rest)
		if #rest < 1 then return choose(take_empty) end
		local oname, tpl, obj
		local curinv = state.get_room():get_inv()
		local level = 1
		while level <= #rest do
			oname, tpl, obj = get_obj_params(rest[level])
			if obj == nil then
				return template(choose(bad_name), tpl)
			end
			if curinv:is_empty() then
				return choose(take_room_empty)
			end
			local amt = curinv:get(oname)
			if amt < 1 then
				return template(choose(take_no_item), tpl)
			end
			level = level + 1
			if level <= #rest then curinv = obj.inv end
		end
		if obj.weight == nil then
			return template(choose(take_object_static), tpl)
		end
		if state.inv:total_weight() + obj.weight > state.carry_limit then
			return template(choose(take_too_heavy), tpl)
		end
		state.inv:add(oname, 1)
		curinv:add(oname, -1)
		return template(choose(take_success), tpl)
	end,
	put = function(rest)
		if #rest < 1 then return choose(put_empty) end
		local oname, tpl, obj = get_obj_params(rest[1])
		if obj == nil then
			return template(choose(bad_name), tpl)
		end
		local srcinv = nil
		for _, inv in ipairs({state.inv, state.get_room():get_inv()}) do
			local amt = inv:get(oname)
			if amt >= 1 then
				srcinv = inv
				break
			end
		end
		if srcinv == nil then
			return template(choose(not_in_inv), tpl)
		end
		local inv = state.get_room():get_inv()
		local level = 2
		if rest[level] ~= nil and prepositions[rest[level]] then
			level = 3
		end
		local invoname, invtpl, invobj
		while level <= #rest do
			invoname, invtpl, invobj = get_obj_params(rest[level])
			if invobj == nil then
				return template(choose(bad_name), invtpl)
			end
			if inv:get(invoname) < 1 then
				return template(choose(put_no_dest), invtpl)
			end
			if invobj.inv == nil then
				return template(choose(put_no_inv), invtpl)
			end
			level = level + 1
			inv = invobj.inv
		end
		srcinv:add(oname, -1)
		inv:add(oname, 1)
		if #rest >= 2 then
			tpl.DEST = invoname
			return template(choose(put_success_into), tpl)
		elseif obj.on_put ~= nil then
			puttext = obj.on_put()
			if puttext ~= nil then
				return template(choose(put_success), tpl) .. "\n" .. puttext
			else
				return template(choose(put_success), tpl)
			end
		else
			return template(choose(put_success), tpl)
		end
	end,
	look = function(rest)
		if #rest >= 1 then
			local oname, tpl, obj = get_obj_params(rest[1])
			if obj == nil then
				return template(choose(bad_name), tpl)
			end
			local amt = state.inv:get(oname)
			if amt < 1 then
				local amt = state.get_room():get_inv():get(oname)
				if amt < 1 then
					return template(choose(not_in_inv), tpl)
				end
			end
			local ret = template("The $OBJECT is a $NAME. $DESC", {OBJECT = oname, NAME = obj.name, DESC = obj.desc})
			if obj.weight ~= nil then
				ret = ret .. "\nIt weighs " .. obj.weight .. " kilograms."
			end
			if obj.use ~= nil then
				ret = ret .. "\nIt seems useful."
			end
			local inv = obj.inv
			if inv ~= nil and not inv:is_empty() then
				ret = ret .. "\nYou find the following inside:"
				for oname, amt in pairs(inv) do
					local desc, copula = describe_item(oname, amt)
					ret = ret .. "\n- There " .. copula .. " " .. desc
				end
			end
			return ret
		end
		local ret
		local inv = state.get_room():get_inv()
		if inv:is_empty() then
			ret = "There's nothing in " .. state.get_room().name .. "."
		else
			ret = "You see the following:"
			for oname, amt in pairs(inv) do
				local desc, copula = describe_item(oname, amt)
				ret = ret .. "\nThere " .. copula .. " " .. desc
			end
		end
		if state.inv:is_empty() then
			ret = ret .. "\nYou are not carrying anything."
		else
			for oname, amt in pairs(state.inv) do
				ret = ret .. "\nYou have " .. describe_item(oname, amt)
			end
			ret = ret .. "\nTotal carrying weight: " .. state.inv:total_weight() .. "kg"
		end
		return ret
	end,
	help = function(rest)
		if math.random() < 0.1 then
			return colors.problem .. "You call out for help. It falls on deaf ears." .. colors.reset
		end
		local ret = "After spending a moment in deep contemplation, you come up with a list of things you think you can do:\n"
		for k, _ in pairs(commands) do
			ret = ret .. "- " .. k .. "\n"
		end
		return ret
	end,
	cheat = function(rest)
		state.inv:add("materializer", 1)
		return "'kay."
	end,
}

local exec_empty = {
	"Speak up, son!",
	"Excuse me?",
	"Did you say something?",
	"What now?",
	"Hmm?",
	"Were you going to say something?",
}

local exec_fail = {
	"I don't know how to $COMMAND.",
	"If only I knew what a '$COMMAND' was...",
	"$COMMAND? That's a waterfowl, right?",
}

function exec(line)
	local parts = {}
	for match in line:gmatch('%S+') do
		table.insert(parts, match)
	end
	if #parts < 1 then
		return choose(exec_empty)
	end
	local cmd = table.remove(parts, 1)
	local cmdf = commands[cmd]
	if cmdf == nil then
		return template(choose(exec_fail), {COMMAND = colors.prompt .. cmd .. colors.reset})
	end
	return cmdf(parts)
end

function print_status()
	local room = state.get_room()
	if room == nil then
		return "<invalid room " .. state.room .. ">"
	end
	local ret = "You are in " .. room.name .. "."
	if room.desc ~= nil then
		ret = ret .. " " .. room.desc
	end
	for nm, npc in pairs(game.npcs) do
		if npc.room == state.room then
			ret = "\n" .. describe_npc(npc) .. " is here."
		end
	end
	if room.extinguished then
		ret = ret .. "\n" .. colors.big_problem .. "The room is absolutely covered in white dust." .. colors.reset
	end
	for dir, rm in pairs(room:get_links()) do
		local rmo = game.rooms[rm]
		if rmo ~= nil then
			local rmoname = rmo.name:sub(0,1):upper() .. rmo.name:sub(2)
			ret = ret .. "\n" .. rmoname .. " is " .. link_desc[dir] .. "."
		end
	end
	return colors.status .. ret .. colors.reset
end

return {
	colors = colors,
	game = game,
	state = state,
	Inv = Inv,
	Room = Room,
	commands = commands,
	exec = exec,
	print_status = print_status,
}
