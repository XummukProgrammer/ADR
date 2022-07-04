#if defined _ADR_included
 #endinput
#endif
#define _ADR_included

/*
 * @brief Версия плагина.
 */
#define ADR_VERSION "1.0.0_alpha"

/*
 * @brief Награда была выдана игроку.
 *
 * @param iClient			Идентификатор клиента.
 * @param szRewardID		Идентификатор награды.
 * @param hRewardConfig		Конфиг награды.
 *
 * @noreturn
 */
typedef ADR_RewardReceived = function void(int iClient, const char[] szRewardID, KeyValues hRewardConfig);

/*
 * @brief Ядро загружено.
 *
 * @noparams
 *
 * @noreturn
 */
forward void ADR_OnCoreLoaded();

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
}
