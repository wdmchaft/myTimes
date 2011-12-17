//
//  ExportSettingsViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 21.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ExportSettingsViewController.h"
#import "TimeUtils.h"
#import "DatePickerViewController.h"
#import "TaskTrackerAppDelegate.h"
#import "ProjectSelectionTableViewController.h"

@implementation ExportSettingsViewController

@synthesize csvEnabled;
@synthesize xmlEnabled;
@synthesize startDate;
@synthesize endDate;
@synthesize projectsToExport;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//create the save button
	UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Weiter" 
																	style:UIBarButtonItemStyleDone
																   target:self 
																   action:@selector(proceed:)] autorelease];
	//and add it to the navigation bar
	self.navigationItem.rightBarButtonItem = saveButton;
	
	//create the cancel button
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				   target:self action:@selector(cancel:)] autorelease];
	//and add it to the navigation bar
	self.navigationItem.leftBarButtonItem = cancelButton;
	
	//disable the common add button in the lower left while editing
	TaskTrackerAppDelegate*	appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.rootViewController enabledGlobalButtons:FALSE sender:self];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	//enable the common add button in the lower left while editing
	TaskTrackerAppDelegate*	appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.rootViewController enabledGlobalButtons:TRUE sender:self];
	
}


//cancel operation and close the view
-(void) cancel:(id) sender {
	[self.navigationController popViewControllerAnimated:TRUE];
}

//validate data and proceed sending the mail
-(void) proceed:(id) sender {
	//check if at least csv or xml export is selected
	if (!self.csvEnabled && !self.xmlEnabled) {
		[self showErrorMessage:NSLocalizedString(@"export.error.exportFormatIsMissing", @"")];
		return;
	}
	//check if start date is before end date
	if ([self.startDate compare:self.endDate] == NSOrderedDescending) {
		[self showErrorMessage:NSLocalizedString(@"export.error.startDateMustBeforeEndDate", @"")];
		return;
	}
	//check if at least one project is marked for export
	if ([self.projectsToExport count] < 1) {
		[self showErrorMessage:NSLocalizedString(@"export.error.atLeastOneProjectForExportMustBeSelected", @"")];
		return;		
	}
	
	
	TaskTrackerAppDelegate*	appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.rootViewController sendExportMail:self];
}

//display an error message
-(void) showErrorMessage:(NSString*)msg {
	NSString* title = NSLocalizedString(@"export.error.title", @"");
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else if (section == 1) {
		return 2;
	} else if (section == 2) {
		return 1;
	} else return 0;
}

-(void) onXMLSwitchToggled:(id)sender {
	UISwitch* s = (UISwitch*)sender;
	xmlEnabled = s.on;
}

-(void) onCSVSwitchToggled:(id)sender {
	UISwitch* s = (UISwitch*)sender;
	csvEnabled = s.on;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == 0) {
		if(indexPath.row == 0) {
			//CSV Switch cell
			static NSString *CellIdentifier = @"CellExportFormatSwitchCSV";
    
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			}
			//set text
			cell.text = NSLocalizedString(@"export.label.options.csv", @"");
			//add switch contrl
			UISwitch* typeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 8, 100, 30)];
			typeSwitch.on = csvEnabled;
			[typeSwitch addTarget: self action: @selector(onCSVSwitchToggled:) forControlEvents: UIControlEventValueChanged]; 			
			[cell addSubview:typeSwitch];
			[typeSwitch release];
			return cell;
		} else 		if(indexPath.row == 1) {
			//XML Switch cell
			static NSString *CellIdentifier = @"CellExportFormatSwitchXML";
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			}
			cell.text = NSLocalizedString(@"export.label.options.xml", @"");
			//add switch control
			UISwitch* typeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 8, 100, 30)];
			typeSwitch.on = xmlEnabled;
			[typeSwitch addTarget: self action: @selector(onXMLSwitchToggled:) forControlEvents: UIControlEventValueChanged]; 
			[cell addSubview:typeSwitch];
			[typeSwitch release];
			return cell;
		}
		
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			//Zeitbereich Start
			static NSString *CellIdentifier = @"CellStart";
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			}
			NSString* lblFormat = NSLocalizedString(@"export.label.options.startFormat", @"");
			cell.text = [NSString stringWithFormat:lblFormat, [TimeUtils formatDate:startDate withFormatType:2]];
			return cell;
		} else if (indexPath.row == 1) {
			//Zeitbereich Ende
			static NSString *CellIdentifier = @"CellEnd";
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			}
			NSString* lblFormat = NSLocalizedString(@"export.label.options.endFormat", @"");
			cell.text = [NSString stringWithFormat:lblFormat, [TimeUtils formatDate:endDate withFormatType:2]];
			return cell;
		}
	} else if (indexPath.section == 2 && indexPath.row == 0) {
		//Projektauswahl
		static NSString *CellIdentifier = @"CellProjects";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		NSMutableString* txt = [[NSMutableString alloc] init];
		TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
		int count = [appDelegate.data count];
		if (self.projectsToExport != nil && count == [self.projectsToExport count] && count > 1) { 
			//es wurden alle projekt für den export ausgewählt, also alle als text anzeigen
			//wenn es nur ein projekt gibt diesen namen anzeigen
			[txt appendString:NSLocalizedString(@"export.label.options.allProjectsSelected", @"")];
		} else {
			//Die Namen der ausgewählten Projekt anzeugen
			if (self.projectsToExport != nil && [self.projectsToExport count] > 0) {
				if ([self.projectsToExport count] > 1) {
					//mehr als 1 Element
					int i=1;
					int count = [self.projectsToExport count];
					for (Project* p in self.projectsToExport) {
						if (i<count) {
							[txt appendString: [NSString stringWithFormat:@"%@, ", p.name]];
						} else {
							[txt appendString: [NSString stringWithFormat:@"%@", p.name]]; //letzter Eintrag ohne Komma
						}
						i++;
					}
				} else {
					//genau 1 Element
					Project* p = (Project*) [self.projectsToExport objectAtIndex:0];
					[txt appendString: p.name];
				}
			}
		}
		cell.text = txt;
		return cell;
		
	}
	
	return nil;
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {		
		return NSLocalizedString(@"export.label.options.chooseExportFormat", @"");
	} else 	if (section == 1) {
		return NSLocalizedString(@"export.label.options.chooseExportRange", @"");
	} else 	if (section == 2) {
		return NSLocalizedString(@"export.label.options.chooseExportProjects", @"");
	}
	return @"";
}


