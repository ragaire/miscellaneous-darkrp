local SAM_PropBans = {}

-- get prop ban function
function SAM_GetPropBan(target)
    if not IsValid(target) then return end

    return SAM_PropBans[target] and SAM_PropBans[target] or false
end

-- prop ban function
function SAM_PropBan(target, banTime)
    if not IsValid(target) then return end
    banTime = banTime or 0
    banTime = banTime > 0 and CurTime() + banTime or math.huge

    if SAM_PropBans[target] and SAM_PropBans[target] >= banTime then return end

    SAM_PropBans[target] = banTime
end

-- prop unban function
function SAM_UnpropBan(target)
    if not IsValid(target) then return end

    SAM_PropBans[target] = nil
end

-- PlayerSpawnObject hook to prevent spawning objects for banned players
hook.Add("PlayerSpawnObject", "PropBanCheck", function(ply, model)
    if SAM_PropBans[ply] and SAM_PropBans[ply] > CurTime() then
        ply:ChatPrint("You are currently banned from spawning props.")
        return false -- Prevent object spawning if player is banned
    end
end)

-- Clear the table if the player becomes invalid
hook.Add("PlayerDisconnected", "ClearPropBanCache", function(ply)
    SAM_PropBans[ply] = nil
end)

-- !propban command
sam.command.new("propban")
    :SetCategory("Utility")
    :SetPermission("propban", "admin")
    :AddArg("player")
    :AddArg("length", { hint = "length, 0 for permanent", optional = false, min = 0, default = 0 })
    :AddArg("text", { hint = "reason", optional = true, default = sam.language.get("default_reason") })
    :GetRestArgs()
    :Help("Ban a player from spawning props.")
    :OnExecute(function(ply, targets, length, reason)
        for i = 1, #targets do
            local target = targets[i]
            SAM_PropBan(target, length * 60)
        end

        if sam.is_command_silent then return end
        sam.player.send_message(nil, "{A} banned {T} from spawning props for {V}. Reason: {V_2}", {
            A = ply, T = targets, V = length <= 0 and "ever" or sam.format_length(length), V_2 = reason
        })
    end)
:End()


-- !unpropban command
sam.command.new("unpropban")
    :SetCategory("Utility")
    :SetPermission("unpropban", "admin")
    :AddArg("player", { optional = true })
    :Help("Unban a player from spawning props.")
    :OnExecute(function(ply, targets)
        for i = 1, #targets do
            local target = targets[i]
            SAM_UnpropBan(target)
        end

        if sam.is_command_silent then return end
        sam.player.send_message(nil, "{A} allowed {T} to spawn props again.", {
            A = ply, T = targets
        })
    end)
:End()
