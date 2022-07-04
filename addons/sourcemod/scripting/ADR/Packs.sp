
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

public void Packs_JumpToRewards()
{
	g_hPacksConfig.JumpToKey("Rewards");
	g_hPacksConfig.GotoFirstSubKey();
}

public bool Packs_JumpToReward(const char[] szRewardID)
{
	return g_hPacksConfig.JumpToKey(szRewardID);
}

public KeyValues Packs_GetRewardConfig()
{
	return g_hPacksConfig;
}

typedef ForEachRewards = function void(const char[] szRewardID, KeyValues hRewardConfig, any data);
public void Packs_ForEachRewards(ForEachRewards fnForEachRewards, any data)
{
	Packs_JumpToRewards();
	
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
		DataPack hData = new DataPack();
		hData.WriteCell(iClient);
		hData.WriteString(szPackID);
	
		Packs_ForEachRewards(Packs_ForEachReceiveRewards, hData);
	}
	else
	{
		ThrowError("Не найден пак с идентификатором \"%s\"!", szPackID);
	}
}

static void Packs_ForEachReceiveRewards(const char[] szRewardID, KeyValues hRewardConfig, DataPack hData)
{
	hData.Reset();
	
	int iClient = hData.ReadCell();
	
	char szPackID[32];
	hData.ReadString(szPackID, sizeof(szPackID));

	Player_ReceiveReward(iClient, szPackID, szRewardID, hRewardConfig);
}
