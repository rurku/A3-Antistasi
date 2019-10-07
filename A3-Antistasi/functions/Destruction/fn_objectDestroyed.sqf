params ["_object"];

/*  Object got destroyed, handle destruction progress
*   Params:
*     _object : OBJECT : The object that got destroyed
*
*   Returns:
*     Nothing
*/

_object allowDamage false;

private _destructPoints = _object getVariable ["destructPoints", 0];
private _destructMarker = _object getVariable ["destructMarker", ""];

if(_destructMarker == "") exitWith
{
  diag_log "ObjectDestroyed: destructMarker on object is not set!";
};

private _canExplode = _object getVariable ["canExplode", false];
if(_canExplode) then
{
  //Object will go BOOM!

  private _explosion = "DemoCharge_Remote_Ammo_Scripted" createVehicle (getPos _object);

  //Sleep as a fuse
  sleep (random 5);

  //Boom
  _explosion setDamage 1;

  {
    if(_x != _object) then
    {
      _canMove = _x getVariable ["canMove", false];
      if(_canMove) then
      {
        //Calculate explosion force and vector
        _distance = _x distance _object;
        _initialForce = 25;
        _direction = (getPos _object) vectorFromTo (getPos _x);
        _velocity = _direction vectorMultiply (_initialForce * (2/_distance));

        //Add explosion velocity
        _x setVelocity _velocity;
      };
    };
  } forEach ((getPos _object) nearObjects 10);
};

//Adding destruct points to the site
[_destructMarker, _destructPoints] call A3A_fnc_addDestructPoints;

//Just replace the model by a destroyed model
[_object] call A3A_fnc_setDestroyedModel;
