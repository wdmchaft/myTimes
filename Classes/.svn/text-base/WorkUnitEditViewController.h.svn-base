//
//  WorkUnitEditViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 11.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "WorkUnit.h"
#import "ProjectTask.h"

@interface WorkUnitEditViewController : UIViewController {
	WorkUnit* workUnit;
	WorkUnit* wuCopy;
	ProjectTask* parentTask;
	UITableView* parentTable;
	IBOutlet UIButton* dateButton;
	IBOutlet UIButton* startButton;
	IBOutlet UIButton* endButton;
	IBOutlet UIButton* durationButton;
	IBOutlet UIButton* pauseButton;
	IBOutlet UITextView* txtDescription;
	BOOL workUnitAddMode;
	id currentEditor;
	int editor;
}

@property  BOOL workUnitAddMode;
@property (retain) ProjectTask* parentTask;
@property (retain) WorkUnit* workUnit;
@property (retain) UITableView* parentTable;

@property (retain) IBOutlet UIButton* dateButton;
@property (retain) IBOutlet UIButton* startButton;
@property (retain) IBOutlet UIButton* endButton;
@property (retain) IBOutlet UIButton* pauseButton;
@property (retain) IBOutlet UIButton* durationButton;
@property (retain) IBOutlet UITextView* txtDescription;


-(IBAction) saveWorkUnit:(id)sender;
-(IBAction) cancelEditing:(id)sender;

-(void) dateButtonPressed:(id) sender;
-(void) startButtonPressed:(id) sender;
-(void) endButtonPressed:(id) sender;
-(void) durationButtonPressed:(id) sender;
-(void) pauseButtonPressed:(id) sender;
-(void) descriptionButtonPressed:(id) sender;

-(void) updateDataFields;
-(void) setButtonText:(UIButton*)button text:(NSString*)text;

-(void) editingFinished;

//-(NSDate*) computeEndDate:(NSDate*)start duration:(NSNumber*) duration pause:(NSNumber*) pause;

@end
