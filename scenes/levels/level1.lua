-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.setDrawMode( "hybrid" )
--------------------------------------------
local player
local goal
local function1, function2
local trans
local direction = nil
local gameObjects

function function1(e)
	trans = transition.to(goal,{time=1500, xScale=1, yScale=1, rotation=goal.rotation+10, onComplete=function2})
end

function function2(e)
	trans = transition.to(goal,{time=1500, xScale=0.8, yScale=0.8, rotation=goal.rotation+10, onComplete=function1})
end

local function movePlayer()
	if direction then
		player:setLinearVelocity(display.contentWidth/5 * direction, 0)
		timer.performWithDelay(50, movePlayer)
		if direction > 0 then
			player.xScale = -1
		else
			player.xScale = 1
		end
	else

	end
end

local function touchControlerListener(event)
    if ( event.phase == "began" ) then
		if event.x > display.contentCenterX then
			direction = 1
		else
			direction = -1
		end
		movePlayer()
    elseif ( event.phase == "ended" ) then
		direction = nil
    end
    return true
end

local function onGoalCollision( self, event )
	timer.performWithDelay(500, function() composer.gotoScene( "scenes.levels.level1", "fade", 1000 ) end )
	goal:removeEventListener( "collision" )
end

function scene:create( event )

	-- Called when the scene's view does not exist.

	local sceneGroup = self.view

	physics.start()
	physics.pause()
	
	local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth*2, display.contentHeight*2)
	background:setFillColor(0.4)
	sceneGroup:insert(background)

	
	local ground = display.newRect(display.contentCenterX, display.contentHeight, display.contentWidth*2, display.contentHeight/5)
	ground.anchorY = 1
	ground:setFillColor(0)
	sceneGroup:insert(ground)
	physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )


end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		gameObjects = display.newGroup()
		sceneGroup:insert(gameObjects)

		player = display.newImage( "assets/concept/playerSprite.png", 0, 0)
		player.x = 0
		player.y = display.contentHeight*4/5 
		player.anchorY = 1
		maxImageSize(player, display.contentWidth/20, display.contentHeight/4)
		physics.addBody( player, { density=1.0, friction=0.7, bounce=0.3 } )
		player.isFixedRotation = true
		gameObjects:insert( player )

	
		local dog = display.newImage( "assets/concept/dogSitSprite.png", 0, 0)
		dog.x = 0
		dog.y = display.contentHeight*4/5 + 5
		dog.anchorY = 1
		maxImageSize(dog, display.contentWidth/40, display.contentHeight/7)
		dog:scale(-1,1)
		physics.addBody( dog, "static", { friction=0.5, bounce=0.3 } )
		gameObjects:insert( dog )

		player.x = player.x + dog.width + 5

	
		goal = display.newImage( "assets/goal.png", 0, 0)
		maxImageSize(goal, display.contentWidth/5, display.contentHeight/4)
		goal.x = display.contentWidth
		goal.y = display.contentHeight*4/5 - goal.height/2
		physics.addBody( goal, "static", { radius = goal.width/6 } )
		gameObjects:insert( goal )
		goal.collision = onGoalCollision
		goal:addEventListener( "collision" )

		local touchControler = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth*2, display.contentHeight*2)
		touchControler.isHitTestable = true
		touchControler.alpha=0
		gameObjects:insert(touchControler)
		touchControler:addEventListener("touch", touchControlerListener)


	elseif phase == "did" then
		-- Called when the scene is now on screen
		physics.start()
		function1()
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
		transition.cancel()
		physics.pause()
	elseif phase == "did" then
		-- Called when the scene is now off screen
		if gameObjects and gameObjects.removeSelf then
			gameObjects:removeSelf()
			gameObjects = nil
		end
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	physics.stop()
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