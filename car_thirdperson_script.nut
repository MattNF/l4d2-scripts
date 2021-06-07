HookController <- {}
IncludeScript("HookController", HookController)

HookController.RegisterOnTick(this)

printl("car_thirdperson_script")

function OnTick(){
	if(Ent(1) != null){
		local cameraAngle = QAngle(15 - Ent("infected_target").GetAngles().x, Ent(1).EyeAngles().y, Ent(1).EyeAngles().z)
		Ent("carthirdperson").SetAngles(cameraAngle + QAngle(0, Ent("infected_target").GetAngles().y, Ent("infected_target").GetAngles().z))
		Ent("carthirdperson").SetOrigin(/*Ent("infected_target").GetOrigin() + */cameraAngle.Forward()*-200)
		
	}
}