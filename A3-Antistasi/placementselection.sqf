if (!isNil "placementDone") then
	{
	theBoss allowDamage false;
	format ["%1 is Dead",name petros] hintC format ["%1 has been killed. You lost part of your assets and need to select a new HQ position far from the enemies.",name petros];
	}
else
	{
	diag_log "Antistasi: New Game selected";
	"Initial HQ Placement Selection" hintC ["Click on the Map Position you want to start the Game.","Close the map with M to start in the default position.","Don't select areas with enemies nearby!!\n\nGame experience changes a lot on different starting positions."];
	};

hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload",
	{
	0 = _this spawn
		{
		_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
		hintSilent "";
		};
	}];

private ["_positionTel","_markerX","_markersX"];
_markersX = markersX select {lados getVariable [_x,sideUnknown] != buenos};
_positionTel = [];
if (isNil "placementDone") then
	{
	_markersX = _markersX - controlsX;
	openMap true;
	}
else
	{
	_markersX = _markersX - (controlsX select {!isOnRoad (getMarkerPos _x)});
	//openMap [true,true];
	openMap [true,true];
	};
_mrkDum = [];
{
_mrk = createMarkerLocal [format ["%1dumdum", count _mrkDum], getMarkerPos _x];
_mrk setMarkerShapeLocal "ELLIPSE";
_mrk setMarkerSizeLocal [500,500];
_mrk setMarkerTypeLocal "hd_warning";
_mrk setMarkerColorLocal "ColorRed";
_mrk setMarkerBrushLocal "DiagGrid";
_mrkDum pushBack _mrk;
} forEach _markersX;
while {true} do
	{
	positionTel = [];
	onMapSingleClick "positionTel = _pos;";
	waitUntil {sleep 1; (count positionTel > 0) or (not visiblemap)};
	onMapSingleClick "";
	if (not visiblemap) exitWith {};
	_positionTel = positionTel;
	_markerX = [_markersX,_positionTel] call BIS_fnc_nearestPosition;
	if (getMarkerPos _markerX distance _positionTel < 500) then {hint "Place selected is very close to enemy zones.\n\n Please select another position"};
	if (surfaceIsWater _positionTel) then {hint "Selected position cannot be in water"};
	_enemiesX = false;
	if (!isNil "placementDone") then
		{
		{
		if ((side _x == malos) or (side _x == Invaders)) then
			{
			if (_x distance _positionTel < 500) then {_enemiesX = true};
			};
		} forEach allUnits;
		};
	if (_enemiesX) then {hint "There are enemies in the surroundings of that area, please select another."};
	if ((getMarkerPos _markerX distance _positionTel >= 500) and (!surfaceIsWater _positionTel) and (!_enemiesX)) exitWith {};
	sleep 0.1;
	};
if (visiblemap) then
	{
	if (isNil "placementDone") then
		{
		{
		if (getMarkerPos _x distance _positionTel < distanceSPWN) then
			{
			lados setVariable [_x,buenos,true];
			};
		} forEach controlsX;
		petros setPos _positionTel;
		}
	else
		{
		_controlsX = controlsX select {!(isOnRoad (getMarkerPos _x))};
		{
		if (getMarkerPos _x distance _positionTel < distanceSPWN) then
			{
			lados setVariable [_x,buenos,true];
			};
		} forEach _controlsX;
		_viejo = petros;
		groupPetros = createGroup buenos;
		publicVariable "groupPetros";
        petros = groupPetros createUnit [typePetros, _positionTel, [], 0, "NONE"];
        groupPetros setGroupId ["Maru","GroupColor4"];
        petros setIdentity "friendlyX";
        if (worldName == "Tanoa") then {petros setName "Maru"} else {petros setName "Petros"};
        petros disableAI "MOVE";
        petros disableAI "AUTOTARGET";
        if (group _viejo == groupPetros) then {[Petros,"mission"] remoteExec ["A3A_fnc_flagaction",[buenos,civilian],petros]} else {[Petros,"buildHQ"] remoteExec ["A3A_fnc_flagaction",[buenos,civilian],petros]};
        _nul= [] execVM "initPetros.sqf";
        deleteVehicle _viejo;
        publicVariable "petros";
		};
	respawnTeamPlayer setMarkerPos _positionTel;
	[respawnTeamPlayer,1] remoteExec ["setMarkerAlphaLocal",[buenos,civilian]];
	[respawnTeamPlayer,0] remoteExec ["setMarkerAlphaLocal",[malos,Invaders]];
	if (isMultiplayer) then {hint "Please wait while moving HQ Assets to selected position";sleep 5};
	_pos = [_positionTel, 3, getDir petros] call BIS_Fnc_relPos;
	fuego setPos _pos;
	_rnd = getdir Petros;
	if (isMultiplayer) then {sleep 5};
	_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
	caja setPos _pos;
	_rnd = _rnd + 45;
	_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
	mapa setPos _pos;
	mapa setDir ([fuego, mapa] call BIS_fnc_dirTo);
	_rnd = _rnd + 45;
	_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
	flagX setPos _pos;
	_rnd = _rnd + 45;
	_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
	vehicleBox setPos _pos;
	if (isNil "placementDone") then {if (isMultiplayer) then {{if ((side _x == buenos) or (side _x == civilian)) then {_x setPos getPos petros}} forEach playableUnits} else {theBoss setPos (getMarkerPos respawnTeamPlayer)}};
	theBoss allowDamage true;
	if (isMultiplayer) then
		{
		caja hideObjectGlobal false;
		vehicleBox hideObjectGlobal false;
		mapa hideObjectGlobal false;
		fuego hideObjectGlobal false;
		flagX hideObjectGlobal false;
		}
	else
		{
		caja hideObject false;
		vehicleBox hideObject false;
		mapa hideObject false;
		fuego hideObject false;
		flagX hideObject false;
		};
	openmap [false,false];
	};
{deleteMarkerLocal _x} forEach _mrkDum;
"Synd_HQ" setMarkerPos (getMarkerPos respawnTeamPlayer);
posHQ = getMarkerPos respawnTeamPlayer; publicVariable "posHQ";
if (isNil "placementDone") then {placementDone = true; publicVariable "placementDone"};
chopForest = false; publicVariable "chopForest";