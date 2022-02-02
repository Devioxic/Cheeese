--[[ Variables & functions ]]--
local Display = script.Parent.Frame.Display
local Price = script.Parent.Frame.Price
local Name = script.Parent.Frame.ItemName
local Tools = script.Parent.Frame.ToolFrame:GetChildren()
local BuyButton = script.Parent.Frame.Buy
local Selected = nil
local Mode = "Tool"
local ToolFrame = script.Parent.Frame.ToolFrame
local BackpackFrame = script.Parent.Frame.BackpackFrame
local BackpackChildren = BackpackFrame:GetChildren()
local LocalP = game.Players.LocalPlayer
local OrderModule = require(game:GetService("ReplicatedStorage"):WaitForChild("ToolOrder"))

local function GetToolOrder(Tool)
	for i,v in pairs(OrderModule.Tools) do
		if v.Name == Tool then
			return i
		end
	end
end

local function GetOwnedTools()
	for i,v in pairs(LocalP.StarterGear:GetChildren()) do
		if v:FindFirstChild("IsShopTool") and v.IsShopTool.Value == true then
			return v.Name
		end
	end
end

--[[ Open & close ]]--
game:GetService("ReplicatedStorage"):WaitForChild("OpenShop").OnClientEvent:Connect(function()
	script.Parent.Frame:TweenPosition(UDim2.new(0.5,0,0.5,0),nil,nil,0.75)
end)
script.Parent.Frame.Close.MouseButton1Down:Connect(function()
	script.Parent.Frame:TweenPosition(UDim2.new(0.5,0,1.5,0),nil,nil,0.75)
end)

--[[ Select Item ]]--
local function SelectTool(v)
	Selected = game:GetService("ReplicatedStorage").ShopItems.ShopTools:FindFirstChild(v.Name)
	Price.Text = "Price: \n" .. Selected.Price.Value
	Name.Text = v.Name
	Mode = "Tool"
	local CurrentOrder = GetToolOrder(GetCurrentTool())
	local SelectedOrder = GetToolOrder(Selected.Name)
	local MaxOrder = LocalP.ToolValue.Value
	if SelectedOrder == CurrentOrder then
		BuyButton.Text = "Equipped"
	elseif SelectedOrder < MaxOrder then
		BuyButton.Text = "Equip"
	elseif SelectedOrder > MaxOrder then
		BuyButton.Text = "Buy"
	end
end

local function SelectBackpack(v)
	Selected = game:GetService("ReplicatedStorage").ShopItems.Backpacks:FindFirstChild(v.Name)
	Price.Text = "Price: \n" .. Selected.Price.Value
	Name.Text = v.Name
	Mode = "Backpack"
	local SelectedSize = Selected.Size.Value
	local CurrentSize = LocalP.BackpackStorage.Value
	if SelectedSize > CurrentSize then
		BuyButton.Text = "Buy"
	elseif CurrentSize == SelectedSize then
		BuyButton.Text = "Equipped"

	elseif CurrentSize > SelectedSize then
		BuyButton.Text = "Owned"
	end
end

--[[ Set buttons ]]--
for i,v in pairs(Tools) do
	if v:IsA("TextButton") then
		Tools[i].MouseButton1Down:Connect(function()
			SelectTool(Tools[i])
		end)
	end
end

for i,v in pairs(BackpackChildren) do
	if v:IsA("TextButton") then
		BackpackChildren[i].MouseButton1Down:Connect(function()
			SelectBackpack(BackpackChildren[i])
		end)
	end
end

wait(1)
SelectTool(Tools[1])

--[[ Buy ]]--
BuyButton.MouseButton1Down:Connect(function()
	if game:GetService("Players").LocalPlayer.leaderstats.Cash.Value < Selected.Price.Value then
		script.Parent.NotEnoughCash:TweenPosition(UDim2.new(0.375, 0,0.4,0),nil,nil,0.5)
		wait(2)
		script.Parent.NotEnoughCash:TweenPosition(UDim2.new(0.375, 0,1,0),nil,nil,0.5)
	else
		game:GetService("ReplicatedStorage").BuyItem:FireServer(Selected.Name,Mode)
	end
end)

--[[ Shop type ]]--
script.Parent.Frame.BackpacksButton.MouseButton1Down:Connect(function()
	ToolFrame.Visible = false
	BackpackFrame.Visible = true
	SelectBackpack(BackpackChildren[1])
end)
script.Parent.Frame.ToolsButton.MouseButton1Down:Connect(function()
	BackpackFrame.Visible = false
	ToolFrame.Visible = true
	SelectTool(Tools[1])
end)