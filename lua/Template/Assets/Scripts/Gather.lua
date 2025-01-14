-- Copyright (c) 2025 Matteo Grasso
-- 
--     https://github.com/matteogrs/templates.o3de.minimal.strategy
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

local TimeDelay = require("Assets.Scripts.Utils.TimeDelay")

local Gather =
{
	Properties =
	{
		RespawnDelay = 3.0,

		Events =
		{
			ResourceRequestEvents = ScriptEventsAssetRef(),
			SelectRequestEvents = ScriptEventsAssetRef()
		}
	}
}

function Gather:OnActivate()
	self.selectHandler = SelectRequestEvents.Connect(self, self.entityId)
end

function Gather:SelectEntity()
	RenderMeshComponentRequestBus.Event.SetVisibility(self.entityId, false)
	ResourceRequestEvents.Broadcast.StoreResource()

	self.timer = TimeDelay:Start(self.Properties.RespawnDelay, function() self:OnDelayEnd() end)
end

function Gather:OnDelayEnd()
	RenderMeshComponentRequestBus.Event.SetVisibility(self.entityId, true)
end

function Gather:OnDeactivate()
	self.selectHandler:Disconnect()

	if self.timer ~= nil then
		self.timer:Stop()
		self.timer = nil
	end
end

return Gather
