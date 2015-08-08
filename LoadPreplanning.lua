-- Preplanned - By ThatGuyFromBreakingBad
-- Modified by r3ddr4gOn
-- LoadPreplanning.lua
-- v3

function MElement(sp_melementtype, sp_id)
	local lockData = tweak_data:get_raw_value("preplanning", "types", sp_melementtype, "upgrade_lock") or false
	if not lockData or managers.player:has_category_upgrade(lockData.category, lockData.upgrade) then
		managers.preplanning:reserve_mission_element(sp_melementtype, sp_id)
	end
end

function Vote(sp_votetype, sp_id)
    managers.preplanning:vote_on_plan(sp_votetype, sp_id)
end

function MAsset(sp_id)
	if managers.assets:is_asset_unlockable(sp_id) then
		managers.assets:unlock_asset(sp_id)
	else
		managers.chat:feed_system_message(ChatManager.GAME, "Preplanned: Couldn't unlock " .. sp_id)
	end
end

function sp_format_slot_num(slot_num)
	if slot_num == 1 then
		return ""
	else
		return "_" .. slot_num
	end
end

if managers.preplanning and managers.assets and managers.job and managers.network then
	local sp_current_level_id =  managers.job:current_real_job_id() .. "_" .. managers.job:current_level_id()
	dofile("mods/preplanned/preplanning/" .. sp_current_level_id .. sp_format_slot_num(sp_slot_num) .. ".lua")
	if managers.chat then
        managers.chat:feed_system_message(ChatManager.GAME, "Preplanned: Loaded from Slot " .. sp_slot_num)
    end
end
