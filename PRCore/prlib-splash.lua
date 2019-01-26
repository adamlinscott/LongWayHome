-------------------------------------------------------------------------------------------
-- prlib-splash.lua defines functions related to splash screen functionality
-- @module prlib-splash
-- @author Adam Linscott
-- @copyright Probably Rational Ltd. 2018
-------------------------------------------------------------------------------------------

local background
local logo
local callbackFunction

local function destroySplashobjects()
	background:removeSelf()
	logo:removeSelf()
	background = nil
	logo = nil
	callbackFunction()
end

-------------------------------------------------------------------------------------------
--- Show Splash Screen.
-- dispay a full screen splash using specified options 
--
-- @tparam[opt] obj			Table containing options to define behaveor of the splash 
-------------------------------------------------------------------------------------------
function prlib.showSplashScreen( obj )
	local o = {}
	obj = obj or {}
	o.image = obj.image or "PRCore/prlogo.png"
	o.effect = obj.effect or "static"
	o.background = obj.background or {1}
	o.time = obj.time or 5000
	o.widthRatio = obj.widthRatio or 0.5
	callbackFunction = obj.onComplete or function() end

	background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth*2, display.contentHeight*2)
	background:setFillColor(unpack(o.background))
	background.alpha = 0
	
	logo = display.newImage( o.image, display.contentCenterX, display.contentCenterY )
	logo.height = logo.height * (display.contentWidth * o.widthRatio) / logo.width
	logo.width = display.contentWidth * o.widthRatio
	logo.alpha = 0

	if(o.effect == "static") then
		transition.to( background,	{ time=o.time/4, delay=0, alpha=1.0 } )
		transition.to( logo,		{ time=o.time/4, delay=0, alpha=1.0 } )
		transition.to( background,	{ time=o.time/4, delay=o.time*3/4, alpha=0 } )
		transition.to( logo,		{ time=o.time/4, delay=o.time*3/4, alpha=0, onComplete=destroySplashobjects } )
	elseif(o.effect == "zoom") then
		local tHight = logo.height
		local tWidth = logo.width
		logo.height = logo.height*0.75
		logo.width = logo.width*0.75
		transition.to( background,	{ time=o.time/3, delay=0, alpha=1.0 } )
		transition.to( logo,		{ time=o.time/3, height=tHight, width=tWidth, delay=0, alpha=1.0 } )
		transition.to( background,	{ time=o.time/3, delay=o.time*2/3, alpha=0 } )
		transition.to( logo,		{ time=o.time/3, height=tHight*0.75, width=tWidth*0.75, delay=o.time*2/3, alpha=0, onComplete=destroySplashobjects } )
	elseif(o.effect == "fade") then
		transition.to( background,	{ time=o.time/3, delay=0, alpha=1.0 } )
		transition.to( logo,		{ time=o.time/3, delay=0, alpha=1.0 } )
		transition.to( background,	{ time=o.time/3, delay=o.time*2/3, alpha=0 } )
		transition.to( logo,		{ time=o.time/3, delay=o.time*2/3, alpha=0, onComplete=destroySplashobjects } )
	end
end

-------------------------------------------------------------------------------------------
-- Table to be passed to 
-- @string[opt]				image			Path to image in resources directory. Defaults to the Probably Rational logo.
-- @string[opt='static']	effect			Effect that the image will have. Values can be "static", or "zoom". 
-- @param[opt={0}]			background		Table value that represents color.  This is takes any standard corona color format of `{ gray }`, `{ gray, alpha }`, `{ red, green, blue }`, or `{ red, green, blue, alpha }`.
-- @int[opt=5000]			time			Time taken in milliseconds for full animation to complete.
-- @function[opt]				onComplete		Function to be called after animation ends.
-- @table obj
-------------------------------------------------------------------------------------------
