
static Handle g_hCoreLoadedForward;
static Handle g_hClientLoadedForward;

public void Forwards_Create()
{
	g_hCoreLoadedForward = CreateGlobalForward("ADR_OnCoreLoaded", ET_Ignore);
	g_hClientLoadedForward = CreateGlobalForward("ADR_OnClientLoaded", ET_Ignore, Param_Cell);
}

public void Forwards_OnCoreLoaded()
{
	Call_StartForward(g_hCoreLoadedForward);
	Call_Finish();
}

public void Forwards_OnClientLoaded(int iClient)
{
	Call_StartForward(g_hClientLoadedForward);
	Call_PushCell(iClient);
	Call_Finish();
}
