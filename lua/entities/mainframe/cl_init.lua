include("shared.lua")
function ENT:Draw()
    self:DrawModel()
end

net.Receive("LvLSysInitMenu",function()
    --here draw the derma or what you want
    local DermaPanel = vgui.Create( "DFrame" )
    DermaPanel:SetPos( ScrW()/2 - (ScrW()/2)/2, ScrH()/2  - (ScrH()/2)/2)
    DermaPanel:SetSize( ScrW()/2, ScrH()/2 )
    DermaPanel:SetTitle( "Mainframe Interface" )
    DermaPanel:SetDraggable( false )
    DermaPanel:MakePopup()
    DermaPanel.btnMinim:SetVisible(false)
    DermaPanel.btnMaxim:SetVisible(false)
    local DLabel = vgui.Create( "DLabel", DermaPanel )
    DLabel:SetPos( 40, 40 )
    DLabel:SetText(net.ReadString())

end)