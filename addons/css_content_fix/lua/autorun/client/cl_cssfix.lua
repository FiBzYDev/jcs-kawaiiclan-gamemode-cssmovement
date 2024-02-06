surface.CreateFont( "cssfix_title", {
	font = "Arial",
	size = 20,
	antialias = true
} )
surface.CreateFont( "cssfix_text", {
	font = "Arial",
	size = 15,
	antialias = true
} )

local langList = { 
    {"materials/flags16/us.png", "Oops...\nIt seems like you don't have Counter-Strike Source content installed!\nYou might see errors and pink/black textures everywhere.\nClick Yes to install it!"}, 
    {"materials/flags16/fr.png", "Oups...\nApparemment tu n'as pas Counter-Strike Source installé!\nTu verras surement des ERROR et textures noires et roses partout.\nAppuie sur Yes pour l'installer!"},

}
local function Initialize()
    local model = "models/items/cs_gift.mdl"
    local entity = ClientsideModel( model )
    entity:SetNoDraw(true)
    entity:Spawn()
    local isErrorMaterial = entity:GetMaterials()[1] == "models/error/new light1"
    entity:Remove()

    if isErrorMaterial then
        local Frame = vgui.Create( "DFrame" )
        Frame:SetSize( 400, 135 ) 
        Frame:SetTitle( "" ) 
        Frame:SetVisible( true ) 
        Frame:SetDraggable( false ) 
        Frame:ShowCloseButton( false ) 
        Frame.Paint = function()
            draw.RoundedBox( 5, 0, 0, Frame:GetWide(), Frame:GetTall(), Color(50,50,50,180 ) )
            draw.RoundedBox( 5, 0, 0, Frame:GetWide(), 28, Color(10,10,10,200 ) )
    
            surface.SetFont( "cssfix_title" )
            surface.SetTextPos( Frame:GetWide() / 2 - surface.GetTextSize( "CSS Content Fix" ) / 2, 5 ) 
            surface.SetTextColor( 255, 255, 255, 255 )
            surface.DrawText( "CSS Content Fix" )

            --[[surface.SetFont( "cssfix_text" )
            surface.SetTextColor( 255, 255, 255, 255 )
            surface.SetTextPos( 6, 30 ) 
            surface.DrawText( "Oops...")
            surface.SetTextPos( 6, 45 ) 
            surface.DrawText("It seems like you don't have Counter-Strike Source content installed!")
            surface.SetTextPos( 6, 60 ) 
            surface.DrawText("You might see errors and pink/black textures everywhere.")
            surface.SetTextPos( 6, 75 ) 
            surface.DrawText("Click Yes to install it!" )--]]
        end

        Frame:MakePopup()
        
        local Label = vgui.Create("DLabel", Frame)
        Label:SetFont("cssfix_text")
        Label:SetPos(6, 15)
        Label:SetSize(400, 90)
        Label:SetTextColor(Color(255, 255, 255, 255))
        Label:SetText(langList[1][2])

        local LanguageButton = vgui.Create("DButton", Frame)
        LanguageButton:SetVisible(true)
        LanguageButton:SetSize(24, 19)
        LanguageButton:SetPos(6, 6)
        LanguageButton:SetMaterial(langList[1][1])
        LanguageButton:SetText("")
        LanguageButton:SetDrawBackground(false)
        local currLang = 1
        LanguageButton.DoClick = function() 
            currLang = currLang + 1
            if currLang > #langList then currLang = 1 end
            LanguageButton:SetMaterial(langList[currLang][1])
            Label:SetText(langList[currLang][2])
        end
        

        local BottomPanel = vgui.Create("DPanel", Frame)
        BottomPanel:Dock(BOTTOM)
        BottomPanel:DockMargin( 3, 3, 3, 3 )
        BottomPanel:SetVisible(true)
        BottomPanel:SetDrawBackground( false )
        BottomPanel:SetSize(0, 30)

            local yesButton = vgui.Create("DButton", BottomPanel)
            yesButton:SetSize(189, 30)
            yesButton:SetText("Yes!")
            yesButton:Dock(LEFT)
            yesButton.DoClick = function() gui.OpenURL("https://www.youtube.com/watch?v=8AfuNpX8RQA") Frame:Close() end

            local noButton = vgui.Create("DButton", BottomPanel)
            noButton:SetSize(189, 30)
            noButton:SetText("No")
            noButton:Dock(RIGHT)
            noButton.DoClick = function() Frame:Close() end
        
        Frame:Center()

    end
end
hook.Add( "InitPostEntity", "cssfix_init", function() timer.Simple(3, Initialize) end )