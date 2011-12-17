//
//  BeginEndEditTableViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BeginEndEditTableViewController.h"
#import "WorkUnitDetailsCellView.h"
#import "TaskTrackerAppDelegate.h"
#import "TimeUtils.h"

@implementation BeginEndEditTableViewController

@synthesize beginCellView;
@synthesize endCellView;
@synthesize lblEnd;
@synthesize lblBegin;
@synthesize workUnit;
@synthesize datePicker;


//make the made changes to appear in the workUnit object
-(BOOL) saveChanges {
	
	//check if start date is valid(not after end date)
	NSComparisonResult cmp = [startDate compare:endDate];
	if (cmp == NSOrderedDescending) {			
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error.title", @"") 
														message:NSLocalizedString(@"error.msg.startDateCannotBeLaterThanEndDate", @"")
													   delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"error.close.button.text", @"") 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		//return and don't save
		return FALSE;
	}
	
	workUnit.date = startDate;
	//duration = diff(start,end) - pause
	//calc the duration bestween start and the edited end time
	NSTimeInterval duration = [endDate timeIntervalSinceDate:startDate];
	//substract the pause time from the duration
	duration = duration - [workUnit.pause intValue];
	workUnit.duration = [NSNumber numberWithDouble:duration];
	//All data is valid and changed so return true
	return TRUE;
}

-(void) refresh {
	startDate = workUnit.date;
	endDate = [workUnit getEndDate];
	//set start date
	[self.datePicker setDate:startDate animated:FALSE];
	//select first row (start date row)
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:true scrollPosition:true];
	//refresh the labels
	[self refreshLabels];	
}

-(void) datePickerValueChanged:(id)sender {
	//the date picker changed it's value
	//so refresh the table data
	NSIndexPath* selPath = [self.tableView indexPathForSelectedRow];
	if (selPath != nil) {
		if (selPath.row == 0) {
			//start date changed
			startDate = [self.datePicker.date copy];
		} else if (selPath.row == 1) {			
			//end time was changed
			endDate = [self.datePicker.date copy];
		}
		//refresh the labels
		[self refreshLabels];
	}	
}

-(void) refreshLabels {
	//refresh labels
	NSString* s = [TimeUtils formatDateAndTime:startDate withFormatType:2];
	self.lblBegin.text = s;
	
	NSString *es = [TimeUtils formatDateAndTime:endDate withFormatType:2];
	self.lblEnd.text = es;			
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		//the start entry cell
		static NSString *CellIdentifier = @"BeginCellView";		 
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		}
		
		NSString* txt;
		if (startDate != nil) {
			txt = [TimeUtils formatDateAndTime:startDate withFormatType:2];
		} else {
			txt = @"                                                                    ";
		}
		cell.textLabel.text = NSLocalizedString(@"label.start", @"");
		self.lblBegin = cell.detailTextLabel;
		cell.detailTextLabel.text = txt;
		return cell;
	} else if (indexPath.row == 1) {
		//the end entry cell
		static NSString *CellIdentifier = @"EndCellView";		 
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		}
		
		NSString* txt;
		if (endDate != nil) {
			txt = [TimeUtils formatDateAndTime:endDate withFormatType:2];
		} else {
			txt = @"                                                                    ";
		}
		cell.textLabel.text = NSLocalizedString(@"label.end", @"");
		self.lblEnd = cell.detailTextLabel;		
		cell.detailTextLabel.text = txt;
		return cell;
	}  	
    return nil;
}

-(void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"indexpath: %i", indexPath.row);
    if (indexPath.row == 0) {
		//selection of begin cell was made
		//so show begin date in date pickeer
		//self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
		if (![self.datePicker.date isEqualToDate:startDate])
			[self.datePicker setDate:startDate];
	} else if (indexPath.row == 1) {
		//selection of end cell was made
		//so show end date in date picker
		//self.datePicker.datePickerMode = UIDatePickerModeTime;		
		if (![self.datePicker.date isEqualToDate:endDate])		
			[self.datePicker setDate:endDate];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self didSelectRowAtIndexPath:indexPath];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[datePicker release];
	[lblEnd release];
	[lblBegin release];
	[beginCellView release];
	[endCellView release];
	[workUnit release];
    [super dealloc];
}


@end

