typedef ModMeta =
{
	var name:String;
	var version:String;

	var credits:Array<
		{
			var name:String;
			var url:Any;
			var role:String;
		}>;

	var priority:Int;
}
