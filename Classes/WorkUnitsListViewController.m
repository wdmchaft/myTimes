//
//  WorkUnitsListViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 11.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WorkUnitsListViewController.h"
#import "TimeWorkUnit.h"
#import "TaskTrackerAppDelegate.h"
#import "WorkUnitCell.h"
#import "WorkUnitDetailsTableViewController.h"

@implementation WorkUnitsListViewController

@synthesize task;
@synthesize parentProject;
@synthesize addButtonItem;
@synthesize dateFormatter;
@synthesize parentTable;
@synthesize data;
@synthesize sectionKeys;
@synthesize dict;
@synthesize sectionTitles;

#define ROW_HEIGHT 60


//start the work unit editing view for adding a new Work Unit to the current editing task
- (void) addItem {
	TimeWorkUnit* wu = [[TimeWorkUnit alloc] init];
	[self editWorkUnit:wu isNewItem:TRUE];
	
}


//edits a workunit object in a model editor view
-(void) editWorkUnit:(TimeWorkUnit*)wu isNewItem:(BOOL)isNewItem {
	//create WorkUnitEditView
	WorkUnitDetailsTableViewController* ctl = [[WorkUnitDetailsTableViewController alloc] initWithNibName:@"WorkUnitDetailsView" bundle:nil];
	//tell the controller that we only edit an existing work unit
	ctl.workUnitAddMode = isNewItem;
	//set task in controller
	ctl.parentTask = task;
	ctl.parentProject = self.parentProject;
	//set workUnit in controller
	ctl.workUnit = wu;
	//set parent table to reload table view after WorkUnit creation
	ctl.parentController = self;
	//popup the view controller
	[self.navigationController pushViewController:ctl animated:YES];	
	[ctl release];
}

-(void) editSelectedItem {
	if (selectedRow > -1) {
//		int row = selectedRow;
		int row = [self.tableView indexPathForSelectedRow].section;
		TimeWorkUnit* wu = [[self.task workUnits] objectAtIndex:row];
		[self editWorkUnit:wu isNewItem:FALSE];
	}
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//setting row height
	UITableView* table = self.tableView;
	table.rowHeight = ROW_HEIGHT;
	//set the title
	self.title = [self.task name];
	
	//init the dateformatter
	NSDateFormatter *df = [[[NSDateFormatter alloc] init]  autorelease];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterShortStyle];
	self.dateFormatter = df;
	
	self.tableView.delaysContentTouches = TRUE;
	self.tableView.allowsSelection = TRUE;
	
	workUnitListCellFormatString = NSLocalizedString(@"WorkUnitListCellFormatString", @"");
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



//returns a date object containing only the year,month and date portion of the given date
//not the time information
-(NSDate*) getDayDate:(NSDate*)date {
	if (gregorian == nil) {
		gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	}

	NSDateComponents *dateComps = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
	NSDate *d = [gregorian dateFromComponents:dateComps];
	
	return d;
}

NSInteger dateSortDescending(NSDate* d0, NSDate* d1, void *context) {
    return [d1 compare:d0];
}

//inits the sorted data dictionary
//for each index there is a key entry which is a distinct date (day)
//and as the value for each key there will be the array with the proper work units set
-(void) initData {
	
	self.data = [self.task getWorkUnitsSorted];
	//NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
	NSMutableDictionary* mDict = [[NSMutableDictionary alloc] init];
	for (TimeWorkUnit* wu in self.data) {
		NSDate* d = [self getDayDate:wu.date];
		if ([mDict objectForKey:d] != nil) {
			NSMutableArray* a = [mDict objectForKey:d];
			[a addObject:wu]; //add workunit to the array
		} else {
			//create new array for the key
			NSMutableArray* a = [[NSMutableArray alloc] init];
			[a addObject:wu]; //add workunit to the array
			//add array to dictionary
			[mDict setObject:a forKey:d];
		}
	}
	
	NSArray *myKeys = [mDict allKeys];
	//sorted keys by date descending
	NSArray *sortedKeys = [myKeys sortedArrayUsingFunction:dateSortDescending context:nil];

	//create the section titles array
	NSMutableArray* titles = [[NSMutableArray alloc] initWithCapacity:[myKeys count]];
	for (NSDate* d in sortedKeys) {
		[titles addObject:[TimeUtils formatDate:d withFormatType:FULL_FORMAT]];
	}
	
	self.sectionKeys = sortedKeys;
	self.dict = mDict;
	self.sectionTitles = titles;
	
	//NSTimeInterval stop = [NSDate timeIntervalSinceReferenceDate];
	//NSTimeInterval diff = stop - start;
	//NSLog(@"init takes: %f", diff);
}

-(void) reload {
	NSLog(@"reload");
	[self initData];
	[self.tableView reloadData];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
	return [super initWithNibName:nibName bundle:nibBundle];
}

