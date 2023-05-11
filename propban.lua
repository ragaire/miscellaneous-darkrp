-- prop ban function
local function PropBan(target, banTime)
    if not IsValid(target) then return end

    target:SetNWInt("PropBanEndTime", os.time() + banTime)
end

-- prop unban function
local function UnpropBan(target)
    if not IsValid(target) then return end

    target:SetNWInt("PropBanEndTime", 0)
end

-- PlayerSpawnProp hook to prevent spawning props for banned players
hook.Add("PlayerSpawnProp", "PropBanCheck", function(ply, model)
    if ply:GetNWInt("PropBanEndTime", 0) > os.time() then
        ply:ChatPrint("You are currently banned from spawning props.")
        return false -- Prevent prop spawning if player is prop banned
    end
end)

-- !propban command
sam.command.new("propban")
    :SetCategory("Utility")
    :SetPermission("propban", "admin")
    :AddArg("player")
    :AddArg("length", { optional = true, default = 0, min = 0 })
    :AddArg("text", {hint = "reason", optional = true, default = sam.language.get("default_reason")})
    :GetRestArgs()
    :Help("Ban a player from spawning props.")
    :OnExecute(function(ply, targets, length, reason)
        for i = 1, #targets do
            local target = targets[i]
            PropBan(target, length * 60)
        end

        if sam.is_command_silent then return end
        sam.player.send_message(nil, "{A} propbanned {T} for {V}. Reason: {V_2}", {
            A = ply, T = targets, V = sam.format_length(length), V_2 = reason
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
            UnpropBan(target)
        end

        if sam.is_command_silent then return end
        sam.player.send_message(nil, "{A} unbanned {T} from spawning props.", {
            A = ply, T = targets
        })
    end)
:End()
