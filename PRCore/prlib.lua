local location = {
	disablePrint = "prlib-debug",
	enablePrettyTables = "prlib-debug",
	showSplashScreen = "prlib-splash"
}
local file_base = "PRCore"

--Eneble external functions
prlib = {}

prlib.setFileBase = function(string)
	file_base = string
end

setmetatable(prlib, {__index = function (t, funcname)
	if not location[funcname] then
		error("Package prlib does not define " .. funcname, 2)
    end
    
    require(file_base .. [[.]] .. location[funcname])     -- load and run definition
    return t[funcname]           -- return the function
end})

return prlib