//
//  DatePickerViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 14.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditController.h"

@interface DatePickerViewController : UIViewController {
	IBOutlet UIDatePicker* datePicker;
	IBOutlet UIBarButtonItem* saveButton;
	id<EditController> masterController;
}

@property (retain) IBOutlet UIBarButtonItem* saveButton;
@property (retain) id masterController;
@property (retain) IBOutlet UIDatePicker* datePicker;

-(void) setDate:(NSDate*)date;
-(NSDate*) getDate;
-(void) save:(id)sender;
-(void) cancel:(id)sender;

@end