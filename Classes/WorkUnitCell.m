//
//  WorkUnitCell.m
//  TaskTracker
//
//  Created by Michael Anteboth on 29.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WorkUnitCell.h"
#import "WorkUnitCellView.h"


@implementation WorkUnitCell

@synthesize workUnit;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		CGRect tzvFrame = CGRectMake(10.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		cellView = [[WorkUnitCellView alloc] initWithFrame:tzvFrame];
		cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:cellView];
	}
	return self;
}

- (void)setWorkUnit:(TimeWorkUnit*)wu {
	WorkUnitCellView* cv = (WorkUnitCellView*) cellView;
	cv.workUnit = wu;
}

- (void)dealloc {
	[workUnit release];
	[super dealloc];
}

@end
