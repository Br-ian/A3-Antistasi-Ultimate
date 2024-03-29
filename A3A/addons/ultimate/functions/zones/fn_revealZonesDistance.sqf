params [
    ["_pos", []],
    ["_distance", 0],
    ["_vehicle", objNull]
];

private _markers = [];

if !(isServer) exitWith {
    [_pos, _distance, _vehicle] remoteExec ["A3U_fnc_revealZonesDistance", 2];
};

if (_vehicle isNotEqualTo objNull) then {
    waitUntil {sleep 1; _vehicle distance2D _pos <= (_distance / 2)}; // not perfect, but should work fine
};

if (_pos isNotEqualTo [] && {_distance isNotEqualTo 0}) then {
    _markers = markersX select { !(_x in markersImmune) && { ( (getMarkerPos _x) distance2D _pos ) <= _distance} };
};

if (_markers isEqualTo []) exitWith {
    false
};

[_markers] call A3U_fnc_revealZones;

true