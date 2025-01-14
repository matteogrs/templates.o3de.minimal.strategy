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

local Monitor =
{
	Properties =
	{
		Events =
		{
			FactoryNotificationEvents = ScriptEventsAssetRef()
		}
	}
}

function Monitor:OnActivate()
	RenderMeshComponentRequestBus.Event.SetVisibility(self.entityId, false)

	self.fullScale = NonUniformScaleRequestBus.Event.GetScale(self.entityId)

	local parentId = TransformBus.Event.GetParentId(self.entityId)
	self.factoryHandler = FactoryNotificationEvents.Connect(self, parentId)
end

function Monitor:OnProgressChanged(ratio)
	local scale = Vector3(self.fullScale.x, self.fullScale.y, ratio * self.fullScale.z)
	NonUniformScaleRequestBus.Event.SetScale(self.entityId, scale)

	RenderMeshComponentRequestBus.Event.SetVisibility(self.entityId, true)
end

function Monitor:OnUnitCreated()
	RenderMeshComponentRequestBus.Event.SetVisibility(self.entityId, false)
end

function Monitor:OnDeactivate()
	self.factoryHandler:Disconnect()
end

return Monitor
