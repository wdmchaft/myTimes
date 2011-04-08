//
//  ExportSettingsViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 21.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditController.h"
#import "DatePickerViewController.h"

@interface ExportSettingsViewController : UITableViewController <EditController, UIAlertViewDelegate> {
	BOOL xmlEnabled;
	BOOL csvEnabled;
	NSDate* startDate;
	NSDate* endDate;
	DatePickerViewController* dateCtl;
	id editingCtl;
	BOOL editStartDate;
	BOOL editProjects;
	NSMutableArray* projectsToExport;
}

@property BOOL xmlEnabled;
@property BOOL csvEnabled;
@property (retain) NSDate* startDate;
@property (retain) NSDate* endDate;
@property (retain) NSMutableArray* projectsToExport;

-(void) onXMLSwitchToggled:(id)sender;
-(void) onCSVSwitchToggled:(id)sender;
-(void) editingFinished;
-(void) cancel:(id)sender;
-(void) proceed:(id)sender;
-(void) showErrorMessage:(NSString*)msg;

@end
