/**
 * bloopTreeExplorerRenderer.as
 * 
 * tree renderer class for bloop explorer. 
 * */

package scripts.extensions
{
	import mx.controls.treeClasses.*;
	import mx.collections.*
	import flash.display.Sprite;
	
	import mx.controls.Alert;
	import flash.events.MouseEvent;

	public class bloopExplorerTreeRenderer extends TreeItemRenderer
	{
	  private var lineColor:Number = 0xA0A0A0;
	  private var lineThickness:Number = 1;
	  private var lineAlpha:Number = .1;
	  private var hiddenAlpha:Number = .5;
	  
		private var isLast:Boolean;
		private var lineArr:Array = new Array();

		public function bloopExplorerTreeRenderer()
		{
			super();
		}

		// Override the set method for the data property
		// to set the font color and style of each node.
		override public function set data(value:Object):void
		{
			super.data = value;
//			setStyle('color',0x000000);
		}

		public function makeLastChildArr(node:Object, requestedLevel:Number, startLevel:Number):Boolean
		{
			var isLastFlag:Boolean = false;
			var parentNode:XML = node.parent();
			var grandParNode:XML = parentNode.parent();

			if (grandParNode){
				var children:XMLList = grandParNode.children();
				var noOfChildren:Number = children.length();

				if ( parentNode == children[noOfChildren -1]){
					isLastFlag = true;
				}

				this.lineArr.push(isLastFlag);

				if (requestedLevel !=  startLevel){
					makeLastChildArr(node.parent(), requestedLevel, startLevel - 1);
				}
			}

			return isLastFlag;
		}

		public function drawParentLines(i:Number):void
		{
			graphics.lineStyle(this.lineThickness,this.lineColor,this.lineAlpha,false,"NONE");
			var offset:Number = i*17 - 11;
			if (i == 2){offset = 23};
			graphics.moveTo(offset,-14);
			graphics.lineTo(offset,10);
		}

		public function drawChildLeafLines(indent:Number):void
		{
			graphics.lineStyle(this.lineThickness, this.lineColor,this.lineAlpha,false,"NONE");
			var offset:Number = indent + 6.5;
			graphics.moveTo(offset,-14);
			graphics.lineTo(offset,10);
			graphics.moveTo(offset,10);
			graphics.lineTo(offset + 10,10);
		}

		public function drawChildFolderLines(indent:Number):void
		{
			graphics.lineStyle(this.lineThickness, this.lineColor,this.lineAlpha,false,"NONE");
			var offset:Number = indent + 6.5;
			graphics.moveTo(offset,-14);
			graphics.lineTo(offset,6);
		}

		// Override the updateDisplayList() method
		// to set the text for each tree node.
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
		  //-call default displa function to draw icons and labels
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//-now draw lines and show the disclosure icon
			if(super.data)
			{
				if (TreeListData(super.listData))
				{
					graphics.clear();
					var i:Number;
					var node:Object = TreeListData(super.listData).item;
					var depth:Number = TreeListData(super.listData).depth;
					var indent:Number = TreeListData(super.listData).indent;
					var directory:XML = new XMLList(TreeListData(super.listData).item)[0];
					
					if (directory.@hidden == 1)
					{
					  this.icon.alpha = this.hiddenAlpha;
					}
					else
					  this.icon.alpha = 1;

					this.lineArr = new Array();

          			var parentDropLine:Boolean = false;
					if(TreeListData(super.listData).hasChildren)
					{
						//trace("icon = " + TreeListData(super.listData).icon );
						//trace("disclosure icon = " + TreeListData(super.listData).disclosureIcon);

						//-makeLastChildArr calls grandparentnode in order to determinewhether if the parent's node iis the last child. error if no grandparent exists
						if (depth > 2)
						{
							makeLastChildArr(node,depth,depth);
							if (depth > 3)
								makeLastChildArr(node,3,depth);

							this.lineArr = this.lineArr.reverse();

							for(i = 1;i<=depth;i++)
							{
								parentDropLine = false;

								TreeListData(super.listData);

								if(i == depth ){
									drawChildFolderLines(indent);
								}
								else
								{ // Preceding lines
									if (i != 1 )
									{ // don't draw first line
										// pull out from correct index of lineArray
										isLast = this.lineArr[i-2];
										
										// draw line if corresponding parent is not lastchild
										if (!isLast){
											drawParentLines(i);
										}
									}
								}
							}
						}
						else if ( depth == 2)
						{
  						graphics.lineStyle(this.lineThickness, this.lineColor,this.lineAlpha,false,"NONE");
							var offset:Number = 23;
							graphics.moveTo(offset,-14);
							graphics.lineTo(offset,6);
						}
					}
					else
					{
						//-if this directory has children, then display disclosure icon
						if (directory.@subdirectories > 0)
						{
						  this.disclosureIcon.visible = true;
						}
						
						makeLastChildArr(node,3,depth);
						this.lineArr = this.lineArr.reverse();
						
						for(i = 1; i <= depth; i++)
						{
							parentDropLine = false;

							if(i == depth )
							{
								drawChildLeafLines(indent);
							}
							else
							{ // Preceding lines
								if (i != 1 )
								{ // don't draw first line
									// pull out from correct index of lineArray
									isLast = this.lineArr[i-2];
									// draw line if corresponding parent is not lastchild
									if (!isLast)
									{
										drawParentLines(i);
									}
								}
							}
						}
					}
				}
			}
		} //-end updatedisplayfunction
	} //-end class
}