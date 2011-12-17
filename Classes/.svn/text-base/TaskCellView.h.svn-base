//
//  TaskCellView.h
//  TaskTracker
//
//  Created by Michael Anteboth on 12.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectTask.h"
#import "TableRowSelectionDelegate.h"
#import "AbstractTableCellView.h"
#import "TaskTrackerAppDelegate.h"

@interface TaskCellView : AbstractTableCellView {
	ProjectTask* task;
	NSString* taskSummaryFormatString;
	UIButton* startStopButton;
	UIActivityIndicatorView* actIndicator;
	TaskTrackerAppDelegate* appDelegate;
}

@property (retain) 	UIButton* startStopButton;
@property (retain) ProjectTask* task;
@property (retain) 	UIActivityIndicatorView* actIndicator;

-(BOOL) hasRunningWorkUnits;

@end
