-- WRUGS: INIT

local WRUGS_WIM_PostMessage;

WRUGS_Version="1.1.4 Beta";
WRUGS_Block="[][][][]";
WRUGS_Lastaction="";
WRUGS_Lastauth="";

-- WRUGS: Chatframe Hook

function WRUGS_ChatFrame_AddMessage(self, msg, a1,a2,a3,a4,a5,a6,a7,a8,a9)
if(WRUGS_Enabled=="1") then
	LOC_WRUGS_AUTHMSG_FILL="";
	WRUGS_INFORM_Confirm="0";
	if(strfind(msg, LOC_WRUGS_MSGBLOCKED, 1, true)~=nil) then
		if(WRUGS_Lastaction=="INFORM") then WRUGS_INFORM_Confirm="1"; end
	elseif(strfind(msg, LOC_WRUGS_MSGPRIVACY, 1, true)~=nil) then
		if(WRUGS_Lastaction=="INFORM") then WRUGS_INFORM_Confirm="1"; end
	elseif(strfind(msg, LOC_WRUGS_MSGHIDPASS, 1, true)~=nil) then
		if(WRUGS_Lastaction=="INFORM") then WRUGS_INFORM_Confirm="1"; end
	elseif(strfind(msg, LOC_WRUGS_AUTHACCEPT, 1, true)~=nil) then
		-- message(WRUGS_Lastaction);
		if(WRUGS_Lastaction=="INFORM") then
			LOC_WRUGS_AUTHMSG_FILL = gsub(LOC_WRUGS_AUTHMSG, "{player}", WRUGS_Lastauth);
			WRUGS_INFORM_Confirm="1"; 
		end
	end
	if(strfind(msg, WRUGS_Block, 1, true)~=nil) then
		WRUGS_Block="[][][][]";
	else
		if(WRUGS_INFORM_Confirm=="0") then
			return self:WRUGS_Orig_AddMessage(msg, a1,a2,a3,a4,a5,a6,a7,a8,a9);
		end
	end
	if(LOC_WRUGS_AUTHMSG_FILL~="") then
		DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_AUTHMSG_FILL);
		WRUGS_Lastauth=nil;
	end
else
	return self:WRUGS_Orig_AddMessage(msg, a1,a2,a3,a4,a5,a6,a7,a8,a9);
end
end

function WRUGS_HookAllChatFrames()
	for i=1,NUM_CHAT_WINDOWS do
		local cf = getglobal("ChatFrame"..i);
		cf.WRUGS_Orig_AddMessage = cf.AddMessage;
		cf.AddMessage = WRUGS_ChatFrame_AddMessage;
	end
end

-- WRUGS: Events

