//
//  ProjectEditViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 11.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "TaskTrackerAppDelegate.h"


@interface ProjectEditViewController : UIViewController {
	Project* project;
	IBOutlet UITextField *txtName;
	BOOL isInEditMode;
}

@property BOOL isInEditMode;
@property (retain) Project* project;
@property (retain) IBOutlet UITextField *txtName;

- (IBAction) saveProject:(id)sender;
- (IBAction) cancelEditing:(id)sender;


@end
