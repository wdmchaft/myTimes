//
//  BeginEndEditTableViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeWorkUnit.h"

@interface PauseEditTableViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate>  {
	IBOutlet UIView* pauseCellView;
	IBOutlet UILabel* lblPause;
	UIPickerView* picker;
	TimeWorkUnit* workUnit;
	int pause;
	NSMutableArray* hours;
	NSMutableArray* mins;
	int selRowHr;
	int selRowMin;
	int minuteInterval;
	NSString* hrsLbl;
	NSString* minsLbl;
}

@property (retain) NSMutableArray* hours;
@property (retain) NSMutableArray* mins;
@property (retain) UIPickerView* picker;
@property (retain) TimeWorkUnit* workUnit;
@property (retain) IBOutlet UILabel* lblPause;
@property (retain) IBOutlet UIView* pauseCellView;

-(void) refresh;
-(void) refreshLabels;
-(void) saveChanges;
-(void) displayPause:(int)p animated:(BOOL)animated;

@end
