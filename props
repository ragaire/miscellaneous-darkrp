--[[

PhysObj:EnableCollisions( boolean enable )


WARNING
     This function currently has major problems with player collisions, and as such should be avoided at all costs.
     A better alternative to this function would be using Entity:SetCollisionGroup( COLLISION_GROUP_WORLD ).


and? what are u gonna do about it ? LOL! 
]]


hook.Add("PlayerSpawnedProp", "ronnyg_collision_check", function(ply, model, ent)
     ent:SetCustomCollisionCheck(true)
end)

hook.Add("ShouldCollide", "ronnyg_should_collide", function(ent1, ent2)
     if ent1:IsValid() and ent2:IsValid() and ent1:GetClass() == "prop_physics" and ent2:GetClass() == "prop_physics" then
          local owner1 = ent1:CPPIGetOwner()
          local owner2 = ent2:CPPIGetOwner()

          if owner1 == owner2 then
               return false
          end
     end

     return true 
end)

hook.Add("KeyPress", "ronnyg_check_jump", function(ply, key)
    if key == IN_JUMP then
        ply.recentlyJumped = true 
        timer.Simple(.5, function()
            if IsValid(ply) then
                ply.recentlyJumped = false 
            end
        end)
    end
end)


hook.Add("PhysgunPickup", "ronnyg_pickup_protection", function(ply, ent)

    if ply.recentlyJumped then
        return false -- Prevent pickup if player recently jumped
    end


    if IsValid(ent) and ent:GetClass() == "prop_physics" then
        local groundEnt = ply:GetGroundEntity()
        local constrainedEnts = constraint.GetAllConstrainedEntities(ent)

        if ent == groundEnt or table.HasValue(constrainedEnts, groundEnt) then
            return false
        end

        -- Check if the prop is attached to a vehicle
        for _, constrainedEnt in pairs(constrainedEnts) do
            if constrainedEnt:IsVehicle() then
                return false
            end
        end

        -- Allow only "mod," "admin," and "superadmin" users to physgun any player's cars
        if ent:IsVehicle() and ent:GetClass():lower() == "prop_vehicle_jeep" then
            local staffPickup = {
                ["mod"] = true,
                ["admin"] = true,
                ["superadmin"] = true
            }

            if staffPickup[ply:GetUserGroup()] then
                return true
            end
        end
    end
end)

hook.Add("OnPhysgunPickup", "ronnyg_on_physgun_pickup", function(ply, ent)
    if IsValid(ent) and ent:GetClass() == "prop_physics" then

        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableCollisions(false) -- Disable collisions

            for _, constrainedEnt in pairs(constraint.GetAllConstrainedEntities(ent)) do
                if IsValid(constrainedEnt) and constrainedEnt:GetClass() == "prop_physics" then
                    local constrainedPhys = constrainedEnt:GetPhysicsObject()
                    if IsValid(constrainedPhys) then
                        constrainedPhys:EnableCollisions(false)
                    end
                end
            end
        end
    end
end)

hook.Add("PhysgunDrop", "ronnyg_drop_protection", function(ply, ent)
         if IsValid(ent) and ent:GetClass() == "prop_physics" then
             local phys = ent:GetPhysicsObject()
             if IsValid(phys) then
                     phys:EnableCollisions(true) 
                     phys:Wake() 

                     for _, constrainedEnt in pairs(constraint.GetAllConstrainedEntities(ent)) do
                         if IsValid(constrainedEnt) and constrainedEnt:GetClass() == "prop_physics" then
                             local constrainedPhys = constrainedEnt:GetPhysicsObject()
                             if IsValid(constrainedPhys) then
                                 constrainedPhys:EnableCollisions(true) 
                                 constrainedPhys:Wake() -- wakey wakey my n word
                             end
                         end
                     end
             end

        for _, v in pairs(constraint.GetAllConstrainedEntities(ent)) do
            if IsValid(v) and v:GetClass() == "prop_physics" then
                local phys = v:GetPhysicsObject()
                if IsValid(phys) then
                    phys:SetVelocityInstantaneous(Vector(0, 0, 0))
                    phys:AddAngleVelocity(-phys:GetAngleVelocity())
                end
            end
        end
    end
end)


hook.Add("CanTool", "AllowToolgunOnCars", function(ply, tr, tool)
    local ent = tr.Entity
    if not ent:IsVehicle() or ent:GetClass():lower() ~= "prop_vehicle_jeep" then return end

    if ent:CPPICanTool(ply) and ent:CPPIGetOwner() == ply then
        return true
    end

end)



hook.Add("EntityTakeDamage", "ronnyg_nokill", function(target, dmginfo)
     if target:IsPlayer() then
          local inflictor = dmginfo:GetInflictor()
          if inflictor:IsVehicle() then
               local driver = inflictor:GetDriver()
               if driver and driver:IsPlayer() then
                    dmginfo:ScaleDamage(0)
               end
          elseif inflictor:GetClass() == "prop_physics" or dmginfo:GetDamageType() == DMG_CRUSH then
               dmginfo:ScaleDamage(0)
          end
     end

     return dmginfo
end)

hook.Add("OnPhysgunReload", "ronnyg_okthisoneisobvious", function(physgun, ply)
     return false
end)
