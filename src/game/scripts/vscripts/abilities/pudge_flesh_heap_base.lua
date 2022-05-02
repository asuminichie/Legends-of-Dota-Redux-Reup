-- Generated by TypescriptToLua v0.2.0
-- https://github.com/Perryvw/TypescriptToLua
require("typescript_lualib")
pudge_flesh_heap_base = {}
pudge_flesh_heap_base.__index = pudge_flesh_heap_base
function pudge_flesh_heap_base.new(construct, ...)
    local instance = setmetatable({}, pudge_flesh_heap_base)
    if construct and pudge_flesh_heap_base.constructor then pudge_flesh_heap_base.constructor(instance, ...) end
    return instance
end
function pudge_flesh_heap_base.constructor(self)
end
function pudge_flesh_heap_base.GetIntrinsicModifierName(self)
    return "modifier_kill"
end
modifier_flesh_heap_base = {}
modifier_flesh_heap_base.__index = modifier_flesh_heap_base
function modifier_flesh_heap_base.new(construct, ...)
    local instance = setmetatable({}, modifier_flesh_heap_base)
    if construct and modifier_flesh_heap_base.constructor then modifier_flesh_heap_base.constructor(instance, ...) end
    return instance
end
function modifier_flesh_heap_base.constructor(self)
end
function modifier_flesh_heap_base.RemoveOnDeath(self)
    return false
end
function modifier_flesh_heap_base.IsPermanent(self)
    return true
end
function modifier_flesh_heap_base.IsPurgable(self)
    return false
end
function modifier_flesh_heap_base.OnCreated(self)
    if IsServer() and not self.GetAbility then
        self:Destroy()
        local hero = self:GetParent()

        hero:CalculateStatBonus(true)
        return
    end
    self.flesh_heap_value_buff_amount=self:GetAbility():GetSpecialValueFor("flesh_heap_value_buff_amount")
    if IsServer() then
        self:SetStackCount(0)
        local hero = self:GetParent()

        hero:CalculateStatBonus(true)
    end
end
function modifier_flesh_heap_base.OnRefresh(self)
    if IsServer() and not self.GetAbility then
        self:Destroy()
        local hero = self:GetParent()

        hero:CalculateStatBonus(true)
        return
    end
    self.flesh_heap_value_buff_amount=self:GetAbility():GetSpecialValueFor("flesh_heap_value_buff_amount")
    if IsServer() then
        self:SetStackCount(0)
        local hero = self:GetParent()

        hero:CalculateStatBonus(true)
    end
end
function modifier_flesh_heap_base.DeclareFunctions(self)
    return {MODIFIER_EVENT_ON_DEATH}
end
function modifier_flesh_heap_base.OnDeath(self,keys)
    local caster = self:GetCaster()

    print("OD1")
    if (not keys.unit or not keys.attacker) or (keys.attacker~=caster) then
        return
    end
    print("OD2")
    if (not keys.unit:IsRealHero() or keys.unit:IsTempestDouble()) or keys.unit:IsReincarnating() then
        return
    end
    print("OD3")
    local killer = keys.attacker:GetPlayerOwner()

    local victim = keys.unit

    if caster:GetTeamNumber()~=victim:GetTeamNumber() then
        print("OD4")
        self.fleshHeapRange=self:GetAbility():GetSpecialValueFor("flesh_heap_range")
        local distance = (caster:GetAbsOrigin()-victim:GetAbsOrigin()):Length2D()

        if self.fleshHeapRange>=distance then
            print("OD5")
            self:IncrementStackCount()
            caster:CalculateStatBonus(true)
        end
        local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf",PATTACH_OVERHEAD_FOLLOW,caster)

        ParticleManager:SetParticleControl(nFXIndex,1,Vector(1,0,0))
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end
