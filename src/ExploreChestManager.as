package
{
	import org.flixel.*;
	
	public class ExploreChestManager extends FlxGroup
	{
		public const creationRate:Number = 20;
		public const maxChests:Number = 3;
		private var _timer:Number = 0;
		private var firstTime:Boolean = true;
		
		public function ExploreChestManager(MaxSize:uint=0)
		{
			super(MaxSize);
		}
		
		override public function update():void {
//			_timer += FlxG.elapsed;
//			if (_timer > creationRate && length < maxChests ) {
//				spawnRandomChest()
//				_timer = 0;
//			}
			if (firstTime) {
				firstTime = false;
				for (var i:Number = 0 ; i < maxChests ; i++) {
					spawnRandomChest();
				}
			}
		}
		
		public function spawnRandomChest():void {
			var x:Number = Math.floor(Math.random()*FlxG.worldBounds.width);
			var y:Number = Math.floor(Math.random()*(FlxG.worldBounds.height-75)); // 75 is lower bar
			add(new ExploreCandyChest(x, y));
		}
	}
}