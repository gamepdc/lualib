local function plain2string(v)
	if type(v) == "number" then
		return tostring(v)
	elseif type(v) == "string" then
		return "\"" .. v .. "\""
	else
		error(string.format("can't supper type:%s", type(v)))
	end
end

local function key2string(v)
	if type(v) == "number" then
		return "[" .. v .. "]"
	elseif type(v) == "string" then
		return "\"" .. v .. "\""
	else
		error(string.format("can't supper key type:%s", type(v)))
	end
end

local function tb2string(tb, visited)
	if visited == nil then
		visited = {}
	end

	local indentStr = ""
	for k, v in ipairs(visited) do
		if v == tb then
			error("loop ref")
		end
		indentStr = indentStr .. "    "
	end
	table.insert(visited, tb)

	local s = "{\n"
	local contentIndent = indentStr .. "    "
	for k, v in pairs(tb) do
		s = s .. contentIndent .. key2string(k) .. ": "
		local valueStr
		if type(v) == "table" then
			valueStr = tb2string(v, visited)
		else
			valueStr = plain2string(v)
		end
		s = s .. valueStr .. "\n"
	end
	s = s .. indentStr .. "}"
	return s
end

local _M = {}

function _M.ToString(v)
	if type(v) == "table" then
		return tb2string(v)
	else
		return plain2string(v)
	end
end

function _M.ParseCmd(line)
	local cmdStr = string.gsub(line, "(%w+)%s(.+)", "return {cmd=\"%1\", param=%2}")
	local cmd = load(cmdStr)()
	return cmd
end

return _M
