-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
--physics.setDrawMode( "hybrid" )
--------------------------------------------
local player
local dog
local goal
local function1, function2
local trans
local touchControler
local direction = nil
local gameObjects

function function1(e)
	trans = transition.to(goal,{time=1500, xScale=1, yScale=1, rotation=goal.rotation+10, onComplete=function2})
end

function function2(e)
	trans = transition.to(goal,{time=1500, xScale=0.8, yScale=0.8, rotation=goal.rotation+10, onComplete=function1})
end

local clouds = {}
clouds.isAnimating = false
clouds.count = 5
local function cloudsUpdate()
	if clouds.isAnimating then
		for i=1, clouds.count do
			if clouds[i] and clouds[i].x > display.contentWidth + clouds[i].width then
				clouds[i].x = -clouds[i].width * 2
			end
		end
		timer.performWithDelay(2000, cloudsUpdate)
	end
end

local function startClouds()
	for i=1, clouds.count do
		clouds[i] = display.newImage( "assets/cloud.png", 0, 0)
		maxImageSize(clouds[i], math.random(display.contentWidth/7,display.contentWidth/5), math.random(display.contentHeight/9, display.contentHeight/7))
		clouds[i].alpha = math.random(40,90) /100
		clouds[i].anchorX = 0
		clouds[i].x =  math.random( - clouds[i].width * 2, display.contentWidth )
		clouds[i].y = math.random(display.contentHeight/20, display.contentHeight/3)
		physics.addBody( clouds[i], "kinematic", { friction=0 } )
		clouds[i]:setLinearVelocity(math.random(display.contentWidth/15, display.contentWidth/9), 0)
		scene.view:insert(clouds[i])
	end
	clouds.isAnimating = true
	cloudsUpdate()
end

local function stopClouds()
	clouds.isAnimating = false
	for i=1, clouds.count do
		if clouds[i] and clouds[i].removeSelf then 
			clouds[i]:removeSelf()
			clouds[i] = nil
		end
	end
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

local function dogEndAnimation()
	dog:removeSelf()

	dog = display.newImage( "assets/concept/dogWalkSprite.png", 0, 0)
	dog.x = 0
	dog.y = display.contentHeight*4/5
	dog.anchorY = 1
	maxImageSize(dog, display.contentWidth, display.contentHeight/7)
	dog.xScale = -1
	physics.addBody( dog, "kinematic", { friction=0 } )
	gameObjects:insert( dog )

	timer.performWithDelay(1000, function() dog.xScale=1; dog:setLinearVelocity(-display.contentWidth/5, 0) end )
	timer.performWithDelay(2000, function() player.xScale=1; direction = -1; movePlayer() end )
	timer.performWithDelay(4000, function() direction = nil; composer.setVariable( "nextScene", "scenes.levels.level2" ); composer.gotoScene( "scenes.black", "fade", 400 ) end )

	goal:removeEventListener( "collision" )
	physics.removeBody( goal )
end

local function onDogCollision( self, event )
	touchControler:removeEventListener("touch", touchControlerListener)
	direction = nil
	timer.performWithDelay(200, dogEndAnimation )

end

local function onGoalCollision( self, event )
	direction = nil
	composer.setVariable( "nextScene", "scenes.levels.level1" )
	timer.performWithDelay(200, function() composer.gotoScene( "scenes.black", "fade", 400 ) end )
	goal:removeEventListener( "collision" )
	physics.removeBody( goal )
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

	local rightArrow = display.newImage( "assets/arrow.png", 0, 0)
	rightArrow.alpha = 0.3
	rightArrow.height = display.contentHeight/10
	rightArrow.width = display.contentHeight/10
	rightArrow.x = display.contentWidth - display.contentHeight/10
	rightArrow.y = display.contentHeight*9/10
	rightArrow.rotation = -90
	sceneGroup:insert(rightArrow)

	local leftArrow = display.newImage( "assets/arrow.png", 0, 0)
	leftArrow.alpha = 0.3
	leftArrow.height = display.contentHeight/10
	leftArrow.width = display.contentHeight/10
	leftArrow.x = display.contentHeight/10
	leftArrow.y = display.contentHeight*9/10
	leftArrow.rotation = 90
	sceneGroup:insert(leftArrow)
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		if player and player.removeSelf then
			player:removeSelf()
			player = nil
		end
		if dog and dog.removeSelf then
			dog:removeSelf()
			dog = nil
		end
		if goal and goal.removeSelf then
			goal:removeSelf()
			goal = nil
		end
		if touchControler and touchControler.removeSelf then
			touchControler:removeSelf()
			touchControler = nil
		end
		if gameObjects and gameObjects.removeSelf then
			gameObjects:removeSelf()
			gameObjects = nil
		end

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

	
		dog = display.newImage( "assets/concept/dogSitSprite.png", 0, 0)
		dog.x = 0
		dog.y = display.contentHeight*4/5 + 5
		dog.anchorY = 1
		maxImageSize(dog, display.contentWidth/40, display.contentHeight/7)
		dog:scale(-1,1)
		physics.addBody( dog, "static", { friction=0.5, bounce=0.3 } )
		gameObjects:insert( dog )
		dog.collision = onDogCollision
		dog:addEventListener( "collision" )

		player.x = player.x + dog.width*2

	
		goal = display.newImage( "assets/goal.png", 0, 0)
		maxImageSize(goal, display.contentWidth/5, display.contentHeight/4)
		goal.x = display.contentWidth
		goal.y = display.contentHeight*4/5 - goal.height/2
		physics.addBody( goal, "static", {bounce=0, radius = goal.width/8 } )
		gameObjects:insert( goal )
		goal.collision = onGoalCollision
		goal:addEventListener( "collision" )
		goal:toBack()

		touchControler = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth*2, display.contentHeight*2)
		touchControler.isHitTestable = true
		touchControler.alpha=0
		gameObjects:insert(touchControler)
		touchControler:addEventListener("touch", touchControlerListener)

		startClouds()
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
		stopClouds()
	elseif phase == "did" then
		-- Called when the scene is now off screen
		if player and player.removeSelf then
			player:removeSelf()
			player = nil
		end
		if dog and dog.removeSelf then
			dog:removeSelf()
			dog = nil
		end
		if goal and goal.removeSelf then
			goal:removeSelf()
			goal = nil
		end
		if touchControler and touchControler.removeSelf then
			touchControler:removeSelf()
			touchControler = nil
		end
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