//
//  DatePickerViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 14.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"


@implementation DatePickerViewController

@synthesize datePicker;
@synthesize masterController;
@synthesize saveButton;

-(void) setDate:(NSDate*)date{
	[datePicker setDate:date animated:NO];
}


-(NSDate*) getDate {
	return datePicker.date;
}

-(void) cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


-(void) save:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
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


- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.rightBarButtonItem = self.saveButton;
}


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
	[saveButton release];
    [super dealloc];
}


@end
