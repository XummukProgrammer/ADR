
public void Natives_Create()
{
	CreateNative("ADR_RegisterReward", Native_RegisterReward);
	CreateNative("ADR_UnregisterReward", Native_UnregisterReward);

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
