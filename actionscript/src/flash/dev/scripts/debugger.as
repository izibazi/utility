var con=new LocalConnection();
_global function output(message:String , type:String=""):void {
	con.send("debugger","output", type , message);

}

con.addEventListener(StatusEvent.STATUS,onStatusChanged);

function onStatusChanged(evt:StatusEvent):void{
	
}
