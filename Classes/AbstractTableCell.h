//
//  AbstractTableCell.h
//  TaskTracker
//
//  Created by Michael Anteboth on 29.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableRowSelectionDelegate.h"
#import "AbstractTableCellView.h"

@interface AbstractTableCell : UITableViewCell {
	AbstractTableCellView* cellView;
}
	
@property (nonatomic,retain) AbstractTableCellView* cellView;
-(void) setCtl:(id<TableRowSelectionDelegate>) ctl;
-(void) setRow:(int)row;	

@end