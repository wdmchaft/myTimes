//
//  BeginEndEditTableViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PauseEditTableViewController.h"
#import "WorkUnitDetailsCellView.h"
#import "TimeUtils.h"
#import "Math.h"
#import "TaskTrackerAppDelegate.h"

@implementation PauseEditTableViewController

@synthesize pauseCellView;
@synthesize lblPause;
@synthesize workUnit;
@synthesize picker;
@synthesize hours;
@synthesize mins;


#pragma mark UIPickerView delegate & dataSource methods

//column count
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

//returns the number of rows
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0) {
		return [hours count];
	} else {
		return [mins count];
	}
}

//get rows text
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (component == 0) {
		if (selRowHr == row) {
			return [NSString stringWithFormat:@"%@ %@", [hours objectAtIndex:row], hrsLbl];
		} else {
			return [self.hours objectAtIndex:row];
		}
	} else if (component == 1) {
		if (selRowMin == row) {
			return [NSString stringWithFormat:@"%@ %@", [mins objectAtIndex:row], minsLbl];
		} else {
			return [self.mins objectAtIndex:row];
		}
	}
	return @"";
}

//picker selection changed
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (component == 0 && row > -1) {
		selRowHr = row;
		[self.picker reloadComponent:0];
	} else if (component == 1 && row > -1) {
		selRowMin = row;
		[self.picker reloadComponent:1];
	}
	//Pause = <gew. Std.> + <gew Min> in Sekunden umgerechnet
	int tmp = selRowHr * 60 * 60 + selRowMin * minuteInterval * 60;
	NSLog(@"pause: %i", tmp);
	int diff = [[workUnit getEndDate] timeIntervalSinceDate:workUnit.date];
	int dur = diff - tmp;
	if (dur < 0) {
		//error pause cannot be greater than the duration (this will result in a negative duration)
		//TODO Show error message and set old value in date picker
		[self displayPause:pause animated:TRUE];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error.title", @"") 
														message:NSLocalizedString(@"error.msg.pauseCannotBeGreaterThanDuration", @"")
													   delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"error.close.button.text", @"") 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	} else {
		pause = tmp;
		[self refreshLabels];
	}
}

//Anzeige der Pause im Picker aktualisieren
-(void) displayPause:(int)p animated:(BOOL)animated {
	selRowHr = 0;
	selRowMin = 0;
	
	if (pause >= 3600) {
		//Stunden ermitteln
		selRowHr = pause / 3600;
	}
	[self.picker selectRow:selRowHr inComponent:0 animated:animated];
	[self.picker reloadComponent:0];
	
	if (pause >= 60) {	
		//Minuten ermitteln
		selRowMin = pause - (selRowHr*3600);
		selRowMin = selRowMin / 60 / minuteInterval;
	}
	[self.picker selectRow:selRowMin inComponent:1 animated:animated];
	[self.picker reloadComponent:1];
}

#pragma mark view methods

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 /*   if (self = [super initWithStyle:style]) {
		[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PauseEditCellView" owner:self options:nil];	
    } */
	
	self.picker.showsSelectionIndicator = TRUE;
	selRowHr = 0;
	selRowMin = 0;
	
	hrsLbl = NSLocalizedString(@"pausePickerView.hours", @"");
	minsLbl = NSLocalizedString(@"pausePickerView.mins", @"");
	
	//Stundenarray anlegen
	self.hours = [[NSMutableArray alloc] init];
	TaskTrackerAppDelegate*	appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	minuteInterval = appDelegate.minuteInterval;
	int i=0;
	int size = 24;
	for (i=0; i<size; i++) {
		[self.hours  addObject:[NSString stringWithFormat:@"%i", i]];
	}
	
	//Minutenarray abhängig vom gewählten MinutenIntervall erzeugen
	size = 60 / minuteInterval;
	self.mins = [[NSMutableArray alloc] init];
	for (i=0; i<size; i++) {
		int min = i * minuteInterval;
		[self.mins addObject:[NSString stringWithFormat:@"%i", min]];
	}
	
    return self;
}

//make the made changes to appear in the workUnit object
-(void) saveChanges {
	//end time = start time + duration - pause
	//if pause changed adjust the duration so that the end time don't change
	int diff = [[workUnit getEndDate] timeIntervalSinceDate:workUnit.date];
	int dur = diff - pause;
	workUnit.duration = [NSNumber numberWithInt:dur];
	workUnit.pause = [NSNumber numberWithDouble:pause];
}

-(void) refresh {
	pause = [workUnit.pause intValue];
	//set pause value in date picker
	
	//Anzeige aktualisieren
	[self displayPause:pause animated:FALSE];
	
	//select first row (pause row)
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:true scrollPosition:true];
	//refresh the labels
	[self refreshLabels];	
}

/*
-(void) datePickerValueChanged:(id)sender {
	//the date picker changed it's value
	int tmp = self.datePicker.countDownDuration;
	NSLog(@"pause: %i", tmp);
	int diff = [[workUnit getEndDate] timeIntervalSinceDate:workUnit.date];
	int dur = diff - tmp;
	if (dur < 0) {
		//error pause cannot be greater than the duration (this will result in a negative duration)
		//TODO Show error message and set old value in date picker
		self.datePicker.countDownDuration = pause;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error.title", @"") 
														message:NSLocalizedString(@"error.msg.pauseCannotBeGreaterThanDuration", @"")
													   delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"error.close.button.text", @"") 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	} else { 
		//pause time is valid, so proceed
		pause = tmp;
		int diff = fmod(pause, 60);
		pause = pause - diff;
		NSLog(@"pause: %i", pause);
		
		
		//refresh the labels
		[self refreshLabels];
	}
}
*/

-(void) refreshLabels {
	//Pause
	NSString* pauseString = [TimeUtils formatSeconds:pause];
	self.lblPause.text = pauseString;
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

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
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		//the start entry cell
		static NSString *CellIdentifier = @"PauseCellView";		 
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		}
		
		cell.textLabel.text = NSLocalizedString(@"label.pause", @"");
		cell.detailTextLabel.text = [TimeUtils formatSeconds:pause];
		self.lblPause = cell.detailTextLabel;	
		return cell;
	} 	
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
		//selection of pause cell was made
		//so show pause time in date picker
		//[self.datePicker setDate:startDate];
	}	
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
	[hours release];
	[mins release];
	[picker release];
	[lblPause release];
	[pauseCellView release];
	[workUnit release];
    [super dealloc];
}


@end

