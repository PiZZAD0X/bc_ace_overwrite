#include "script_component.hpp"
/*
 * Author: PabstMirror, Glowbal
 * Determines if damage is fatal
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 * 1: Part No <NUMBER>
 * 2: Damage Array - QGVAR(medical,bodyPartDamage) <ARRAY>
 * 3: New Damage <NUMBER>
 *
 * ReturnValue:
 * Was Fatal <BOOL>
 *
 * Example:
 * [player, 0, 1.4, 0.7] call ace_medical_damage_fnc_determineIfFatal
 *
 * Public: No
 */
params ["_unit", "_part", "_bodyPartDamage", "_woundDamage"];

scopeName "main";
if (EGVAR(medical,fatalDamageSource) in [0, 2]) then {
    // Emulate damage to vital organs - Original rewrite logic, only powerfull headshots or random torso shots
    if (_part == 0 && {_woundDamage >= ace_medical_const_headDamageThreshold}) exitWith {
        // Fatal damage to the head is guaranteed death
        TRACE_1("determineIfFatal: lethal headshot",_woundDamage);
        true breakOut "main";
    };
    if (_part == 1 && {_woundDamage >= ace_medical_const_organDamageThreshold} && {random 1 < ACE_MEDICAL_const_heartHitChance}) exitWith {
        // Fatal damage to torso has various results based on organ hit - Heart shot is lethal
        TRACE_1("determineIfFatal: lethal heartshot",_woundDamage);
        true breakOut "main";
    };
};
if (EGVAR(medical,fatalDamageSource) in [1, 2]) then {
    // Sum of trauma to critical areas can be fatal (e.g. many small hits)
    private _damageThreshold = if (isPlayer _unit) then { EGVAR(medical,playerDamageThreshold) } else { EGVAR(medical,AIDamageThreshold) };
    private _headThreshhold = ace_medical_const_headResistance * _damageThreshold;
    private _bodyThreshhold = ace_medical_const_bodyResistance * _damageThreshold;
    private _armsThreshhold = ace_medical_const_armsResistance * _damageThreshold;
    private _legsThreshhold = ace_medical_const_legsResistance * _damageThreshold;

    _bodyPartDamage params ["_headDamage", "_bodyDamage","_lArmDamage","_rArmDamage","_lLegDamage","_rLegDamage"];

    private _sumOfDamage = 0;
    _sumOfDamage = _sumOfDamage + ((_headDamage - _headThreshhold) max 0) * ace_medical_const_headVitalMutiplier;
    _sumOfDamage = _sumOfDamage + ((_bodyDamage - _bodyThreshhold) max 0) * ace_medical_const_bodyVitalMutiplier;
    _sumOfDamage = _sumOfDamage + (((_lArmDamage + _rArmDamage) - _armsThreshhold) max 0) * ace_medical_const_armsVitalMutiplier;
    _sumOfDamage = _sumOfDamage + (((_lLegDamage + _rLegDamage) - _legsThreshhold) max 0) * ace_medical_const_legsVitalMutiplier;

    private _chanceFatal = 1 - exp -((_sumOfDamage/ace_medical_const_fatalSumDamageWeibull_L)^ace_medical_const_fatalSumDamageWeibull_K);
    if(_unit getVariable ["ace_isunconscious", false])then{_chanceFatal = (_chanceFatal * 2) max .3};
    if (_chanceFatal > random 1) exitWith {
        true breakOut "main";
    };
};

false
