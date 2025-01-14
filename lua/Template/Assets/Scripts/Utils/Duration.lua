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

local Duration = {}

function Duration:Start(duration, callbacks)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self

	instance.duration = duration
	instance.callbacks = callbacks

	instance.elapsedTime = 0.0
	instance.tickHandler = TickBus.Connect(instance)

	return instance
end

function Duration:OnTick(deltaTime, time)
	self.elapsedTime = self.elapsedTime + deltaTime

	if self.callbacks.OnTick ~= nil then
		self.callbacks.OnTick(self.elapsedTime)
	end

	if self.elapsedTime > self.duration then
		self.tickHandler:Disconnect()
		self.tickHandler = nil

		if self.callbacks.OnCompleted ~= nil then
			self.callbacks.OnCompleted()
		end
	end
end

function Duration:Stop()
	if self.tickHandler ~= nil then
		self.tickHandler:Disconnect()
		self.tickHandler = nil
	end
end

return Duration
