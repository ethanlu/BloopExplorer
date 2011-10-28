/**
 * Derrick Grigg
 * dgrigg@rogers.com
 * http://www.dgrigg.com
 * created on Nov 3, 2006
 * 
 * Custom drag proxy that displays an image and a label
 * 
 * For use with the com.dgrigg.controls.DataGrid
 */

package scripts.extensions
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	import mx.core.UIComponent;	
	import mx.core.UITextField;
	import mx.controls.DataGrid;	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.Text;
	
	public class CustomDragProxy extends UIComponent
	{
		public function CustomDragProxy():void
		{
			super();
		}
		override protected function createChildren():void
		{
			super.createChildren();
			
			//retrieve the selected indicies and then sort them
			//in order to display them in the proper order
			var items:Array = mx.controls.DataGrid(owner).selectedIndices;
			items.sort();
			
			//Alert.show(this.mouseY.toString());
			
			var len:int = items.length;
			var itemY:int = 0; //y position to place items at
			var w:int = 0;
			var dg:mx.controls.DataGrid = mx.controls.DataGrid(owner);
			
			for (var i:int=0;i<len;i++)
			{
			  var itemRenderer:IListItemRenderer = dg.indexToItemRenderer(items[i]);
			  
			  if (itemRenderer)
			  {
  				var container: UIComponent = new UIComponent();
  				addChild(DisplayObject(container));	
  				
  				//container.setStyle('color','0xFFFFFF');
  				
  				var item:Object = dg.dataProvider[items[i]];
  				
  				var label:UITextField = new UITextField();
  				label.text = item.name;
//  				label.textColor = 0x000000;
  				label.y = 1;
  				label.x = 20;
  				
  				container.addChild(label);
  				
  				var loader:Loader = new Loader();
  				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
  				container.addChild(loader);
  				var request:URLRequest = new URLRequest(item.iconPath);
  				loader.load(request);
  				loader.scaleX = .35;
  				loader.scaleY = .35;
  				
  				container.y = itemRenderer.y+23;
  				container.x = -(this.mouseX - 30);
			  }
			}
			
			x = this.mouseX - 30;
		}
		
		private function handleComplete(event:Event):void
		{
			//scale the image to the desired size
			var info:LoaderInfo = LoaderInfo(event.target);
			var image:Bitmap = Bitmap(info.content);
			var ratio:Number = image.width/image.height
			image.height = 50;
			image.width = image.height * ratio;
		}
	}
}