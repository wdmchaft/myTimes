//
//  TaskCellView.m
//  TaskTracker
//
//  Created by Michael Anteboth on 12.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProjectCellView.h"
#import "ProjectTask.h"

@implementation ProjectCellView

@synthesize project;
@synthesize actIndicator;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		summaryFormatString = NSLocalizedString(@"projectSummaryFormatString", "");
		
		//create and add the UIActivityIndicatorView
		self.actIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(220, 20, 20, 20)];
		self.actIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		self.actIndicator.hidesWhenStopped = TRUE;
		[self.actIndicator stopAnimating];
		[self addSubview:self.actIndicator];
    }
    return self;
}

-(int) getMaxTextWidth {
	return 200;
}

- (void)setEditing:(BOOL)isEditing {
	BOOL visible = !isEditing && [self.actIndicator isAnimating];
	[self.actIndicator setHidden:!visible];
}

//returns true if the project has at least one running active task
-(BOOL) hasRunningWorkUnits {
	return [self.project hasRunningWorkUnits];
}

//update button state
-(void) updateButtonState {
	if ([self hasRunningWorkUnits]) {
		[self.actIndicator startAnimating];
	} else {
		[self.actIndicator stopAnimating];
	}
}

-(void) setProject:(Project*)aProject {	
	// If the task changes update reference
	if (project != aProject) {
		[project release];
		project = [aProject retain];
        self.accessibilityLabel = project.name;
	}
	[self setNeedsDisplay];
	[self updateButtonState];
}

//returns the project name
-(NSString*) getMainText {
	NSString* projectName = [self.project name];
	return projectName;
}

//returns the number of sub tasks and the total duration
-(NSString*) getSecondText {
	int taskCount = [[self.project tasks] count];
	NSString* duration = [NSString stringWithFormat:summaryFormatString, taskCount, [self.project summary]];
	return duration;
}

- (void)dealloc {
	[project release];
	[actIndicator release];
	[super dealloc];
}


@end
