//
//  TextEditViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 18.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextEditViewController.h"


@implementation TextEditViewController

@synthesize textView;
@synthesize parent;
@synthesize workUnit;



-(void) save:(id)sender {
	//ommit entered text
	workUnit.description = self.textView.text;
	if (parent != nil) {
		//refresh parent view
		[parent updateDataFields];	
		//mark the workUnit entry as changed in the parent controller
		parent.dirty = TRUE;
	}
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
	[textView becomeFirstResponder];
	//show the workunits text
	textView.text = workUnit.description;
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
	[workUnit release];
	[parent release];
	[textView release];
    [super dealloc];
}


@end
