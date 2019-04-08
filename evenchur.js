var world = {
	"rooms" : {
		"COSI" : {
			"name" : "COSI",
			"desc" : "You are in COSI.",
			"links" : {
				"south" : "SC3hall",
				"east" : "ITL",
			},
			"inv" : {
				"chair" : 1,
				"fridge" : 1,
			},
		},
		"ITL" : {
			"name" : "The ITL",
			"desc" : "You are in the ITL. There is a class right now. People are staring at you.",
			"links" : {
				"south" : "SC3hall",
				"west" : "COSI",
			},
		},
		"ServerRoom" : {
			"name" : "The server room",
			"desc" : "The server room is loud and noisy, its primary occupants humming busily.",
			"links" : {
				"south" : "COSI",
			},
		},
		"SC3hall" : {
			"name" : "A hallway outside COSI",
			"desc" : "You are in the Science Center's 3rd floor hallway.",
			"links" : {
				"north" : "COSI",
				"west" : "Concrete",
				"east" : "SC3Collins",
			},
		},
		"Concrete" : {
			"name" : "Concrete Cafe",
			"desc" : "You are in the Concrete Cafe.",
			"links" : {
				"east" : "SC3hall",
			},
		},
		"Outside" : {
			"name" : "the outside world",
			"desc" : "It is an overcast, Potsdam day; the clouds threaten snow, despite being quite warm.",
			"links" : {
				"north" : "Concrete",
			},
		},
		"SC3Collins" : {
			"name" : "A hallway near Tony Collins' office",
			"desc" : "You are outside of Tony Collins' office.",
			"links" : {
				"west" : "SC3hall",
				"north" : "SC3North",
			},
			"inv" : {
				"key": 1,
			},
		},
		"Collins" : {
			"name" : "Tony Collins' office",
			"desc" : "You are inside Tony Collins' office. He is looking at you, slightly perplexed as to how you got here.",
			"links" : {
				"west" : "SC3Collins",
			},
			"inv" : {
				"collins": 1,
			},
		},
		"SC3North" : {
			"name" : "A hallway near the chairwell",
			"desc" : "You are in the northernmost part of the Science Center's 3rd floor hallway.",
			"links" : {
				"south" : "SC3Collins",
				"west" : "ChairwellBottom",
			},
		},
		"ChairwellBottom" : {
			"name" : "The bottom of the chairwell",
			"desc" : "You are at the bottom of the chairwell. The ramp goes up to the north.",
			"links" : {
				"north" : "ChairwellTop",
				"east" : "SC3North",
			},
		},
		"ChairwellTop" : {
			"name" : "The top of the chairwell",
			"desc" : "You are at the top of the chairwell. The ramp goes down to the south.",
			"links" : {
				"south" : "ChairwellBottom",
			}
		},
	},
	"objects" : {
		"fridge" : {
			"name" : "Fridge",
			"lname" : "Refrigerator",
			"desc" : "It is a cold box usually filled with refreshing fluids and victuals.",
			"inv" : {
				"moxie" : 1,
			},
		},
		"moxie" : {
			"name" : "Moxie",
			"lname" : "Moxie soda",
			"desc" : "The brightly colored can's carbonic contents fizzle gently, beckoning any dry throat.",
			"use" : function() {
				inv_add(state.inv, "moxie", -1);
				inv_add(state.inv, "moxie can", 1);
				return "You ingest the sparkling fluid.";
			},
		},
		"moxie can" : {
			"name" : "Moxie can",
			"lname" : "Empty moxie can",
			"desc" : "It is now a bright, but empty, frail can.",
		},
		"chair" : {
			"name" : "Chair",
			"lname" : "Swivel chair",
			"use" : function() {
				if(state.room == "ChairwellTop") {
					state.room = "ChairwellBottom";
					return "You roll down the ramp--whee!";
				}
				return "The chair is of no use to you here.";
			},
		},
		"key" : {
			"name" : "Key",
			"lname" : "Master key",
			"desc" : "It is a cut brass Sargent key with a couple numbers and letters carved on it.",
			"use" : function() {
				if(state.room == "SC3Collins") {
					var roomspec = world.rooms[state.room];
					if(roomspec.links == undefined) roomspec.links = {};
					roomspec.links.east = "Collins";
					return "The key turns smoothly in the door.";
				} else if(state.room == "Concrete") {
					var roomspec = world.rooms[state.room];
					if(roomspec.links == undefined) roomspec.links = {};
					roomspec.links.south = "Outside";
					return "The latch on a nearby, thick door clicks.";
				} else if(state.room == "COSI") {
					var roomspec = world.rooms[state.room];
					if(roomspec.links == undefined) roomspec.links = {};
					roomspec.links.north = "ServerRoom";
					return "You insert the key into the glass doors, and the bolt retracts.";
				}
				return "You can't find a place to put the key.";
			},
		},
		"collins" : {
			"name" : "Tony Collins",
			"lname" : "Tony Collins",
			"desc" : "He is the president of the university.",
			"use" : function() {
				return "He turns and glares at you.";
			},
		},
	},
};

