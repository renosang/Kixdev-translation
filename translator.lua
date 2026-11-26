-- KIXDEV Vietnamese UI translation only.
-- Run after opening the original KIXDEV window.
local URL = "https://raw.githubusercontent.com/renosang/Kixdev-translation/main/vi.json"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ok, data = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(URL))
end)
if not ok or type(data) ~= "table" then
    warn("[KIXDEV-VI] Cannot load dictionary: " .. tostring(data))
    return
end

local env = type(getgenv) == "function" and getgenv() or _G
if type(env.KIXDEV_VI_Stop) == "function" then
    pcall(env.KIXDEV_VI_Stop)
end
local active = true
local connections = {}
local seen = setmetatable({}, {__mode = "k"})
local roots = setmetatable({}, {__mode = "k"})
local function connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(connections, c)
    return c
end
env.KIXDEV_VI_Stop = function()
    active = false
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    table.clear(connections)
end

local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end
local function exact(s)
    return type(data[s]) == "string" and data[s] or nil
end
local function escapePattern(s)
    return (s:gsub("(%W)", "%%%1"))
end
local function literalReplace(s, from, to)
    return (s:gsub(escapePattern(from), function() return to end))
end
-- Translate inventory display only; preserve names, counts and unknown items.
local function translateInventory(s)
    if not s:find("^Inventory of ") then return nil end
    return (s:gsub("[^\r\n]+", function(line)
        local who = line:match("^Inventory of Local Player%s*(%b())%s*:%s*$")
        if who then return (exact("Inventory of Local Player") or "Inventory of Local Player") .. " " .. who .. ":" end
        local other = line:match("^Inventory of%s+(.+):%s*$")
        if other then return (exact("Inventory of") or "Inventory of") .. " " .. other .. ":" end
        local lead, item = line:match("^(%s*%-%s*)(.+)$")
        if lead then
            local name, quantity = item:match("^(.-)(%s+[xX]%d+%s*)$")
            name = name or item
            return lead .. (exact(trim(name)) or name) .. (quantity or "")
        end
        local key, sep, value = line:match("^(%s*[%a ]-)(%s*:%s*)(.*)$")
        if key then
            local cleanKey = trim(key)
            if cleanKey == "Armour" or cleanKey == "Diamond" or cleanKey == "Coin" or cleanKey == "Stew" or cleanKey == "Items" then
                return (exact(cleanKey) or cleanKey) .. sep .. (exact(trim(value)) or value)
            end
        end
        return line
    end))
end

local dynamicPrefixes = {
    "Total Playtime", "Total Diamonds Collected", "Furniture List",
    "Total Saplings", "Fire Full", "Opens in", "Campfire", "Stronghold", "Status",
    "Hunger", "Level", "Fire", "Limit", "Total", "Needed", "Ping", "FPS"
}
local dynamicValues = {"Monitoring", "Disabled", "Standby", "RAIDING", "CLEAR!", "Idle", "MAX", "Off", "On"}
local function translate(s)
    if type(s) ~= "string" or s == "" then return s end
    local direct = exact(s) or exact(trim(s))
    if direct then return direct end
    local scanTarget = s:match("^Scan Output:%s*(.+)$")
    if scanTarget then
        return (exact("Scan Output") or "Scan Output") .. ": " .. (exact(scanTarget) or scanTarget)
    end
    local inventory = translateInventory(s)
    if inventory then return inventory end
    -- Translate the fire status suffix even if the status prefix is already localized.
    local fuelStatus = "Automatically dropping fuels to reach max level."
    if s:find(fuelStatus, 1, true) and exact(fuelStatus) then
        s = literalReplace(s, fuelStatus, exact(fuelStatus))
    end
    -- Preserve numeric values and only translate known status labels.
    local isStatus = false
    for _, key in ipairs(dynamicPrefixes) do
        if s:find("^" .. escapePattern(key) .. "%s*:")
            or s:find("\n" .. escapePattern(key) .. "%s*:")
            or s:find("^" .. escapePattern(key) .. "%s+%d")
            or s:find("^" .. escapePattern(key) .. "%s*%(") then
            isStatus = true
            break
        end
    end
    if isStatus then
        local out = s
        for _, key in ipairs(dynamicPrefixes) do
            local vi = exact(key)
            if vi then
                out = out:gsub(escapePattern(key) .. "(%s*:)", function(sep) return vi .. sep end)
                out = out:gsub(escapePattern(key) .. "(%s+%d)", function(sep) return vi .. sep end)
            end
        end
        for _, val in ipairs(dynamicValues) do
            local vi = exact(val)
            if vi then out = literalReplace(out, val, vi) end
        end
        return out
    end
    -- Multi-select summaries: translate only if every item is recognized.
    if s:find(",", 1, true) then
        local parts = {}
        for item in s:gmatch("[^,]+") do
            item = trim(item)
            local vi = exact(item)
            if item == "..." or item == "…" then vi = item end
            if not vi then return s end
            table.insert(parts, vi)
        end
        if #parts > 1 then return table.concat(parts, ", ") end
    end
    return s
end

local function attach(obj)
    if seen[obj] then return end
    local property
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        property = "Text"
    elseif obj:IsA("TextBox") then
        property = "PlaceholderText" -- Never translate user input.
    else
        return
    end
    seen[obj] = true
    local writing = false
    local function refresh()
        if not active or writing or not obj.Parent then return end
        local original = obj[property]
        local translated = translate(original)
        if translated ~= original then
            writing = true
            pcall(function() obj[property] = translated end)
            writing = false
        end
    end
    connect(obj:GetPropertyChangedSignal(property), refresh)
    refresh()
end

local function bindRoot(root)
    if roots[root] then return end
    roots[root] = true
    connect(root.DescendantAdded, function(obj)
        if active then task.defer(attach, obj) end
    end)
    for _, obj in ipairs(root:GetDescendants()) do
        attach(obj)
    end
    print("[KIXDEV-VI] Attached: " .. root.Name)
end

local function isKixdev(root)
    if root.Name:lower():find("kixdev", 1, true) then return true end
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local t = trim(obj.Text):upper()
            if t == "KIXDEV" or t:find("KIXDEV HUB", 1, true) == 1 then
                return true
            end
        end
    end
    return false
end
local function discover()
    local containers = {}
    if type(gethui) == "function" then
        local success, gui = pcall(gethui)
        if success and gui then table.insert(containers, gui) end
    end
    local success, core = pcall(function() return game:GetService("CoreGui") end)
    if success and core then table.insert(containers, core) end
    local player = Players.LocalPlayer
    local playerGui = player and player:FindFirstChildOfClass("PlayerGui")
    if playerGui then table.insert(containers, playerGui) end
    for _, parent in ipairs(containers) do
        pcall(function()
            for _, obj in ipairs(parent:GetDescendants()) do
                if obj:IsA("ScreenGui") and not roots[obj] and isKixdev(obj) then
                    bindRoot(obj)
                end
            end
        end)
    end
end
local count = 0
for _ in pairs(data) do count = count + 1 end
print("[KIXDEV-VI] Dictionary ready: " .. count)
discover()
task.spawn(function()
    while active do
        task.wait(2)
        if active then discover() end
    end
end)
