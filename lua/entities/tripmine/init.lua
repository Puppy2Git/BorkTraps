--server side file 

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("Bork_Traps_config.lua")
include("Bork_Traps_config.lua")
include("shared.lua")
-- Used when removing the mine after damage or explosion
-- Used when calling the mine
function ENT:SpawnFunction(ply, tr, Class)
    if (Bork_traps_TripMines_enabled) then
        self.towner = ply
        ply:SetNWInt("Bork_traps_Tripmines_pl", ply:GetNWInt("Bork_traps_Tripmines_pl") + 1)
        if ply:GetNWInt("Bork_traps_Tripmines_pl") < 0 then
            ply:SetNWInt("Bork_traps_Tripmines_pl", 0)
        end
        if ply:GetNWInt("Bork_traps_Tripmines_pl") <= Bork_traps_TripMines_limit then
            local SpawnPos = tr.HitPos + tr.HitNormal
            local ent = ents.Create( Class )
            local anglechange = Angle(90,0,0)
            ent:Spawn()
            ent:SetPos( SpawnPos )
            ent:SetAngles((tr.HitNormal):Angle() +anglechange)
            ent:Activate()
            undo.Create("tripmine")
                undo.AddEntity(ent)
                undo.SetPlayer(ply)
            undo.Finish()
        else
            ply:SetNWInt("Bork_traps_Tripmines_pl", ply:GetNWInt("Bork_traps_Tripmines_pl") - 1)
        end
    end

end

-- Initing the mine
function ENT:Initialize()
    self:SetModel("models/tripmine/tripmine.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self.timer = CurTime()
    self.active = false
    self.busy = false
    self:SetColor(Color(255,255,255,255))
    local phys = self:GetPhysicsObject()
    if(phys:IsValid()) then
        phys:Wake()
        phys:EnableMotion(false)
    end
end
--If the line is triggered by a player
local function Line_triggered(thing)
    if ((((Bork_traps_TripMines_pff == false) && (thing.towner != toucher)) || Bork_traps_TripMines_pff == true) && (true)) then
        thing.busy = true
        local explode = ents.Create("env_explosion")
        explode:SetPos(thing:GetPos())
        explode:SetOwner(thing.Owner)
        explode:SetKeyValue("iMagnitude",tostring(Bork_traps_TripMines_damage))
        explode:Fire("Explode", 0,0)
        thing:Remove()

    end
end


-- Every game tick
function ENT:Think()
    if (self.active == true) then
        if ((self.busy == false) && self.line.Entity:IsPlayer()) then
            Line_triggered(self)
        end
    end
    if (self.towner:IsValid()) then
        if CurTime() > self.timer + Bork_traps_TripMines_delay then
            self.active = true
            self:SetSkin(1)
            self.line = util.TraceLine( {
                start = (self:GetPos() + self:GetRight()*-2.6 + self:GetUp()*3 + self:GetForward()*-2.4), --startpos
                endpos = self:GetPos() + self:GetAngles():Up() * 500}) --endpos
        end
    else
        self:Remove()
    end
    --Prevent Color values from being changed, making it invisible
    if (self:GetColor() != Color(255,255,255,255)) then
        self:SetColor(Color(255,255,255,255))
    end

    self:NextThink( CurTime() + 0.075)
    return true
    --controls where to draw line
end


-- If shot at
function ENT:OnTakeDamage(dmginfo)
    if ((dmginfo:GetAttacker():IsPlayer()) || Bork_traps_TripMines_mff) then
        self:Remove()
    end
end

function ENT:OnRemove()
    if self.towner:GetNWInt("Bork_traps_Tripmines_pl") > 0 then
        self.towner:SetNWInt("Bork_traps_Tripmines_pl", self.towner:GetNWInt("Bork_traps_Tripmines_pl") - 1)
    else
        self.towner:SetNWInt("Bork_traps_Tripmines_pl", 0)
    end
end