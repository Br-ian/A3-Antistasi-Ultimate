private ["_positionX","_size","_buildings","_grupo","_typeUnit","_lado","_building","_tipoB","_frontierX","_tipoVeh","_veh","_vehiclesX","_soldiers","_pos","_ang","_markerX","_unit","_return"];
_markerX = _this select 0;
_positionX = getMarkerPos _markerX;
_size = _this select 1;
_buildings = nearestObjects [_positionX, listMilBld, _size * 1.2, true];

if (count _buildings == 0) exitWith {[grpNull,[],[]]};

_lado = _this select 2;
_frontierX = _this select 3;

_vehiclesX = [];
_soldiers = [];

_grupo = createGroup _lado;
_typeUnit = if (_lado==malos) then {staticCrewOccupants} else {staticCrewInvaders};

for "_i" from 0 to (count _buildings) - 1 do
	{
	if (spawner getVariable _markerX == 2) exitWith {};
	_building = _buildings select _i;
	/*
	if !(_building getVariable ["conEH",false]) then
		{
		_building setVariable ["conEH",true,true];
		_building addEventHandler ["Killed",{
			_building = _this select 0;
			destroyedBuildings pushBackUnique (getPos _building);
			publicVariable "destroyedBuildings";
			}
			];
		};*/
	_tipoB = typeOf _building;
	if ((_tipoB == "Land_HelipadSquare_F") and (!_frontierX)) then
		{
		_tipoVeh = if (_lado == malos) then {vehNATOPatrolHeli} else {vehCSATPatrolHeli};
		_veh = createVehicle [_tipoVeh, position _building, [],0, "CAN_COLLIDE"];
		_veh setDir (getDir _building);
		_vehiclesX pushBack _veh;
		}
	else
		{
		if 	((_tipoB == "Land_Cargo_HQ_V1_F") or (_tipoB == "Land_Cargo_HQ_V2_F") or (_tipoB == "Land_Cargo_HQ_V3_F")) then
			{
			_tipoVeh = if (_lado == malos) then {staticAAOccupants} else {staticAAInvaders};
			_veh = createVehicle [_tipoVeh, (_building buildingPos 8), [],0, "CAN_COLLIDE"];
			_veh setPosATL [(getPos _building select 0),(getPos _building select 1),(getPosATL _veh select 2)];
			_veh setDir (getDir _building);
			_unit = _grupo createUnit [_typeUnit, _positionX, [], 0, "NONE"];
			[_unit,_markerX] call A3A_fnc_NATOinit;
			_unit moveInGunner _veh;
			_soldiers pushBack _unit;
			_vehiclesX pushBack _veh;
			}
		else
			{
			if 	((_tipoB == "Land_Cargo_Patrol_V1_F") or (_tipoB == "Land_Cargo_Patrol_V2_F") or (_tipoB == "Land_Cargo_Patrol_V3_F")) then
				{
				_tipoVeh = if (_lado == malos) then {NATOMG} else {CSATMG};
				_veh = createVehicle [_tipoVeh, (_building buildingPos 1), [], 0, "CAN_COLLIDE"];
				_ang = (getDir _building) - 180;
				_pos = [getPosATL _veh, 2.5, _ang] call BIS_Fnc_relPos;
				_veh setPosATL _pos;
				_veh setDir (getDir _building) - 180;
				_unit = _grupo createUnit [_typeUnit, _positionX, [], 0, "NONE"];
				[_unit,_markerX] call A3A_fnc_NATOinit;
				_unit moveInGunner _veh;
				_soldiers pushBack _unit;
				_vehiclesX pushBack _veh;
				}
			else
				{
				if 	(_tipoB in listbld) then
					{
					_tipoVeh = if (_lado == malos) then {NATOMG} else {CSATMG};
					_veh = createVehicle [_tipoVeh, (_building buildingPos 11), [], 0, "CAN_COLLIDE"];
					_unit = _grupo createUnit [_typeUnit, _positionX, [], 0, "NONE"];
					[_unit,_markerX] call A3A_fnc_NATOinit;
					_unit moveInGunner _veh;
					_soldiers pushBack _unit;
					_vehiclesX pushBack _veh;
					sleep 0.5;
					_veh = createVehicle [_tipoVeh, (_building buildingPos 13), [], 0, "CAN_COLLIDE"];
					_unit = _grupo createUnit [_typeUnit, _positionX, [], 0, "NONE"];
					[_unit,_markerX] call A3A_fnc_NATOinit;
					_unit moveInGunner _veh;
					_soldiers pushBack _unit;
					_vehiclesX pushBack _veh;
					};
				};
			};
		};
	};
[_grupo,_vehiclesX,_soldiers]