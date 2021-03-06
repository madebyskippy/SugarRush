package {
	/**
	 * @author ethanis
	 */
	public class Weapon {
		var attack:int;
		var defense:int;
		// Cotton Candy Sythe would be of Type Sythe and Mod Cotton Candy
		public var weaponType:String;
		var weaponMod:String;
		var buff:int;
		
		/*
		'buffs' is a dictionary of arrays. each key is a point at which buffs can be applied.
		for example, buffs['equip'] might contain buffs that are applied when equipping this weapon, like 'heal'
		and buffs['hit'] might contain buffs that are applied when hitting an enemy, like 'burn' and 'freeze'.
		*/
		var buffs:Object = { }; // yo nate why isn't this just the index of the buff? we only have 1 buff and they are all on-hit effects
		
		private static const verboseMods:Object = {
			"Cane": "Candy Cane",
			"Cotton" : "Cotton Candy",
			"Chocolate": "Chocolate",
			"Gumdrop": "Gumdrop",
			"Marsh": "Marshmallow"
		};
		
		// 1-3 match Candy constants.
		public static const NO_SPECIAL:int = 0;
		public static const RED_SPECIAL:int = 1;
		public static const BLUE_SPECIAL:int = 2;
		public static const WHITE_SPECIAL:int = 3;
		public static const RR_SPECIAL:int = 4;
		public static const BB_SPECIAL:int = 5;
		public static const WW_SPECIAL:int = 6;
		public static const RB_SPECIAL:int = 7;
		public static const RW_SPECIAL:int = 8;
		public static const WB_SPECIAL:int = 9;
		
		// this might get moved later -npinsker
		//some functions return true if the buff was applied.
		public static const BUFF_LIST:Array = [         new Buff('none', 'none', '', 0, function(src:BattleCharacter, trg:BattleCharacter):void { }, Sources.empty),
			new Buff('burn', 'Burn', 'Applies a burn on hit for additional damage.', 1, 
				function(src:BattleCharacter, trg:BattleCharacter):void { src.hurt(1); }, Sources.burn),
			new Buff('freeze', 'Freeze', 'Has a 30% chance to freeze the enemy, disabling their attack for a turn.', 1, 
				function(src:BattleCharacter, trg:BattleCharacter):Boolean { if (Math.random() < 0.3) { src.flags = ['frozen']; src.tempAttackStat = -src.attackStat; return true; } return false;}, Sources.freeze),
			new Buff('heal', 'Drain', 'Restores one point of blood sugar on hit.', -1, 
				function(src:BattleCharacter, trg:BattleCharacter):Boolean { src.heal(1); return true; return false;}, Sources.drain),
			new Buff('burn', 'Ignite', 'Applies a burn on hit for lots of additional damage.', 1, 
				function(src:BattleCharacter, trg:BattleCharacter):void { src.hurt(2); }, Sources.burn),
			new Buff('freeze', 'Deep Freeze', 'Has a 50% chance to freeze the enemy, disabling their attack for a turn.', 1, 
				function(src:BattleCharacter, trg:BattleCharacter):Boolean { if (Math.random() < 0.5) { src.flags = ['frozen']; src.tempAttackStat = -src.attackStat; return true;} return false;}, Sources.freeze),
			new Buff('heal', 'Mega Drain', 'Restores two points of blood sugar on hit.', -1, 
				function(src:BattleCharacter, trg:BattleCharacter):void { src.heal(2); }, Sources.drain),
			new Buff('berserk', 'Perseverance', 'Attacks with this weapon are stronger with less health.', -1, 
				function(src:BattleCharacter, trg:BattleCharacter):void {
					var critChance:Number = 1. - src.currentHealth / src.maxHealth;
					critChance *= critChance; // yes this is intentional. qudratic scaling on crit chance.
					
					if (Math.random() < critChance) {
						src.flags = ['crit'];
					}
				}, Sources.empty),
			new Buff('luck', 'Luck', 'Attacks with this weapon have a 50% chance to deal double damage.', -1, 
				function(src:BattleCharacter, trg:BattleCharacter):void { if (Math.random() < 0.5) { src.flags = ['crit']; } }, Sources.empty),
			new Buff('cascade', 'Cascade', 'Repeated attacks with this weapon become stronger and stronger.', -1, 
				function(src:BattleCharacter, trg:BattleCharacter):void {
					var obj = src.findBuff("cascade");
					if (obj["stacks"]) {
						obj["stacks"] += 1;
					}
					else { 
						obj["stacks"] = 1;
					}
					if (obj["stacks"] > 7) obj["stacks"] = 7;
					
					src.tempAttackStat = obj["stacks"] / 3;
				}, Sources.empty)        ];
		
		public function Weapon(weaponType:String, weaponMod:String, attack:int=1, defense:int=0, buffs:Object = null, useDefault:Boolean = true){
			this.weaponType = weaponType;
			this.weaponMod = weaponMod;
			this.attack = attack;
			this.defense = defense;
			
			if (useDefault) {
				this.buff = (int)(buffs);
				this.buffs = { };
				this.buffs[Sources.defaultBuffStrings[buffs]] = buffs;
			}
			else {
				this.initializeBuffs(buffs);
			}
		}
		public function getBuff():Buff {
			return BUFF_LIST[this.buff];
		}
		
		public function initializeBuffs(buffs:Object):void{
			this.buffs = buffs;
		}
		
		public function buffsOfType(type:String):Array {
			return buffs[type];
		}
		
		public function get baseName():String {
			return verboseMods[weaponMod] + " " + this.weaponType;
		}
		
		public function get displayName():String {
			if (buff == 0) {
				return this.baseName;
			}
			else {
				return this.baseName + " of " + BUFF_LIST[buff].name;
			}
		}
		
		public function get image():Class {
			var varNameStr:String = this.weaponType + this.weaponMod;
			return Sources[varNameStr]; 
		}
	}
}