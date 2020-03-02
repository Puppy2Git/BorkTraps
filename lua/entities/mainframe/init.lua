AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("Bork_Traps_config.lua")
include("Bork_Traps_config.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr, Class)
    self.towner = ply
    ply:SetNWInt("Bork_traps_mainframe", ply:GetNWInt("Bork_traps_mainframe") + 1)
    if ply:GetNWInt("Bork_traps_mainframe") < 0 then
        ply:SetNWInt("Bork_traps_mainframe", 0)
    end
    if ply:GetNWInt("Bork_traps_mainframe") <= 1 then
        --Offset Pos
        local SpawnPos = tr.HitPos + tr.HitNormal * 12
        local ent = ents.Create( Class )
        --Offset angle
        local anglechange = Angle(0,90,0)
        ent:Spawn()
        ent:SetPos( SpawnPos )
        ent:SetAngles((tr.HitNormal):Angle() +anglechange)
        ent:Activate()
        --Name of ent
        undo.Create("mainframe")
            undo.AddEntity(ent)
            undo.SetPlayer(ply)
        undo.Finish()
    else
        ply:SetNWInt("Bork_traps_mainframe", ply:GetNWInt("Bork_traps_mainframe") - 1)
    end
end



function ENT:Initialize()
    --Temp model til cameron makes one (after I get it working)
    self:SetModel("models/props_wasteland/controlroom_filecabinet001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetColor(Color(255,255,255,255))
    self:SetUseType(3)
    local phys = self:GetPhysicsObject()
    if(phys:IsValid()) then
        phys:Wake()
        phys:EnableMotion(false)
    end
    
end


function ENT:OnRemove()
    if self.towner:GetNWInt("Bork_traps_mainframe") > 0 then
        self.towner:SetNWInt("Bork_traps_mainframe", self.towner:GetNWInt("Bork_traps_mainframe") - 1)
    else
        self.towner:SetNWInt("Bork_traps_mainframe", 0)
    end
end


util.AddNetworkString("LvLSysInitMenu")
function ENT:Use(ply,c)
    net.Start("LvLSysInitMenu")
    net.WriteString(tostring(ply:GetNWInt("Bork_traps_Tripmines_pl")) .. " mines out!")
    net.Send(ply)
end