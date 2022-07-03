
static const char g_szReceiveDailyRewardItemKey[32] = "receiveDailyReward";

public void Menus_ShowMainMenu(int iClient)
{
	Player_UpdateClient(iClient);

	Menu hMenu = new Menu(Menus_OnMainMenuHandler);
	Helpers_SetMenuTitle(hMenu, iClient, "MAIN_MENU_TITLE");
	Helpers_AddMenuAcceptableItem(hMenu, iClient, g_szReceiveDailyRewardItemKey, "MAIN_MENU_ITEM_RECEIVE_DAILY_REWARD");
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menus_OnMainMenuHandler(Menu hMenu, MenuAction eAction, int iClient, int iItem)
{
	switch (eAction)
	{
		case MenuAction_Cancel:
		{
			delete hMenu;
		}
		
		case MenuAction_Select:
		{
			char szInfo[32];
			hMenu.GetItem(iItem, szInfo, sizeof(szInfo));
			if (StrEqual(szInfo, g_szReceiveDailyRewardItemKey))
			{
				Player_ReceiveDailyReward(iClient);
			}
		}
	}
}
