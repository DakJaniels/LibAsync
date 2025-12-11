-- Test runner for LibAsync using ESOLua or standard Lua 5.1 with ESO mocks
-- Usage: lua scripts/run_tests.lua
-- Or: esolua scripts/run_tests.lua (if ESOLua is available)

package.path = package.path .. ";esoui/?.lua;esoui/esoui/?.lua;AddOns/?.lua;AddOns/?/?.lua"

-- Minimal ESO API mocks for testing
_G.GetFrameTimeSeconds = function() return os.clock() end
_G.GetGameTimeSeconds = function() return os.clock() end

_G.GetEventManager = function() 
    local em = {updateIds = {}}
    function em:RegisterForUpdate(id, interval, func)
        self.updateIds[id] = {interval = interval, func = func, last = os.clock()}
    end
    function em:UnregisterForUpdate(id)
        self.updateIds[id] = nil
    end
    return em
end

_G.GetFramerate = function() return 60 end
_G.HUD_SCENE = {IsShowing = function() return true end}
_G.HUD_UI_SCENE = {IsShowing = function() return false end}

_G.ZO_InitializingCallbackObject = {
    New = function(self) 
        return setmetatable({}, {__index = self}) 
    end,
    Subclass = function(self) 
        return self 
    end
}

_G.ZO_ClearNumericallyIndexedTable = function(t) 
    for i = #t, 1, -1 do 
        t[i] = nil 
    end 
end

_G.zo_callLater = function(func, ms) 
    -- Simple delayed call simulation for testing
    local start = os.clock()
    while os.clock() - start < ms / 1000 do end
    func()
end

_G.CHAT_ROUTER = {AddSystemMessage = function(msg) print(msg) end}
_G.SLASH_COMMANDS = {}

-- Setup event manager
_G.EventManager = GetEventManager()
_G.em = GetEventManager()

-- Load Taneth from ESO-Taneth repository
-- Try different possible paths for Taneth
local tanethLoaded = false
local tanethPaths = {
    "AddOns/Taneth/Taneth.lua",
    "taneth/src/Taneth.lua",
    "taneth/src/Taneth/Taneth.lua"
}

for _, path in ipairs(tanethPaths) do
    local file = io.open(path, "r")
    if file then
        file:close()
        dofile(path)
        tanethLoaded = true
        break
    end
end

if not tanethLoaded then
    error("Taneth not found. Please clone ESO-Taneth repository: git clone https://github.com/sirinsidiator/ESO-Taneth.git taneth")
end

-- Setup package paths for AddOns
package.path = package.path .. ";AddOns/?.lua;AddOns/?/?.lua"

-- Load LibAsync
print("Loading LibAsync...")
dofile("LibAsync.lua")

-- Load and register tests
print("Loading tests...")
dofile("tests/LibAsync_test.lua")

-- Run tests
print("Running LibAsync tests...")
local success = Taneth:RunTestSuites({"LibAsync"}, function()
    print("All tests completed successfully!")
end)

if not success then
    print("Tests completed synchronously")
end

