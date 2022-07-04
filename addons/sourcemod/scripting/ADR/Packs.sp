
static KeyValues g_hPacksConfig;
static const char g_szPacksConfigPath[PLATFORM_MAX_PATH] = "configs/ADR/Packs.cfg";

public void Packs_InitVariables()
{
	g_hPacksConfig = new KeyValues("Packs");
	
	char szPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, szPath, sizeof(szPath), g_szPacksConfigPath);
	
	if (!g_hPacksConfig.ImportFromFile(szPath))
	{
		SetFailState("Не удалось загрузить файл конфигурации: \"%s\"!", szPath);
	}
}

public bool Packs_TryJumpToPack(const char[] szPackID)
{
	g_hPacksConfig.Rewind();
	return g_hPacksConfig.JumpToKey(szPackID);
}

public KeyValues Packs_GetPackConfig()
{
	return g_hPacksConfig;
}

typedef ForEachRewards = function void(const char[] szRewardID, KeyValues hRewardConfig, any data);
public void Packs_ForEachRewards(ForEachRewards fnForEachRewards, any data)
{
	g_hPacksConfig.JumpToKey("Rewards");
	g_hPacksConfig.GotoFirstSubKey();
	
	char szRewardID[32];
	
	do
	{
		g_hPacksConfig.GetSectionName(szRewardID, sizeof(szRewardID));
	
		Call_StartFunction(null, fnForEachRewards);
		Call_PushString(szRewardID);
		Call_PushCell(g_hPacksConfig);
		Call_PushCell(data);
		Call_Finish();
	}
	while (g_hPacksConfig.GotoNextKey());
}

public void Packs_ReceivePackRewards(int iClient, const char[] szPackID)
{
	if (Packs_TryJumpToPack(szPackID))
	{
		Packs_ForEachRewards(Packs_ForEachReceiveRewards, iClient);
	}
	else
	{
		ThrowError("Не найден пак с идентификатором \"%s\"!", szPackID);
	}
}

static void Packs_ForEachReceiveRewards(const char[] szRewardID, KeyValues hRewardConfig, int iClient)
{
	Player_ReceiveReward(iClient, szRewardID, hRewardConfig);
}
