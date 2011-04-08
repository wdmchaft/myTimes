//
//  TimerPickerViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 15.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditController.h"

@interface TimerPickerViewController : UIViewController {
	IBOutlet UIDatePicker* datePicker;
	id<EditController> masterController;
}

@property (retain) id masterController;
@property (retain) IBOutlet UIDatePicker* datePicker;

-(void) setDuration:(NSTimeInterval)duration;
-(NSTimeInterval) getDuration;	
-(void) save:(id)sender;
-(void) cancel:(id)sender;

@end
