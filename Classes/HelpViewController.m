//
//  HelpViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 24.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"


@implementation HelpViewController

@synthesize webView;


/**
 * Closes the Help View
 */
-(void) closeView:(id)sender {
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
	
	/* load html from file and display it in the webView */
	
	//get the help file name (localized version)
	NSString* helpFileName = NSLocalizedString(@"help.file.name", @"");
	//we need to get the corrent base url for linked images and css, so simply abuse the bundle
	NSBundle *bundle = [NSBundle mainBundle]; 
	NSString *path = [bundle bundlePath];
	//finanlly the base complete url object
	NSURL* baseUrl = [NSURL fileURLWithPath:path isDirectory:true];
	
	//create complete file path to html file
	NSString *filePath = [[NSBundle mainBundle] pathForResource:helpFileName ofType:@"html"];  
	//and load the content from the file
	NSData *htmlData = [NSData dataWithContentsOfFile:filePath];  
	
	if (htmlData) {  
		//now just display the htmldata and obtain the baseurl
		[webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseUrl];  
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
	[webView release];
    [super dealloc];
}


@end
