
enum Database_Fields
{
	Database_AccountIDField,
	Database_LastVisitTimeField,
	Database_DayField,
	Database_NextDayTimeField,
	Database_ReceiveUsesField
}
#define DATABASE_FIELD(%0) view_as<int>(Database_%0Field)

#define QUERY_LENGTH 2048

static const char g_szDBKey[32] = "ADR-Database";
static const char g_szCreateTablesQuery[512] = "\
			CREATE TABLE IF NOT EXISTS `players_table` (\
			`accountid` 				INTEGER PRIMARY KEY NOT NULL,\
			`lastvisit_time`			INTEGER NOT NULL NOT NULL,\
			`day`						INTEGER NOT NULL default '1',\
			`nextday_time`				INTEGER NOT NULL default '-1',\
			`receive_uses`				INTEGER NOT NULL default '0'); ";
static const char g_szLoadPlayerQuery[256] = "SELECT * FROM `players_table` WHERE `accountid` = '%d';";
static const char g_szAddPlayerQuery[256] = "INSERT INTO `players_table` (`accountid`, `lastvisit_time`) VALUES('%d', '%d');";
static const char g_szUpdatePlayerQuery[256] = "\
			UPDATE `players_table`\
			SET `lastvisit_time` = '%d', `day` = '%d', `nextday_time` = '%d', `receive_uses` = '%d'\
			WHERE `accountid` = '%d';";

public void Database_InitDB()
{
	if (SQL_CheckConfig(g_szDBKey))
	{
		Database.Connect(Database_OnInitDB, g_szDBKey);
	}
	else
	{
		char szError[256];
		g_hDatabase = SQLite_UseDatabase(g_szDBKey, szError, sizeof(szError));
		Database_OnInitDB(g_hDatabase, szError, 1);
	}
}

public void Database_OnInitDB(Database hDatabase, const char[] szError, any data)
{
	if (!hDatabase || szError[0])
	{
		SetFailState(szError);
		return;
	}
	
	if (g_hDatabase != hDatabase)
	{
		g_hDatabase = hDatabase;
	}
		
	Database_CreateTables();
}

static void Database_CreateTables()
{
	SQL_LockDatabase(g_hDatabase);
	
	char szDriver[8];
	g_hDatabase.Driver.GetIdentifier(szDriver, sizeof(szDriver));
	
	if (szDriver[0] == 's')
	{
		g_hDatabase.Query(Database_OnCreateTables, g_szCreateTablesQuery);
	}
	else
	{
		SetFailState("Драйвер \"%s\" не поддерживается данным плагином!", szDriver);
	}
	
	SQL_UnlockDatabase(g_hDatabase);
}

public void Database_OnCreateTables(Database hDatabase, DBResultSet hResults, const char[] szError, any data)
{
	if (!hResults || szError[0])
	{
		ThrowError(szError);
		return;
	}
	
	CoreLoaded();
}

public void Database_LoadPlayer(int iClient)
{
	char szQuery[QUERY_LENGTH];
	FormatEx(szQuery, sizeof(szQuery), g_szLoadPlayerQuery, GetSteamAccountID(iClient));
	g_hDatabase.Query(Database_OnLoadPlayer, szQuery, GetClientUserId(iClient));
}

public void Database_OnLoadPlayer(Database hDatabase, DBResultSet hResults, const char[] szError, int iUserID)
{
	if (!hResults || szError[0])
	{
		ThrowError(szError);
		return;
	}
	
	int iClient = GetClientOfUserId(iUserID);
	if (!Helpers_IsPlayerValid(iClient))
	{
		return;
	}
	
	if (!hResults.FetchRow())
	{
		Database_AddPlayer(iClient);
		return;
	}
	
	int iPrevLastVisitTime = hResults.FetchInt(DATABASE_FIELD(LastVisitTime));
	int iDay = hResults.FetchInt(DATABASE_FIELD(Day));
	int iNextDayTime = hResults.FetchInt(DATABASE_FIELD(NextDayTime));
	int iReceiveUses = hResults.FetchInt(DATABASE_FIELD(ReceiveUses));
	
	Player_PostClientLoad(iClient, iPrevLastVisitTime, iDay, iNextDayTime, iReceiveUses);
}

public void Database_AddPlayer(int iClient)
{
	int iLastVisitTime = -1;
	Player_GetClientInfo(iClient, iLastVisitTime);
	
	char szQuery[QUERY_LENGTH];
	FormatEx(szQuery, sizeof(szQuery), g_szAddPlayerQuery, GetSteamAccountID(iClient), iLastVisitTime);
	g_hDatabase.Query(Database_OnAddPlayer, szQuery, GetClientUserId(iClient));
}

public void Database_OnAddPlayer(Database hDatabase, DBResultSet hResults, const char[] szError, int iUserID)
{
	if (!hResults || szError[0])
	{
		ThrowError(szError);
		return;
	}
	
	int iClient = GetClientOfUserId(iUserID);
	if (!Helpers_IsPlayerValid(iClient))
	{
		return;
	}
	
	Player_PostClientAdd(iClient);
}

public void Database_UpdatePlayer(int iClient)
{
	int iLastVisitTime = -1;
	int iDay = 1;
	int iNextDayTime = -1;
	int iReceiveUses = 0;
	Player_GetClientInfo(iClient, iLastVisitTime, iDay, iNextDayTime, iReceiveUses);
	
	char szQuery[QUERY_LENGTH];
	FormatEx(szQuery, sizeof(szQuery), g_szUpdatePlayerQuery, iLastVisitTime, iDay, iNextDayTime, iReceiveUses, GetSteamAccountID(iClient));
	g_hDatabase.Query(Database_OnUpdatePlayer, szQuery, GetClientUserId(iClient));
}

public void Database_OnUpdatePlayer(Database hDatabase, DBResultSet hResults, const char[] szError, int iUserID)
{
	if (!hResults || szError[0])
	{
		ThrowError(szError);
		return;
	}
	
	int iClient = GetClientOfUserId(iUserID);
	if (!Helpers_IsPlayerValid(iClient))
	{
		return;
	}
	
	Player_PostClientUpdate(iClient);
}
