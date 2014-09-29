package utils
{
	import flash.filters.GlowFilter;
	
	import org.agony2d.Agony;
	import org.agony2d.flashApi.LabelUU;

	// 嵌入字體，旋轉後可能無法顯示.
	// 設定字體width,height，不會影響scale值.
	public class TextUtil
	{
		
		private static var FONT_A:String = "微软雅黑";
		
		public static function createLabel( text:*, size:uint, color:uint, bold:Boolean = true, letterSpacing:int = 1, blur:Number = 3.5, glowStrength:Number = 22, font:String = null ) : LabelUU {
			var label:LabelUU;
			
			label = new LabelUU;
			label.font = font ? font : FONT_A;
			label.text = String(text);
			label.color = color;
			label.size = size;
			label.filters = [new GlowFilter(0x11, 0.9, blur, blur, glowStrength)];
			label.letterSpacing = letterSpacing;
			label.bold = bold;
			label.touchable = false;
			return label;
		}
		
		public static function createLabel2( text:String, size:uint, color:uint, letterSpacing:Number, blur:Number = 3.5, glowStrength:Number = 22, font:String = null ) : LabelUU {
			var label:LabelUU;
			
			label = new LabelUU;
			label.font = font ? font : FONT_A;
			label.text = text;
			label.color = color;
			label.size = size;
			label.filters = [new GlowFilter(0x11, 0.9, blur, blur, glowStrength, 1)];
			label.letterSpacing = letterSpacing;
			label.bold = false;
			label.touchable = false;
			return label;
		}
		
		public static function createLabel3( text:String, size:uint, color:uint, bold:Boolean, letterSpacing:Number = 1, font:String = null ) : LabelUU {
			var label:LabelUU;
			
			label = new LabelUU;
			label.font = font ? font : FONT_A;
			label.text = text;
			label.color = color;
			label.size = size;
			label.letterSpacing = letterSpacing;
			label.bold = bold;
			label.touchable = false;
			return label;
		}
		
		public static function createLabel4( text:String, size:uint, color:uint, width:Number, font:String = null ) : LabelUU {
			var label:LabelUU;
			
			label = new LabelUU("none");
			label.font = font ? font : FONT_A;
			label.text = text;
			label.color = color;
			label.size = size;
			label.width = width;
//			label.background = true;
//			label.backgroundColor = 0xdddd33;
			label.bold = true;
			label.wordWrap = true;
			label.touchable = false;
			return label;
		}
		
		public static function decorateLabel( label:LabelUU, size:uint, color:uint, bold:Boolean = true, blur:Number = 3.5, glowStrength:Number = 22, font:String = null ) : LabelUU {
			label.font = font ? font : FONT_A;
			label.color = color;
			label.size = size;
			label.filters = [new GlowFilter(0x0, 0.9, blur, blur, glowStrength, 1)];
			label.bold = bold;
			label.touchable = false;
			return label;
		}
		
		public static function decorateLabel2( label:LabelUU, text:String, size:uint, color:uint, letterSpacing:Number, blur:Number = 3, glowStrength:Number = 22, font:String = null ) : void {
			label.font = font ? font : FONT_A;
			label.text = text;
			label.color = color;
			label.size = size;
			label.filters = [new GlowFilter(0x0, 1, blur, blur, glowStrength, 2)];
			label.letterSpacing = letterSpacing;
			label.bold = false;
			label.touchable = false;
		}
		
		// 竖排.
//		public static function decorateLabel2( label:LabelUU, text:String, size:uint, color:uint, bold:Boolean = true, blur:Number = 2.2, glowStrength:Number = 16, font:String = "微软雅黑" ) : void {
//			label.font = font;
//			label.text = text;
//			label.color = color;
//			label.size = size;
//			label.width = 42;
//			label.filters = [new GlowFilter(0x11, 1, blur, blur, glowStrength, 3)];
//			label.bold = bold;
//		}
	}
}