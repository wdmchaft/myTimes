//
//  TaskCell.m
//  TaskTracker
//
//  Created by Michael Anteboth on 12.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TaskCell.h"
#import "TaskCellView.h"
#import "ProjectTask.h"
#import "ProjectDetailsViewController.h"

@implementation TaskCell

@synthesize task;

//initialize this cell view
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		//create the details button for this cell
		UIButton* btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		//it' located on the left side of this cell
		btn.frame = CGRectMake(2, 10, btn.frame.size.width, btn.frame.size.height);
		//Add action handler and set current class as target
		[btn addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
	 
		
		//create the task cell view which displays a task summary for the particular task
		CGRect tzvFrame = CGRectMake(30.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		cellView = [[TaskCellView alloc] initWithFrame:tzvFrame];
		cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:btn];
		[self.contentView addSubview:cellView];
	}
	return self;
}

//invoked when the details button touched
-(void)showDetails:(id)sender {
	NSLog(@"UIButton was clicked");
	ProjectDetailsViewController* ctl =  cellView.ctl;
	[ctl editTask: self.task editMode:TRUE];
}

//sets the task for this cell view
- (void)setTask:(ProjectTask*)atask{
	TaskCellView* cv = (TaskCellView*) cellView;
	cv.task = atask;
	task = atask;
}

- (void)dealloc {
	[task release];
	[super dealloc];
}

@end
