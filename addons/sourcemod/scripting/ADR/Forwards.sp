
static Handle g_hCoreLoadedForward;

public void Forwards_Create()
{
	g_hCoreLoadedForward = CreateGlobalForward("ADR_OnCoreLoaded", ET_Ignore);
}

public void Forwards_OnCoreLoaded()
{
	Call_StartForward(g_hCoreLoadedForward);
	Call_Finish();
}
