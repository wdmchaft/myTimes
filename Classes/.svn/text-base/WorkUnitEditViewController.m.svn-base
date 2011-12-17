//
//  WorkUnitEditViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 11.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WorkUnitEditViewController.h"
#import "DatePickerViewController.h"
#import "TimePickerViewController.h"
#import "TaskTrackerAppDelegate.h"
#import "TimerPickerViewController.h"
#import "TextEditViewController.h";


@implementation WorkUnitEditViewController

@synthesize workUnit;
@synthesize parentTask;
@synthesize parentTable;

@synthesize dateButton;
@synthesize startButton;
@synthesize endButton;
@synthesize pauseButton;
@synthesize durationButton;
@synthesize txtDescription;
@synthesize workUnitAddMode;

const int START_EDITOR = 0;
const int END_EDITOR = 1;
const int DUR_EDITOR = 2;
const int PAUSE_EDITOR = 3;
const int DESC_EDITOR = 4;

//save the work unit
- (IBAction) saveWorkUnit:(id)sender {

	//put values from working copy to real work unit element
	workUnit.date = wuCopy.date;
	workUnit.pause = wuCopy.pause;
	workUnit.description = wuCopy.description;
	workUnit.duration = wuCopy.duration;
	
	//add work unit to task we are in addMode
	if (workUnitAddMode) {
		[[self.parentTask workUnits] addObject:self.workUnit];
	}
	
	//reload parent table view
	[self.parentTable reloadData];
	
	//leave the vieew
	[self.navigationController popViewControllerAnimated:YES];
	
	//enabble the common add button in the lower left after leaving the edit view
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	//globale buttons de-/aktivieren
	[appDelegate.rootViewController enabledGlobalButtons:true sender:self];
	
}

//cancel editing and leave the modal view
- (IBAction) cancelEditing:(id)sender {
	//leave the view
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void) dateButtonPressed:(id) sender {
	//todo
	//popup date chooser dialog and let the user choose a date
	NSLog(@"show date picker");
	DatePickerViewController* ctl = [[DatePickerViewController alloc] initWithNibName:@"DatePickerView" bundle:nil];
	[self.navigationController presentModalViewController:ctl animated:TRUE];
	[ctl setDate:wuCopy.date];
	ctl.masterController = self;
	currentEditor = ctl;
	editor = START_EDITOR;
}

-(void) startButtonPressed:(id) sender {
	//todo
	//popup date chooser dialog and let the user choose a date
	NSLog(@"show time picker");
	TimePickerViewController* ctl = [[TimePickerViewController alloc] initWithNibName:@"TimePickerView" bundle:nil];
	[self.navigationController presentModalViewController:ctl animated:TRUE];
	[ctl setDate:wuCopy.date];
	ctl.masterController = self;
	currentEditor = ctl;
	editor = START_EDITOR;
}

-(void) endButtonPressed:(id) sender {
	//popup date chooser dialog and let the user choose a date
	TimePickerViewController* ctl = [[TimePickerViewController alloc] initWithNibName:@"TimePickerView" bundle:nil];
	[self.navigationController presentModalViewController:ctl animated:TRUE];
	
	NSTimeInterval dur = [wuCopy.duration intValue] + [wuCopy.pause intValue];
	NSDate* endDate = [[NSDate alloc] initWithTimeInterval:dur sinceDate:wuCopy.date];
	
	[ctl setDate:endDate];
	ctl.masterController = self;
	currentEditor = ctl;
	editor = END_EDITOR;
}

-(void) durationButtonPressed:(id) sender {
	//popup date chooser dialog and let the user choose a date
	TimerPickerViewController* ctl = [[TimerPickerViewController alloc] initWithNibName:@"TimerPickerView" bundle:nil];
	[self.navigationController presentModalViewController:ctl animated:TRUE];	
	[ctl setDuration:[wuCopy.duration intValue]];
	ctl.masterController = self;
	currentEditor = ctl;
	editor = DUR_EDITOR;
}

