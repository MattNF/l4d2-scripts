HookController <- {}
IncludeScript("HookController", HookController)
HookController.RegisterHooks(this)

function OnTick(){
	if(user != null){
		Ent("camera_3").SetAngles(user.EyeAngles())
	}
}