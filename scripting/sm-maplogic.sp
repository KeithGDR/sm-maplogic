/*****************************/
//Pragma
#pragma semicolon 1
#pragma newdecls required

/*****************************/
//Defines
#define PLUGIN_NAME "[SM] Map Logic"
#define PLUGIN_DESCRIPTION "A plugin to setup to allow mappers to easily create mini games with Sourcemod logic."
#define PLUGIN_VERSION "1.0.0"

/*****************************/
//Includes
#include <sourcemod>
#include <sdktools>

/*****************************/
//ConVars

/*****************************/
//Globals

ArrayList g_Classnames;

enum struct MapLogic
{
	int entity;
	char name[64];

	void Init(int entity, const char[] name)
	{
		this.entity = entity;
		strcopy(this.name, 64, name);		
	}
}

MapLogic g_MapLogic[256];
int g_Total;

/*****************************/
//Plugin Info
public Plugin myinfo = 
{
	name = PLUGIN_NAME, 
	author = "Drixevel", 
	description = PLUGIN_DESCRIPTION, 
	version = PLUGIN_VERSION, 
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	ParseMapLogic();

	HookEvent("teamplay_round_start", Event_OnRoundStart);

	g_Classnames = new ArrayList(ByteCountToCells(64));
	g_Classnames.PushString("queue");
	g_Classnames.PushString("queues");
}

public void OnMapStart()
{
	ParseMapLogic();
}

public void Event_OnRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	ParseMapLogic();
}

void ParseMapLogic()
{
	g_Total = 0;

	int entity = -1; char name[64];
	while ((entity = FindEntityByClassname(entity, "info_target")) != -1)
	{
		GetEntPropString(entity, Prop_Data, "m_iName", name, sizeof(name));

		if (g_Classnames.FindString(name) == -1)
			continue;
		
		g_MapLogic[g_Total].Init(entity, name);
		g_Total++;
	}

	LogMessage("%i map logic entities loaded.", g_Total);
}