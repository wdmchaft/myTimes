//
//  TaskCellView.m
//  TaskTracker
//
//  Created by Michael Anteboth on 12.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TaskCellView.h"

@implementation TaskCellView

@synthesize task;
@synthesize startStopButton;
@synthesize actIndicator;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
        // Initialization code
		taskSummaryFormatString = NSLocalizedString(@"taskSummaryFormatString", "");
		
		//create and add start/stop button
		self.startStopButton = [UIButton buttonWithType:UIButtonTypeCustom]; 
		[self.startStopButton setFrame:CGRectMake(210, 10, 35, 35)];
		[self.startStopButton addTarget:self action:@selector(startStopButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		[self.startStopButton setBackgroundImage:[UIImage imageNamed:@"play-btn.png"] forState:UIControlStateNormal];		
		[self addSubview:self.startStopButton];
		
		//create and add the UIActivityIndicatorView
		self.actIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(190, 20, 20, 20)];
		self.actIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		self.actIndicator.hidesWhenStopped = TRUE;
		[self.actIndicator stopAnimating];
		[self addSubview:self.actIndicator];
    }
    return self;
}

- (void)setEditing:(BOOL)isEditing {
	BOOL visible = !isEditing && [self.actIndicator isAnimating];
	[self.actIndicator setHidden:!visible];
	[self.startStopButton setHidden:isEditing];
}

//show the correct image for the running state of the cells workUnit
-(void) updateButtonState {
	if ([self hasRunningWorkUnits]) {
		[self.startStopButton setBackgroundImage:[UIImage imageNamed:@"pause-btn.png"] forState:UIControlStateNormal];
		[self.actIndicator startAnimating];
	} else {
		[self.startStopButton setBackgroundImage:[UIImage imageNamed:@"play-btn.png"] forState:UIControlStateNormal];
		[self.actIndicator stopAnimating];
	}
}

//returns true if there is a workUnit which is running, false else
-(BOOL) hasRunningWorkUnits {
	return [task hasRunningWorkUnits];
}

//start/stop button pressed
-(void) startStopButtonClicked:(id)sender {
	//start a new workunit or stop the running one
	if ([self hasRunningWorkUnits]) {
		//there is a running task, stop it
		for (TimeWorkUnit* wu in task.workUnits) {
			if(wu.running) {
				[wu stopTimeTracking];
				break;
			}
		}
		
	} else {
		//no running task yet, create a new workUnit and set running to true
		TimeWorkUnit* workUnit = [[TimeWorkUnit alloc] init];
		[workUnit setDuration:[NSNumber numberWithInt:0]]; //initial duration = 0
		[workUnit startTimeTracking];
		[self.task.workUnits addObject:workUnit]; //add to tasks workUnits
		
		//stop all other running work units when only one active is allowed
		if (!appDelegate.allowMultipleTasks) {
			[appDelegate stopAllOtherWorkUnitsExcept:workUnit];
		}
		
		[workUnit release];
	}
	[self setNeedsDisplay];
	[self updateButtonState];
}

-(void) setTask:(ProjectTask*)aTask {	
	// If the task changes update reference
	if (task != aTask) {
		[task release];
		task = [aTask retain];
	}
    self.accessibilityLabel = task.name;
	[self setNeedsDisplay];
	[self updateButtonState];
}

-(NSString*) getMainText {
	NSString* taskName = [self.task name];
	return taskName;
}

-(NSString*) getSecondText {
	int taskCount = [[self.task workUnits] count];
	NSString* duration = [NSString stringWithFormat:taskSummaryFormatString, taskCount, [self.task summary]];
	return duration;
}


- (void)dealloc {
	[startStopButton release];
	[task release];
	[actIndicator release];
	[super dealloc];
}

@end
