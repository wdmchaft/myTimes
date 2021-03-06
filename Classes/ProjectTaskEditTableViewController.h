//
//  BeginEndEditTableViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeWorkUnit.h"
#import "Project.h"
#import "ProjectTask.h"

@interface ProjectTaskEditTableViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate> {
	IBOutlet UIView* projectCellView;
	IBOutlet UIView* taskCellView;	
	IBOutlet UILabel* lblProject;
	IBOutlet UILabel* lblTask;	
	UIPickerView* picker;
	TimeWorkUnit* workUnit;
	Project* project;
	ProjectTask* task;
	int pause;
	NSArray* projects;
}

@property (retain) UIPickerView* picker;
@property (retain) TimeWorkUnit* workUnit;
@property (retain)  Project* project;
@property (retain) ProjectTask* task;

@property (retain) IBOutlet IBOutlet UIView* projectCellView;
@property (retain) IBOutlet IBOutlet UIView* taskCellView;	
@property (retain) IBOutlet IBOutlet UILabel* lblProject;
@property (retain) IBOutlet IBOutlet UILabel* lblTask;

-(void) refresh;
-(void) refreshLabels;
-(void) saveChanges;

@end
