-- Preplanned - By ThatGuyFromBreakingBad
-- LoadPreplanning.lua
-- v1.27.0_0

function MElement(sp_melementtype, sp_id)
	managers.preplanning:reserve_mission_element(sp_melementtype, sp_id)
end

function Vote(sp_votetype, sp_id)
    managers.preplanning:vote_on_plan(sp_votetype, sp_id)
end

if managers.preplanning and managers.job and managers.network then
	local sp_current_level_id =  managers.job:current_real_job_id() .. "_" .. managers.job:current_level_id()
	dofile("preplanning\\" .. sp_current_level_id .. ".lua")
end