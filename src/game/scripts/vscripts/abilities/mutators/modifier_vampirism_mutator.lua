--=======================================================================================
-- Generated by TypescriptToLua transpiler https://github.com/Perryvw/TypescriptToLua 
-- Date: Sun May 13 2018
--=======================================================================================
require("typescript_lualib")
--LinkLuaModifier("modifier_vampirism_mutator","abilities/mutators/modifier_vampirism_mutator.lua",LUA_MODIFIER_MOTION_NONE)
modifier_vampirism_mutator = {}
modifier_vampirism_mutator.__index = modifier_vampirism_mutator
function modifier_vampirism_mutator.new(construct, ...)
    local instance = setmetatable({}, modifier_vampirism_mutator)
    if construct and modifier_vampirism_mutator.constructor then modifier_vampirism_mutator.constructor(instance, ...) end
    return instance
end
function modifier_vampirism_mutator.IsPermanent(self)
    return true
end
function modifier_vampirism_mutator.IsPurgable(self)
    return false
end
function modifier_vampirism_mutator.OnCreated(self)
    self.daytime_hp_drain=1
    self.night_lifesteal=20
end
function modifier_vampirism_mutator.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,MODIFIER_EVENT_ON_ATTACK_LANDED}
end
function modifier_vampirism_mutator.GetModifierHealthRegenPercentage(self)
    if IsClient() then
        return 0
    end
    if GameRules:IsDaytime() then
        return -1
    end
    return 0
end
function modifier_vampirism_mutator.OnAttackLanded(self,kv)
    if GameRules:IsDaytime() then
        return 0
    end
    if (self:GetParent()==kv.attacker) and kv.target:IsAlive() then
        if not kv.target:IsOther() and not kv.target:IsBuilding() then
            self:GetParent():Heal((kv.damage*self.night_lifesteal)*0.01,self:GetParent())
            local p = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_OVERHEAD_FOLLOW,self:GetParent())

            ParticleManager:ReleaseParticleIndex(p)
        end
    end
end