function WRUGS_OnEvent()
	-- WRUGS: Localization // Need this since the /wrugs command is still available and can't update vars while disabled.
	if(event=="ADDON_LOADED" and arg1=="WRUGS") then
		if(WRUGS_Enabled==nil) then WRUGS_Enabled="1"; end
		-- WRUGS: Vars update
		if(type(Authenticated)=="table") then
			WRUGS_Auth = Authenticated;
			Authenticated = "";
		end
		if(wrugscmd~=nil) then
			if(strlen(wrugscmd)>0) then
				WRUGS_Cmd = wrugscmd;
				wrugscmd = "";
			end
		end
		if(type(blocklog)=="table") then
			WRUGS_Blocklog = blocklog;
			blocklog = "";
		end
		if(WRUGS_Privacy=="1") then DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_PRIVACYON);	end
		if(WRUGS_Hidepass=="1") then DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_HIDPASSON); end
		-- WRUGS: INIT Part 2
		if(WRUGS_Blocklog==nil) then WRUGS_Blocklog={ }; end
		if(WRUGS_Hidepass==nil) then WRUGS_Hidepass="0"; end
		if(WRUGS_Privacy==nil) then WRUGS_Privacy="0"; end
		if(WRUGS_Auth==nil) then WRUGS_Auth = { }; end
		if(WRUGS_Cmd==nil) then WRUGS_Cmd = "WRUGS"; end
		LOC_WRUGS_LOADED = gsub(LOC_WRUGS_LOADED, "{ver}", WRUGS_Version);
		LOC_WRUGS_MSGBLOCKED = gsub(LOC_WRUGS_MSGBLOCKED, "{cmd}", WRUGS_Cmd);
		LOC_WRUGS_MSGPRIVACY = gsub(LOC_WRUGS_MSGPRIVACY, "{player}", UnitName("player"));
		LOC_WRUGS_MSGHIDPASS = gsub(LOC_WRUGS_MSGHIDPASS, "{player}", UnitName("player"));
		-- Chatr Hook
		if(IsAddOnLoaded("Chatr")) then
			function WRUGS_AddWhisper(name,msg,status,chatrId)
				WRUGS_Chatr_AddIt = "0";
				if(UnitInParty("player")~=nil) then
					nParty = GetNumPartyMembers();
					for i=1, nParty do
						if(name==UnitName("party"..i)) then
							-- Player is a partymember, message allowed.
							WRUGS_Chatr_AddIt="1";
						end
					end
				end
				if(UnitInRaid("player")~=nil) then
					nRaid = GetNumRaidMembers();
					for i=1, nRaid do
						Rname = GetRaidRosterInfo(i);
						if(name==Rname) then
							-- Player is a raidmember, message allowed.
							WRUGS_Chatr_AddIt="1";
						end
					end
				end
				if(IsInGuild()) then
					nGuild = GetNumGuildMembers(true);
					for i=1, nGuild do
						Gname = GetGuildRosterInfo(i);
						if(name==Gname) then
							-- Player is a guildmember, message allowed.
							WRUGS_Chatr_AddIt="1";
						end
					end
				end
				nFriends = GetNumFriends();
				for i=1, nFriends do
					Fname = GetFriendInfo(i);
					if(name==Fname) then
						-- Player is on the friendslist, message allowed.
						WRUGS_Chatr_AddIt="1";
					end
				end
				if(WRUGS_Auth[name]=="1") then
					-- Player has authenticated before, message allowed.
					WRUGS_Chatr_AddIt="1";
				end

				if(status=="GM") then
					WRUGS_Chatr_AddIt = "1";
				end
				if(WRUGS_Chatr_AddIt=="1") then
					return WRUGS_Chatr_AddWhisper(name, msg, status, chatrId);
				end
				
			end
			WRUGS_Chatr_AddWhisper = Chatr_AddWhisper;
			Chatr_AddWhisper = WRUGS_AddWhisper;
			function WRUGS_AddWhisperTo(name,msg)
						DoNotShow = "0";
						if(strfind(msg, LOC_WRUGS_MSGBLOCKED, 1, true)~=nil) then
							DoNotShow = "1";
						elseif(strfind(msg, LOC_WRUGS_MSGPRIVACY, 1, true)~=nil) then
							DoNotShow = "1";
						elseif(strfind(msg, LOC_WRUGS_MSGHIDPASS, 1, true)~=nil) then
							DoNotShow = "1";
						elseif(strfind(msg, LOC_WRUGS_AUTHACCEPT, 1, true)~=nil) then
							DoNotShow = "1";
						end
				if(DoNotShow~="1") then
					if(strfind(WRUGS_Block, msg, nil, true)==nil) then
						return WRUGS_Chatr_AddWhisperTo(name,msg);
					end
				end
			end
			WRUGS_Chatr_AddWhisperTo = Chatr_AddWhisperTo;
			Chatr_AddWhisperTo = WRUGS_AddWhisperTo;
		end
		-- WIM Hook
		if(IsAddOnLoaded("WIM")) then
			function WRUGS_PostMessage(user, msg, ttype, from, raw_msg)
				if(WRUGS_Enabled=="1") then
					WIM_ALLOWMSG="1";
					if(ttype==1) then 
						-- reserved
					elseif(ttype==2) then
						if(strfind(msg, LOC_WRUGS_MSGBLOCKED, 1, true)~=nil) then
							user = nil;
						elseif(strfind(msg, LOC_WRUGS_MSGPRIVACY, 1, true)~=nil) then
							user = nil;
						elseif(strfind(msg, LOC_WRUGS_MSGHIDPASS, 1, true)~=nil) then
							user = nil;
						elseif(strfind(msg, LOC_WRUGS_AUTHACCEPT, 1, true)~=nil) then
							user = nil;
						end
					end
					WRUGS_WIM_RETVAL_USER = user;
					WRUGS_WIM_RETVAL_MSG = msg;
					WRUGS_WIM_RETVAL_TTYPE = ttype;
					WRUGS_WIM_RETVAL_FROM = from;
					WRUGS_WIM_RETVAL_RAWMSG = raw_msg;
					if(ttype~=1) then
						return WRUGS_WIM_PostMessage(user, msg, ttype, from, raw_msg);
					end
				else
					return WRUGS_WIM_PostMessage(user, msg, ttype, from, raw_msg);
				end
			end
			WRUGS_WIM_PostMessage = WIM_PostMessage;
			WIM_PostMessage = WRUGS_PostMessage;
		end
		WRUGS_HookAllChatFrames();
		if(IsInGuild()) then GuildRoster(); end
	end
