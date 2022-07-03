
static const char g_szNameKey[32] = "szName";

public void Player_InitData(int iClient)
{
	StringMap hData = g_hPlayersData[iClient];
	hData.SetString(g_szNameKey, "");
}

public void Player_LoadClient(int iClient)
{
	if (!Helpers_IsPlayerValid(iClient)) 
	{
		return;
	}
	
	StringMap hData = g_hPlayersData[iClient];
	
	char szName[MAX_NAME_LENGTH];
	GetClientName(iClient, szName, sizeof(szName));
	// TODO: Добавить экранирование для имени с помощью объекта базы данных.
	hData.SetString(g_szNameKey, szName);
}

public void Player_UnloadClient(int iClient)
{
	Player_UpdateClient(iClient);
	Player_ClearClient(iClient);
}

public void Player_ClearClient(int iClient)
{
	StringMap hData = g_hPlayersData[iClient];
	hData.SetString(g_szNameKey, "");
}

public void Player_UpdateClient(int iClient)
{
	if (!Helpers_IsPlayerValid(iClient)) 
	{
		return;
	}
}

public void Player_ReceiveDailyReward(int iClient)
{

}
