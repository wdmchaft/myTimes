//
//  TaskEditViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 11.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TaskEditViewController.h"
#import "ProjectDetailsViewController.h"

@implementation TaskEditViewController

@synthesize editMode;
@synthesize parentTable;
@synthesize task;
@synthesize txtName;

//save a task
- (IBAction) saveTask:(id)sender {
	NSLog(@"Save task");
	ProjectTask* pt = self.task;
	 
	pt.name = [self.txtName text];
	
	TaskTrackerAppDelegate *appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	//add the Task to the project task list only if we are in creation mode
	if (editMode == FALSE) {
		[appDelegate addTask:pt];
	}
		
	//leave the EditView
	[self dismissModalViewControllerAnimated:YES];
	
	//refresh the parent table view (containing the task list)
	[self.parentTable reloadData];
	
	[appDelegate saveData];
}


- (IBAction) cancelEditing:(id)sender {
	//leave EditView
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
	
	//show the keypad
	[txtName becomeFirstResponder];
	
	//display the tasks name in editor
	if (editMode) {
		txtName.text = task.name;	
	} else {	
		txtName.placeholder = @"<Name>";
	}

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
	[task release];
	[txtName release];
    [super dealloc];
}


@end
