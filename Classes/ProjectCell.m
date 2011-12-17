//
//  TaskCell.m
//  TaskTracker
//
//  Created by Michael Anteboth on 12.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProjectCell.h"
#import "ProjectTask.h"
#import "ProjectCellView.h"

@implementation ProjectCell

@synthesize project;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		CGRect tzvFrame = CGRectMake(10.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		cellView = [[ProjectCellView alloc] initWithFrame:tzvFrame];
		cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:cellView];
	}
	return self;
}

//- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
//	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
//		CGRect tzvFrame = CGRectMake(10.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
//		cellView = [[ProjectCellView alloc] initWithFrame:tzvFrame];
//		cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//		[self.contentView addSubview:cellView];
//	}
//	return self;
//}

- (void)setProject:(Project*)aProject{
	ProjectCellView* cv = (ProjectCellView*) cellView;
	cv.project = aProject;
    
    self.accessibilityLabel = aProject.name;
}


- (void)dealloc {
	[project release];
    [super dealloc];
}

@end