var state = {
	"room" : "COSI",
	"inv" : {},
};

function rand_item(arr) {
	return arr[Math.floor(Math.random() * arr.length)];
}

function inv_cnt(inv, item) {
	if(inv[item] == undefined || inv[item] == NaN) return 0;
	return inv[item];
}

function inv_add(inv, item, cnt) {
	inv[item] = inv_cnt(inv, item) + cnt;
	if(inv[item] <= 0) delete inv[item];
}

function inv_has(inv, item, cnt) {
	if(cnt == undefined) cnt = 1;
	return inv_cnt(inv, item) >= cnt;
}

function inv_move(from, to, item, cnt) {
	if(cnt == undefined) cnt = 1;
	var amt = Math.min(inv_cnt(from, item), cnt);
	if(amt <= 0) return 0;
	inv_add(from, item, -amt);
	inv_add(to, item, amt);
	return amt;
}

function inv_for_room(room) {
	if(world.rooms[room].inv == undefined) {
		world.rooms[room].inv = {};
	}
	return world.rooms[room].inv;
}

function inv_empty(inv) {
	return (inv == undefined) || (Object.keys(inv).length == 0);
}

function obj_from_name(oname) {
	var inval_object = {name: "INVALID_OBJECT", lname: "INVALID OBJECT", desc: "This is an invalid object."};
	return world.objects[oname] || inval_object;
}

function cmd_go(rest) {
	var link_alias = {n: "north", s: "south", e: "east", w: "west", u: "up", d: "down"};
	var go_fail = [
		"You cannot go $DIRECTION.",
		"Your passage to $DIRECTION is blocked.",
		"A wall greets you to the $DIRECTION.",
		"The $DIRECTION is impassible."
	];
	if(rest.length < 1) {
		return "Go what direction?";
	}
	var dir = rest[0];
	while(link_alias[dir] != undefined) {
		dir = link_alias[dir];
	}
	var room = world.rooms[state.room];
	if(room.links[dir] != undefined) {
		state.room = room.links[dir];
		return "You move to "+world.rooms[state.room].name;
	}
	return rand_item(go_fail).replace(/\$DIRECTION/g, dir);
}

function cmd_use(rest) {
	if(rest.length < 1) {
		return "Use what?";
	}
	var oname = rest[0];
	var object = obj_from_name(oname);
	if(!inv_has(state.inv, oname)) {
		return "You don't have a "+object.name+".";
	}
	if(object == undefined) {
		return "You have one, but I don't know what a "+oname+" is.";
	}
	if(object.use == undefined) {
		return "The "+object.name+" isn't particularly useful.";
	}
	return object.use();
}

