//
//  WorkUnitCellView.h
//  TaskTracker
//
//  Created by Michael Anteboth on 29.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractTableCellView.h"
#import "WorkUnitCellView.h"
#import "TimeWorkUnit.h"
#import "TaskTrackerAppDelegate.h"

@interface WorkUnitCellView : AbstractTableCellView {
	TimeWorkUnit* workUnit;
	TaskTrackerAppDelegate* appDelegate;
	NSString* workUnitListCellFormatString;
	NSDateFormatter* dateFormatter;
	NSDateFormatter* timeFormatter;
	UIButton* startStopButton;
	UIActivityIndicatorView* actIndicator;
}

@property (retain) TimeWorkUnit* workUnit;
@property (retain) UIButton* startStopButton;
@property (retain) 	UIActivityIndicatorView* actIndicator;

-(void) updateButtonState;

@end
