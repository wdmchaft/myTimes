//
//  ProjectSelectionTableViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 03.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskTrackerAppDelegate.h"
#import "EditController.h"

@interface ProjectSelectionTableViewController : UITableViewController {
	IBOutlet UIBarButtonItem* saveButton;
	TaskTrackerAppDelegate* appDelegate;
	NSMutableArray* projectsForExport;
	id<EditController> masterController;
}

@property (retain) IBOutlet UIBarButtonItem* saveButton;
@property (retain) id masterController;

@property (retain) NSMutableArray* projectsForExport;

-(void) save:(id)sender;
-(void) cancel:(id)sender;


@end
