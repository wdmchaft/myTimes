//
//  AppInfoViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 18.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppInfoViewController.h"

@implementation AppInfoViewController

@synthesize textView;
@synthesize backButton;
@synthesize urlButton;
@synthesize mailButton;
@synthesize urlLinkLabel;

//close the info view
-(void) closeView:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

//Open the application info url in safari
-(void) openUrl:(id)sender {
	NSURL* url = [NSURL URLWithString:NSLocalizedString(@"applicationHomepageURL", @"")];
	UIApplication* app = [UIApplication sharedApplication];
	[app openURL:url];  
}

//Open a new mail to write comments about the app to the author
-(void) openMail:(id)sender {
	NSString* receiver = NSLocalizedString(@"application.email", @"");
	NSString* body = NSLocalizedString(@"applicationInfoEmail.body", @"");
	NSString* subject = NSLocalizedString(@"applicationInfoEmail.subject", @"");

	
	// device specific code
	NSString *encodedBody = [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
	subject = [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *urlString = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@", receiver, subject, encodedBody];
	NSLog(@"sending mail: %@", urlString);
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[[UIApplication sharedApplication] openURL:url];
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
	
	//read version number from Info.plist file
	NSBundle * bundle = [NSBundle mainBundle];
	NSString *filePath = [bundle pathForResource:@"Info" ofType:@"plist"]; 
	NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath]; 
	NSString* version = [plistDict objectForKey:@"CFBundleVersion"];
	
	//load and display I18N values
	NSString* info = NSLocalizedString(@"versionInfoKey", @"");
	
	//replace placeholder with version number and set text
	textView.text = [NSString stringWithFormat:info, version];

	//Close Button text
	NSString* backBtnTxt = NSLocalizedString(@"backButtonLabelKey", @"");
	[self setButtonText:backButton text:backBtnTxt];
	
	
	//URL Link of the app homepage
	NSString* appHomeUrlLabel = NSLocalizedString(@"applicationHomepageURLLabel", @"");
	urlLinkLabel.text = appHomeUrlLabel;
	
	NSString* appHomeUrl = NSLocalizedString(@"applicationHomepageURL", @"");
    [self setButtonText:urlButton text:appHomeUrl];
	
	//eMail Link
	NSString* mailAdr = NSLocalizedString(@"application.email", @"");
    [self setButtonText:mailButton text:[NSString stringWithFormat:@"mailto:%@", mailAdr]];
	
	[super viewDidLoad];
}

//sets the text of a UIButton
-(void) setButtonText:(UIButton*)button text:(NSString*)text {
	[button setTitle:text forState:UIControlStateNormal];
	[button setTitle:text forState:UIControlStateSelected];
	[button setTitle:text forState:UIControlStateDisabled];
	[button setTitle:text forState:UIControlStateHighlighted];
	[button setTitle:text forState:UIControlStateApplication];
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
	[textView release];
	[backButton release];
	[urlButton release];
	[urlLinkLabel release];
    [super dealloc];
}


@end
