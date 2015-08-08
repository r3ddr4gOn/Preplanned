-- Preplanned - By ThatGuyFromBreakingBad
-- SavePreplanning.lua
-- v3

function sp_formatString(sp_value)
	if type(sp_value) == "string" then
		return string.format("%q", sp_value)
	else
		return sp_value
	end
end

function sp_toMElementString(melementtype, sp_id)
	return "MElement(" .. sp_formatString(melementtype) .. ", " .. sp_formatString(sp_id) .. ")"
end

function sp_toVoteString(sp_votetype, sp_id)
    return "Vote(" .. sp_formatString(sp_votetype) .. ", " .. sp_formatString(sp_id) .. ")"
end

function sp_toMAssetString(sp_id)
	return "MAsset(" .. sp_formatString(sp_id) .. ")"
end

function sp_chat_message(message)
	if managers.chat then
		managers.chat:feed_system_message(ChatManager.GAME, message)
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
	local sp_peer_id = managers.network:session():local_peer():id()
	local sp_current_level_id = managers.job:current_real_job_id() .. "_" .. managers.job:current_level_id()
    if sp_current_level_id and sp_peer_id then
	    local sp_endl = "\n"
	    local sp_file = io.open("mods/preplanned/preplanning/" .. sp_current_level_id .. sp_format_slot_num(sp_slot_num) .. ".lua", "w")
				
        local sp_reserved_mission_elements = managers.preplanning._reserved_mission_elements

		local sp_all_mission_assets = managers.assets:get_every_asset_ids()
		local sp_reserved_mission_assets = {}
		if sp_all_mission_assets and next(sp_all_mission_assets) ~= nil then
			for i, sp_id in ipairs(sp_all_mission_assets) do
				if managers.assets:get_asset_unlocked_by_id(sp_id) and managers.assets:get_asset_no_mystery_by_id(sp_id) then
					table.insert(sp_reserved_mission_assets, sp_id)
				end
			end
		end
		
		if sp_reserved_mission_elements and next(sp_reserved_mission_elements) ~= nil then
			for sp_id, sp_reserved_mission_element in pairs(sp_reserved_mission_elements) do
				sp_melementtype, sp_index = unpack(sp_reserved_mission_element.pack)
				sp_file:write(sp_toMElementString(sp_melementtype, sp_id), sp_endl)
			end
			local sp_player_votes = managers.preplanning:get_player_votes(sp_peer_id)
			if sp_player_votes then
				for sp_plan, sp_data in pairs(sp_player_votes) do
					sp_votetype, sp_index = unpack(sp_data)
					sp_file:write(sp_toVoteString(sp_votetype, managers.preplanning:get_mission_element_id(sp_votetype, sp_index)), sp_endl)
				end
			end
			sp_chat_message("Preplanned: Saved to Slot " .. string.format("%u", sp_slot_num))
		elseif sp_reserved_mission_assets and next(sp_reserved_mission_assets) ~= nil then
			for i, sp_id in ipairs(sp_reserved_mission_assets) do
				sp_file:write(sp_toMAssetString(sp_id), sp_endl)
			end
			sp_chat_message("Preplanned: Saved to Slot " .. string.format("%u", sp_slot_num))
		else
			sp_chat_message("Preplanned: Nothing to save")
		end
		sp_file:close()
    end
end
