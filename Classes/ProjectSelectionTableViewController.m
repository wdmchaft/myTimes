//
//  ProjectSelectionTableViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 03.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProjectSelectionTableViewController.h"
#import "TaskTrackerAppDelegate.h"
#import "Project.h"


@implementation ProjectSelectionTableViewController

@synthesize projectsForExport;
@synthesize masterController;
@synthesize saveButton;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

-(void) cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


-(void) save:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
	[masterController editingFinished];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.navigationItem.rightBarButtonItem = self.saveButton;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

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
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {		
		return NSLocalizedString(@"export.label.options.markProjectsForExport", @"");
	} 
	return @"";
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int rows = [appDelegate.data count];
    return rows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
    Project* p = [appDelegate.data objectAtIndex:indexPath.row];
	cell.textLabel.text = p.name;
	
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	//return checkmark if project is in list of project for export
	Project* p = [appDelegate.data objectAtIndex:indexPath.row];
	if ([self.projectsForExport containsObject:p]) {
		return UITableViewCellAccessoryCheckmark;
	} else {
		return UITableViewCellAccessoryNone;
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Project* p = [appDelegate.data  objectAtIndex:indexPath.row];
	
	if ([self.projectsForExport containsObject:p]) {
		//remove p to remove export selection
		[self.projectsForExport removeObject:p];
	} else {
		//add p to add export selection
		[self.projectsForExport addObject:p];
	}
	[self.tableView reloadData];
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:true];
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
	[projectsForExport release];
	[saveButton release];	
    [super dealloc];
}


@end