if(WRUGS_Enabled=="1") then
	if(event=="ADDON_LOADED" and arg1=="WRUGS") then
		DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_LOADED);
	elseif(event=="CHAT_MSG_ADDON" and arg1=="WRUGSAUTH" and arg3=="GUILD") then
		if(arg2~=nil) then
			if(arg2~=UnitName("player")) then
				WRUGS_Auth[arg2]="1";
			end
		end		
	elseif(event=="CHAT_MSG_WHISPER") then
		WRUGS_Lastaction="CHATMSG";
		WRUGS_NOWIMYET="0";
		if(strupper(arg1)==strupper(WRUGS_Cmd)) then
			if(WRUGS_Privacy=="0") then
				-- Authentication is only possible when the privacy function is disabled
				if(WRUGS_Auth[arg2]~="1") then
					WRUGS_Lastauth = arg2;
					WRUGS_Block=arg1;
					-- Player has used the authentication command, player accepted.
					WRUGS_Auth[arg2]="1";
					-- Sending Authentication to Guildchannel
					if(IsInGuild()) then
						SendAddonMessage("WRUGSAUTH", arg2, "GUILD");
					end
					
					SendChatMessage(LOC_WRUGS_AUTHACCEPT, "WHISPER", nil, arg2);
					WRUGS_NOWIMYET="1";
				end
			end
		end
		WRUGS_ALLOWMSG="0";
		if(UnitInParty("player")~=nil) then
			nParty = GetNumPartyMembers();
			for i=1, nParty do
				if(arg2==UnitName("party"..i)) then
					-- Player is a partymember, message allowed.
					WRUGS_ALLOWMSG="1";
				end
			end
		end
		if(UnitInRaid("player")~=nil) then
			nRaid = GetNumRaidMembers();
			for i=1, nRaid do
				Rname = GetRaidRosterInfo(i);
				if(arg2==Rname) then
					-- Player is a raidmember, message allowed.
					WRUGS_ALLOWMSG="1";
				end
			end
		end
		if(IsInGuild()) then
			nGuild = GetNumGuildMembers(true);
			for i=1, nGuild do
				Gname = GetGuildRosterInfo(i);
				if(arg2==Gname) then
					-- Player is a guildmember, message allowed.
					WRUGS_ALLOWMSG="1";
				end
			end
		end
		nFriends = GetNumFriends();
		for i=1, nFriends do
			Fname = GetFriendInfo(i);
			if(arg2==Fname) then
				-- Player is on the friendslist, message allowed.
				WRUGS_ALLOWMSG="1";
			end
		end
		if(WRUGS_Auth[arg2]=="1") then
			-- Player has authenticated before, message allowed.
			WRUGS_ALLOWMSG="1";
		end
		if(strfind(arg6, "GM")~=nil) then
			-- Message from a GameMaster, message allowed.
			WRUGS_ALLOWMSG="1";
		end
		if(strsub(arg1, 1, 9)~="LVBM VER ") then
			if(WRUGS_ALLOWMSG=="0") then
				WRUGS_Block=arg1;
				tinsert(WRUGS_Blocklog, getn(WRUGS_Blocklog)+1, "["..arg2.."]: "..arg1);
				if(arg2~=UnitName("player")) then
					if(WRUGS_Privacy=="0") then
						if(WRUGS_Hidepass=="0") then
							SendChatMessage(LOC_WRUGS_MSGBLOCKED, "WHISPER", nil, arg2);
						else
							SendChatMessage(LOC_WRUGS_MSGHIDPASS, "WHISPER", nil, arg2);
						end
					else
						if(WRUGS_Hidepass=="0") then
							SendChatMessage(LOC_WRUGS_MSGPRIVACY, "WHISPER", nil, arg2);
						else
							SendChatMessage(LOC_WRUGS_MSGHIDPASS, "WHISPER", nil, arg2);
						end
					end
				end
			end
		end
		if(IsAddOnLoaded("WIM")) then
			if(WRUGS_WIM_RETVAL_TTYPE==1) then
				if(WRUGS_ALLOWMSG=="1") then
					if(strfind(WRUGS_WIM_RETVAL_MSG, arg1, 1, true)~=nil) then
						if(WRUGS_NOWIMYET=="0") then
							WRUGS_WIM_PostMessage(WRUGS_WIM_RETVAL_USER, WRUGS_WIM_RETVAL_MSG, WRUGS_WIM_RETVAL_TTYPE, WRUGS_WIM_RETVAL_FROM, WRUGS_WIM_RETVAL_RAWMSG);
						end
					end
				else
					WRUGS_WIM_RETVAL_USER = nil;
					WRUGS_WIM_PostMessage(WRUGS_WIM_RETVAL_USER, WRUGS_WIM_RETVAL_MSG, WRUGS_WIM_RETVAL_TTYPE, WRUGS_WIM_RETVAL_FROM, WRUGS_WIM_RETVAL_RAWMSG);
				end
			end
		end
	elseif(event=="CHAT_MSG_WHISPER_INFORM") then
		WRUGS_Lastaction="INFORM";
		-- By whispering a person you automatically authenticate this player. Exception for automatic messages.
		WRUGS_AutoMSG="0";
		if(strfind(arg1, LOC_WRUGS_MSGBLOCKED, 1, true)~=nil) then
			WRUGS_AutoMSG="1";
		elseif(strfind(arg1, LOC_WRUGS_MSGPRIVACY, 1, true)~=nil) then
			WRUGS_AutoMSG="1";
		elseif(strfind(arg1, LOC_WRUGS_MSGHIDPASS, 1, true)~=nil) then
			WRUGS_AutoMSG="1";
		elseif(strfind(arg1, LOC_WRUGS_AUTHACCEPT, 1, true)~=nil) then
			WRUGS_AutoMSG="1";
		end
		if(WRUGS_AutoMSG=="0") then
			WRUGS_Auth[arg2]="1";
			-- Sending Authentication to Guildchannel
			if(IsInGuild()) then
				SendAddonMessage("WRUGSAUTH", arg2, "GUILD");
			end
		end
	elseif(event=="PLAYER_GUILD_UPDATE") then
		if(IsInGuild()) then
			GuildRoster();
		end
	end
