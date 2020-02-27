#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <dhooks>
#include <tf2>
#include <tf2_stocks>
#include <tf_econ_data>

#include <CEconItemView>

#pragma semicolon 1
#pragma newdecls required

//#define DEBUG

Handle g_hSDKGetLoadoutItem;
Handle g_hHookGetLoadoutItem;

Handle g_hSDKGiveNamedItem;
Handle g_hHookGiveNamedItem;

Handle g_hSDKGetCustomName;
Handle g_hHookGetCustomName;

Handle g_hSDKGetBaseEntity;
Handle g_hSDKEquipWearable;
Handle g_hSDKRemoveWearable;
Handle g_hSDKGetEntityForLoadoutSlot;
Handle g_hSDKGetEquippedWearable;

bool g_bLate;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	g_bLate = late;
}

public void OnPluginStart()
{
	if (LibraryExists("TF2Items"))
		SetFailState("TF2Items is loaded: GiveNamedItem hook will crash the server.");
	
	RegAdminCmd("sm_test", Command_Test, ADMFLAG_BAN); // Prints loadout item data
	RegAdminCmd("sm_test2", Command_Test2, ADMFLAG_BAN); // Equips all other players with caller's melee weapon
	
	GameData hGameData = new GameData("tf2.econitemview");
	if (!hGameData)
		SetFailState("Failed to load gamedata!");
	
	g_hHookGetLoadoutItem = DHookCreateFromConf(hGameData, "CTFPlayer::GetLoadoutItem");
	if (!g_hHookGetLoadoutItem)
		SetFailState("Failed to hook CTFPlayer::GetLoadoutItem!");
	
	if (!DHookEnableDetour(g_hHookGetLoadoutItem, false, Detour_OnGetLoadoutItem))
		SetFailState("Failed to detour CTFPlayer::GetLoadoutItem!");
	if (!DHookEnableDetour(g_hHookGetLoadoutItem, true, Detour_OnGetLoadoutItemPost))
		SetFailState("Failed to detour CTFPlayer::GetLoadoutItem post!");
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "CTFPlayer::GetLoadoutItem");
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_ByValue);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_ByValue);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_ByValue);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_ByValue);
	g_hSDKGetLoadoutItem = EndPrepSDKCall();
	if (!g_hSDKGetLoadoutItem)
		SetFailState("Failed to create call CTFPlayer::GetLoadoutItem!");
	
	g_hHookGiveNamedItem = DHookCreate(hGameData.GetOffset("CTFPlayer::GiveNamedItem"), HookType_Entity, ReturnType_CBaseEntity, ThisPointer_CBaseEntity);
	if (!g_hHookGiveNamedItem)
	{
		SetFailState("Failed to create hook: CTFPlayer::GiveNamedItem!");
	}
	else
	{
		DHookAddParam(g_hHookGiveNamedItem, HookParamType_CharPtr);
		DHookAddParam(g_hHookGiveNamedItem, HookParamType_Int);
		DHookAddParam(g_hHookGiveNamedItem, HookParamType_Int);
		DHookAddParam(g_hHookGiveNamedItem, HookParamType_Bool);
	}
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "CTFPlayer::GiveNamedItem");
	PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_ByValue);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_ByValue);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_ByValue);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_ByValue);
	g_hSDKGiveNamedItem = EndPrepSDKCall();
	if (!g_hSDKGiveNamedItem)
		SetFailState("Failed to create call CTFPlayer::GiveNamedItem!");
	
	g_hHookGetCustomName = DHookCreate(hGameData.GetOffset("CEconItemView::GetCustomName"), HookType_Raw, ReturnType_CharPtr, ThisPointer_Address, Detour_OnGetCustomName);
	if (!g_hHookGetCustomName)
		SetFailState("Failed to create hook: CEconItemView::GetCustomName!");
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "CEconItemView::GetCustomName");
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	PrepSDKCall_SetReturnInfo(SDKType_String, SDKPass_Pointer);
	g_hSDKGetCustomName = EndPrepSDKCall();
	if (!g_hSDKGetCustomName)
		SetFailState("Failed to create call CEconItemView::GetCustomName!");
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "CBaseEntity::GetBaseEntity");
	PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
	g_hSDKGetBaseEntity = EndPrepSDKCall();
	if (!g_hSDKGetBaseEntity)
		SetFailState("Failed to create call: CBaseEntity::GetBaseEntity!");
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "CBasePlayer::EquipWearable");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	g_hSDKEquipWearable = EndPrepSDKCall();
	if (!g_hSDKEquipWearable)
		SetFailState("Failed to create call: CBasePlayer::EquipWearable!");
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "CBasePlayer::RemoveWearable");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	g_hSDKRemoveWearable = EndPrepSDKCall();
	if (!g_hSDKRemoveWearable)
		SetFailState("Failed to create call: CBasePlayer::RemoveWearable!");
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "CTFPlayer::GetEntityForLoadoutSlot");
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_ByValue); // slot
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_ByValue); // bool
	PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
	g_hSDKGetEntityForLoadoutSlot = EndPrepSDKCall();
	if (!g_hSDKGetEntityForLoadoutSlot)
		SetFailState("Failed to create call: CTFPlayer::GetEntityForLoadoutSlot!");
	
	LogMessage("Started");
	
	delete hGameData;
	
	if (g_bLate)
		for (int i = 1; i <= MaxClients; i++)
			if (IsClientInGame(i))
				OnClientPutInServer(i);
}

