-- Preplanned - By ThatGuyFromBreakingBad
-- Modified by r3ddr4gOn
-- ClearAllPreplanning.lua
-- v2

function sp_chat_message(message)
	if managers.chat then
		managers.chat:feed_system_message(ChatManager.GAME, message)
	end
end

if Network:is_server() then
	if managers.preplanning and managers.job and managers.network then
		local sp_reserved_mission_elements = managers.preplanning._reserved_mission_elements
		if sp_reserved_mission_elements and next(sp_reserved_mission_elements) ~= nil then
			local sp_peer_id = managers.network:session():local_peer():id()
			local sp_current_level_id = managers.job:current_real_job_id() .. "_" .. managers.job:current_level_id()
			if sp_current_level_id and sp_peer_id then
				local sp_reserved_mission_elements = managers.preplanning._reserved_mission_elements
				if sp_reserved_mission_elements and next(sp_reserved_mission_elements) ~= nil then
					for sp_id, sp_reserved_mission_element in pairs(sp_reserved_mission_elements) do
						sp_melementtype, sp_index = unpack(sp_reserved_mission_element.pack)
						managers.preplanning:unreserve_mission_element(sp_id)
					end
				else
					sp_chat_message("Preplanned: Nothing to clear")
				end
				sp_chat_message("Preplanned: Cleared all elements (except votes)")
			end
		else
			sp_chat_message("Preplanned: Nothing to clear")
		end
	end
end
