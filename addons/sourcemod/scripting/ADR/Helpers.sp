
public bool Helpers_IsPlayerValid(int iClient)
{
	return iClient > 0 && iClient <= MaxClients && IsClientConnected(iClient) && IsClientInGame(iClient) && !IsFakeClient(iClient);
}

public bool Helpers_IsTimeValid(int iTime)
{
	return iTime > -1;
}

public void Helpers_InitVariables()
{
	for (int i = 0; i < MAXPLAYERS + 1; ++i)
	{
		g_hPlayersData[i] = new StringMap();
		Player_InitData(i);
	}
	
	Packs_InitVariables();
	Days_InitVariables();
	Rewards_InitVariables();
}

public void Helpers_LoadTranslations()
{
	LoadTranslations("ADR/ADR_Core.phrases");
}

public void Helpers_SetMenuTitle(Menu hMenu, int iClient, const char[] szTranslationID)
{
	hMenu.SetTitle("%T", szTranslationID, iClient);
}

public void Helpers_AddMenuItem(Menu hMenu, int iClient, const char[] szInfo, const char[] szTranslationID, int iDisplayFlags)
{
	static char szBuffer[PLATFORM_MAX_PATH];
	FormatEx(szBuffer, sizeof(szBuffer), "%T", szTranslationID, iClient);
	hMenu.AddItem(szInfo, szBuffer, iDisplayFlags);
}

public void Helpers_AddMenuAcceptableItem(Menu hMenu, int iClient, const char[] szInfo, const char[] szTranslationID)
{
	int iDisplayFlags = Player_CanReceive(iClient) ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED;
	Helpers_AddMenuItem(hMenu, iClient, szInfo, szTranslationID, iDisplayFlags);
}

public void Helpers_PackRewardStringsCat(const char[] szPackID, const char[] szRewardID, char[] szBuffer, int iLength)
{
	FormatEx(szBuffer, iLength, "%s__%s", szPackID, szRewardID);
}

public void Helpers_PackRewardStringExplode(const char[] szBuffer, char[] szPackID, int iPackIDLength, char[] szRewardID, int iRewardIDLength)
{
	char szBuffers[2][32];
	ExplodeString(szBuffer, "__", szBuffers, 2, 32);
	strcopy(szPackID, iPackIDLength, szBuffers[0]);
	strcopy(szRewardID, iRewardIDLength, szBuffers[1]);
}
