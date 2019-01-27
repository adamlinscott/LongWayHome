-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-----------------------------------------------------------------------------------------
-- require libraries
-----------------------------------------------------------------------------------------
prlib = require("PRCore.prlib")
composer = require( "composer" )
widget = require( "widget" )

-----------------------------------------------------------------------------------------
-- set global variables
-----------------------------------------------------------------------------------------
padding = display.contentWidth/40
topInset, leftInset, bottomInset, rightInset = display.getSafeAreaInsets()
tasks = {}
colors = {
	banner = {0.95, 0.95, 0.95},
	bannerText = {91/255, 155/255, 213/255}, 
	headingText = {0.7, 0, 0.9},
	backgroundText = {0.5, 0.5, 0.5},
	text = {1,1,1},
	subtitle = {0.6, 0.6, 0.6},
	highlight = {91/255, 155/255, 213/255},
	background = {0, 0, 0},
	cardBackground = {1, 1, 1},
	divider = {0.5, 0.5, 0.5},
	navButton = {0.05, 0.05, 0.05},
	shadow = {0, 0, 0, 0.2},
}

fonts = {
	bannerText =  "assets/Dentra Font.ttf",
	headingText =  "assets/georgiab.ttf",
	backgroundText =  "assets/Georgia.ttf",
	text =  "assets/Georgia.ttf",
}

strings = {
	appname = "Long Way Home",
	act1 = "ACT 1",
	act1title = "Stigma",
	act2 = "ACT 2",
	act2title = "Understanding",
	demotitle = "Long Way Home",
	demosubtitle = "Full game coming soon!",
	appSubtitle = "(Demo)"
}

addresses = {
	playerImage = "assets/concept/playerClear.png",
	dogImage = "assets/concept/dogClear.png",
	npcImage = "assets/concept/npcClear.png",
	goalImage = "assets/goal.png",
}

ScaleImgByWidth = function(img, w)
	if(not img or type(img) ~= "table") then
		error("image must be provided", 2)
	end
	if(not w or type(w) ~= "number") then
		error("second parameter must be a number", 2)
	end
	img.height = w/(img.width/img.height)
	img.width = w
end

maxImageSize = function(img, maxWidth, maxHeight)
 --   local photo = display.newImage(img, x, y)
    local heightDiff = math.abs(maxHeight - img.height)
    local widthDiff = math.abs(maxWidth - img.width)
    local scale
    if heightDiff > widthDiff then
    	scale = maxHeight / img.height
		img.height = img.height * scale
		img.width = img.width * scale
    --	img:scale(scale,scale)
    else
    	scale = maxWidth / img.width
		img.height = img.height * scale
		img.width = img.width * scale
    --	img:scale(scale,scale)
    	--img:scale(scale,scale)
    end
    return img
end


-----------------------------------------------------------------------------------------
-- set defaults
-----------------------------------------------------------------------------------------
display.setDefault( "fillColor", 0, 0, 0 )
display.setDefault( "background", unpack(colors.background))
--composer.recycleOnSceneChange = true

-----------------------------------------------------------------------------------------
-- Start up behaveor
-----------------------------------------------------------------------------------------
local function goToFirstScene()
	composer.gotoScene("scenes.menu")
end

prlib.showSplashScreen({
	effect = "static",
	time = 3000,
	onComplete = goToFirstScene,
})

