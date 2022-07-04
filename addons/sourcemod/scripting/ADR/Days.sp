
static KeyValues g_hDaysConfig;
static const char g_szDaysConfigPath[PLATFORM_MAX_PATH] = "configs/ADR/Days.cfg";

static const char g_szDefaultDayKey[32] = "defaultDay";
static const char g_szPackIdKey[32] = "packId";

public void Days_InitVariables()
{
	g_hDaysConfig = new KeyValues("Days");
	
	char szPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, szPath, sizeof(szPath), g_szDaysConfigPath);
	
	if (!g_hDaysConfig.ImportFromFile(szPath))
	{
		SetFailState("Не удалось загрузить файл конфигурации: \"%s\"!", szPath);
	}
}

public bool Days_TryJumpToDay(int iDay)
{
	char szDay[32];
	IntToString(iDay, szDay, sizeof(szDay));

	g_hDaysConfig.Rewind();
	
	if (!g_hDaysConfig.JumpToKey(szDay))
	{
		g_hDaysConfig.GetString(g_szDefaultDayKey, szDay, sizeof(szDay));
		
		if (!g_hDaysConfig.JumpToKey(szDay))
		{
			return false;
		}
	}
	
	return true;
}

public void Days_GetPackID(char[] szPackID, int iLength)
{
	g_hDaysConfig.GetString(g_szPackIdKey, szPackID, iLength);
}

public void Days_GetCurrentPackID(int iClient, char[] szPackID, int iLength)
{
	int iDay = 1;
	Player_GetClientInfo(iClient, _, iDay);
	
	if (Days_TryJumpToDay(iDay))
	{
		Days_GetPackID(szPackID, iLength);
	}
	else
	{
		ThrowError("Не найден день с идентификатором \"%d\"!", iDay);
	}
}

public void Days_ReceiveDayRewards(int iClient)
{
	char szPackID[32];
	Days_GetCurrentPackID(iClient, szPackID, sizeof(szPackID));
	
	Packs_ReceivePackRewards(iClient, szPackID);
}
