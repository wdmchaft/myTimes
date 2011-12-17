//
//  ImportUrlViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 24.06.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImportUrlViewController.h"
#import "TaskTrackerAppDelegate.h"


@implementation ImportUrlViewController


- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:TRUE];
}

//import project data from URL and just remove the old projects
- (IBAction)importAndRemoveProjects:(id)sender {
	//get URL
	NSString* sUrl = urlTextField.text;
	//start the import
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate importFromUrl:sUrl addAsNewProjects:FALSE];
	//close view
	[self.parentViewController dismissModalViewControllerAnimated:TRUE];
}


//import project data from URL and just add the new projects
- (IBAction)importAndAddProjects:(id)sender {
	//get the URL
	NSString* sUrl = urlTextField.text;
	//Start the import
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];	
	[appDelegate importFromUrl:sUrl addAsNewProjects:TRUE];
	//close view
	[self.parentViewController dismissModalViewControllerAnimated:TRUE];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:TRUE];
	//set label and button texts
	urlLabel.text = NSLocalizedString(@"xml.import.importSourceDialogTitle", @"");
	[btnImportAddProjects setTitle:NSLocalizedString(@"xml.import.importSourceDialog.import", @"") forState:UIControlStateNormal];
	[btnImportRemoveProjects setTitle:NSLocalizedString(@"xml.import.importSourceDialog.import2", @"") forState:UIControlStateNormal];		
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//set default url
	NSString* sUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"defaultImportUrl"];
	if (sUrl != nil) {
		urlTextField.text = sUrl;
	}

	//popup keyboard
	[urlTextField becomeFirstResponder];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
