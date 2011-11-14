package  {
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	
	/**
	 * This is an organizational class that can update and render a bunch of <code>FlxObject</code>s.
	 * NOTE: Although <code>PosGroup</code> extends <code>FlxObject</code>, it will not automatically
	 * add itself to the global collisions quad tree, it will only add its members.
	 */
	public class PosGroup extends FlxObject {
		
		static public const ASCENDING:int = -1;
		static public const DESCENDING:int = 1;
		
		static public const STRICT:uint = 0;
		static public const GROW:uint = 1;
		
		/**
		 * Array of all the <code>FlxObject</code>s that exist in this layer.
		 */
		public var members:Array;
		public var length:Number;

		protected var _maxSize:uint;
		protected var _marker:uint;
		
		/**
		 * Helpers for sorting members.
		 */
		protected var _sortIndex:String;
		protected var _sortOrder:int;
		
		private var _lastX:Number;
		private var _lastY:Number;
		
		public function PosGroup(X:Number = 0, Y:Number = 0, MaxSize:uint=0) {
			super(X, Y);
			members = new Array();
			length = 0;
			_maxSize = MaxSize;
			_marker = 0;
			_sortIndex = null;
			_lastX = X;
			_lastY = Y;
		}
		
		/**
		 * Override this function to handle any deleting or "shutdown" type operations you might need,
		 * such as removing traditional Flash children like Sprite objects.
		 */
		override public function destroy():void
		{
			if(members != null)
			{
				var b:FlxObject;
				var i:uint = 0;
				while(i < length)
				{
					b = members[i++] as FlxObject;
					if(b != null)
						b.destroy();
				}
				members.length = 0;
				members = null;
			}
			_sortIndex = null;
		}
		
		/**
		 * Automatically goes through and calls update on everything you added,
		 * override this function to handle custom input and perform collisions.
		 */
		override public function update():void
		{
			var dx:Number = x - _lastX;
			var dy:Number = y - _lastY;
			_lastX = x;
			_lastY = y;
			
			var b:FlxObject;
			var i:uint = 0;
			while(i < length)
			{
				b = members[i++] as FlxObject;
				if ((b != null) && b.exists && b.active) {
					b.x += dx;
					b.y += dy;
					b.update();
				}
			}
		}
		
		/**
		 * Automatically goes through and calls render on everything you added,
		 * override this loop to control render order manually.
		 */
		override public function draw():void
		{
			var b:FlxObject;
			var i:uint = 0;
			while(i < length)
			{
				b = members[i++] as FlxObject;
				if((b != null) && b.exists && b.visible)
					b.draw();
			}
		}
		
		public function get maxSize():uint
		{
			return _maxSize;
		}
		
		public function set maxSize(Size:uint):void
		{
			_maxSize = Size;
			if(_marker >= _maxSize)
				_marker = 0;
			if((_maxSize == 0) || (members == null) || (_maxSize >= members.length))
				return;
			
			//If the max size has shrunk, we need to get rid of some objects
			var b:FlxObject;
			var i:uint = _maxSize;
			var l:uint = members.length;
			while(i < l)
			{
				b = members[i++] as FlxObject;
				if(b != null)
					b.destroy();
			}
			length = members.length = _maxSize;
		}
		
		/**
		 * Adds a new <code>FlxObject</code> subclass (FlxSprite, MyEnemy, etc) to the group.
		 * FlxGroup will try to replace a null member of the array first.
		 * Failing that, FlxGroup will add it to the end of the member array,
		 * assuming there is room for it, and doubling the size of the array if necessary.
		 * WARNING: If the group has a maxSize that has already been met,
		 * the object will NOT be added to the group!
		 *
		 * @param	Object			The object you want to add to the group.
		 *
		 * @return	The same <code>FlxObject</code> object that was passed in.
		 */
		public function add(Object:FlxObject):FlxObject
		{
			if (Object == null)
				return null;
			
			//Don't bother adding an object twice.
			if(members.indexOf(Object) >= 0)
				return Object;
			
			Object.x += x;
			Object.y += y;
			Object.update(); //to prevent weird jerky issues
			
			//First, look for a null entry where we can add the object.
			var i:uint = 0;
			var l:uint = members.length;
			while(i < l)
			{
				if(members[i] == null)
				{
					members[i] = Object;
					if(i >= length)
						length = i+1;
					return Object;
				}
				i++;
			}
			
			//Failing that, expand the array (if we can) and add the object.
			if(_maxSize > 0)
			{
				if(members.length >= _maxSize)
					return Object;
				else if(members.length * 2 <= _maxSize)
					members.length *= 2;
				else
					members.length = _maxSize;
			}
			else
				members.length *= 2;
			
			//If we made it this far, then we successfully grew the group,
			//and we can go ahead and add the object at the first open slot.
			members[i] = Object;
			length = i+1;
			return Object;
		}
		
		/**
		 * Recycling is designed to help you reuse game objects without always re-allocating or "newing" them.
		 *
		 * If you specified a maximum size for this group (like in FlxEmitter),
		 * then recycle will employ what we're calling "rotating" recycling.
		 * Recycle() will first check to see if the group is at capacity yet.
		 * If group is not yet at capacity, recycle() returns a new object.
		 * If the group IS at capacity, then recycle() just returns the next object in line.
		 *
		 * If you did NOT specify a maximum size for this group,
		 * then recycle() will employ what we're calling "grow-style" recycling.
		 * Recycle() will return either the first object with exists == false,
		 * or, finding none, add a new object to the array,
		 * doubling the size of the array if necessary.
		 *
		 * WARNING: If this function needs to create a new object,
		 * and no object class was provided, it will return null
		 * instead of a valid object!
		 *
		 * @param	ObjectClass		The class type you want to recycle (e.g. FlxSprite, EvilRobot, etc). Do NOT "new" the class in the parameter!
		 *
		 * @return	A reference to the object that was created.  Don't forget to cast it back to the Class you want (e.g. myObject = myGroup.recycle(myObjectClass) as myObjectClass;).
		 */
		public function recycle(ObjectClass:Class=null):FlxObject
		{
			var b:FlxObject;
			if(_maxSize > 0)
			{
				if(length < _maxSize)
				{
					if(ObjectClass == null)
						return null;
					return add(new ObjectClass() as FlxObject);
				}
				else
				{
					b = members[_marker++];
					if(_marker >= _maxSize)
						_marker = 0;
					return b;
				}
			}
			else
			{
				b = getFirstAvail(ObjectClass);
				if(b != null)
					return b;
				if(ObjectClass == null)
					return null;
				return add(new ObjectClass() as FlxObject);
			}
		}
		
		/**
		 * Removes an object from the group.
		 *
		 * @param	Object	The <code>FlxObject</code> you want to remove.
		 * @param	Splice	Whether the object should be cut from the array entirely or not.
		 *
		 * @return	The removed object.
		 */
		public function remove(Object:FlxObject,Splice:Boolean=false):FlxObject
		{
			var index:int = members.indexOf(Object);
			if((index < 0) || (index >= members.length))
				return null;
			if(Splice)
			{
				members.splice(index,1);
				length--;
			}
			else
				members[index] = null;
			return Object;
		}
		
		/**
		 * Replaces an existing <code>FlxObject</code> with a new one.
		 *
		 * @param	OldObject	The object you want to replace.
		 * @param	NewObject	The new object you want to use instead.
		 *
		 * @return	The new object.
		 */
		public function replace(OldObject:FlxObject,NewObject:FlxObject):FlxObject
		{
			var index:int = members.indexOf(OldObject);
			if((index < 0) || (index >= members.length))
				return null;
			members[index] = NewObject;
			return NewObject;
		}
		
		/**
		 * Call this function to sort the group according to a particular value and order.
		 * For example, to sort game objects for Zelda-style overlaps you might call
		 * <code>myGroup.sort("y",ASCENDING)</code> at the bottom of your
		 * <code>FlxState.update()</code> override.  To sort all existing objects after
		 * a big explosion or bomb attack, you might call <code>myGroup.sort("exists",DESCENDING)</code>.
		 *
		 * @param	Index	The <code>String</code> name of the member variable you want to sort on.  Default value is "y".
		 * @param	Order	A <code>FlxGroup</code> constant that defines the sort order.  Possible values are <code>ASCENDING</code> and <code>DESCENDING</code>.  Default value is <code>ASCENDING</code>.
		 */
		public function sort(Index:String="y",Order:int=ASCENDING):void
		{
			_sortIndex = Index;
			_sortOrder = Order;
			members.sort(sortHandler);
		}

		public function setAll(VariableName:String,Value:Object,Recurse:Boolean=true):void
		{
			var b:FlxObject;
			var i:uint = 0;
			while(i < length)
			{
				b = members[i++] as FlxObject;
				if(b != null)
				{
					if(Recurse && (b is PosGroup))
						(b as PosGroup).setAll(VariableName,Value);
					else
						b[VariableName] = Value;
				}
			}
		}
		
		/**
		 * Call this function to retrieve the first object with exists == false in the group.
		 * This is handy for recycling in general, e.g. respawning enemies.
		 *
		 * @param	ObjectClass		An optional parameter that lets you narrow the results to instances of this particular class.
		 *
		 * @return	A <code>FlxObject</code> currently flagged as not existing.
		 */
		public function getFirstAvail(ObjectClass:Class=null):FlxObject
		{
			var b:FlxObject;
			var i:uint = 0;
			while(i < length)
			{
				b = members[i++] as FlxObject;
				if((b != null) && !b.exists && ((ObjectClass == null) || (b is ObjectClass)))
					return b;
			}
			return null;
		}
		
		/**
		 * Call this function to retrieve the first index set to 'null'.
		 * Returns -1 if no index stores a null object.
		 *
		 * @return	An <code>int</code> indicating the first null slot in the group.
		 */
		public function getFirstNull():int
		{
			var b:FlxObject;
			var i:uint = 0;
			var l:uint = members.length;
			while(i < l)
			{
				if(members[i] == null)
					return i;
				else
					i++;
			}
			return -1;
		}
		
		/**
		 * Call this function to retrieve the first object with exists == true in the group.
		 * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
		 *
		 * @return	A <code>FlxObject</code> currently flagged as existing.
		 */
		public function getFirstExtant():FlxObject
		{
			var b:FlxObject;
			var i:uint = 0;
			while(i < length)
			{
				b = members[i++] as FlxObject;
				if((b != null) && b.exists)
					return b;
			}
			return null;
		}
		
		/**
		 * Call this function to retrieve the first object with dead == false in the group.
		 * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
		 *
		 * @return	A <code>FlxObject</code> currently flagged as not dead.
		 */
		public function getFirstAlive():FlxObject
		{
			var b:FlxObject;
			var i:uint = 0;
			while(i < length)
			{
				b = members[i++] as FlxObject;
				if((b != null) && b.exists && b.alive)
					return b;
			}
			return null;
		}
		
		/**
		 * Call this function to retrieve the first object with dead == true in the group.
		 * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
		 *
		 * @return	A <code>FlxObject</code> currently flagged as dead.
		 */
		public function getFirstDead():FlxObject
		{
			var b:FlxObject;
			var i:uint = 0;
			while(i < length)
			{
				b = members[i++] as FlxObject;
				if((b != null) && !b.alive)
					return b;
			}
			return null;
		}
		
		/**
		 * Call this function to find out how many members of the group are not dead.
		 *
		 * @return	The number of <code>FlxObject</code>s flagged as not dead.  Returns -1 if group is empty.
		 */
		public function countLiving():int
		{
			var count:int = -1;
			var b:FlxObject;
			var i:uint = 0;
			while(i < length)
			{
				b = members[i++] as FlxObject;
				if(b != null)
				{
					if(count < 0)
						count = 0;
					if(b.exists && b.alive)
						count++;
				}
			}
			return count;
		}
		
		/**
		 * Call this function to find out how many members of the group are dead.
		 *
		 * @return	The number of <code>FlxObject</code>s flagged as dead.  Returns -1 if group is empty.
		 */
		public function countDead():int
		{
			var count:int = -1;
			var b:FlxObject;
			var i:uint = 0;
			while(i < length)
			{
				b = members[i++] as FlxObject;
				if(b != null)
				{
					if(count < 0)
						count = 0;
					if(!b.alive)
						count++;
				}
			}
			return count;
		}
		
		/**
		 * Returns a member at random from the group.
		 *
		 * @return	A <code>FlxObject</code> from the members list.
		 */
		public function getRandom():FlxObject
		{
			return FlxG.getRandom(members) as FlxObject;
		}
		
		/**
		 * Remove all instances of <code>FlxObject</code> subclass (FlxSprite, FlxBlock, etc) from the list.
		 * WARNING: does not destroy() or kill() any of these objects!
		 */
		public function clear():void
		{
			length = members.length = 0;
		}
		
		/**
		 * Calls kill on the group and all its members.
		 */
		override public function kill():void
		{
			var b:FlxObject;
			var i:uint = 0;
			while(i < length)
			{
				b = members[i++] as FlxObject;
				if(b != null)
					b.kill();
			}
			super.kill();
		}
		
		/**
		 * Helper function for the sort process.
		 *
		 * @param 	Obj1	The first object being sorted.
		 * @param	Obj2	The second object being sorted.
		 *
		 * @return	An integer value: -1 (Obj1 before Obj2), 0 (same), or 1 (Obj1 after Obj2).
		 */
		protected function sortHandler(Obj1:FlxObject,Obj2:FlxObject):int
		{
			if(Obj1[_sortIndex] < Obj2[_sortIndex])
				return _sortOrder;
			else if(Obj1[_sortIndex] > Obj2[_sortIndex])
				return -_sortOrder;
			return 0;
		}
	}
}