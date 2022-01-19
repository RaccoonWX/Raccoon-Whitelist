function ExtractIdentifiers(src)
    local identifiers = {
        discord = ""
    }

    --Loop Identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        
        if string.find(id, "discord") then
            identifiers.discord = id
        end
    end
    return identifiers
end

roleList = Configure.Whitelisted;

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local Configure = Configure
    deferrals.defer()
    local src = source
    local identifierDiscord = "";
    deferrals.update("Checking Your Server Permissions For " .. Configure.svname)
		
    Citizen.Wait(0);

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
				if string.sub(v, 1, string.len("discord:")) == "discord:" then
					identifierDiscord = v
				end
        end
        local isWhitelisted = false;
        if identifierDiscord then
                local roleIDs = exports.Badger_Discord_API:GetDiscordRoles(src)
                if not (roleIDs == false) then
                    for i = 1, #roleList do
                        for j = 1, #roleIDs do
                            if exports.Badger_Discord_API:CheckEqual(roleList[i], roleIDs[j]) then
                                print("[Raccoon-Whitelist] (playerConnecting) Allowing " .. GetPlayerName(src) .. " to join with the role "  .. roleList[i])
				print("[Raccoon-Whitelist] (playerConnecting) Player " .. GetPlayerName(src) .. "  Attempted to connect with Raccoon-Whitelist, They were allowed entry")
                                isWhitelisted = true;
                            else
                                if isWhitelisted == false then 
                                  isWhitelisted = false;
                                end
                            end
                        end
                    end
                else
                    print("[Raccoon-Whitelist] (playerConnecting) Player " .. GetPlayerName(src) .. "  We could not get your Role ID\'s, failed to connect.")
		    print("[Raccoon-Whitelist] (playerConnecting) Player " .. GetPlayerName(src) .. "  Attempted to connect with Raccoon-Whitelist, connection has failed.")
                    deferrals.done(Configure.RoleIDKick)
                    CancelEvent()
                    return;
                end
            else
                print("[Raccoon-Whitelist] (playerConnecting) Declined connection from " .. GetPlayerName(src) .. "  because they did not have Discord open")
		print("[Raccoon-Whitelist] (playerConnecting) Player " .. GetPlayerName(src) .. "  Attempted to connect with Raccoon-Whitelist, connection has failed.")
                deferrals.done(Configure.DiscordKick)
                CancelEvent()
                return;
            end
        if isWhitelisted then 
          deferrals.done();
        else
          deferrals.done(Configure.WhitelistKick);
          CancelEvent()
        end
end)
