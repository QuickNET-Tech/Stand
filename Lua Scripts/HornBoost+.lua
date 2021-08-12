require("natives-1614644776")

local hornBoostEnabled = true
local hornBrakeEnabled = true
local hornInstantStopEnabled = true

local hornBoostPower = 1
local hornBrakePower = 2

local vehHandle = 0

local controlVehicleHorn = 86
local controlVehicleAccelerate = 71
local controlVehicleBrake = 72
local controlVehicleHandbrake = 76



menu.toggle(menu.my_root(), "Horn Boost", { "hornboost" }, "Enable horn boost. Press horn and gas to activate.", function(toggle)
	hornBoostEnabled = toggle
end, hornBoostEnabled)

menu.slider(menu.my_root(), "Horn Boost Power", { "hornboostpower" }, "Set the power of the horn boost. Higher increases your speed quicker.", 0, 10000, 1, 1, function(current, previous)
	hornBoostPower = current
end)

menu.toggle(menu.my_root(), "Horn Brake", { "hornbrake" }, "Enable horn brake. Press horn and brake to activate.", function(toggle)
	hornBrakeEnabled = toggle
end, hornBrakeEnabled)

menu.slider(menu.my_root(), "Horn Brake Power", { "hornbrakepower" }, "Set the power of the horn brake. Higher is slows you down quicker.", 0, 10000, 2, 1, function(current, previous)
	hornBrakePower = current
end)

menu.toggle(menu.my_root(), "Horn Instant Stop", { "horninstantstop" }, "Bring your vehicle to an instant halt. Press horn and hand brake to activate.", function(toggle)
	hornInstantStopEnabled = toggle
end, hornInstantStopEnabled)




function updateVehHandle()	
	vehHandle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
end

function isHornPressed()
	return PAD.IS_DISABLED_CONTROL_PRESSED(0, controlVehicleHorn)
end

function isGasPressed()
	return PAD.IS_DISABLED_CONTROL_PRESSED(0, controlVehicleAccelerate)
end

function isBrakePressed()
	return PAD.IS_DISABLED_CONTROL_PRESSED(0, controlVehicleBrake)
end

function isHandBrakePressed()
	return PAD.IS_DISABLED_CONTROL_PRESSED(0, controlVehicleHandbrake)
end

function shouldHornBoost()
	if not vehHandle then return false end
	if not hornBoostEnabled then return false end
	if not isHornPressed() then return false end
	if not isGasPressed() then return false end

	return true
end

function shouldHornBrake()
	if not vehHandle then return false end
	if not hornBrakeEnabled then return false end
	if not isHornPressed() then return false end
	if not isBrakePressed() then return false end

	return true
end

function shouldInstantStop()
	if not vehHandle then return false end
	if not hornInstantStopEnabled then return false end
	if not isHornPressed() then return false end
	if not isHandBrakePressed() then return false end

	return true
end

function hornBoost()
	local newSpeed = ENTITY.GET_ENTITY_SPEED(vehHandle) + hornBoostPower
	VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehHandle, newSpeed)
end

function hornBrake()
	local newSpeed = math.max(ENTITY.GET_ENTITY_SPEED(vehHandle) - hornBrakePower, 0.0)
	VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehHandle, newSpeed)
end

function instantStop()
	ENTITY.FREEZE_ENTITY_POSITION(vehHandle, true)
	ENTITY.FREEZE_ENTITY_POSITION(vehHandle, false)
end

function tick()
	updateVehHandle()

	if shouldHornBoost() then hornBoost() end
	if shouldHornBrake() then hornBrake() end
	if shouldInstantStop() then instantStop() end

	util.yield()
end

while true do
	tick()
end