- (void)viewWillAppear:(BOOL)animated {
	selectedRow = -1;
	//init the table data
	[self initData];
	
    [super viewWillAppear:animated];
	//set current table view in appDelegate to be able to edit all the tables on the views with a unique mechanism
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentTableView = self.tableView;	
	appDelegate.addItemController = self;
	//globale buttons de-/aktivieren
	[appDelegate.rootViewController enabledGlobalButtons:true sender:self];
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (appDelegate.workUnitToLoadAtStartup != nil) {
		TimeWorkUnit* wu = appDelegate.workUnitToLoadAtStartup;
		int row = [self.task.workUnits indexOfObject:wu];
		NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:0];
		//scroll down to active workunit
		[self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:false];
		UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:path];
		//select the row
		[cell setSelected:TRUE];
		//open the active workunit an show its task list
		//[self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:path];
		//reset workunit to load to nil
		appDelegate.workUnitToLoadAtStartup = nil;
	}
	
	//add an empty footer view which is as large as the bottom toolbar, so that the last table row will not be hidden by the bottom toolbar
	int toolbarHeight = self.navigationController.toolbar.frame.size.height;
	CGRect r = self.tableView.frame;
	CGRect f = CGRectMake(0, r.origin.y + r.size.height , r.size.width, toolbarHeight);	
	UIView* footer = [[UIView alloc] initWithFrame:f];	
	self.tableView.tableFooterView = footer;
	
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.parentTable reloadData];
}

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

#pragma mark TableRowSelectionDelegate methods
-(BOOL) isRowSelected:(int)row {
	return row == selectedRow;
}
-(void) setRowSelected:(int)row selected:(BOOL) selected {
	if (selected) selectedRow = row;
	else selectedRow = -1;
}

-(void) release {
	[super release];
}


#pragma mark Table view methods

// The accessory type is the image displayed on the far right of each table cell. In order for the delegate method
// tableView:accessoryButtonClickedForRowWithIndexPath: to be called, you must return the "Detail Disclosure Button" type.
/*- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {	
    return UITableViewCellAccessoryNone;
}*/


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
    [self.tableView reloadData];
	//enabble/disable the common add button in the lower left
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	//globale buttons de-/aktivieren
	[appDelegate.rootViewController enabledGlobalButtons:!editing sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dict count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray* keys = self.sectionKeys;
	if ([keys objectAtIndex:section] != nil) {
		NSArray* a = [self.dict objectForKey:[keys objectAtIndex:section]];
		return [a count];
	}
	return 0;
}	

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	 static NSString *CellIdentifier = @"WorkUnitCellView";	
	WorkUnitCell* cell = (WorkUnitCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		CGRect startingRect = CGRectMake(0.0, 0.0, 320.0, ROW_HEIGHT);
		cell = [[[WorkUnitCell alloc] initWithFrame:startingRect reuseIdentifier:CellIdentifier] autorelease];
	}

	//set the project task element in the cell view
	NSArray* keys = self.sectionKeys;
	if ([keys objectAtIndex:indexPath.section] != nil) {
		NSArray* a = [self.dict objectForKey:[keys objectAtIndex:indexPath.section]];
		TimeWorkUnit* w = [a objectAtIndex:indexPath.row];
		cell.workUnit = w;
		[cell setRow:[indexPath row]];
		[cell setCtl:self];		
	}		
	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.sectionTitles objectAtIndex:section];
}
 

/*- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	TimeWorkUnit* wu = [self.data objectAtIndex:[indexPath row]];
	[self editWorkUnit:wu isNewItem:FALSE];
}*/

//called when cell is selected
//remember the selected row (in this case the "row" is the section index of the selected cell)
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	if (selectedRow == -1) {
		//select a row
		selectedRow = [indexPath section];
	} else if (selectedRow == [indexPath section]){
		//deselect row
		selectedRow = -1;
	} else {
		//select another row		 
		selectedRow = [indexPath section];
	}
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id key = [self.sectionKeys objectAtIndex:indexPath.section];
	NSArray* workUnits = [self.dict objectForKey:key];
	TimeWorkUnit* wu = [workUnits objectAtIndex:indexPath.row];
	[self editWorkUnit:wu isNewItem:NO];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		id key = [self.sectionKeys objectAtIndex:indexPath.section];
		NSArray* workUnits = [self.dict objectForKey:key];
		TimeWorkUnit* wu = [workUnits objectAtIndex:indexPath.row];		
        [task.workUnits removeObject:wu];
		//[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		[self reload];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(NSArray*) getSectionIndexTitles {
	if ([self.sectionKeys count] > 2 && [self.data count] > 5) {
		NSMutableArray* sit = [NSMutableArray arrayWithCapacity:[self.sectionKeys count]];
//		[sit addObject:UITableViewIndexSearch];
		for (NSDate* d in self.sectionKeys) {
			NSString* s = [TimeUtils formatDate:d withFormatType:TINY_FORMAT];
			[sit addObject:s];
		}
		return sit;
	} else return nil;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return [self getSectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	int i=0;
	for (NSDate* d in self.sectionKeys) {
		NSString* s = [TimeUtils formatDate:d withFormatType:TINY_FORMAT];
		if ([s compare:title] == NSOrderedSame) {
			return i;
		}
		i++;
	}
	
    return 0;//[[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}


// Override to support rearranging the table view.
/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	NSMutableArray* array = task.workUnits;
	NSUInteger fromRow = [fromIndexPath row];
	NSUInteger toRow = [toIndexPath row];
	id object = [[array objectAtIndex:fromRow] retain];
	[array removeObjectAtIndex:fromRow];
	[array insertObject:object atIndex:toRow];
	[object release];
}
 */


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}




- (void)dealloc {
	[dateFormatter release];
	[task release];
	[parentProject release];	
	[addButtonItem release];
	[parentTable release];
	[sectionKeys release];
	[sectionTitles release];
	[dict release];
    [super dealloc];
}


@end

