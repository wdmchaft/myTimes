//
//  WorkUnitCellView.m
//  TaskTracker
//
//  Created by Michael Anteboth on 29.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WorkUnitCellView.h"
#import "WorkUnitCellView.h"

@implementation WorkUnitCellView

@synthesize workUnit;
@synthesize startStopButton;
@synthesize actIndicator;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		//summaryFormatString = NSLocalizedString(@"projectSummaryFormatString", "");
		appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];

		timeFormatter = [[NSDateFormatter alloc] init];
		[timeFormatter setDateStyle:NSDateFormatterNoStyle];
		[timeFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		workUnitListCellFormatString = NSLocalizedString(@"WorkUnitListCellFormatString", @"");
		
		//create show the start/stop button
		self.startStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.startStopButton.frame = CGRectMake(220, 10, 35, 35);
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
	if (workUnit.running) {
		[self.startStopButton setBackgroundImage:[UIImage imageNamed:@"pause-btn.png"] forState:UIControlStateNormal];
		[self.actIndicator startAnimating];
	} else {
		[self.startStopButton setBackgroundImage:[UIImage imageNamed:@"play-btn.png"] forState:UIControlStateNormal];
		[self.actIndicator stopAnimating];
	}
}

//start/stop button pressed
-(void) startStopButtonClicked:(id)sender {
	if (workUnit.running) {
		//stop running 
		[workUnit stopTimeTracking];
	} else {
		//Start running
		[workUnit startTimeTracking];
		if (!appDelegate.allowMultipleTasks) {
			//stop all other running work units when only one active is allowed
			[appDelegate stopAllOtherWorkUnitsExcept:workUnit];
		}
	}
	[self setNeedsDisplay];
	[self updateButtonState];
}

-(void) setWorkUnit:(TimeWorkUnit*)aWorkUnit {	
	// If the task changes update reference
	if (workUnit != aWorkUnit) {
		[workUnit release];
		workUnit = [aWorkUnit retain];
	}
	[self setNeedsDisplay];
	[self updateButtonState];
}

//returns the project name
-(NSString*) getMainText {
	//Date - Duration
	NSString* dateString = [dateFormatter stringFromDate:workUnit.date];
	NSString* durString = [appDelegate formatSeconds:[workUnit.duration intValue]];
	NSString* txt = [NSString stringWithFormat:workUnitListCellFormatString, dateString, durString];
	
	return txt;
}

//returns the number of sub tasks and the total duration
-(NSString*) getSecondText {
	//start - ende
	NSString* start = [timeFormatter stringFromDate:workUnit.date];
	NSString* end = [timeFormatter stringFromDate:[workUnit getEndDate]];
	NSString* txt = [NSString stringWithFormat:@"%@ - %@", start, end];	
	return txt;
}



- (void)dealloc {
	[actIndicator release];
	[startStopButton release];
	[dateFormatter release];
	[timeFormatter release];
	[workUnit release];
	[super dealloc];
}

@end
