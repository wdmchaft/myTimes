//
//  PauseEditViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PauseEditViewController.h"
#import "TaskTrackerAppDelegate.h"


@implementation PauseEditViewController

@synthesize pauseTableView;
@synthesize workUnit;
@synthesize picker;
@synthesize parent;

-(void) save:(id)sender {
	//Save changes to workUnit instance
	[tvctl saveChanges];
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
	
	UITableView* tv = self.pauseTableView;
	tv.bounces = FALSE;
	tvctl = [[PauseEditTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	tvctl.workUnit = self.workUnit;
	tvctl.tableView = tv;
	
	tv.delegate = tvctl;
	tv.dataSource = tvctl;

	picker.delegate = tvctl;
	picker.dataSource = tvctl;	
	tvctl.picker = self.picker;	
		
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
	[pauseTableView release];
	[workUnit release];
	[tvctl release];
    [super dealloc];
}


@end