function cmd_take(rest) {
	if(rest.length < 1) {
		return "Take what?";
	}
	var oname = rest[0];
	var object = obj_from_name(oname);
	if(object == undefined) {
		return "I don't know what a "+oname+" is.";
	}
	var inv = inv_for_room(state.room);
	if(inv_empty(inv)) {
		return "There is nothing here for you to take.";
	}
	if(!inv_has(inv, oname)) {
		return "There are no "+object.name+"s here.";
	}
	inv_move(inv, state.inv, oname);
	return "You take the "+obj_from_name(oname).name+".";
}

function cmd_put(rest) {
	if(rest.length < 1) {
		return "Put what?";
	}
	var oname = rest[0];
	var inv = inv_for_room(state.room);
	if(!inv_has(state.inv, oname)) {
		return "You don't have any "+oname+"s.";
	}
	inv_move(state.inv, inv, oname);
	return "You put down the "+obj_from_name(oname).name+".";
}

function cmd_look(rest) {
	var res = "";
	if(rest.length < 1) {
		var inv = inv_for_room(state.room);
		if(inv_empty(inv)) {
			res += "There's nothing in "+world.rooms[state.room].name+".";
		} else {
			res += "You see the following: ";
			for(oname in inv) {
				if(inv_cnt(inv, oname) == 1) {
					res += "\nThere is a "+obj_from_name(oname).name+" ('"+oname+"').";
				} else {
					res += "\nThere are "+inv_cnt(inv, oname)+" "+obj_from_name(oname).name+"s ('"+oname+"').";
				}
			}
		}
		if(inv_empty(state.inv)) {
			res += "\nYou aren't holding onto anything.";
		} else {
			for(oname in state.inv) {
				if(inv_cnt(state.inv, oname) == 1) {
					res += "\nYou have one "+obj_from_name(oname).name+" ('"+oname+"').";
				} else {
					res += "\nYou have "+inv_cnt(state.inv, oname)+" "+obj_from_name(oname).name+"s ('"+oname+"').";
				}
			}
		}
		return res;
	}
	var oname = rest[0];
	var inv = inv_for_room(state.room);
	var object = null;
	if(inv_has(inv, oname)) {
		object = oname;
	}
	if(inv_has(state.inv, oname)) {
		object = oname;
	}
	if(object == null) {
		return "You don't have or see a "+oname+".";
	}
	object = obj_from_name(object);
	res = "The "+object.name+" is a "+object.lname+". "+(object.desc || "");
	if(object.use != undefined) {
		res += "\nIt seems useful.";
	}
	return res;
}

function cmd_help(rest) {
	var res = "After spending a moment in deep contemplation, you come up with a list of things you think you can do:\n";
	for(i in commands) {
		res += "-"+i+"\n";
	}
	return res;
}

var commands = {
	go : cmd_go,
	use : cmd_use,
	take : cmd_take,
	put : cmd_put,
	look : cmd_look,
	help : cmd_help,
};

function exec(line) {
	var parts = line.split(/\s+/);
	var exec_fail = [
		"I don't know how to $COMMAND.",
		"If only I knew what '$COMMAND' was...",
		"$COMMAND? That's a waterfowl, right?",
	];
	var exec_empty = [
		"Speak up, son!",
		"Excuse me?",
		"Did you say something?",
		"What, now?",
	];
	if(line.length == 0) {
		return rand_item(exec_empty);
	}
	var cmd = commands[parts[0]];
	if(cmd != undefined) {
		parts.splice(0, 1);
		return cmd(parts);
	}
	return rand_item(exec_fail).replace(/\$COMMAND/g, parts[0]);
}

function print_status() {
	var room = world.rooms[state.room];
	if(room == undefined) {
		return "<In invalid room "+state.room+">";
	}
	var res = room.desc;
	for(dir in room.links) {
		res += "\n"+world.rooms[room.links[dir]].name+" is to the "+dir;
	}
	return res;
}
