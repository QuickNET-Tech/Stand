require("natives-1614644776")

local lockTime = false;
local h = 12
local m = 0
local s = 0

menu.action(menu.my_root(), "Set Time", { "settime" }, "Set the time to the currently selected hour, minute and second", function()
	setTime(h, m, s)
end)

menu.toggle(menu.my_root(), "Pause Clock", { "pauseclock" }, "Pauses your clock to the selected time", function(toggle)
	lockTime = toggle
end, false)

menu.slider(menu.my_root(), "Clock Hour", { "clockhour" }, "Set the clock hour to be used", 0, 23, h, 1, function(current, prior)
	h = current
end)

menu.slider(menu.my_root(), "Clock Minute", { "clockminute" }, "Set the clock minute to be used", 0, 59, m, 1, function(current, prior)
	m = current
end)

menu.slider(menu.my_root(), "Clock Second", { "clocksecond" }, "Set the clock second to be used", 0, 59, h, 1, function(current, prior)
	s = current
end)

function setTime(hour, minute, second)
	NETWORK.NETWORK_OVERRIDE_CLOCK_TIME(hour, minute, second)
end

function tick()
	if lockTime then setTime(h, m, s) end
end

while true do
	tick()

	util.yield()
end
