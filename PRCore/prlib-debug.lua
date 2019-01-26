-------------------------------------------------------------------------------------------
-- prlib-debug.lua defines functions related to debugging. These functions are written to help identify issues and keep debugging code clean and simple.
-- @module prlib-debug
-- @author Adam Linscott
-- @copyright Probably Rational Ltd. 2018
-------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
--- Disable print.
-- function dissables all print() function calls throughout the project
-------------------------------------------------------------------------------------------
function prlib.disablePrint()
	print = function() end
end

-------------------------------------------------------------------------------------------
--- Enable pretty tables.
-- Turning this option on overrides the standard print() funcion to output 
-- the data or tables in a formatted multiline manner.
-- WARNING: enabling this behaveour may cause unexpected results when 
-- printing recursive/large tables.  This is only to be used as a debugging tool.
--
-- @param bool Use true/false to enable/disable pretty table formatting
-------------------------------------------------------------------------------------------
function prlib.enablePrettyTables(bool)
	print("PRCORE WARNING: using enablePrettyTables may cause unexpected behavior when printing recursive/large tables.  This is only to be used as a debugging tool.")
	local enabled = bool or true
	local PRINT_FUNC_OLD = print

	print = function(string, level)
		local l = level or 0
		local indent = ''
		for i=1, l do
			indent = indent .. '\t'
		end
		if(type(string) == "table") then
			print( indent .. tostring(string) .. "{")
			for k,v in pairs(string) do
				if(type(v) == "table") then
					print(indent .. '\t' .. k .. ': '  )
					print(v, l+1)
				elseif(type(v) == "string" or type(v) == "number") then
					print(indent .. '\t' .. k .. ': ' .. v)
				end
			end
			print(indent .. "}")
		elseif(type(string) == "string" or type(string) == "number") then
			PRINT_FUNC_OLD(string)
		end
	end
end
