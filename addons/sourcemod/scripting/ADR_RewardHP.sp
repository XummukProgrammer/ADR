#pragma semicolon 1
#pragma tabsize 0

#pragma newdecls required

#include <ADR>
#include <sourcemod>

static const char g_szRewardID[32] = "HP";

public Plugin myinfo = 
{
	name = "[ADR] HP (Reward)",
	author = "Xummuk97",
	description = "Награда для выдачи здоровья",
	version = "1.0.0",
	url = "HLmod: @Xummuk97"
};

public void ADR_OnCoreLoaded()
{
	ADR_RegisterReward(g_szRewardID, NORMAL_REWARD, Reward_OnReceived);
}

public ADR_RewardReceiveResult Reward_OnReceived(int iClient, const char[] szPackID, const char[] szRewardID, KeyValues hRewardConfig)
{
	PrintToChat(iClient, "Вы получили награду %s (HP: %d)", szRewardID, hRewardConfig.GetNum("value"));
}
