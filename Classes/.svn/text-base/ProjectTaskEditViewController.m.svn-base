//
//  PauseEditViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProjectTaskEditViewController.h"
#import "TaskTrackerAppDelegate.h"
#import "Project.h"
#import "ProjectTask.h"

@implementation ProjectTaskEditViewController

@synthesize projectTaskTableView;
@synthesize workUnit;
@synthesize picker;
@synthesize parent;
@synthesize project;
@synthesize task;



#pragma mark EditViewController methods

-(void) save:(id)sender {
	//Save changes to workUnit instance
	[tvctl saveChanges];
	
	//show error message and break if task and/or project is nil
	if (tvctl.project == nil || tvctl.task == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error.title", @"") 
														message:NSLocalizedString(@"error.msg.projectAndSubprojectAreNessecary", @"")
													   delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"error.close.button.text", @"") 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	parent.parentProject = [tvctl.project retain];
	
	if (parent.parentTask != tvctl.task) {
		parent.parentTask = [tvctl.task retain];
		parent.taskChanged = TRUE;
	}
	
	//refresh parent view
	[parent updateDataFields];	
	//mark the workUnit entry as changed in the parent controller
	parent.dirty = TRUE;
	//close view
	[self dismissModalViewControllerAnimated:YES];
}

-(void) cancel:(id)sender {
	//close view
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
	
	UITableView* tv = self.projectTaskTableView;
	tv.bounces = FALSE;
	tvctl = [[ProjectTaskEditTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	tvctl.workUnit = self.workUnit;
	if (self.project != nil)
		tvctl.project = self.project;
	if (self.task != nil)
		tvctl.task  =self.task;
	tvctl.tableView = tv;
	
	picker.delegate = tvctl;
	picker.dataSource = tvctl;	
	tvctl.picker = self.picker;	
	
	tv.delegate = tvctl;
	tv.dataSource = tvctl;	
	
	[self.view addSubview:tv];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];	
	//refresh view
	[tvctl refresh];
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
	[parent release];
	[picker release];
	[projectTaskTableView release];
	[workUnit release];
	[tvctl release];
	[project release];
	[task release];
    [super dealloc];
}


@end
