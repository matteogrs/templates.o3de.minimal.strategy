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

local Manage =
{
	Properties =
	{
		Events =
		{
			ResourceRequestEvents = ScriptEventsAssetRef()
		}
	}
}

function Manage:OnActivate()
	RenderMeshComponentRequestBus.Event.SetVisibility(self.entityId, false)
	self.amount = 0

	self.resourceHandler = ResourceRequestEvents.Connect(self)
end

function Manage:ConsumeResource()
	local notEmpty = (self.amount > 0)

	if notEmpty then
		self:OnResourceChanged(self.amount - 1)
	end

	return notEmpty
end

function Manage:StoreResource()
	self:OnResourceChanged(self.amount + 1)
end

function Manage:OnResourceChanged(newAmount)
	local visible = newAmount > 0

	if newAmount > 0 then
		local scale = Vector3(1.0, 1.0, newAmount)
		NonUniformScaleRequestBus.Event.SetScale(self.entityId, scale)

		if self.amount == 0 then
			RenderMeshComponentRequestBus.Event.SetVisibility(self.entityId, true)
		end
	else
		RenderMeshComponentRequestBus.Event.SetVisibility(self.entityId, false)
	end

	self.amount = newAmount
end

function Manage:OnDeactivate()
	self.resourceHandler:Disconnect()
end

return Manage
