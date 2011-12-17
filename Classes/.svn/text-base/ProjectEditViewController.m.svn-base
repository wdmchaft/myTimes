//
//  ProjectEditViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 11.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProjectEditViewController.h"


@implementation ProjectEditViewController

@synthesize project;
@synthesize txtName;
@synthesize isInEditMode;


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
	
	//show keypad	
	[txtName becomeFirstResponder];
	//Projektname im editor setzen
	if (isInEditMode) {
		txtName.text = project.name;	
	} else {	
		txtName.placeholder = @"<Name>";
	}
}

//Save project
- (IBAction) saveProject:(id)sender {
	NSLog(@"Save project");
	Project* p = self.project;
	//Daten speichern 
	p.name = [self.txtName text];

	TaskTrackerAppDelegate *appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (isInEditMode == FALSE) {
		//Wenn nicht im EditMode (dann im create mode) neues Projekt zur Projekt liste adden, nur dann
		[appDelegate addProject:p];
	}
	
	//und Edit View wieder verlassen
	[self dismissModalViewControllerAnimated:YES];
	
	[appDelegate saveData];
}

- (IBAction) cancelEditing:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
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
	[project release];
	[txtName release];
	[super dealloc];
}


@end
