//
//  AbstractTableCellView.m
//  TaskTracker
//
//  Created by Michael Anteboth on 29.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractTableCellView.h"


@implementation AbstractTableCellView

@synthesize highlighted;
@synthesize editing;
@synthesize ctl;
@synthesize row;

#define LEFT_COLUMN_OFFSET 20
#define LEFT_COLUMN_WIDTH 130

#define MIDDLE_COLUMN_OFFSET 140
#define MIDDLE_COLUMN_WIDTH 110

#define RIGHT_COLUMN_OFFSET 270

#define UPPER_ROW_TOP 8
#define LOWER_ROW_TOP 34

#define MAIN_FONT_SIZE 18
#define MIN_MAIN_FONT_SIZE 12
#define SECONDARY_FONT_SIZE 12
#define MIN_SECONDARY_FONT_SIZE 10

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		maxTxtWidth = [self getMaxTextWidth];
    }
    return self;
}

//called whe the table is switching edit mode and back, implement in sub classes
- (void)setEditing:(BOOL)editing {
}

-(int) getMaxTextWidth {
	return LEFT_COLUMN_WIDTH+MIDDLE_COLUMN_WIDTH - 70;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	
	// Color and font for the main text items (time zone name, time)
	UIColor *mainTextColor = nil;
	UIFont *mainFont = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
	
	// Color and font for the secondary text items (GMT offset, day)
	UIColor *secondaryTextColor = nil;
	UIFont *secondaryFont = [UIFont systemFontOfSize:SECONDARY_FONT_SIZE];
	
	// Choose font color based on highlighted state.
	if (self.highlighted) {
		mainTextColor = [UIColor whiteColor];
		secondaryTextColor = [UIColor whiteColor];
	}
	else {
		mainTextColor = [UIColor blackColor];
		secondaryTextColor = [UIColor darkGrayColor];
		self.backgroundColor = [UIColor whiteColor];
	}
	
	CGRect contentRect = self.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern.
//    if (!self.editing) {
		
		CGFloat boundsX = contentRect.origin.x;
		CGPoint point;
		
		// Set the color for the main text items
		[mainTextColor set];
		
		
		/*
		 Draw the task name top left; use the NSString UIKit method to scale the font size down if the text does not fit in the given area
		 */
		NSString* txt = [self getMainText];
		point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP);
		[txt drawAtPoint:point forWidth:maxTxtWidth withFont:mainFont minFontSize:MIN_MAIN_FONT_SIZE actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
		
		// Set the color for the secondary text items
		[secondaryTextColor set];
		
		/*
		 Draw the total task duration botton left; use the NSString UIKit method to scale the font size down if the text does not fit in the given area
		 */
		NSString* secondTxt = [self getSecondText];
		point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP);
		[secondTxt drawAtPoint:point forWidth:maxTxtWidth withFont:secondaryFont minFontSize:MIN_SECONDARY_FONT_SIZE actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
		
		//draw selection marker
		BOOL sel = [ctl isRowSelected:self.row];
		if (sel) {
			//checkMarkClr = [UIColor colorWithRed:152.0/255 green:162.0/255 blue:200.0/255 alpha:1.0];
			//[self makeCircleAt:CGPointMake(5,30) withDiameter:10.0 withColor:checkMarkClr];

			//   ist erstmal nicht mehr nötig
			//[self drawCheckmark];
		}
	//}
}

//returns the text of the first row
//Override in subclass
-(NSString*) getMainText {
	return @"MAIN";
}

//returns the text of the 2nd row
//Override in subclass
-(NSString*) getSecondText {
	return @"2nd row text";
}


- (void)drawCheckmark {

	UIImage *backgroundImage = [UIImage imageNamed:@"checkmark.jpg"];
	CGRect elementSymbolRectangle = CGRectMake(0.0, 25.0, 10.0, 10.0);
	[backgroundImage drawInRect:elementSymbolRectangle];
	
	/*	
	float radius = diameter * 0.5;
	CGRect myOval = {center.x - radius, center.y - radius, diameter, diameter};
	CGContextRef context = UIGraphicsGetCurrentContext();
	[myColor set];
	CGContextAddEllipseInRect(context, myOval);
	CGContextFillPath(context);
	 
	 */
}


- (void)setHighlighted:(BOOL)lit {
	// If highlighted state changes, need to redisplay.
	if (highlighted != lit) {
		highlighted = lit;	
		[self setNeedsDisplay];
	}
}


- (void)dealloc {
	[ctl release];
    [super dealloc];
}

@end
