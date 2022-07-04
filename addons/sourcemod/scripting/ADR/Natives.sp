
public void Natives_Create()
{
	CreateNative("ADR_RegisterReward", Native_RegisterReward);
	CreateNative("ADR_UnregisterReward", Native_UnregisterReward);
	
	CreateNative("ADR_GetDayConfig", Native_GetDayConfig);
	CreateNative("ADR_GetPackConfig", Native_GetPackConfig);
	CreateNative("ADR_GetRewardConfig", Native_GetRewardConfig);
	
	CreateNative("ADR_GetClientInfo", Native_GetClientInfo);
	
	RegPluginLibrary("ADR_Core");
}

public int Native_RegisterReward(Handle hPlugin, int iNumParams)
{
	char szRewardID[32];
	GetNativeString(1, szRewardID, sizeof(szRewardID));
	
	ADR_RewardReceived fnRewardReceived = view_as<ADR_RewardReceived>(GetNativeFunction(2));
	
	Rewards_RegisterReward(szRewardID, view_as<Plugin>(hPlugin), fnRewardReceived);
}

public int Native_UnregisterReward(Handle hPlugin, int iNumParams)
{
	char szRewardID[32];
	GetNativeString(1, szRewardID, sizeof(szRewardID));
	
	Rewards_UnregisterReward(szRewardID);
}

public int Native_GetDayConfig(Handle hPlugin, int iNumParams)
{
	int iDay = GetNativeCell(1);
	Days_TryJumpToDay(iDay);
	
	return view_as<int>(Days_GetDayConfig());
}

public int Native_GetPackConfig(Handle hPlugin, int iNumParams)
{
	char szPackID[32];
	GetNativeString(1, szPackID, sizeof(szPackID));
	Packs_TryJumpToPack(szPackID);
	
	return view_as<int>(Packs_GetPackConfig());
}

public int Native_GetRewardConfig(Handle hPlugin, int iNumParams)
{
	char szPackID[32];
	GetNativeString(1, szPackID, sizeof(szPackID));
	Packs_TryJumpToPack(szPackID);
	
	Packs_JumpToRewards();
	
	char szRewardID[32];
	GetNativeString(2, szRewardID, sizeof(szRewardID));
	Packs_JumpToReward(szRewardID);
	
	return view_as<int>(Packs_GetRewardConfig());
}

public int Native_GetClientInfo(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	bool bIsLoaded = false;
	int iLastVisitTime = -1;
	int iDay = 1;
	int iNextDayTime = -1;
	int iReceiveUses = 0;
	Player_GetClientInfo(iClient, bIsLoaded, iLastVisitTime, iDay, iNextDayTime, iReceiveUses);
	
	SetNativeCellRef(2, bIsLoaded);
	SetNativeCellRef(3, iLastVisitTime);
	SetNativeCellRef(4, iDay);
	SetNativeCellRef(5, iNextDayTime);
	SetNativeCellRef(6, iReceiveUses);
}