-(void) pauseButtonPressed:(id) sender {
	TimerPickerViewController* ctl = [[TimerPickerViewController alloc] initWithNibName:@"TimerPickerView" bundle:nil];
	[self.navigationController presentModalViewController:ctl animated:TRUE];
	[ctl setDuration:[wuCopy.pause intValue]];
	ctl.masterController = self;
	currentEditor = ctl;
	editor = PAUSE_EDITOR;
}

-(void) descriptionButtonPressed:(id) sender {
/*	TextEditViewController* ctl = [[TextEditViewController alloc] initWithNibName:@"TextEditView" bundle:nil];
	[self.navigationController presentModalViewController:ctl animated:TRUE];
	[ctl setText:wuCopy.description];
	ctl.masterController = self;
	currentEditor = ctl;
	editor = DESC_EDITOR;
 */
}


-(void) editingFinished {
	if (currentEditor != nil) {
		if (editor == START_EDITOR) {
			NSDate* date = [currentEditor getDate];
			wuCopy.date = date;
		} else if (editor == END_EDITOR) {
			NSDate* date = [currentEditor getDate];
			//calc the duration bestween start and the edited end time
			NSTimeInterval duration = [date timeIntervalSinceDate:wuCopy.date];
			//substract the pause time from the duration
			duration = duration - [wuCopy.pause intValue];
			wuCopy.duration = [NSNumber numberWithDouble:duration];
		} else if (editor == DUR_EDITOR) {
			NSTimeInterval dur = [currentEditor getDuration];
			wuCopy.duration = [NSNumber numberWithInt:dur];
		} else if (editor == PAUSE_EDITOR) {
			NSTimeInterval pause = [currentEditor getDuration];
			wuCopy.pause = [NSNumber numberWithInt:pause];
		} else if (editor == DESC_EDITOR) {
			wuCopy.description = [currentEditor getText];
		}	
		
		[self updateDataFields];
	}
	//wuCopy.date = date;
	//[self updateDataFields];
}

//sets the text of a UIButton
-(void) setButtonText:(UIButton*)button text:(NSString*)text {
	[button setTitle:text forState:UIControlStateNormal];
	[button setTitle:text forState:UIControlStateSelected];
	[button setTitle:text forState:UIControlStateDisabled];
	[button setTitle:text forState:UIControlStateHighlighted];
	[button setTitle:text forState:UIControlStateApplication];
}


//Update all button texts with current model values
-(void) updateDataFields {
	
	//init the dateformatter
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
//	dateFormatter = appDelegate.dateFormatter;
//	timeFormatter = appDelegate.timeFormatter;

	//update view data 	
	//Start date
	NSString *dateString = [appDelegate.dateFormatter stringFromDate:wuCopy.date];
	[self setButtonText:dateButton text:dateString];
	
	//Start time
	NSString *startString = [appDelegate.timeFormatter stringFromDate:wuCopy.date];
	[self setButtonText:startButton text:startString];
	
	//end time
	NSDate* end = [wuCopy getEndDate];
	NSString *endString = [appDelegate.timeFormatter stringFromDate:end];
	[self setButtonText:endButton text:endString];
	
	//duration
	NSString* durString = [appDelegate formatSeconds:[wuCopy.duration intValue]];
	[self setButtonText:durationButton text:durString];
	
	//Pause
	NSString* pauseString = [appDelegate formatSeconds:[wuCopy.pause intValue]];
	[self setButtonText:pauseButton text:pauseString];
	
	//description
	txtDescription.text = wuCopy.description;
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
	
	wuCopy = [workUnit copy];
	
	//create the save button
	UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
									target:self action:@selector(saveWorkUnit:)] autorelease];
	//and add it to the navigation bar
	self.navigationItem.rightBarButtonItem = saveButton;
	
	//show the data
	[self updateDataFields];
	
	//disable the common add button in the lower left while editing
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	//globale buttons de-/aktivieren
	[appDelegate.rootViewController enabledGlobalButtons:FALSE sender:self];	
}


- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
	[super viewWillAppear:animated];
	//show the data
	[self updateDataFields];

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
	[parentTask release];
	[workUnit release];
	[parentTable release];
	[dateButton release];
	[startButton release];
	[endButton release];
	[pauseButton release];
	[durationButton release];
	[txtDescription release];
    [super dealloc];
}


@end
