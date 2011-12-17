//
//  AbstractTableCellView.h
//  TaskTracker
//
//  Created by Michael Anteboth on 29.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableRowSelectionDelegate.h"

@interface AbstractTableCellView : UIView {
	BOOL highlighted;
	BOOL editing;

	id<TableRowSelectionDelegate> ctl;
	int row;
	UIColor* checkMarkClr;
	int maxTxtWidth;
}
	
@property int row;
@property (retain) id<TableRowSelectionDelegate> ctl;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isEditing) BOOL editing;
	
- (void)drawCheckmark;
- (void)setEditing:(BOOL)editing;
	
-(NSString*) getSecondText;
-(NSString*) getMainText;
//returns the maximum text length, should be overridden in sub classes
-(int) getMaxTextWidth;

@end
	
