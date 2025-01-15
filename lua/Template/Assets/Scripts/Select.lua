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

require("Assets.Scripts.Utils.RayCast")

local Select =
{
	Properties =
	{
		Events =
		{
			SelectRequestEvents = ScriptEventsAssetRef()
		}
	}
}

function Select:OnActivate()
	UiCursorBus.Broadcast.IncrementVisibleCounter()

	self.inputHandler = InputEventNotificationBus.Connect(self, InputEventNotificationId("Select"))
end

function Select:OnPressed(value)
	local result = RayCastFromScreenCursor()

	if result ~= nil then
		SelectRequestEvents.Event.SelectEntity(result.EntityId)
	end
end

function Select:OnDeactivate()
	self.inputHandler:Disconnect()
end

return Select
