include("shared.lua")

function ENT:Draw()
    self:DrawModel()
    self.pline = util.TraceLine({
        start = (self:GetPos() + self:GetRight()*-2.6 + self:GetUp()*3 + self:GetForward()*-2.4), --startpos
        endpos = self:GetPos() + self:GetAngles():Up() * 500} --endpos
    )
    render.SetMaterial(Material("trails/laser"))
    render.DrawBeam(self:GetPos() + self:GetRight()*-2.6 + self:GetUp()*3 + self:GetForward()*-2.4, self.pline.HitPos, 5, 1, 1, Color(255,0,0,255), false)
end