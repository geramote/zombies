package  Core
{
	import flash.utils.Timer;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	
	/**
	* ...
	* @author Default
	*/
	public class Time 
	{
		private static var __instance:Time;
		private static var __allowInstantiation:Boolean = false;
		private var paused_: Boolean = false;
		private var pausedTime: Date= null;
		
		private var millisecsInPause: Number = 0;
		
		
		private var startTime_: Date = new Date();
		
		public static function get instance():Time
		{
			if(!__instance)
			{
				__allowInstantiation = true;
				__instance = new Time();
				__allowInstantiation = false;
			}
			return __instance;
		}

		public function Time()
		{
			if (!__allowInstantiation)
			{
				//throw new Error("Awards instance duplicates!")
			}
			else
			{
				var date: Date = new Date();
				startTime_ = new Date();// .time;
			}
		}
		
		public function getMilliseconds(): Number
		{
			//return startTime_ + timer.currentCount;
			var now: Date = new Date();
			
			if (paused_)
			{
				return pausedTime.time - startTime_.time;
			}
			millisecsInPause = 0;
			
			return now.time - startTime_.time;
		}
		
		public function getGameMilliseconds(): Number
		{
			return getMilliseconds();// * Consts.instance.TIME_MULTIPLIER;
		}
		
		
		public function gameDayOf(): Number
		{
			var totalDays: Number = (getGameMilliseconds() / 1000 / 60 / 60 / 24);
			//if (totalDays >)
			return Math.floor(totalDays % 30);
		}
		
		public function gameHourOf(): Number
		{	
			var totalHours: Number = (getGameMilliseconds() / 1000 / 60 / 60);
			
			if (totalHours >= 24)
			{
				return Math.floor(totalHours % 24);
			}
			else
			{
				return totalHours;
			}
		}
		
		public function gameMonthOf(): int
		{
			//var nm: Number = //(getGameMilliseconds() / 1000 / 60 / 60 / 30);
			var totalMonths: int = int(Math.floor(getGameMilliseconds() / 1000 / 60 / 60 / 24 / 30));
			
			if (totalMonths > 12)
			{
				return int (Math.floor(totalMonths % 12));
			}
			else
			{
				return totalMonths;
			}
		}
		
		public function gameMonthString(): String
		{
			var im: int = int(gameMonthOf());
			return "";// Consts.instance.MONTH_NAMES[im];
		}
		
		public function gameMinuteOf(): Number
		{
			var totalMins: Number = getGameMilliseconds() / 1000 / 60;
			
			if (totalMins >= 60)			
			{
				return Math.floor(totalMins % 60);
			}
			else
			{
				return Math.floor(totalMins);
			}
			/*return 0;
			var sec: Number = Math.floor(getGameMilliseconds() / 1000);
			return Math.floor(sec / 60) % 60;*/
		}
		
		public function gameSecondOf(): Number
		{
			//return Math.floor(getGameMilliseconds() / 1000) % 60;
			var totalSecs: Number = getGameMilliseconds() / 1000;
			if (totalSecs >= 60)
			{
				return Math.floor(totalSecs % 60);
			}
			else
			{
				return Math.floor(totalSecs);
			}
		}
		
		public function hourOf(): Number
		{
			var sec: Number = Math.floor(getMilliseconds() / 1000);
			var min: Number = Math.floor(sec / 60);
			return Math.floor(min / 60) % 24;
		}
		
		public function minuteOf(): Number
		{
			var sec: Number = Math.floor(getMilliseconds() / 1000);
			return Math.floor(sec / 60) % 60;
		}
		
		public function secondOf(): Number
		{
			return Math.floor(getMilliseconds() / 1000) % 60;
		}
		
		public function set startTime(value: Number)
		{
			startTime_.setTime(value);
		}
		
		public function get startTime(): Number
		{
			return startTime_.time;
		}
		
		public function set gameMilliseconds(value: Number)
		{
			//var realMilliseconds: Number = value / Consts.instance.TIME_MULTIPLIER;
			//startTime_ = realMilliseconds;
			//var now: Date = new Date();
			//var diff: Number = realMilliseconds - getMilliseconds();
			//startTime_ += -1 * diff;
		}
		
		public function get gameMilliseconds(): Number
		{
			return getGameMilliseconds();
		}
		
		public function changeMilliseconds(increment: Number)
		{
			startTime_.setTime(startTime_.time - increment);
			//var ms: Number = (startTime_.time - increment;
			trace("Change time: " + (startTime_.time - increment).toString());
		}
		
		public function save(xmlNode: XMLNode)
		{
			var timeNode: XMLNode = xmlNode;// new XMLNode(XMLNodeType.ELEMENT_NODE, "");
			
			timeNode.attributes["startTime"] = startTime_.time.toString();
			var now: Date = new Date();
			timeNode.attributes["exitTime"] = now.time.toString();
			//xmlNode.appendChild(timeNode);
		}
		
		public function load(xml: XML)
		{
			var st: Number = Number(xml.time.@startTime);
			
			
			startTime_.setTime(st);
			try
			{
				var now: Date = new Date();
				var s: String = xml.time.@exitTime;
				var et: Number = 0; 
				if (s != "")
				{
					et = Number(s);
				}
				
				var msInClosing: Number = now.time - et;
				startTime_.setTime(startTime_.time + msInClosing);
			//	var s: Number = startTime_.time;
			}
			catch (e: Error)
			{}
			
			//s = 0;
		}
		
		public function reset()
		{
			///var date: Date = new Date();
			startTime_ = new Date();
		}
		
		public function pause()
		{
			//return;
			if (paused_) return;
			if (pausedTime != null) return;
			
			paused_ = true;
			pausedTime = new Date();
		}
		
		public function unpause()
		{	
//			if ((Variables.diaryPause) || (Variables.mainMenuPause) || (Variables.pauseScreenPause) || (Variables.helpPause) || (Variables.focusPause)) return;
			
			if (!paused_) return;
			
			if (pausedTime != null)
			{
				paused_ = false;
				var now: Date = new Date();
				millisecsInPause = now.time - pausedTime.time;
				startTime_.setTime(startTime_.time + millisecsInPause);
			}
			pausedTime = null;
		}
		
		public function get paused(): Boolean
		{
			return paused_;
		}
	}
}