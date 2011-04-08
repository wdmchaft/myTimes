//
//  TaskEditViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 11.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectTask.h"
#import "TaskTrackerAppDelegate.h"


@interface TaskEditViewController : UIViewController {
	ProjectTask* task;
	IBOutlet UITextField *txtName;
	UITableView* parentTable;
	BOOL editMode;
}

@property BOOL editMode;
@property (retain) UITableView* parentTable;
@property (retain) ProjectTask* task;
@property (retain) IBOutlet UITextField *txtName;

- (IBAction) saveTask:(id)sender;
- (IBAction) cancelEditing:(id)sender;

@end
