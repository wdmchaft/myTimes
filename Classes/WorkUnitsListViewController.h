//
//  WorkUnitsListViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 11.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "ProjectTask.h"
#import "IAddItem.h"
#import "TimeWorkUnit.h"
#import "TableRowSelectionDelegate.h"
#import "TimeUtils.h"

@interface WorkUnitsListViewController : UITableViewController <IAddItem, TableRowSelectionDelegate> {
	ProjectTask* task;
	Project* parentProject;	
	UIBarButtonItem* addButtonItem;
	NSDateFormatter *dateFormatter;
	UITableView* parentTable;
	NSString* workUnitListCellFormatString;
	int selectedRow;
	NSArray* data;
	NSArray* sectionKeys;
	NSArray* sectionTitles;
	NSMutableDictionary* dict;
	NSCalendar *gregorian;
}

@property (retain) NSDateFormatter *dateFormatter;
@property (retain) ProjectTask* task;
@property (retain) Project* parentProject;	
@property (retain) UIBarButtonItem* addButtonItem;
@property (retain) UITableView* parentTable;
@property (retain) NSArray* data;
@property (retain) NSArray* sectionKeys;
@property (retain) NSArray* sectionTitles;
@property (retain) NSMutableDictionary* dict;

- (void) editWorkUnit:(TimeWorkUnit*)wu isNewItem:(BOOL)isNewItem;
- (void) addItem;
- (void) editSelectedItem;
-(NSArray*) getSectionIndexTitles;
- (BOOL) isRowSelected:(int)row;
- (void) reload;
- (void) release;

@end