//DateEdit Controller starten für Start und Enddatum
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	editProjects = FALSE;
	editStartDate = FALSE;
	if (indexPath.section == 1 && indexPath.row == 0) {
		DatePickerViewController* ctl = [[DatePickerViewController alloc] initWithNibName:@"DatePickerView" bundle:nil];
		[self.navigationController pushViewController:ctl animated:TRUE];
		[ctl setDate:self.startDate];		
		ctl.masterController = self;
		dateCtl = ctl;
		editStartDate = TRUE;
		[ctl release];
	} else if (indexPath.section == 1 && indexPath.row == 1) {
		DatePickerViewController* ctl = [[DatePickerViewController alloc] initWithNibName:@"DatePickerView" bundle:nil];
		[self.navigationController pushViewController:ctl animated:TRUE];
		[ctl setDate:self.endDate];
		ctl.masterController = self;		
		dateCtl = ctl;
		editStartDate = FALSE;		
		[ctl release];
	} else if (indexPath.section == 2 && indexPath.row == 0) {
		//Projekte für Export auswählen
		editProjects = TRUE;
		//TODO
		ProjectSelectionTableViewController* ctl = [[ProjectSelectionTableViewController alloc] initWithNibName:@"ProjectSelectionTableView" bundle:nil];
		[self.navigationController pushViewController:ctl animated:TRUE];

		TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
		if (self.projectsToExport == nil) {
			self.projectsToExport = [[NSMutableArray alloc] init];
			for (Project* p in appDelegate.data) {
				[self.projectsToExport addObject:p];
			}
		}
		NSMutableArray* tmp = [NSMutableArray arrayWithArray:self.projectsToExport];
		
		ctl.projectsForExport = tmp;
		ctl.masterController = self;
		editingCtl = ctl;
		[ctl release];		
	}
}

//Datum bearbeiten abgeschlossen
-(void) editingFinished {
	
	if (editProjects) { 
		//selektierte Projekte übernehmen
		//TODO sicherstellen, dass mind. ein Projekt selektiert ist
		ProjectSelectionTableViewController* ctl = (ProjectSelectionTableViewController*) editingCtl;
		[self.projectsToExport removeAllObjects];
		[self.projectsToExport addObjectsFromArray:ctl.projectsForExport];
	} else {
	
		//TODO Prüfen dass Anfang nicht nach Ende liegt
		if (editStartDate) {		
			//Datum holen und Uhrzeit auf 00:00 Uhr setzen
			self.startDate = [[TimeUtils getStartTimeForDay:dateCtl.datePicker.date] retain];
		} else {
			//Datum holen und Uhrzeit auf 23:59 Uhr setzen
			self.endDate = [TimeUtils getEndTimeForDay:dateCtl.datePicker.date];;
		}
	}
	
	[self.tableView reloadData];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 || indexPath.section == 2) return indexPath;
	return nil; //no row selection is allowed
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 || indexPath.section == 2)
		return UITableViewCellAccessoryDisclosureIndicator;
	else 
		return UITableViewCellAccessoryNone;
}


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



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}



- (void)dealloc {
	[startDate release];
	[endDate release];
	[projectsToExport release];
    [super dealloc];
}


@end

