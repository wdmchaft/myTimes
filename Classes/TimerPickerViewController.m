//
//  TimerPickerViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 15.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimerPickerViewController.h"


@implementation TimerPickerViewController

@synthesize datePicker;
@synthesize masterController;

-(void) setDuration:(NSTimeInterval)duration{
	datePicker.countDownDuration = duration;
}

-(NSTimeInterval) getDuration {
	return datePicker.countDownDuration;
}

-(void) cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}


-(void) save:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
	[masterController editingFinished];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[datePicker release];
	[(NSObject*) masterController release];
    [super dealloc];
}


@end
