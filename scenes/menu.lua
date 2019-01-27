-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"

--------------------------------------------

local playBtn

local function resetScenes()
	composer.removeScene("scenes.levels.level1")
	composer.removeScene("scenes.levels.level2")
end

local function onPlayBtnRelease()
	composer.gotoScene( "scenes.cuts.intro", "fade", 1000 )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view
	
	local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth*2, display.contentHeight*2)
	background:setFillColor(0.4)
	sceneGroup:insert(background)

	local titleLogo = display.newText(strings.appname, 0, 0)
	titleLogo.x = display.contentCenterX
	titleLogo.y = display.contentCenterY/2
	titleLogo.size = titleLogo.size*3
	titleLogo:setFillColor(1)
	sceneGroup:insert( titleLogo )
	
	local subtitle = display.newText(strings.appSubtitle, 0, 0)
	subtitle.x = display.contentCenterX
	subtitle.y = display.contentCenterY*3/4
	subtitle.size = subtitle.size*1.5
	subtitle:setFillColor(1)
	sceneGroup:insert( subtitle )

	playBtn = widget.newButton{
		label="Play Now",
		labelColor = { default={255}, over={128} },
		width = display.contentWidth / 5, 
		height = display.contentWidth / 10,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentCenterY*1.3
	
	sceneGroup:insert( playBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		resetScenes()
	elseif phase == "did" then
		-- Called when the scene is now on screen
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene