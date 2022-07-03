
public void Cmds_InitCommands()
{
	RegConsoleCmd("sm_dr", Cmds_OnDRCommand);
}

public Action Cmds_OnDRCommand(int iClient, int iArgs)
{
	Menus_ShowMainMenu(iClient);
}