end
end

-- WRUGS: Slashcommands

function WRUGS_Command(cmd)
	if(cmd=="") then
		if(WRUGS_Enabled=="1") then
			LOC_WRUGS_STATUSEN_FILL = gsub(LOC_WRUGS_STATUSEN, "{ver}", WRUGS_Version);
			LOC_WRUGS_STATUSEN_FILL = gsub(LOC_WRUGS_STATUSEN_FILL, "{cmd}", WRUGS_Cmd);
			DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_STATUSEN_FILL);
			if(WRUGS_Privacy=="1") then
				if(WRUGS_Hidepass=="1") then
					DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_STATUS4);
				else
					DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_STATUS3);
				end
			else
				if(WRUGS_Hidepass=="1") then
					DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_STATUS2);
				else
					DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_STATUS1);
				end
			end
		else
			LOC_WRUGS_STATUSDIS_FILL = gsub(LOC_WRUGS_STATUSDIS, "{ver}", WRUGS_Version);
			LOC_WRUGS_STATUSDIS_FILL = gsub(LOC_WRUGS_STATUSDIS_FILL, "{cmd}", WRUGS_Cmd);
			DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_STATUSDIS);
		end
	elseif(strlower(cmd)=="on") then
		if(WRUGS_Enabled~="1") then 
			WRUGS_Enabled="1"; 
			DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_MSGADDON);
		end
	elseif(strlower(cmd)=="off") then
		if(WRUGS_Enabled~="0") then 
			WRUGS_Enabled="0"; 
			DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_MSGADDOFF);
		end
	elseif(strlower(cmd)=="privacy") then
		if(WRUGS_Privacy=="1") then
			WRUGS_Privacy="0";
			DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_PRIVACYOFF);
		else
			WRUGS_Privacy="1";
			DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_PRIVACYON);
		end
	elseif(strlower(cmd)=="hidepass") then
		if(WRUGS_Hidepass=="1") then
			WRUGS_Hidepass="0";
			DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_HIDPASSOFF);
		else
			WRUGS_Hidepass="1";
			DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_HIDPASSON);
		end
	elseif(strlower(cmd)=="purgeplayers") then
		WRUGS_Auth = { };
		DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_WLPURGED);
	elseif(strlower(cmd)=="purgehistory") then
		WRUGS_Blocklog = { };
		DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_HISPURGED);
	elseif(strsub(strlower(cmd), 1, 7)=="remove ") then
		WRUGS_PTR = strupper(strsub(cmd, 8, 8))..strlower(strsub(cmd, 9));
		if(WRUGS_Auth[WRUGS_PTR]=="1") then
			WRUGS_Auth[WRUGS_PTR]="0";
			LOC_WRUGS_REMAUTHMSG_FILL = gsub(LOC_WRUGS_REMAUTHMSG, "{remplayer}", WRUGS_PTR);
			DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_REMAUTHMSG_FILL);
		end
	elseif(strsub(strlower(cmd), 1, 4)=="add ") then
		if(strlen(cmd)>4) then
			WRUGS_PTA = strupper(strsub(cmd, 5, 5))..strlower(strsub(cmd, 6));
			if(WRUGS_Auth[WRUGS_PTA]~="1") then
				WRUGS_Auth[WRUGS_PTA]="1";
				LOC_WRUGS_AUTHMSG_FILL = gsub(LOC_WRUGS_AUTHMSG, "{player}", WRUGS_PTA);
				DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_AUTHMSG_FILL);
				LOC_WRUGS_AUTHMSG_FILL = nil;
			else
				LOC_WRUGS_ADD_EXIST_FILL = gsub(LOC_WRUGS_ADD_EXIST, "{player}", WRUGS_PTA);
				DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_ADD_EXIST_FILL);
			end
		end
	elseif(strsub(strlower(cmd), 1, 8)=="setpass ") then
		if(strlen(cmd)>9) then
			WRUGS_Cmd = strupper(strsub(cmd, 9));
			LOC_WRUGS_NEW_PASS_FILL = gsub(LOC_WRUGS_NEW_PASS, "{newpass}", strupper(strsub(cmd, 9)));
			DEFAULT_CHAT_FRAME:AddMessage(LOC_WRUGS_NEW_PASS_FILL);
		end
	end
end

SLASH_WRUGS1 = "/wrugs";
SlashCmdList["WRUGS"] = WRUGS_Command;

-- WRUGS: Frame creation / Event registration

local wrugs = CreateFrame("Frame");
wrugs:SetScript("OnEvent", WRUGS_OnEvent);
wrugs:RegisterEvent("ADDON_LOADED");
wrugs:RegisterEvent("CHAT_MSG_WHISPER");
wrugs:RegisterEvent("CHAT_MSG_WHISPER_INFORM");
wrugs:RegisterEvent("PLAYER_GUILD_UPDATE");
wrugs:RegisterEvent("CHAT_MSG_ADDON");