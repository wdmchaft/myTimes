//
//  PauseEditViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectTaskEditTableViewController.h"
#import "TimeWorkUnit.h"
#import "WorkUnitDetailsTableViewController.h"
#import "ProjectTask.h"
#import "Project.h"

@interface ProjectTaskEditViewController : UIViewController  {
	IBOutlet UITableView* projectTaskTableView;
	IBOutlet UIPickerView* picker;
	TimeWorkUnit* workUnit;
	ProjectTaskEditTableViewController* tvctl;
	WorkUnitDetailsTableViewController* parent;
	Project* project;
	ProjectTask* task;
}

@property (retain) WorkUnitDetailsTableViewController* parent;
@property (retain) IBOutlet UIPickerView* picker;
@property (retain) IBOutlet UITableView* projectTaskTableView;
@property (retain) TimeWorkUnit* workUnit;
@property (retain) Project* project;
@property (retain) ProjectTask* task;

-(void) save:(id)sender;
-(void) cancel:(id)sender;

@end
