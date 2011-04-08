//
//  PauseEditViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PauseEditTableViewController.h"
#import "TimeWorkUnit.h"
#import "WorkUnitDetailsTableViewController.h"

@interface PauseEditViewController : UIViewController {
	IBOutlet UITableView* pauseTableView;
	IBOutlet UIPickerView* picker;
	TimeWorkUnit* workUnit;
	PauseEditTableViewController* tvctl;
	WorkUnitDetailsTableViewController* parent;
}

@property (retain) WorkUnitDetailsTableViewController* parent;
@property (retain) 	IBOutlet UIPickerView* picker;
@property (retain) 	IBOutlet UITableView* pauseTableView;
@property (retain) TimeWorkUnit* workUnit;

-(void) save:(id)sender;
-(void) cancel:(id)sender;

@end
