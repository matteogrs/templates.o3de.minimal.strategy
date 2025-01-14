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

local Duration = require("Assets.Scripts.Utils.Duration")

local Create =
{
	Properties =
	{
		UnitPrefab = SpawnableScriptAssetRef(),
		Offset = 1.25,
		Duration = 2.0,

		Events =
		{
			FactoryNotificationEvents = ScriptEventsAssetRef(),
			ResourceRequestEvents = ScriptEventsAssetRef(),
			SelectRequestEvents = ScriptEventsAssetRef()
		}
	}
}

function Create:OnActivate()
	self.spawnSystem = SpawnableScriptMediator()
	self.spawnCounter = 0
	self.spawnTicket = self.spawnSystem:CreateSpawnTicket(self.Properties.UnitPrefab)
	self.spawnHandler = SpawnableScriptNotificationsBus.Connect(self, self.spawnTicket:GetId())

	self.selectHandler = SelectRequestEvents.Connect(self, self.entityId)
end

function Create:SelectEntity()
	if not self.busy then
		local success = ResourceRequestEvents.Broadcast.ConsumeResource()

		if success then
			self.busy = true

			self.timer = Duration:Start(self.Properties.Duration,
			{
				OnTick =  function(elapsedTime) self:OnDurationTick(elapsedTime) end,
				OnCompleted = function() self:OnDurationCompleted() end
			})
		end
	end
end

function Create:OnDurationTick(elapsedTime)
	local ratio = elapsedTime / self.Properties.Duration
	FactoryNotificationEvents.Event.OnProgressChanged(self.entityId, ratio)
end

function Create:OnDurationCompleted()
	local parentId = TransformBus.Event.GetParentId(self.entityId)
	local spawnPosition = Vector3(0.0, -self.spawnCounter * self.Properties.Offset, 0.0)

	self.spawnSystem:SpawnAndParentAndTransform(self.spawnTicket, parentId, spawnPosition, Vector3(0.0, 0.0, 0.0), 1.0)
end

function Create:OnSpawn(spawnTicket, spawnedEntityIds)
	self.spawnCounter = self.spawnCounter + 1
	self.busy = false

	FactoryNotificationEvents.Event.OnUnitCreated(self.entityId)
end

function Create:OnDeactivate()
	self.selectHandler:Disconnect()
	self.spawnHandler:Disconnect()

	if self.timer ~= nil then
		self.timer:Stop()
		self.timer = nil
	end
end

return Create
