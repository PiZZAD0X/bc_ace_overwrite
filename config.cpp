class CfgPatches
{
	class bc_briefingkit
	{
		units[]={};
		weapons[]={};
		requiredVersion=1.62;
		requiredAddons[]=
		{
			"cba_main"
		};
	};
};
class Extended_PreInit_EventHandlers
{
	class bc_briefingkit
	{
		clientinit="call compile preprocessFileLineNumbers '\z\bc\addons\ace_overwrite\xeh_preInit.sqf'";
	};
};

class CfgFunctions {
	#include "cfgfunctions.hpp"
};
