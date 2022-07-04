#if defined _ADR_included
 #endinput
#endif
#define _ADR_included

/*
 * @brief Версия плагина.
 */
#define ADR_VERSION "1.0.0_alpha"

/*
 * @brief Ядро загружено.
 *
 * @noparams
 *
 * @noreturn
 */
forward void ADR_OnCoreLoaded();

/*
 * @brief Игрок загружен.
 *
 * @param iClient	Идентификатор клиента.
 *
 * @noreturn
 */
forward void ADR_OnClientLoaded(int iClient);

/*
 * @brief Результат при выдаче награды.
 */
enum ADR_RewardReceiveResult
{
	RECEIVE_SUCCESS // Награда была выдана успешно.
}

/*
 * @brief Награда была выдана игроку.
 *
 * @param iClient			Идентификатор клиента.
 * @param szPackID			Идентификатор пака.
 * @param szRewardID		Идентификатор награды.
 * @param hRewardConfig		Конфиг награды.
 *
 * @return Результат при выдаче награды.
 */
typedef ADR_RewardReceived = function ADR_RewardReceiveResult(int iClient, const char[] szPackID, const char[] szRewardID, KeyValues hRewardConfig);

/*
 * @brief Регистрация награды.
 *
 * @param szRewardID			Идентификатор награды.
 * @param fnRewardReceived		Функция, которая вызывается при выдаче награды.
 *
 * @noreturn
 */
native void ADR_RegisterReward(const char[] szRewardID, ADR_RewardReceived fnRewardReceived = INVALID_FUNCTION);

/*
 * @brief Снять регистрацию с награды.
 *
 * @param szRewardID	Идентификатор награды.
 *
 * @noreturn
 */
native void ADR_UnregisterReward(const char[] szRewardID);

/*
 * @brief Получить конфиг дня.
 *
 * @param iDay	Идентификатор дня.
 *
 * @return Конфиг.
 * @note Нельзя использовать в коллбеках, принимающий KeyValues во избежание ошибок.
 */
native KeyValues ADR_GetDayConfig(int iDay);

/*
 * @brief Получить конфиг пака.
 *
 * @param szPackID	Идентификатор пака.
 *
 * @return Конфиг.
 * @note Нельзя использовать в коллбеках, принимающий KeyValues во избежание ошибок.
 */
native KeyValues ADR_GetPackConfig(const char[] szPackID);

/*
 * @brief Получить конфиг награды.
 *
 * @param szPackID		Идентификатор пака.
 * @param szRewardID	Идентификатор награды.
 *
 * @return Конфиг.
 * @note Нельзя использовать в коллбеках, принимающий KeyValues во избежание ошибок.
 */
native KeyValues ADR_GetRewardConfig(const char[] szPackID, const char[] szRewardID);

/*
 * @brief Получить информацию о игроке.
 *
 * @param iClient			Идентификатор клиента.
 * @param bIsLoaded			Загружен ли клиент.
 * @param iLastVisitTime	Время последнего подключения к серверу (фактически время текущего подключения).
 * @param iDay				Кол-во дней, которые игрок непрерывно играет на сервере.
 * @param iNextDayTime		Время, когда начнётся следующий день для возможности получить награду.
 * @param iReceiveUses		Сколько всего игрок уже получил наград.
 *
 * @noreturn
 */
native void ADR_GetClientInfo(int iClient, bool& bIsLoaded = false, int& iLastVisitTime = 0, int& iDay = 0, int& iNextDayTime = 0, int& iReceiveUses = 0);


public SharedPlugin __pl_ADR_Core = 
{
	name = "ADR_Core",
	file = "ADR_Core.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_ADR_Core_SetNTVOptional()
{
	MarkNativeAsOptional("ADR_RegisterReward");
	MarkNativeAsOptional("ADR_UnregisterReward");
	
	MarkNativeAsOptional("ADR_GetDayConfig");
	MarkNativeAsOptional("ADR_GetPackConfig");
	MarkNativeAsOptional("ADR_GetRewardConfig");
	
	MarkNativeAsOptional("ADR_GetClientInfo");
}
