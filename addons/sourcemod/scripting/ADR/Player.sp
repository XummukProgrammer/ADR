
static const char g_iLastVisitTime[32] = "iLastVisitTime";
static const char g_iDayKey[32] = "iDay";
static const char g_iNextDayTime[32] = "iNextDayTime";
static const char g_iReceiveUses[32] = "iReceiveUses";

public void Player_InitData(int iClient)
{
	Player_ClearClient(iClient);
}

public void Player_LoadClient(int iClient)
{
	if (!Helpers_IsPlayerValid(iClient)) 
	{
		return;
	}
	
	StringMap hData = g_hPlayersData[iClient];

	// Получаем здесь текущее время, а при работе с БД сможем узнать предыдущее время.
	hData.SetValue(g_iLastVisitTime, GetTime());
	
	Database_LoadPlayer(iClient);
}

public void Player_UnloadClient(int iClient)
{
	Player_UpdateClient(iClient);
	Player_ClearClient(iClient);
}

public void Player_ClearClient(int iClient)
{
	StringMap hData = g_hPlayersData[iClient];
	hData.SetValue(g_iLastVisitTime, -1);
	hData.SetValue(g_iDayKey, 1);
	hData.SetValue(g_iNextDayTime, -1);
	hData.SetValue(g_iReceiveUses, 0);
}

public void Player_UpdateClient(int iClient)
{
	if (!Helpers_IsPlayerValid(iClient)) 
	{
		return;
	}
	
	Player_TryIncrementDay(iClient);
	
	Database_UpdatePlayer(iClient);
}

stock void Player_GetClientInfo(int iClient, int& iLastVisitTime = 0, int& iDay = 0, int& iNextDayTime = 0, int& iReceiveUses = 0)
{
	if (!Helpers_IsPlayerValid(iClient)) 
	{
		return;
	}
	
	StringMap hData = g_hPlayersData[iClient];
	hData.GetValue(g_iLastVisitTime, iLastVisitTime);
	hData.GetValue(g_iDayKey, iDay);
	hData.GetValue(g_iNextDayTime, iNextDayTime);
	hData.GetValue(g_iReceiveUses, iReceiveUses);
}

public void Player_ReceiveDailyReward(int iClient)
{
	if (!Helpers_IsPlayerValid(iClient) || !Player_CanReceive(iClient)) 
	{
		return;
	}
	
	StringMap hData = g_hPlayersData[iClient];
	
	int iReceiveUses = 0;
	hData.GetValue(g_iReceiveUses, iReceiveUses);
	hData.SetValue(g_iReceiveUses, iReceiveUses + 1);
	
	hData.SetValue(g_iNextDayTime, GetTime() + g_iDayTime);
	
	Player_UpdateClient(iClient);
}

public bool Player_CanReceive(int iClient)
{
	StringMap hData = g_hPlayersData[iClient];
	
	int iNextDayTime = -1;
	hData.GetValue(g_iNextDayTime, iNextDayTime);

	return !Helpers_IsTimeValid(iNextDayTime) || (GetTime() >= iNextDayTime);
}

public void Player_ClearDay(int iClient)
{
	if (!Helpers_IsPlayerValid(iClient)) 
	{
		return;
	}
	
	StringMap hData = g_hPlayersData[iClient];
	hData.SetValue(g_iDayKey, 1);
	hData.SetValue(g_iNextDayTime, -1);
	
	/*if (!bIsFromUpdate)
	{
		Player_UpdateClient(iClient);
	}*/
}

public void Player_TryIncrementDay(int iClient)
{
	if (!Helpers_IsPlayerValid(iClient)) 
	{
		return;
	}
	
	StringMap hData = g_hPlayersData[iClient];
	int iNextDayTime = -1;
	hData.GetValue(g_iNextDayTime, iNextDayTime);
	
	if (Helpers_IsTimeValid(iNextDayTime) && (GetTime() >= iNextDayTime))
	{
		hData.SetValue(g_iNextDayTime, -1);
	
		int iDay = 1;
		hData.GetValue(g_iDayKey, iDay);
		hData.SetValue(g_iDayKey, iDay + 1);
	}
}

public void Player_PostClientLoad(int iClient, int iPrevLastVisitTime, int iDay, int iNextDayTime, int iReceiveUses)
{
	StringMap hData = g_hPlayersData[iClient];
	hData.SetValue(g_iDayKey, iDay);
	hData.SetValue(g_iNextDayTime, iNextDayTime);
	hData.SetValue(g_iReceiveUses, iReceiveUses);
		
	if (Helpers_IsTimeValid(g_iLackTimeOnClear) && (GetTime() >= (iPrevLastVisitTime + g_iLackTimeOnClear)))
	{
		Player_ClearDay(iClient);
	}
	
	Player_OnClientLoaded(iClient);
}

public void Player_PostClientAdd(int iClient)
{
	Player_OnClientLoaded(iClient);
}

static void Player_OnClientLoaded(int iClient)
{
	Player_UpdateClient(iClient);
}

public void Player_PostClientUpdate(int iClient)
{

}
