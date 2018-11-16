local Inv = {}
Inv.mt = {
	__index = Inv,
}

local colors = {
	reset = "\x1b[m",
	prompt = "\x1b[1;35m",
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
	"Your passage to $DIRECTION is blocked.",
	"A wall greets you to the $DIRECTION.",
	"The $DIRECTION is impassible.",
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
				east = "SC3Collins",
				down = "SC2EastStairwell",
			},
		},
		Concrete = {
			name = "Concrete Cafe",
			desc = "The Cafe is closed right now. Everything is spotless, except for the pockmark from where a brick crashed through the skylight.",
			links = {
				east = "SC3Hall",
			},
			inv = Inv.clone({
				fork = 1,
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
			name = "the floor below COSI",
			desc = "There are stairs going up and down a floor. A poster labelled \"Chemistry\" is on the wall.",
			links = {
				up = "SC3Hall",
				--down = ""
				east = "OutsidePeplOffice"
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
			}),
		},
		ComputationalSingularity = {
			name = "the Core of the Computational Singularity",
			desc = colors.extreme .. cs_names[1] .. colors.reset,
			links = {
				up = "ServerRoom",
			},
		},
	},
	objects = {
		fridge = {name = "refrigerator", desc = "A cold box usually filled with refreshing beverages and tasty victuals.", inv = Inv.clone({moxie = 1}), weight = 20},
		moxie = {
			name = "Moxie soda",
			desc = "The bright orange can's fizzly liquid contents beckon to your parched throat.",
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
					local chunk, err = load(ex)
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
							print(colors.debug .. "The error is: " .. tostring(err) .. colors.reset)
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
						return describe_npc(self) .. colors.big_problem .. " administers a Tino Exam!" .. colors.reset
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
		local ret = ''
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
			if state.fork_bombing == 0 then
				local inv = room:get_inv()
				inv:add("fork_bomb", inv:get("fork_bomb"))
			end
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
		if state.fork_bombing ~= nil and state.fork_bombing > 0 then
			ret = ret .. colors.big_problem .. "\nYou have " .. tostring(state.fork_bombing) .. " seconds before things get ugly." .. colors.reset
			state.fork_bombing = state.fork_bombing - 1
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
				ret = ret .. colors.problem .. "You see some smoke coming out of " .. room.name .. " to the " .. dir .. ".\n" .. colors.reset
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

local vowel = {
	a = true,
	e = true,
	i = true,
	o = true,
	u = true,
}

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

local link_alias = {
	n = "north",
	s = "south",
	e = "east",
	w = "west",
	u = "up",
	d = "down",
}

local link_desc = {
	north = "to the north",
	south = "to the south",
	east = "to the east",
	west = "to the west",
	up = "above you",
	down = "below you",
}

local prepositions = {
	on = true,
	["in"] = true,
	with = true,
	from = true,
}

local commands
commands = {
	go = function(rest)
		if #rest < 1 then return choose(go_empty) end
		if state.immobile then return choose(go_immobile) end
		local dir = rest[1]
		if link_alias[dir] ~= nil then dir = link_alias[dir] end
		local new_room = state.get_room():get_links()[dir]
		if new_room ~= nil then
			state.room = new_room
			return "You move to " .. state.get_room(new_room).name .. "."
		end
		return template(choose(go_fail), {DIRECTION = dir})
	end,
	use = function(rest)
		if #rest < 1 then return choose(use_empty) end
		if rest[1] == "on" then
			return template(choose(use_no_used), tpl)
		end
		local level = 1
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
				return template(choose(not_in_inv), tpl)
			end
			level = level + 1
		end
		if obj.use == nil then
			return template(choose(use_not_useful), tpl)
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
		return template(choose(exec_fail), {COMMAND = cmd})
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
