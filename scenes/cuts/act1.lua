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
local actText
local titleText

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
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

	elseif phase == "did" then
		-- Called when the scene is now on screen
		actText = display.newText({
			text = strings.act1,     
			x = display.contentCenterX,
			y = display.contentHeight/3,
		})
		actText.size = actText.size * 3
		actText:setFillColor(unpack(colors.text))
		actText.alpha = 0
		sceneGroup:insert(actText)
		
		titleText = display.newText({
			text = strings.act1title,     
			x = display.contentCenterX,
			y = display.contentHeight*3/5,
		})
		titleText.size = titleText.size * 2
		titleText:setFillColor(unpack(colors.text))
		titleText.alpha = 0
		sceneGroup:insert(titleText)

		transition.to(actText, {time = 500, alpha = 1})
		transition.to(titleText, {delay = 1000, time = 500, alpha = 1, oncomplete})
		timer.performWithDelay(4000, function() composer.gotoScene( "scenes.levels.level1", "fade", 1000 ) end)
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
		if actText and actText.removeSelf then
			actText:removeSelf()
			actText = nil
		end
		if titleText and titleText.removeSelf then
			titleText:removeSelf()
			titleText = nil
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