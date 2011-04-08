//
//  TaskEditViewController2.h
//  TaskTracker
//
//  Created by Michael Anteboth on 14.05.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectTask.h"
#import "TextEditController.h"
#import "BooleanEditController.h"
#import "TaskTrackerAppDelegate.h"
#import "DataEntry.h"

@interface TaskEditViewController2 : UITableViewController<TextEditingControllerDelegate, BooleanEditingControllerDelegate> {
	ProjectTask* task;
	int textEditMode; //used to dertermin if the name or the desciption has been edited
	TaskTrackerAppDelegate* appDelegate;
	DataEntry* editingEntry;
}

@property (retain) ProjectTask* task;
@property (retain) DataEntry* editingEntry;


@end
