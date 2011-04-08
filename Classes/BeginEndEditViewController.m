//
//  BeginEndEditViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BeginEndEditViewController.h"
#import "BeginEndEditTableViewController.h"
#import "TaskTrackerAppDelegate.h"

@implementation BeginEndEditViewController

@synthesize beginEndTableView;
@synthesize workUnit;
@synthesize datePicker;
@synthesize parent;
@synthesize editStartTime;

-(void) save:(id)sender {
	//Save changes to vo
	BOOL success = [tvctl saveChanges];
	if (success) {
		//mark the workUnit entry as changed in the parent controller
		parent.dirty = TRUE;
		//refresh parent view
		[parent updateDataFields];	
		//close view
		[self dismissModalViewControllerAnimated:YES];
	}
}

-(void) cancel:(id)sender {
	//close view
	[self dismissModalViewControllerAnimated:YES];
}

-(void) datePickerValueChanged:(id)sender {
	[tvctl datePickerValueChanged:sender];
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
	
	UITableView* tv = self.beginEndTableView;
	tv.bounces = FALSE;
	tvctl = [[BeginEndEditTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	tvctl.workUnit = self.workUnit;
	tvctl.tableView = tv;
	tvctl.datePicker = self.datePicker;
	
	tv.delegate = tvctl;
	tv.dataSource = tvctl;
	
	//set minutes interval
	TaskTrackerAppDelegate*	appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.datePicker.minuteInterval = appDelegate.minuteInterval;

	[self.view addSubview:tv];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];	

	//refresh view
	[tvctl refresh];
	
	//preselect the start or the end time cell
	int row = self.editStartTime ? 0 : 1;
	NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:0];	
	[self.beginEndTableView selectRowAtIndexPath:path animated:TRUE scrollPosition:FALSE];
	[tvctl didSelectRowAtIndexPath:path];
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
	[datePicker release];
	[beginEndTableView release];
	[workUnit release];
	[tvctl release];
    [super dealloc];
}


@end
