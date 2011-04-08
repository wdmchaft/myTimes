//
//  BeginEndEditViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeWorkUnit.h"
#import "BeginEndEditTableViewController.h"
#import "WorkUnitDetailsTableViewController.h"

@interface BeginEndEditViewController : UIViewController {
	IBOutlet UITableView* beginEndTableView;
	IBOutlet UIDatePicker* datePicker;
	TimeWorkUnit* workUnit;
	BeginEndEditTableViewController* tvctl;
	WorkUnitDetailsTableViewController* parent;
	BOOL editStartTime;
}

@property (retain) WorkUnitDetailsTableViewController* parent;
@property (retain) 	IBOutlet UIDatePicker* datePicker;
@property (retain) 	IBOutlet UITableView* beginEndTableView;
@property (retain) TimeWorkUnit* workUnit;
@property BOOL editStartTime;

-(void) save:(id)sender;
-(void) cancel:(id)sender;
-(void) datePickerValueChanged:(id)sender;

@end
