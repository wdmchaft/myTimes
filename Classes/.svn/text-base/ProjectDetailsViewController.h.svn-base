//
//  ProjectDetailsViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 10.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "ProjectTask.h"
#import "TaskEditViewController.h"
#import "IAddItem.h"
#import "TableRowSelectionDelegate.h"
 
@interface ProjectDetailsViewController : UITableViewController <IAddItem, TableRowSelectionDelegate> {
	Project* project;
	UIBarButtonItem* addButtonItem;
	int selectedRow;
}

@property int selectedRow;
@property (retain) UIBarButtonItem* addButtonItem;
@property (retain) Project* project;

- (void) addItem;
- (void) editSelectedItem;
- (void) editTask:(ProjectTask*)pt editMode:(BOOL)editMode;
-(BOOL) isRowSelected:(int)row;
-(void) release;
@end
