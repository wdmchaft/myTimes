//
//  TimeEntryViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 15.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimeEntryViewController.h"
#import "TimeWorkUnit.h"
#import "TaskTrackerAppDelegate.h"
#import "Project.h"
#import "ProjectTask.h"
#import "TimeUtils.h"
#import "LedTextView.h"

@implementation TimeEntryViewController

@synthesize imageViewLed;
@synthesize btnPlay;
@synthesize btnPause;
@synthesize lblProject;
@synthesize lblSubproject;
@synthesize workUnit;
@synthesize ledViewDate;
@synthesize ledViewTime;

-(void) playBtnPressed:(id)sender {
	NSLog(@"play pressed");
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	//create new workUnit if there is no running one
	if (self.workUnit == nil) {
		//TODO richtiges Projekt und Subprojekt auswählen
		project = [appDelegate.data objectAtIndex:0];
		task = [project.tasks objectAtIndex:0];

		self.workUnit = [[TimeWorkUnit alloc] init];
		[self.workUnit startTimeTracking];
		[task.workUnits addObject:self.workUnit];
	} else {
		if (self.workUnit.running) {
			[self.workUnit stopTimeTracking];
		} else {
			[self.workUnit startTimeTracking];			
		}
	}
	
	[self playBtnPressedSound];
	
	[self updateLabels];
	[self updateButtons];
}

-(void) playBtnPressedSound {
	CFURLRef        soundFileURLRef;
    SystemSoundID    soundFileObject;
	
	// Get the main bundle for the app	
    CFBundleRef mainBundle = CFBundleGetMainBundle ();
	
	 // Get the URL to the sound file to play. The file in this case is "tap.aiff"	
    soundFileURLRef  =    CFBundleCopyResourceURL (mainBundle, CFSTR ("tap"),  CFSTR ("aif"), NULL);
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (soundFileURLRef, &soundFileObject);
	AudioServicesPlaySystemSound (soundFileObject);
}

-(void) pauseBtnPressed:(id)sender {
	NSLog(@"pause pressed");
}

-(void) updateLabels {
	if (project != nil) {
		self.lblProject.text = project.name;
	} else {
		self.lblProject.text = @"";
	}
	
	if (task != nil) {
		self.lblSubproject.text = task.name;
	} else {
		self.lblSubproject.text = @"";
	}
	
	//update date & time views
	if (self.workUnit != nil && self.workUnit.running) {
		//set date text
		ledViewDate.text = [TimeUtils formatDate:self.workUnit.date withFormatType:2];
		
		//create and set time text
		NSString* start = [TimeUtils formatTime:self.workUnit.date withFormatType:2];
		NSString* end = self.workUnit.running ? 
			[TimeUtils formatTime:[NSDate date] withFormatType:2] :
			[TimeUtils formatTime:self.workUnit.date withFormatType:2];
		NSString* pause = [TimeUtils formatSeconds:[self.workUnit.pause intValue]];
		NSString* duration = [TimeUtils formatSeconds:[self.workUnit.duration intValue]];

		ledViewTime.text = [NSString stringWithFormat:@"%@-%@(%@)  %@", start, end, pause, duration];
	} else {
		ledViewDate.text = @"";
		ledViewTime.text = @"";
	}
	//force frpaint of views
	[ledViewDate setNeedsDisplay];
	[ledViewTime setNeedsDisplay];	
}

-(void) updateButtons {
	if (self.workUnit != nil) {
		UIImage* imgBtnPlay;
//		UIImage* imgBtnPause;		
		if (self.workUnit.running) {
			imgBtnPlay = [UIImage imageNamed:@"button-stop-enabled.png"];
			[btnPlay setImage:imgBtnPlay forState:UIControlStateNormal];			
			[btnPlay setImage:[UIImage imageNamed:@"button-stop_pressed.png"] forState:UIControlStateSelected];
			[btnPlay setImage:[UIImage imageNamed:@"button-stop_pressed.png"] forState:UIControlStateHighlighted];		
			
			UIImage* ledOff = [UIImage imageNamed:@"led_off.png"];
			UIImage* ledOn = [UIImage imageNamed:@"led_on.png"];
			
			self.imageViewLed.animationImages = [[NSArray alloc] initWithObjects:ledOff, ledOn,ledOn,ledOn,ledOn, nil];
			[self.imageViewLed startAnimating];
			
		} else {
			UIImage* ledOff = [UIImage imageNamed:@"led_off.png"];
			[self.imageViewLed stopAnimating];
			[self.imageViewLed setImage:ledOff];
						
			imgBtnPlay = [UIImage imageNamed:@"button-play-enabled.png"];
			[btnPlay setImage:imgBtnPlay forState:UIControlStateNormal];
			[btnPlay setImage:[UIImage imageNamed:@"button-play-pressed.png"] forState:UIControlStateSelected];
			[btnPlay setImage:[UIImage imageNamed:@"button-play-pressed.png"] forState:UIControlStateHighlighted];						
		}
	}
	
}



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.navigationController.navigationBarHidden = YES;
	[super loadView];
	
	//create color RGB(153,198,255)
	UIColor* clr = [UIColor colorWithRed:0.6 green:0.77 blue:1.0 alpha:1.0];

	//Add LED Day View
	CGRect rect = CGRectMake(40, 30, 210, 40);	
	self.ledViewDate = [[LedTextView alloc] initWithFrame:rect];
	ledViewDate.text = @"day";
	ledViewDate.fontSize = 22;
	ledViewDate.textColor = clr;
	[self.view addSubview:ledViewDate];
	
	//Add LED Time View
	CGRect rect2 = CGRectMake(40, 40, 220, 60);
	self.ledViewTime = [[LedTextView alloc] initWithFrame:rect2];
	ledViewTime.text = @"time";
	ledViewTime.fontSize = 20;
	ledViewTime.textColor = clr;
	[self.view addSubview:ledViewTime];
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self updateLabels];
}

-(void) hideView:(id)sender {
	[self.navigationController popViewControllerAnimated:TRUE];
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
	[imageViewLed release];
	[btnPlay release];
	[btnPause release];
	[lblProject release];
	[lblSubproject release];
	[workUnit release];
	[ledViewDate release];
	[ledViewTime release];	
    [super dealloc];
}


@end
