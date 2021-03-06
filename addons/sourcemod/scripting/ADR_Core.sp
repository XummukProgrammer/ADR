#pragma semicolon 1
#pragma tabsize 0

#pragma newdecls required

#include <ADR>
#include <sourcemod>

#include "ADR/Variables.sp"
#include "ADR/Helpers.sp"
#include "ADR/Player.sp"
#include "ADR/Database.sp"
#include "ADR/Menus.sp"
#include "ADR/Cmds.sp"
#include "ADR/Packs.sp"
#include "ADR/Days.sp"
#include "ADR/Rewards.sp"
#include "ADR/Natives.sp"
#include "ADR/Forwards.sp"

public Plugin myinfo = 
{
	name = "[ADR] Advanced Daily Rewards (Core)",
	author = "Xummuk97",
	description = "Ядро ежедневных наград",
	version = ADR_VERSION,
	url = "HLmod: @Xummuk97"
};

public APLRes AskPluginLoad2(Handle hMySelf, bool bIsLate, char[] szError, int iErrorMax)
{
	Natives_Create();
	return APLRes_Success;
}

public void OnPluginStart()
{
	Helpers_InitVariables();
	Helpers_LoadTranslations();
	
	Cmds_InitCommands();
	
	Forwards_Create();
}

public void OnAllPluginsLoaded()
{
	Database_InitDB();
}

public void OnClientPutInServer(int iClient)
{
	Player_LoadClient(iClient);
}

public void OnClientDisconnect(int iClient)
{
	Player_UnloadClient(iClient);
}

public void CoreLoaded()
{
	Forwards_OnCoreLoaded();
}
