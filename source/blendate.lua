--- all credits to @osuika on discord for this script 
--- don't copy this for your non-CLEAR ENGINE project, go buy blendate yourself!
--- I slightly modified this script to output an imagetable instead of an animation object and also just added `local err` to the first function to shut up the `global variable with lowercase` error

import("CoreLibs/graphics")
import("CoreLibs/animation")
import("CoreLibs/object")

local gfx <const> = playdate.graphics

class("Blendate").extends(Object)

function Blendate:init(json_path)
	local err
	self.metadata, err = json.decodeFile(json_path)
	if err then
		error(err)
	end
end

function Blendate:_getKey(img_path)
	local key = img_path:match("([^/]+)$")
	key = string.gsub(key, "-", "/")
	if self.metadata[key] == nil then
		error("Image not found in metadata: " .. img_path .. " (" .. key .. ")")
	end
	return key
end

function Blendate:_load(img_path, loop)
	local key = self:_getKey(img_path)
	local data = self.metadata[key]

	-- Calculate total number of frames
	local totalFrames = 0
	for i = 0, data["num_spritesheets"] - 1 do
		local num_frames = data["rows"] * data["cols"]
		if i == data["num_spritesheets"] - 1 then
			num_frames = data["num_frames_utilized"] and data["num_frames_utilized"] or num_frames
		end
		totalFrames = totalFrames + num_frames
	end

	-- Create an imagetable with the total number of frames
	local frameTable = gfx.imagetable.new(totalFrames)

	-- Fill the imagetable with frames from all spritesheets
	local frameIdx = 1
	for i = 0, data["num_spritesheets"] - 1 do
		local img_table, err = gfx.imagetable.new(img_path .. "-" .. i)
		if err then
			error(err)
		end
		local num_frames = data["rows"] * data["cols"]
		if i == data["num_spritesheets"] - 1 then
			num_frames = data["num_frames_utilized"] and data["num_frames_utilized"] or num_frames
		end
		for j = 1, num_frames do
			frameTable:setImage(frameIdx, img_table:getImage(j))
			frameIdx = frameIdx + 1
		end
	end

	loop = loop or true
	return frameTable
end

function Blendate:loadRotation(img_path, loop)
	local key = self:_getKey(img_path)
	if self.metadata[key]["num_anim_frames"] ~= nil then
		error(img_path .. " also has animations, use loadAnimation() instead")
	end
	return self:_load(img_path, loop)
end

function Blendate:loadAnimation(img_path, anim_name, loop)
	local key = self:_getKey(img_path .. "-" .. anim_name)
	if self.metadata[key]["num_anim_frames"] ~= nil then
		local data = self.metadata[key]
		return BlendateRotatingAnimation(img_path, anim_name, data)
	else
		return self:_load(img_path .. "-" .. anim_name, loop)
	end
end

class("BlendateRotatingAnimation").extends(Object)

function BlendateRotatingAnimation:init(img_path, anim_name, data)
	local angle_frames = {}
	local num_frames = data["num_frames_utilized"] and data["num_frames_utilized"] or data["rows"] * data["cols"]

	-- Initialize arrays to collect frames for each angle
	for i = 1, num_frames do
		angle_frames[i] = {}
	end

	-- Load and organize frames by angle
	for i = 0, data["num_anim_frames"] - 1 do
		for j = 0, data["num_spritesheets"] - 1 do
			local img_table, err = gfx.imagetable.new(img_path .. "-" .. anim_name .. "-" .. i .. "-" .. j)
			if err then
				error(err)
			end
			for k = 1, num_frames do
				if img_table:getImage(k) then
					local frame_idx = i * data["num_spritesheets"] + j + 1
					angle_frames[k][frame_idx] = img_table:getImage(k)
				end
			end
		end
	end

	self.angle_anims = {}
	for angle_idx, frames in ipairs(angle_frames) do
		-- Count actual frames for this angle (non-nil entries)
		local frameCount = 0
		for _ in pairs(frames) do
			frameCount = frameCount + 1
		end

		-- Create an imagetable for this angle
		local frameTable = gfx.imagetable.new(frameCount)

		-- Fill the imagetable
		local idx = 1
		for j = 1, #frames do
			if frames[j] then
				frameTable:setImage(idx, frames[j])
				idx = idx + 1
			end
		end

		-- Create animation with this imagetable
		self.angle_anims[angle_idx] = gfx.animation.loop.new(1000 / data["fps"], frameTable, true)
	end
end

function BlendateRotatingAnimation:get(angle)
	local spriteAngle = (360 - angle + 180) % 360
	local normalized_angle = spriteAngle % 360
	local num_angles = #self.angle_anims
	local angle_step = 360 / num_angles
	local angle_idx = math.floor(normalized_angle / angle_step) + 1
	if angle_idx > num_angles then
		angle_idx = 1
	end

	return self.angle_anims[angle_idx]
end




--- oh hello there :b