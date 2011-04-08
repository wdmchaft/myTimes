//
//  ProjectDetailsViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 10.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "ProjectDetailsViewController.h"
#import "WorkUnitsListViewController.h"
#import "ProjectTask.h"
#import "TaskCell.h"
#import "TableRowSelectionDelegate.h"
#import "TaskEditViewController2.h"

#define ROW_HEIGHT 60

@implementation ProjectDetailsViewController

@synthesize project;
@synthesize addButtonItem;
@synthesize selectedRow;

//editing a project task either in edit mode or in creation mode
- (void) editTask:(ProjectTask*)pt editMode:(BOOL)editMode {
	
	if (!editMode) { //create new task
		//create TaskEditView
		TaskEditViewController* ctl = [[TaskEditViewController alloc] initWithNibName:@"TaskEditView" bundle:nil];
		//set task in controller
		ctl.task = pt;
		ctl.editMode = editMode;
		ctl.parentTable = self.tableView;
		//show details controller as modal controller
		[self.navigationController presentModalViewController:ctl animated:YES];
	} 
	//edit selected task
	else {
		TaskEditViewController2* ctl = [[TaskEditViewController2 alloc] initWithNibName:@"TaskEditViewController2" bundle:nil];
		ctl.task = pt;
		
		//show details controller as modal controller
		[self.navigationController pushViewController:ctl animated:YES];
	}
}

//edit the selected project task (if one is selected)
- (void) editSelectedItem {
	if (selectedRow > -1) {
		int row = selectedRow;
		ProjectTask* pt = [project.tasks objectAtIndex:row];
		
		//check if the task is editable
		if (pt.userChangeable) {
			[self editTask:pt editMode:TRUE];
		}
	}
}

//Neues Task Element anlegen
- (void) addItem {
	//create new project object
	ProjectTask* pt = [[ProjectTask alloc] init];
	[self editTask:pt editMode:FALSE];
}

- (void)viewDidLoad {
    [super viewDidLoad];

	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];

	//setting row height of each row to 60
	UITableView* table = self.tableView;
	table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	table.rowHeight = ROW_HEIGHT;
	
	NSLog(@"editing project: %@", [self.project name]);
	
	appDelegate.editingProject = self.project;
	appDelegate.addItemController = self;

	//setting the views title
	self.title = [self.project name];
	
	//self.navigationItem.rightBarButtonItem = self.addButtonItem;
    
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.tableView.allowsSelectionDuringEditing = TRUE;
}



- (void)viewWillAppear:(BOOL)animated {
	selectedRow = -1;
    [super viewWillAppear:animated];
	//set current table view in appDelegate to be able to edit all the tables on the views with a unique mechanism
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentTableView = self.tableView;
	appDelegate.addItemController = self;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (appDelegate.taskToLoadAtStartup != nil) {
		ProjectTask* pt = appDelegate.taskToLoadAtStartup;
		int row = [self.project.tasks indexOfObject:pt];
		//load a task a startup
		NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:0];
		//scroll down to active task
		[self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:false];
		UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:path];
		//select the row
		[cell setSelected:TRUE];
		//open the active task an show its task list
		[self tableView:self.tableView didSelectRowAtIndexPath:path];		
		//reset task to load to nil
		appDelegate.taskToLoadAtStartup = nil;
	}
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	//globale buttons de-/aktivieren
	[appDelegate.rootViewController enabledGlobalButtons:!editing sender:self];
 }

/*
- (void)viewDidAppear:(BOOL)animated {
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.projectDetailsViewCtl = self;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return number of tasks for the current project
	if (section == 0) {
		return [[self.project tasks] count];
	} else {
		return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"TaskCellView";	
	TaskCell* taskCell = (TaskCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (taskCell == nil) {
		CGRect startingRect = CGRectMake(0.0, 0.0, 320.0, ROW_HEIGHT);
		taskCell = [[[TaskCell alloc] initWithFrame:startingRect reuseIdentifier:CellIdentifier] autorelease];
	}
	
	//set the project task element in the cell view
	ProjectTask* pt = [[self.project tasks] objectAtIndex:[indexPath row]];
	if (pt != nil) {
		taskCell.task = pt;
		[taskCell setRow:[indexPath row]];
		[taskCell setCtl:self];
	}
	return taskCell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	if (selectedRow == -1) {
		//select a row
		selectedRow = [indexPath row];
	} else if (selectedRow == [indexPath row]){
		//deselect row
		selectedRow = -1;
	} else {
		//select another row		 
		selectedRow = [indexPath row];
	}
	
//	[self.tableView reloadData];
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.tableView.editing) {
		//Teilprojekt selektiert, Details zum Teilprojekt anzeigen (Zeiten)
		//the selected task
		ProjectTask* t = [[self.project tasks] objectAtIndex:[indexPath row]];
		NSLog(@"start editing task: %@", t.name);
		//ProjectDetailsView erzeugen und anzeigen
		WorkUnitsListViewController* workUnitsViewCtl = [[WorkUnitsListViewController alloc] initWithNibName:@"WorkUnitsListView" bundle:nil];
		//set task in workunitlistview
		workUnitsViewCtl.task = t;
		workUnitsViewCtl.parentProject = self.project;
		workUnitsViewCtl.parentTable = self.tableView;
		[self.navigationController pushViewController:workUnitsViewCtl animated:YES];
	} else {
		TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
		//Im EditModus selektiert, also teilprojekt editieren
		[appDelegate.addItemController editSelectedItem];
	}
	
	//[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	//the selected task
	ProjectTask* t = [[self.project tasks] objectAtIndex:[indexPath row]];
	
	NSLog(@"start editing task: %@", t.name);
	
	//ProjectDetailsView erzeugen und anzeigen
	WorkUnitsListViewController* workUnitsViewCtl = [[WorkUnitsListViewController alloc] initWithNibName:@"WorkUnitsListView" bundle:nil];
	//set task in workunitlistview
	workUnitsViewCtl.task = t;
	workUnitsViewCtl.parentProject = self.project;
	
	workUnitsViewCtl.parentTable = self.tableView;
	
	[self.navigationController pushViewController:workUnitsViewCtl animated:YES];
}
 */

// The accessory type is the image displayed on the far right of each table cell. In order for the delegate method
// tableView:accessoryButtonClickedForRowWithIndexPath: to be called, you must return the "Detail Disclosure Button" type.
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//check if the task is editable
	if (indexPath.row < [[self.project tasks] count]) {
		ProjectTask* task = [[self.project tasks] objectAtIndex:indexPath.row];
		if (task.userChangeable) {
			return YES;
		}
	}
    
    return NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		ProjectTask* t = [[self.project tasks] objectAtIndex:[indexPath row]];
		[[self.project tasks] removeObject:t];
		//delete the row from table view
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		//is this nessecary? reload data
		[self.tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	NSMutableArray* array = project.tasks;
	NSUInteger fromRow = [fromIndexPath row];
	NSUInteger toRow = [toIndexPath row];
	id object = [[array objectAtIndex:fromRow] retain];
	[array removeObjectAtIndex:fromRow];
	[array insertObject:object atIndex:toRow];
	[object release];
}




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



- (void)dealloc {
	[addButtonItem release];
	[project release];
    [super dealloc];
}


@end

