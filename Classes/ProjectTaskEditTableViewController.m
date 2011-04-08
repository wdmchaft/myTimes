//
//  BeginEndEditTableViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 16.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProjectTaskEditTableViewController.h"
#import "WorkUnitDetailsCellView.h"
#import "TaskTrackerAppDelegate.h"

@implementation ProjectTaskEditTableViewController

@synthesize projectCellView;
@synthesize taskCellView;
@synthesize lblProject;
@synthesize lblTask;
@synthesize workUnit;
@synthesize picker;
@synthesize project;
@synthesize task;

#pragma mark UIPickerView delegate & dataSource methods

//column count
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

//returns the number of rows
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0) {
		if (projects != nil)
			return [projects count];
		else 
			return 0;
	} else {
		if (self.project != nil) {
			return [self.project.tasks count];
		} else {
			return 0;
		}
	}
}

//get rows text
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (component == 0) {
		if (projects != nil) {
			Project* p = [projects objectAtIndex:row];
			return p.name;
		} else return @" ";
		
	} else if (component == 1) {
		if (self.project != nil) {
			ProjectTask* pt = [self.project.tasks objectAtIndex:row];
			return pt.name;
		}
	}
	return @" ";
}

//picker selection changed
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (component == 0 && projects != nil && row > -1) {
		self.project = [[projects objectAtIndex:row] retain];
		if (project.tasks != nil && [project.tasks count] > 0)
			self.task = [project.tasks objectAtIndex:0];
		else 
			self.task = nil;
		[self refreshLabels];
		[picker reloadComponent:1];
	} else if (component == 1 && row > -1) {
		if (self.project != nil) {
			self.task = [project.tasks objectAtIndex:row];
			[self refreshLabels];
		}
	}
}


#pragma mark UIView methods

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ProjectTaskEditCellView" owner:self options:nil];	
    }
    return self;
}
 */

//make the made changes to appear in the workUnit object
-(void) saveChanges {
	//TODO Workunit unter gewähltem Project und Task einordnen
}

-(void) refresh {
	
	//project list
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];	
	projects = appDelegate.data;
	
	if (projects != nil && [projects count] > 0) {
	
		//refresh picker view
		[picker reloadAllComponents];
	
		//preselect the persisted project and task
		int row = 0;
		if (project != nil) {
			row = [projects indexOfObject:project];
			[picker selectRow:row inComponent:0 animated:false];
		} else {
			//if new project is present select the first one
			[picker selectRow:row inComponent:0 animated:false];
			//and fll the project task compoment (becaus no event is fired on programmatic selection in picker)
			self.project = [projects objectAtIndex:row];
			if (project.tasks != nil && [project.tasks count] > 0)
				self.task = [project.tasks objectAtIndex:0];
			else 
				self.task = nil;
			[picker reloadComponent:1];
		}
	
		row = 0;
		if (task != nil) {
			row = [project.tasks indexOfObject:task];
		}
		[picker selectRow:row inComponent:1 animated:false];	
	}	
	
	[self.tableView reloadData];
	//refresh the labels
	[self refreshLabels];	
	 
}


-(void) refreshLabels {
	//TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (project == nil) {
		self.lblProject.text = @" ";
	} else {
		self.lblProject.text = project.name;
	}
	
	if (task == nil) {
		self.lblTask.text = @" ";
	} else {
		self.lblTask.text = task.name;
	}
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


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

-(NSString*) lpad:(NSString*) s length:(int) n {
	if (s != nil) {
		if ([s length] >= n) {
			return s;
		} else {
			return [s stringByPaddingToLength:n withString:@" " startingAtIndex:0];
		}
	}
	else return s;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		//the start entry cell
		static NSString *CellIdentifier = @"ProjectCellView";		 
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		}

		cell.textLabel.text = NSLocalizedString(@"label.project", @"");
		
		NSString* txt;
		if (self.project != nil) {
			txt = self.project.name;
		} else {
			txt = @" ";
		}
		txt = [self lpad:txt length:40];
		cell.detailTextLabel.text = txt;
		self.lblProject = cell.detailTextLabel;	
		return cell;
	} else if (indexPath.row == 1) {
		//the start entry cell
		static NSString *CellIdentifier = @"TaskCellView";		 
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		}
		
		NSString* txt;
		if (self.task.name != nil) {
			txt = self.task.name;
		} else {
			txt = @" ";
		}
		txt = [self lpad:txt length:40];
		
		cell.textLabel.text = NSLocalizedString(@"label.subproject", @"");
		cell.detailTextLabel.text = txt;
		self.lblTask = cell.detailTextLabel;	
		return cell;
	} 
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:false];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
	[picker release];
	[lblProject release];
	[lblTask release];
	[projectCellView release];
	[taskCellView release];	
	[workUnit release];
	[project release];
	[task release];
    [super dealloc];
}


@end

