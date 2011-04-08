//
//  AbstractTableCell.m
//  TaskTracker
//
//  Created by Michael Anteboth on 29.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractTableCell.h"
#import "AbstractTableCellView.h"

@implementation AbstractTableCell

@synthesize cellView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		//implement these steps in subclass be using the concrete cellView impl
		//		CGRect tzvFrame = CGRectMake(10.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		//		cellView = [[AbstractTableCellView alloc] initWithFrame:tzvFrame];
		//		cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		//		[self.contentView addSubview:cellView];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if (selected)
		[cellView.ctl setRowSelected:cellView.row selected:selected];
}

-(void) setRow:(int)row {
	cellView.row = row;
}

-(void) setCtl:(id<TableRowSelectionDelegate>)ctl {
	cellView.ctl = ctl;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	//call set editing on cellView
	[cellView setEditing:editing]; 
	[super setEditing:editing animated:animated];	
}

- (void)dealloc {
	[cellView release];
    [super dealloc];
}

@end
