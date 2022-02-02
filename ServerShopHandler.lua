local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopTools = ReplicatedStorage:WaitForChild("ShopItems"):WaitForChild("ShopTools")
local OrderModule = require(game:GetService("ReplicatedStorage"):WaitForChild("ToolOrder"))

local function GetTools(Player)
	for i,v in pairs(Player.StarterGear:GetChildren()) do
		local vv = v:FindFirstChild("IsShopTool")
		if vv and vv.Value == true then
			print(v.Name)
			return v
		end
	end
end

local function GetToolOrder(Tool) -- String name
	for i,v in pairs(OrderModule.Tools) do
		if v.Name == Tool then
			return i
		end
	end
end


--[[ On Remote ]]--

ReplicatedStorage:WaitForChild("BuyItem").OnServerEvent:Connect(function(Player,Item,Mode) -- Item is the name
	print(Item)
	local PlayerBal = Player.leaderstats.Cash.Value
	if Mode == "Tool" then	
		
        local Cost = ReplicatedStorage:FindFirstChild("ShopItems").ShopTools:FindFirstChild(Item).Price
        
        if PlayerBal >= Cost.Value then
            
        end
		
	elseif Mode == "Backpack" then
		local Backpack = ReplicatedStorage.ShopItems.Backpacks:FindFirstChild(Item)
		local Cost = Backpack.Price.Value
		local Size = Backpack.Size.Value
		if PlayerBal >= Cost and Size > Player.BackpackStorage.Value then
			Player.leaderstats.Cash.Value = PlayerBal - Cost
			Player.BackpackStorage.Value = Size
		end
	end
end)