//
//  TaskNameEditController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 14.05.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BooleanEditController.h"


@implementation BooleanEditController

@synthesize delegate;
@synthesize value;
@synthesize labelTxt;


-(void) save:(id)sender {
	//set new value 
	[self.delegate takeNewBool:valueSwitch.on];

	//close view
	[self dismissModalViewControllerAnimated:YES];
}


-(void) cancel:(id)sender {
	//close the view
	[self dismissModalViewControllerAnimated:YES];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	//display the selection state
	valueSwitch.on = value;

	//and set the label text
	valueLabel.text = self.labelTxt;
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
	[labelTxt release];
    [super dealloc];
}


@end

