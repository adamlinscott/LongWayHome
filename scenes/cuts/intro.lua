-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------

local charImg
local charText
local currentTextPos = 0
local timerTask

local script = {
	{
		character = "player",
		text = "Where am I? How did I get here?",
		side = "left",
	},
	{
		character = "player",
		text = "The last thing I remember is...",
		side = "left",
	},
	{
		character = "player",
		text = "...",
		side = "left",
	},
	{
		character = "player",
		text = "Friends, or maybe family?  I'm sure I was with people, where did they go?",
		side = "left",
	},
	{
		character = "dog",
		text = "Woof!",
		side = "right",
	},
	{
		character = "player",
		text = "Woah, Where did you come from?",
		side = "left",
	},
	{
		character = "dog",
		text = "...",
		side = "right",
	},
	{
		character = "player",
		text = "You look familiar.  I should probably be wary but I'm kind of glad to see you here.",
		side = "left",
	},
	{
		character = "dog",
		text = "...",
		side = "right",
	},
	{
		character = "player",
		text = "So, where should we go?",
		side = "left",
	},
}

local function nextCharacter()
	local currSize = charText.text:len()
	charText.text = charText.targetText:sub(1, currSize + 1)
	if charText.text:len() < charText.targetText:len() then
		timerTask = timer.performWithDelay(50, nextCharacter)
	end
end

local function showNextText()
	if charImg and charImg.removeSelf then
		charImg:removeSelf()
		charImg = nil
	end
	
	if timerTask then
		timer.cancel(timerTask)
		timerTask = nil
	end

	currentTextPos = currentTextPos + 1
	local txtObj = script[currentTextPos]

	if txtObj.side and txtObj.side == "left" then
		if txtObj.character == "player" then
			charImg = display.newImage(addresses.playerImage, 0, 0)
		elseif txtObj.character == "dog" then
			charImg = display.newImage(addresses.dogImage, 0, 0)
		end
		charImg.anchorY = 1
		charImg.anchorX = 1
		charImg.y = display.contentHeight*2/3
		charImg.x = 0 --display.contentWidth/20
		charImg:scale(-1, 1)
		maxImageSize(charImg, display.contentWidth/2, display.contentHeight/2)
		scene.view:insert(charImg)
	elseif txtObj.side and txtObj.side == "right" then
		if txtObj.character == "player" then
			charImg = display.newImage(addresses.playerImage, 0, 0)
		elseif txtObj.character == "dog" then
			charImg = display.newImage(addresses.dogImage, 0, 0)
		end
		charImg.anchorY = 1
		charImg.anchorX = 1
		charImg.y = display.contentHeight*2/3
		charImg.x = display.contentWidth -- display.contentWidth/20
		maxImageSize(charImg, display.contentWidth/2, display.contentHeight/2)
		scene.view:insert(charImg)
	end

	charText.targetText = txtObj.text
	charText.text = ""
	nextCharacter()

end

local function tapListener(event)
	if currentTextPos ~= #script then
		showNextText()
	else
		--Next scene
		composer.gotoScene( "scenes.cuts.act1", "fade", 1000 )
	end
end

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()
	
	local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth*2, display.contentHeight*2)
	background:setFillColor(0.4)
	sceneGroup:insert(background)
	background:addEventListener("tap", tapListener)
	
	local textArea = display.newRect(display.contentCenterX, display.contentHeight, display.contentWidth*2, display.contentHeight/3)
	textArea:setFillColor(0)
	textArea.anchorY = 1
	sceneGroup:insert(textArea)

	charText = display.newText({
		text = "",     
		x = display.contentCenterX,
		y = display.contentHeight*5/6,
		width = display.contentWidth - display.contentWidth/10,
		align = "left",  -- Alignment parameter
	})
	charText:setFillColor(unpack(colors.text))
	sceneGroup:insert(charText)
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		if charImg and charImg.removeSelf then
			charImg:removeSelf()
			charImg = nil
		end
	
		charText.text = ""

	elseif phase == "did" then
		-- Called when the scene is now on screen
		currentTextPos = 0
		showNextText()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
		if charImg and charImg.removeSelf then
			charImg:removeSelf()
			charImg = nil
		end
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene