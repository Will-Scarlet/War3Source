/* Plugin Template generated by Pawn Studio */

#include <sourcemod>
#include "W3SIncs/War3Source_Interface"

#pragma semicolon 1

new Handle:FHOnW3DodgePre;
new Handle:FHOnW3DodgePost;

new dummyresult;

public Plugin:myinfo = 
{
	name = "WCX - Dodge Engine",
	author = "necavi, Anthony Iacono",
	description = "WCX - Dodge Engine",
	version = "0.1",
	url = "http://necavi.com"
}

public OnPluginStart()
{
}
public bool:InitNativesForwards()
{
	FHOnW3DodgePre=CreateGlobalForward("OnW3DodgePre",ET_Hook,Param_Cell,Param_Cell,Param_Float);
	FHOnW3DodgePost=CreateGlobalForward("OnW3DodgePost",ET_Hook,Param_Cell,Param_Cell);
	return true;
}
public OnW3TakeDmgBulletPre(victim,attacker,Float:damage)
{
	new Float:EvadeChance = 0.0;
	EvadeChance = W3GetBuffStackedFloat(victim,fDodgeChance);
	if(EvadeChance<1.0)
	{
		if(IS_PLAYER(victim)&&IS_PLAYER(attacker)&&victim>0&&attacker>0&&attacker!=victim)
		{
			new vteam=GetClientTeam(victim);
			new ateam=GetClientTeam(attacker);
			if(vteam!=ateam)
			{
				new Float:chance = GetRandomFloat(0.0,1.0);
				
				Call_StartForward(FHOnW3DodgePre);
				Call_PushCell(victim);
				Call_PushCell(attacker);
				Call_PushFloat(chance);
				Call_Finish(dummyresult);
				
				if(!Hexed(victim,false) && chance>=EvadeChance && !W3HasImmunity(attacker,Immunity_Skills))
				{
					W3FlashScreen(victim,RGBA_COLOR_BLUE);
					
					
					War3_DamageModPercent(0.0);
					
					W3MsgEvaded(victim,attacker);
					
					Call_StartForward(FHOnW3DodgePost);
					Call_PushCell(victim);
					Call_PushCell(attacker);
					Call_Finish(dummyresult);
					
					if(War3_GetGame()==Game_TF)
					{
						decl Float:pos[3];
						GetClientEyePosition(victim, pos);
						pos[2] += 4.0;
						War3_TF_ParticleToClient(0, "miss_text", pos); //to the attacker at the enemy pos
					}
				}
			}
		}
	}
}



