//
//  TimeEntryViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 15.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#include <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import "TimeWorkUnit.h"
#import "Project.h"
#import "ProjectTask.h"
#import "LedTextView.h"
 
@interface TimeEntryViewController : UIViewController {
	
	IBOutlet UIButton* btnPlay;
	IBOutlet UIButton* btnPause;
	IBOutlet UIImageView* imageViewLed;	

	IBOutlet UILabel* lblProject;
	IBOutlet UILabel* lblSubproject;	
	TimeWorkUnit* workUnit;
	Project* project;
	ProjectTask* task;
	LedTextView* ledViewDate;
	LedTextView* ledViewTime;
}

-(void) playBtnPressed:(id)sender;
-(void) pauseBtnPressed:(id)sender;
-(void) hideView:(id)sender;

-(void) updateLabels;
-(void) updateButtons;

-(void) playBtnPressedSound ;

@property (retain) LedTextView* ledViewDate;
@property (retain) LedTextView* ledViewTime;

@property (retain) TimeWorkUnit* workUnit;

@property (retain) IBOutlet UIButton* btnPlay;
@property (retain) IBOutlet UIButton* btnPause;
@property (retain) IBOutlet UIImageView* imageViewLed;	

@property (retain) IBOutlet UILabel* lblProject;
@property (retain) IBOutlet UILabel* lblSubproject;

@end
