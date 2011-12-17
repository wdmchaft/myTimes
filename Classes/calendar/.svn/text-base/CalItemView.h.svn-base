//
//  CalItemView.h
//  Calendar
//
//  Created by Michael Anteboth on 20.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalEventDescriptor.h"


@interface CalItemView : UIView {
	NSMutableArray* calItemDescriptors;
	CGPoint touchPoint1;
	CGPoint touchPoint2;
	CalEventDescriptor* selectedItem;
	UIImage* calItemImage;
}

@property (retain) UIImage* calItemImage;
@property (retain)	NSMutableArray* calItemDescriptors;

-(void) selectCalItem:(CGPoint)point;


- (void)drawRoundRect:(CGRect)rect 
				 text:(NSString*)text 
		  description:(NSString*)description
			rectColor:(UIColor*)rectColor
		  strokeColor:(UIColor*)strokeColor 
		  strokeWidth:(int)strokeWidth 
		 cornerRadius:(float)cornerRadius
		   isSelected:(BOOL)selected;

@end