public void OnClientPutInServer(int client)
{
	DHookEntity(g_hHookGiveNamedItem, false, client, _, Detour_OnGiveNamedItem);
	DHookEntity(g_hHookGiveNamedItem, true, client, _, Detour_OnGiveNamedItemPost);
}

public void OnEntityCreated(int entity, const char[] classname)
{
	
}

CEconItemView GetLoadoutItem(int iClient, TFClassType iClass, int iSlot, bool b = false)
{
	return SDKCall(g_hSDKGetLoadoutItem, iClient, iClass, iSlot, b);
}

Address GiveNamedItem(int iClient, char[] sClassname, int iSubType, CEconItemView Item, bool b = false)
{
	return SDKCall(g_hSDKGiveNamedItem, iClient, sClassname, iSubType, Item, b);
}

// Still borked. Getting the return string from a post hook works though.
void GetCustomName(CEconItemView Item, char[] buf, int maxlen)
{
	SDKCall(g_hSDKGetCustomName, Item, 0, buf, maxlen);
}

int GetBaseEntity(Address ent)
{
	return SDKCall(g_hSDKGetBaseEntity, ent);
}

void EquipWearable(int iClient, int iWearable)
{
	SDKCall(g_hSDKEquipWearable, iClient, iWearable);
}

void RemoveWearable(int iClient, int iWearable)
{
	SDKCall(g_hSDKRemoveWearable, iClient, iWearable);
}

// ALWAYS returns -1 for slots 7 and 10 thanks valve
int GetEntityForLoadoutSlot(int iClient, int iSlot, bool b = false)
{
	return SDKCall(g_hSDKGetEntityForLoadoutSlot, iClient, iSlot, b);
}

public MRESReturn Detour_OnGetLoadoutItem(int iClient, Handle hReturn, Handle hParams)
{
	#if defined DEBUG
	int iClass = DHookGetParam(hParams, 1);
	int iSlot = DHookGetParam(hParams, 2);
	bool b = DHookGetParam(hParams, 3);
	
	PrintToServer("%N's CTFPlayer::GetLoadoutItem called. iClass %i, iSlot %i, b %i", iClient, iClass, iSlot, b);
	#endif
}

public MRESReturn Detour_OnGetLoadoutItemPost(int iClient, Handle hReturn, Handle hParams)
{
	CEconItemView Item = CEconItemView(DHookGetReturn(hReturn));
	if (Item)
		DHookRaw(g_hHookGetCustomName, true, view_as<Address>(Item));
	
	#if defined DEBUG
	int iClass = DHookGetParam(hParams, 1);
	int iSlot = DHookGetParam(hParams, 2);
	bool b = DHookGetParam(hParams, 3);
	
	PrintToServer("%N's CTFPlayer::GetLoadoutItem post called. iClass %i, iSlot %i, b %i", iClient, iClass, iSlot, b);
	PrintToServer("m_iItemDefinitionIndex: %i", Item.m_iItemDefinitionIndex);
	PrintToServer("m_iEntityQuality: %i", Item.m_iEntityQuality);
	PrintToServer("m_iEntityLevel: %i", Item.m_iEntityLevel);
	PrintToServer("m_iItemID: %i", 322);
	PrintToServer("m_iItemIDHigh: %i", Item.m_iItemIDHigh);
	PrintToServer("m_iItemIDLow: %i", Item.m_iItemIDLow);
	PrintToServer("m_iAccountID: %i", Item.m_iAccountID);
	PrintToServer("m_iInventoryPosition: %i", Item.m_iInventoryPosition);
	PrintToServer("m_bColorInit: %i", Item.m_bColorInit);
	PrintToServer("m_bPaintOverrideInit: %i", Item.m_bPaintOverrideInit);
	PrintToServer("m_bHasPaintOverride: %i", Item.m_bHasPaintOverride);
	PrintToServer("m_flOverrideIndex: %f", Item.m_flOverrideIndex);
	PrintToServer("m_unRGB: %i", Item.m_unRGB);
	PrintToServer("m_unAltRGB: %i", Item.m_unAltRGB);
	PrintToServer("m_iTeamNumber: %i", Item.m_iTeamNumber);
	PrintToServer("m_bInitialized: %i", Item.m_bInitialized);
	PrintToServer(" ");
	#endif
	
	return MRES_Ignored;
}

