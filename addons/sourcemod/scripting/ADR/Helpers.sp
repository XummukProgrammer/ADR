
public bool Helpers_IsPlayerValid(int iClient)
{
	return iClient > 0 && iClient <= MaxClients && IsClientConnected(iClient) && IsClientInGame(iClient) && !IsFakeClient(iClient);
}

public void Helpers_InitVariables()
{
	for (int i = 0; i < MAXPLAYERS + 1; ++i)
	{
		g_hPlayersData[i] = new StringMap();
		Player_InitData(i);
	}
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
