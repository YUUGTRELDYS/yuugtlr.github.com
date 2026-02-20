local YUUGTRL = loadstring(game:HttpGet("https://raw.githubusercontent.com/YUUGTRELDYS/YUUGTRL.github.io/refs/heads/main/lib.lua"))()

local window = YUUGTRL:CreateWindow("ТЕСТ")

-- Синяя кнопка: текст светлее синего
window:AddButton("СИНИЙ", Color3.fromRGB(80, 100, 220), function() end)

-- Зеленая кнопка: текст светлее зеленого
window:AddButton("ЗЕЛЕНЫЙ", Color3.fromRGB(80, 180, 120), function() end)

-- Красная кнопка: текст светлее красного
window:AddButton("КРАСНЫЙ", Color3.fromRGB(200, 70, 70), function() end)

window:AddButton("ЗАКРЫТЬ", Color3.fromRGB(200, 70, 70), function()
    window:Destroy()
end)