public MRESReturn Detour_OnGiveNamedItem(int iClient, Handle hReturn, Handle hParams)
{
	return MRES_Ignored;
}

public MRESReturn Detour_OnGiveNamedItemPost(int iClient, Handle hReturn, Handle hParams)
{
	return MRES_Ignored;
}

public MRESReturn Detour_OnGetCustomName(Address pThis, Handle hReturn)
{
	char str[64];
	DHookGetReturnString(hReturn, str, sizeof(str));
	PrintToServer("OnGetCustomName: %s", str);
	
	return MRES_Ignored;
}

// Unsafe. Will crash the server if client has anything equipped in the loadout slot.
bool CreateAndEquipItem(int iClient, char[] sClassname, CEconItemView Item, int iSubType = 0)
{
	Address ptr = GiveNamedItem(iClient, sClassname, iSubType, Item);
	if (ptr)
	{
		int ent = GetBaseEntity(GiveNamedItem(iClient, sClassname, iSubType, Item));
		
		if (StrContains(sClassname, "tf_wearable") != -1)
			EquipWearable(iClient, ent);
		else
			EquipPlayerWeapon(iClient, ent);
		
		return true;
	}
	
	return false;
}

void RemoveWeaponSlot(int iClient, int iSlot)
{
	if (iSlot <= 6)
	{
		int iEnt = GetEntityForLoadoutSlot(iClient, iSlot);
		
		if (iEnt != -1)
		{
			int iExtraWearable = GetEntPropEnt(iEnt, Prop_Send, "m_hExtraWearable");
			if (iExtraWearable != -1)
				TF2_RemoveWearable(iClient, iExtraWearable);
			
			iExtraWearable = GetEntPropEnt(iEnt, Prop_Send, "m_hExtraWearableViewModel");
			if (iExtraWearable != -1)
				RemoveWearable(iClient, iExtraWearable);
			
			AcceptEntityInput(iEnt, "Kill");
		}
	}
}

void RemoveAllWeapons(int iClient)
{
	for (int i = 0; i <= 6; i++)
		RemoveWeaponSlot(iClient, i);
	
	// Spell book check
	int iAction = GetEntityForLoadoutSlot(iClient, 9);
	if (iAction != -1)
	{
		char sClass[64];
		GetEntityClassname(iAction, sClass, sizeof(sClass));
		if (StrContains(sClass, "tf_weapon"))
			RemoveWeaponSlot(iClient, 9);
	}
}

void RemoveWearableSlot(int iClient, int iSlot)
{
	if (iSlot >= 7 && iSlot <= 10)
	{
		int iEnt = GetEntityForLoadoutSlot(iClient, iSlot);
		
		if (iEnt != -1)
		{
			RemoveWearable(iClient, iEnt);
			AcceptEntityInput(iEnt, "Kill");
		}
	}
}

public Action Command_Test(int iClient, int iArgs)
{
	TFClassType iClass = TF2_GetPlayerClass(iClient);
	
	PrintToServer(" ");
	for (int i = 0; i <= 18; i++)
	{
		CEconItemView Item = GetLoadoutItem(iClient, iClass, i);
		char sClassname[128];
		TF2Econ_GetItemClassName(Item.m_iItemDefinitionIndex, sClassname, sizeof(sClassname));
		
		char sName[128];
		TF2Econ_GetItemName(Item.m_iItemDefinitionIndex, sName, sizeof(sName));
		
		PrintToServer("Slot %i: %i | %s | %s", i, GetEntityForLoadoutSlot(iClient, i), sClassname, sName);
	}
	PrintToServer(" ");
}

public Action Command_Test2(int iClient, int iArgs)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && i != iClient)
		{
			RemoveAllWeapons(i);
			
			CEconItemView Item = GetLoadoutItem(iClient, TF2_GetPlayerClass(iClient), 2);
			
			char sClassname[64];
			TF2Econ_GetItemClassName(Item.m_iItemDefinitionIndex, sClassname, sizeof(sClassname));
			
			Address ptr = GiveNamedItem(i, sClassname, 1, Item);
			if (ptr)
				EquipPlayerWeapon(i, GetBaseEntity(ptr));
		}
	}
	return Plugin_Handled;
}