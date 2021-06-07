local timer = SpawnEntityFromTable("logic_timer",{RefireTime = 0.01})
timer.ValidateScriptScope()
timer.GetScriptScope()["scope"] <- this
timer.GetScriptScope()["func"] <- function(){
	scope.WitchGlow_OnTick()
}
timer.ConnectOutput("OnTimer", "func")
EntFire("!self","Enable",null,0,timer)

local glowColor = Vector(255, 255, 255)

local function ConvertVectorToInt(vector){
	local color = vector.x
	color += 256 * vector.y
	color += 65536 * vector.z
	return color
}

function WitchGlow_OnTick(){
	if(Director.HasAnySurvivorLeftSafeArea()){
		local witch = null
		while(witch = Entities.FindByClassname(witch, "witch")){
			if(NetProps.GetPropInt(witch, "m_Glow.m_iGlowType") == 3){
				NetProps.SetPropInt(witch, "m_Glow.m_iGlowType", 0)
			}
		}
	} else {
		local witch = null
		while(witch = Entities.FindByClassname(witch, "witch")){
			if(NetProps.GetPropInt(witch, "m_Glow.m_iGlowType") != 3){
				NetProps.SetPropInt(witch, "m_Glow.m_iGlowType", 3)
				NetProps.SetPropInt(witch, "m_Glow.m_nGlowRange", 99999999)
				NetProps.SetPropInt(witch, "m_Glow.m_glowColorOverride", ConvertVectorToInt(glowColor))
			}
		}
	}
	
    if(Director.HasAnySurvivorLeftSafeArea() && !hasLeftSaferoom){
        hasLeftSaferoom = true
        Say(null, "Enter !b in chat to print boss spawns.", false)
    }
}
