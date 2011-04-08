//
//  BeginEndEditTableViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeWorkUnit.h"

@interface BeginEndEditTableViewController : UITableViewController {
	IBOutlet UIView* beginCellView;
	IBOutlet UIView* endCellView;	
	IBOutlet UILabel* lblBegin;
	IBOutlet UILabel* lblEnd;
	UIDatePicker* datePicker;
	TimeWorkUnit* workUnit;
	NSDate* startDate;
	NSDate* endDate;
}

@property (retain) UIDatePicker* datePicker;
@property (retain) TimeWorkUnit* workUnit;
@property (retain) IBOutlet UILabel* lblBegin;
@property (retain) IBOutlet UILabel* lblEnd;
@property (retain) IBOutlet UIView* beginCellView;
@property (retain) IBOutlet UIView* endCellView;	

-(void) refresh;
-(void) datePickerValueChanged:(id)sender;
-(void) refreshLabels;
-(BOOL) saveChanges;
-(void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
