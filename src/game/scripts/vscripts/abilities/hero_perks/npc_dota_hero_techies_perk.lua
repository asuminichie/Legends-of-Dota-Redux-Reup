--------------------------------------------------------------------------------------------------------
--
--		Hero: Techies
--		Perk: Traps and Explosives will have 30% of their mana refunded and cooldowns reduced by 30%.
--
--------------------------------------------------------------------------------------------------------
if modifier_npc_dota_hero_techies_perk ~= "" then modifier_npc_dota_hero_techies_perk = class({}) end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_techies_perk:IsPassive()
	return true
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_techies_perk:IsHidden()
	return false
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_techies_perk:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_techies_perk:IsPurgable()
	return false
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_techies_perk:OnCreated(keys)
	self.cooldownPercentReduction = 30
	self.manaPercentReduction = 30

	self.cooldownReduction = 1 - (self.cooldownPercentReduction / 100)
	self.manaReduction = self.manaPercentReduction / 100
end
--------------------------------------------------------------------------------------------------------
-- Add additional functions
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_techies_perk:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_techies_perk:OnAbilityFullyCast(keys)
	if IsServer() then
		local hero = self:GetCaster()
		local target = keys.target
		local ability = keys.ability
		if hero == keys.unit and ability and ( ability:HasAbilityFlag("trap") or ability:HasAbilityFlag("explosive") ) then
			hero:GiveMana(ability:GetManaCost(ability:GetLevel() - 1) * self.manaReduction)
			local cooldown = ability:GetCooldownTimeRemaining() * self.cooldownReduction
			ability:EndCooldown()
			ability:StartCooldown(cooldown)
		end
	end
end
