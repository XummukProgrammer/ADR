
static StringMap g_hRewards;

static DataPackPos g_posPlugin = view_as<DataPackPos>(0);
static DataPackPos g_posRewardReceived = view_as<DataPackPos>(1);

public void Rewards_InitVariables()
{
	g_hRewards = new StringMap();
}

public void Rewards_RegisterReward(const char[] szRewardID, Plugin hPlugin, ADR_RewardReceived fnRewardReceived)
{
	DataPack hRewardData = new DataPack();
	hRewardData.WriteCell(hPlugin);
	hRewardData.WriteFunction(fnRewardReceived);
	g_hRewards.SetValue(szRewardID, hRewardData);
}

public void Rewards_UnregisterReward(const char[] szRewardID)
{
	g_hRewards.Remove(szRewardID);
}

public void Rewards_OnRewardReceived(int iClient, const char[] szPackID, const char[] szRewardID, KeyValues hRewardConfig)
{
	DataPack hRewardData;
	g_hRewards.GetValue(szRewardID, hRewardData);
	
	hRewardData.Position = g_posPlugin;
	Handle hPlugin = hRewardData.ReadCell();
	
	hRewardData.Position = g_posRewardReceived;
	ADR_RewardReceived fnRewardReceived = view_as<ADR_RewardReceived>(hRewardData.ReadFunction());
	
	if (fnRewardReceived != INVALID_FUNCTION)
	{
		ADR_RewardReceiveResult eResult = RECEIVE_SUCCESS;
		
		Call_StartFunction(hPlugin, fnRewardReceived);
		Call_PushCell(iClient);
		Call_PushString(szPackID);
		Call_PushString(szRewardID);
		Call_PushCell(hRewardConfig);		
		Call_Finish(eResult);
		
		char szPackReward[64];
		Helpers_PackRewardStringsCat(szPackID, szRewardID, szPackReward, sizeof(szPackReward));
		
		switch (eResult)
		{
			case RECEIVE_SUCCESS:
			{
				LogMessage("Успешная выдача награды \"%s\" для игрока %N (%d)", szPackReward, iClient, GetSteamAccountID(iClient));
			}
		}
	}
}
