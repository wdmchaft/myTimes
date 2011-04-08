//
//  RootViewController.m
//  TaskTracker
//
//  Created by Michael Anteboth on 10.01.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"
#import "Project.h"
#import "ProjectEditViewController.h"
#import "ProjectDetailsViewController.h"
#import "AppInfoViewController.h"
#import "CsvExportHelper.h"
#import "ProjectCell.h"
#import "CalendarTableViewController.h"
#import "CalendarTableView.h"
#import "CalendarTableViewModel.h"
#import "TimeWorkUnit.h"
#import "WorkUnitDetailsTableViewController.h"
#import "HelpViewController.h"
#import "WorkUnitDetailsTableViewController.h"
#import "WorkUnitsListViewController.h"
#import "TimeEntryViewController.h"
#import "NSDataAddition.h"
#import "ImportUrlViewController.h"

@implementation RootViewController

@synthesize data;
@synthesize addButtonItem;
@synthesize editElementButtonItem;
@synthesize emailButtonItem;
@synthesize calButtonItem;
@synthesize helpButtonItem;
@synthesize newWorkUnitButton;
@synthesize importButtonItem;

#define ROW_HEIGHT 60

#pragma mark -
#pragma mark actions

//Opens the calendar view
- (IBAction)openCalendarView:(id)sender {
	CGRect frame = [self.tableView frame];	
	//current date
	calViewDay = [[NSDate date] retain];	
	//init controller
	CalendarTableViewController* calCtl = [[CalendarTableViewController alloc] init];	
	//and view
	CalendarTableView* calView = [[CalendarTableView alloc] initWithFrame:frame];
	
	//connect them
	calCtl.view = calView;
	calView.delegate = calCtl;
	calView.dataSource = calCtl;
	calView.calendarDelegate = self; //CalendarTableViewDelegate is implemented by this class
	
	//show calendar view
	[self.navigationController pushViewController:calCtl animated:YES];
	
	//release resources
	[calCtl release];
	[calView release];
	
	//hide the toolbar
	[toolbar setHidden:TRUE];	
}

//popups the ImportUrlInpit view
-(IBAction)importButtonPressed:(id)sender {
	//create the controller
	ImportUrlViewController* ctl = [[ImportUrlViewController alloc] initWithNibName:@"ImportUrlViewController" bundle:nil];
	//popup as model view
	[self.navigationController presentModalViewController:ctl animated:TRUE];
	//release controller
	[ctl release];
}
#pragma mark -
#pragma mark AlertView mwthods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	/*if (buttonIndex == 2) return;
	else {
		BOOL addProjects = buttonIndex == 0;
		NSString* urlString = txtUrl.text;
		if ([urlString length] > 0) {
			[appDelegate importFromUrl:urlString addAsNewProjects:addProjects];
		}
	}*/
}

#pragma mark -
#pragma mark Mail Export methods
//email action
- (IBAction)emailButonPressed:(id)sender {
	//at first popup the export settings controller to let the user customize the data to export
	ExportSettingsViewController *ctl = [[ExportSettingsViewController alloc] initWithNibName:@"ExportSettingsView" bundle:nil];
	ctl.csvEnabled = TRUE;
	ctl.xmlEnabled = TRUE;	
	NSDate* startDate = [self getFirstDateInProjects:appDelegate.data];
	ctl.startDate = startDate;
	ctl.endDate = [NSDate date];		
	ctl.projectsToExport = [NSMutableArray arrayWithArray:self.data];
	
//	settingsController = ctl;
	
	[self.navigationController pushViewController:ctl animated:TRUE];
	//[self presentModalViewController:ctl animated:TRUE];
	[ctl release];	
}

//create the mail form with the data to export and let the user enter the receiver adress and send the mail
- (void) sendExportMail:(ExportSettingsViewController*) ctl {
 	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	//get default export mail adress(es) separated by semicolon if there are more than one
	NSString* sReceiver = [[NSUserDefaults standardUserDefaults] stringForKey:@"defaultExportEmailAdress"];
	NSArray *receivers = [sReceiver componentsSeparatedByString:@";"];
	if (receivers != nil && [receivers count] > 0) {
		[picker setToRecipients:receivers];
	}
	//set subject
	[picker setSubject:NSLocalizedString(@"export.label.subject.text", @"")];
	//and email body
	NSString *emailBody = NSLocalizedString(@"export.label.body.text", @"");	
	
	//filter projects by start and end date
	NSDate* startDate = ctl.startDate;// [self getFirstDateInProjects:appDelegate.data];
	NSDate* endDate = ctl.endDate; //[NSDate date];
	NSArray* projects = [self markDataForExport:appDelegate.data startDate:startDate endDate:endDate projectsToExport:ctl.projectsToExport];	

	//get XML Data
	NSString* xml = [XMLHelper getXmlData:projects];
	NSData* xmlData = [xml dataUsingEncoding:NSUTF8StringEncoding];

	//for pre iOS3.2 devices attach the backup data as link with encapsulated data
	NSString* base64xml = [xmlData base64Encoding];
	NSString* importLinkText = NSLocalizedString(@"export.label.importLinkText", @"");
	emailBody = [emailBody stringByAppendingString:[NSString stringWithFormat:@"%@ <a href=\"mytimes://?importdata=%@\">Import Link</a>", importLinkText,	base64xml]];
	
	//for iOS3.2+ devices just attach the data as "backup.mtb" file
	NSData* backupData = [NSKeyedArchiver archivedDataWithRootObject:ctl.projectsToExport];
	[picker addAttachmentData:backupData mimeType:@"application/octet-stream" fileName:@"mytimes-backup.mtb"];

	if (ctl.xmlEnabled) {
		//add attachment
		[picker addAttachmentData:xmlData mimeType:@"application/xml" fileName:@"export.xml"];		
	}
	
	if (ctl.csvEnabled) {
		//get CSV data
		NSString* csv = [CsvExportHelper getCsvExportData:projects];
		NSData* csvData = [csv dataUsingEncoding:NSUTF8StringEncoding];
		//add attachment
		[picker addAttachmentData:csvData mimeType:@"text/csv" fileName:@"export.csv"];
	}
	
	[picker setMessageBody:emailBody isHTML:YES];
	
	[ctl.navigationController presentModalViewController:picker animated:TRUE];
	[picker release];
}

//Auswertung ob mail auch versandt wurde, ggf Fehlermeldung anzeigen
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			[self dismissModalViewControllerAnimated:TRUE];	
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved");
			[self dismissModalViewControllerAnimated:FALSE];
			[self.navigationController popToRootViewControllerAnimated:TRUE];
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail sent");
			[self dismissModalViewControllerAnimated:FALSE];
			[self.navigationController popToRootViewControllerAnimated:TRUE];
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Fehler bei Versenden der Mail:");
			if (error != nil) {
				NSLog([error localizedDescription]);
				[self showErrorMessage:[error localizedDescription]];
			}
			[self dismissModalViewControllerAnimated:FALSE];
			[self.navigationController popToRootViewControllerAnimated:TRUE];
			break;
	}	
}

//display an error message
-(void) showErrorMessage:(NSString*)msg {
	NSString* title = NSLocalizedString(@"export.error.title", @"");
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}

//Liefert das erste Datum(früheste) aus der Projektliste
-(NSDate*) getFirstDateInProjects:(NSArray*)projects {
	NSDate* begin = [[NSDate date] retain];
	
	if (projects != nil) {
		for (Project* p in projects) {
			for (ProjectTask* pt in p.tasks) {
				for (TimeWorkUnit* wu in pt.workUnits) {
					//Datum vergleichen und älteres merken
					begin = [wu.date earlierDate:begin];
				}
			}
		}
	}
	
	return begin;
}

//Markieren der Einträge für den Export, nur die Einträge benutzen die den Filterkriterien entsprechen.
//also zwischen start und end liegen
-(NSArray*) markDataForExport:(NSArray*)pdata startDate:(NSDate*)start endDate:(NSDate*)end projectsToExport:(NSMutableArray*)projects {
	for (Project* p in pdata) {
		p.markedForExport = FALSE; //erstmal für export abwählen
		for (ProjectTask* pt in p.tasks) {
			pt.markedForExport = FALSE; //erstmal für export abwählen
			for (TimeWorkUnit* wu in pt.workUnits) {
				wu.markedForExport = FALSE; //erstmal für export abwählen
				//Prüfen ob Startdatum des Eintrags nach dem Anfangsdatum aber vor dem Enddatum liegt
				NSComparisonResult cmp1 = [wu.date compare:start];
				if (cmp1 == NSOrderedSame || cmp1 == NSOrderedDescending) {
					NSComparisonResult cmp2 = [wu.date compare:end];
					if (cmp2 == NSOrderedSame || cmp2 == NSOrderedAscending) {
						//Datum des Eintrags liegt zwischen start und ende
						//also Eintrag zum Export markieren
						wu.markedForExport = TRUE;
						//Project und Task auch markieren
						p.markedForExport = TRUE;
						pt.markedForExport = TRUE;
					} 
				}
			}
		}
		
		//prüfen ob das Projekt auch in der liste der zu exportierenden Projekt enthalten ist
		//wenn nicht, Projekt nicht für den export markieren
		if (p.markedForExport &&  projects != nil) { //wenn nil, wurde nicht gefiltert, also alle Projekt ausgeben
			if ( ! [projects containsObject:p]) {
				p.markedForExport = FALSE;
			}
		}
		
	}
	return pdata;
}

#pragma mark -
#pragma mark other methods

//edit a project either in edit mode or in creation mode
-(void) editProject:(Project*)p editMode:(BOOL)editMode {
	//create ProjectEditView
	ProjectEditViewController* ctl = [[ProjectEditViewController alloc] initWithNibName:@"ProjectEditView" bundle:nil];
	//set project in controller
	ctl.project = p;
	ctl.isInEditMode = editMode;
	//show details controller as modal controller
	[self.navigationController presentModalViewController:ctl animated:YES];
	[ctl release];
}

//open the workUnit dialog work creating a new item
- (void) addNewWorkUnit:(id)sender {
	TimeWorkUnit* wu = [[TimeWorkUnit alloc] init];
	//set the default start/end/pase values if the user enabled default values in the settings 
	if (appDelegate.useDefaultTimes) {
		//set pause value
		int pauseValue = appDelegate.defaultPauseValue * 60;
		wu.pause = [NSNumber numberWithInt:pauseValue]; //defaultValue in min * 60(sec)
		
		if (appDelegate.defaultStartTime != nil) {
			//set default start date-time
			wu.date = appDelegate.defaultStartTime;
		}
		
		if (appDelegate.defaultEndTime != nil) {
			//calculate the duration and set it
			//duration = end - start - pause (in secs)
			int diff = [appDelegate.defaultEndTime timeIntervalSinceDate:appDelegate.defaultStartTime];
			diff -= pauseValue;
			if (diff < 0) diff = 0;
			wu.duration = [NSNumber numberWithInt:diff];
		}
	}
	
	//create WorkUnitEditView
	WorkUnitDetailsTableViewController* ctl = [[WorkUnitDetailsTableViewController alloc] initWithNibName:@"WorkUnitDetailsView" bundle:nil];
	//tell the controller that we only edit an existing work unit
	ctl.workUnitAddMode = TRUE;
	
	//set project
	ctl.parentProject = nil;
	if ([appDelegate.addItemController isKindOfClass:[ProjectDetailsViewController class]]) {
		ProjectDetailsViewController* c = (ProjectDetailsViewController*) appDelegate.addItemController;
		ctl.parentProject = c.project;
	} 
	
	//set project task
	ctl.parentTask = nil;
	if ([appDelegate.addItemController isKindOfClass:[WorkUnitsListViewController  class]]) {
		WorkUnitsListViewController* c = (WorkUnitsListViewController*) appDelegate.addItemController;
		ctl.parentProject = c.parentProject;
		ctl.parentTask = c.task;
		ctl.parentController = c;
	}
	
	//set workUnit in controller
	ctl.workUnit = wu;
	//set parent table to reload table view after WorkUnit creation
	ctl.parentTable = appDelegate.currentTableView;

	//popup the view controller
	[self.navigationController pushViewController:ctl animated:YES];	
	[ctl release];	
}


//add a new project(start editor in add mode)
-(void) addItem{
	//create new project object
	Project* p = [[Project alloc] init];
	//start editing
	[self editProject:p editMode:FALSE];
}

//edit the selectem table item (project)
- (void) editSelectedItem {
	if (selectedRow > -1) {
		int row = selectedRow;
		Project* p = [self.data objectAtIndex:row];
		
		if ( ! p.userChangeable) {
			//leave method if the project is not editable
			return;
		}
		
		//start editing
		[self editProject:p editMode:TRUE];
	}
}

	
//global create a new item
- (IBAction)addItem:(id)sender {
	[appDelegate.addItemController addItem];
}
//global edit the selected element
- (IBAction)editItem:(id)sender {
	[appDelegate.addItemController editSelectedItem];
}

/**
 * Popup the Help View
 */
-(void) showHelpView:(id)sender {
	HelpViewController* ctl = [[HelpViewController alloc] initWithNibName:@"HelpView" bundle:nil];
	[self.navigationController presentModalViewController:ctl animated:true];
	[ctl release];	
}

/**
 * Popup the Info view
 **/
- (void) infoAction {
	//create and show info view
	AppInfoViewController* ctl = [[AppInfoViewController alloc] initWithNibName:@"AppInfoView" bundle:nil];
	[self.navigationController presentModalViewController:ctl animated:true];
	[ctl release];
}

-(void) enabledGlobalButtons:(BOOL)enabled sender:(id) sender {
	addButtonItem.enabled = enabled;
	editElementButtonItem.enabled = enabled;
	calButtonItem.enabled = enabled;
	newWorkUnitButton.enabled = enabled;
	//email&import button is only in project view enabled
	if (sender == self) {
		emailButtonItem.enabled = enabled;
		importButtonItem.enabled = enabled;
	}
}

- (void)viewDidLoad {
	firstViewLoad = TRUE;
    [super viewDidLoad];
	
	//setting row height of each row to 60
	UITableView* table = self.tableView;
	table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	table.rowHeight = ROW_HEIGHT;
    
	self.navigationItem.rightBarButtonItem = self.editButtonItem;	

	appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[self initToolbar];
		
}

- (void)viewWillAppear:(BOOL)animated {
	selectedRow = -1;
	self.navigationController.navigationBarHidden = FALSE;
	[super viewWillAppear:animated];

	//set current table view in appDelegate to be able to edit all the tables on the views with a unique mechanism
	appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentTableView = self.tableView;
	appDelegate.rootViewController = self;
	appDelegate.addItemController = self;
	
	//create and init new data array
	self.data = appDelegate.data;
	
	//Reload the table view
	[self.tableView reloadData];
	
	[emailButtonItem setEnabled:TRUE];
	[importButtonItem setEnabled:TRUE];	
}

-(void) initToolbar {
	//Initialize the toolbar
	toolbar = [[UIToolbar alloc] init];
	[toolbar setHidden:FALSE];
	toolbar.barStyle = UIBarStyleDefault;
	
	//Set the toolbar to fit the width of the app.
	[toolbar sizeToFit];
	
	//Caclulate the height of the toolbar
	CGFloat toolbarHeight = [toolbar frame].size.height;
	
	//Get the bounds of the parent view
	CGRect rootViewBounds = self.parentViewController.view.bounds;
	
	//Get the height of the parent view.
	CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
	
	//Get the width of the parent view,
	CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
	
	//Create a rectangle for the toolbar
	CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
	
	//Reposition and resize the receiver
	[toolbar setFrame:rectArea];
	
	
	//create the info button
	// einen Button vom Typ info button erzeugen
	UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	// wir legen fest, welche Funktion aufgerufen wird, wenn der button angeklickt wird
	[infoButton addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
	// der button soll in der Navigationsleiste zu sehen sein
	// also erstellen wir aus dem button ein UIBarButtonItem Objekt um dieses auf der Navigationsleiste abzulegen
	UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	
	
	//space between buttons
	UIBarButtonItem* flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace  target:nil action:nil];
	UIBarButtonItem* flexButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace  target:nil action:nil];	
	
	//Button created in RootViewController.xib
	[toolbar setItems:[NSArray arrayWithObjects:newWorkUnitButton, addButtonItem, calButtonItem, emailButtonItem, importButtonItem, flexButton, flexButton2, infoButtonItem, nil]];
	
	//Add the toolbar as a subview to the navigation controller.
	[self.navigationController.view addSubview:toolbar];
	
	// die interne Speicherverwaltung für das ButtonItem haben wir an die Navigationsleiste abgegeben
	// dadurch können wir den Anspruch auf den "Besitz" dessen abgeben
	[infoButtonItem release];
	[flexButton release];
	[flexButton2 release];
	
	[emailButtonItem setEnabled:FALSE];
	[importButtonItem setEnabled:FALSE];	
}	

- (void)viewDidAppear:(BOOL)animated {
	selectedRow = -1;
    [super viewDidAppear:animated];
	
	self.tableView.allowsSelectionDuringEditing = TRUE;
		
	if (appDelegate.projectToLoadAtStartup != nil) {
		Project* p = appDelegate.projectToLoadAtStartup;
		int row = [self.data indexOfObject:p];
		//load a project a startup
		NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:0];
		//scroll down to active project
		[self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:FALSE];
		UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:path];
		//select the row
		[cell setSelected:TRUE];
		//open the active project an show its task list
		[self tableView:self.tableView didSelectRowAtIndexPath:path];
		//reset project to load to nil
		appDelegate.projectToLoadAtStartup = nil;
	}
	

/*
	if (firstViewLoad) {
		[self loadTimeEntryView];
		firstViewLoad = FALSE;
	}
 */
}

- (void) loadTimeEntryView {
	toolbar.hidden = true;
//	self.navigationController.navigationBar.hidden = true;
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	TimeEntryViewController* ctl = [[TimeEntryViewController alloc] initWithNibName:@"TimeEntryView" bundle:nil];
	[self.navigationController pushViewController:ctl animated:TRUE];
}

- (void)viewWillDisappear:(BOOL)animated {
	[emailButtonItem setEnabled:FALSE];
	[importButtonItem setEnabled:FALSE];	
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark -
#pragma mark CalendarTableViewDelegate methods

//returns the current day
-(NSDate*) getDisplayedDay {
	return calViewDay;
}

//sets the current day
-(void) setDisplayedDay:(NSDate*)day {
	calViewDay = day;
	 //need to invalidate cached data
	[self clearCachedData];
}


//neede for sorting CalEvent elements
NSInteger calItemTimeSort(id obj0, id obj1, void *reverse) {
    CalEvent* c0 = (CalEvent*) obj0;
    CalEvent* c1 = (CalEvent*) obj1;
	
    NSComparisonResult comparison = [c0.date compare:c1.date];
	
    if ((BOOL *)reverse == NO) {
        return 0 - comparison;
    }
    return comparison;
}

//clear cached data 
-(void) clearCachedData {
/*	if (calEntriesForViewDay != nil) {
		[calEntriesForViewDay release];
		calEntriesForViewDay = nil; //need to invalidate cached data
	}
 */
}

-(long) getDurationOfAllEntriesForCurrentDay {
	long totalDuration=0;
	for (CalEvent* ce in [self getAllItemsForCurrentDay]) {
		totalDuration += [ce.duration intValue] - [ce.pause intValue];
	}
	return totalDuration;
}

//return CalItems array of sorted event for the current day
-(NSArray*) getAllItemsForCurrentDay {
	//use cached data if valid and existing
/*	if (calEntriesForViewDay != nil) {
		return calEntriesForViewDay;
	}
 */
	
	NSMutableArray* eventsForDay = [NSMutableArray arrayWithCapacity:5];
	
	//find all events for the current displayed day
	for (Project*p in self.data) {
		for (ProjectTask* pt in p.tasks) {
			for (TimeWorkUnit* wu in pt.workUnits) {
				//check for same day
				if ([self isSameDay:wu.date anotherDate:calViewDay]) {
					//if event is at the same day as this displayed day create a new CalEvent item
					CalEvent* ce = [[CalEvent alloc] init];
					ce.date = wu.date;
					int dur = [wu.duration intValue] + [wu.pause intValue];					
					ce.duration = [NSNumber numberWithInt:dur];
					NSString* s = [NSString stringWithFormat:@"%@ - %@", p.name, pt.name];
					ce.description = s;
					ce.pause = wu.pause;
					ce.referenceObject = wu;
					//and add the CalEvent item to the aray
					[eventsForDay addObject:ce];
				}
			}
		}
	}	
	
	//sort 'em cronologically
	BOOL reverseSort = NO;
	NSArray* sortedArray = [eventsForDay sortedArrayUsingFunction:calItemTimeSort context:&reverseSort];	
//	calEntriesForViewDay = [sortedArray retain]; //remember data
	return sortedArray;
}


-(BOOL) isSameDay:(NSDate*) day0 anotherDate:(NSDate*)day1 {
	NSCalendar* cal = [NSCalendar currentCalendar];	
	unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
	NSDateComponents *dc0 = [cal components:unitFlags fromDate:day0];
	NSDateComponents *dc1 = [cal components:unitFlags fromDate:day1];
	
	int yearDiff = dc0.year - dc1.year;
	int monthDiff = dc0.month - dc1.month;
	int dayDiff = dc0.day - dc1.day;
	
	if (yearDiff == 0 && monthDiff == 0 && dayDiff == 0)
		return true;
	else 
		return false;
}

#pragma mark -
#pragma mark Table view methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    //globale buttons de-/aktivieren
	[self enabledGlobalButtons:!editing sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) 
		return [self.data count]; 
	else 
		return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"ProjectCellView";	
	ProjectCell* cell = (ProjectCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		CGRect startingRect = CGRectMake(0.0, 0.0, 320.0, ROW_HEIGHT);
		cell = [[[ProjectCell alloc] initWithFrame:startingRect reuseIdentifier:CellIdentifier] autorelease];
	}
	
	//set the project task element in the cell view
	Project* p = [self.data objectAtIndex:[indexPath row]];
	cell.project = p;
	[cell setRow:[indexPath row]];
	[cell setCtl:self];
 	return cell;
}

-(BOOL) isRowSelected:(int)row {
	return row == selectedRow;
}

-(void) setRowSelected:(int)row selected:(BOOL) selected {
	if (selected) selectedRow = row;
	else selectedRow = -1;
}

// The accessory type is the image displayed on the far right of each table cell. In order for the delegate method
// tableView:accessoryButtonClickedForRowWithIndexPath: to be called, you must return the "Detail Disclosure Button" type.
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
  //  [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (!self.tableView.editing) {
		//wenn nicht im editiermode, das Projekt öffnen und die Teilprojekte anzeigen
		if ([indexPath row] < [self.data count]) {
			//the selected project
			Project* p = [self.data objectAtIndex:[indexPath row]];
			NSLog(@"start editing project: %@", p.name);
			//ProjectDetailsView erzeugen und anzeigen
			ProjectDetailsViewController* projectDetailsViewCtl = [[ProjectDetailsViewController alloc] initWithNibName:@"ProjectDetailsView" bundle:nil];
			projectDetailsViewCtl.project = p;
			[self.navigationController pushViewController:projectDetailsViewCtl animated:YES];
			[projectDetailsViewCtl release];
		}
	} else {
		//im editiermodus das selektiert Element editieren, also das projekt
		[appDelegate.addItemController editSelectedItem];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] < [self.data count]) {
		//the selected project
		Project* p = [self.data objectAtIndex:[indexPath row]];
		NSLog(@"start editing project: %@", p.name);
		//ProjectDetailsView erzeugen und anzeigen
		ProjectDetailsViewController* projectDetailsViewCtl = [[ProjectDetailsViewController alloc] initWithNibName:@"ProjectDetailsView" bundle:nil];
		projectDetailsViewCtl.project = p;
		[self.navigationController pushViewController:projectDetailsViewCtl animated:YES];
		[projectDetailsViewCtl release];
	}
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] < [self.data count]) {
		//check if the project is editable
		Project* p = [self.data objectAtIndex:indexPath.row];
		if (p.userChangeable) {
			return YES;
		}
	} 
	
	return NO;
	
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		Project* p = [self.data objectAtIndex:[indexPath row]];
		[self.data removeObject:p];
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
	NSMutableArray* array = self.data;
	NSUInteger fromRow = [fromIndexPath row];
	NSUInteger toRow = [toIndexPath row];
	id object = [[array objectAtIndex:fromRow] retain];
	[array removeObjectAtIndex:fromRow];
	[array insertObject:object atIndex:toRow];
	[object release];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] < [self.data count]) {
		// Return NO if you do not want the item to be re-orderable.
		return YES;
	} else return NO;
}

- (void)dealloc {
	[editElementButtonItem release];
	[addButtonItem release];
	[data release]; 
	[emailButtonItem release];
	[calButtonItem release];
	[calViewDay release];
	[toolbar release];
	[helpButtonItem release]; 
	[newWorkUnitButton release];
	[importButtonItem release];
    [super dealloc];
}

-(void) release {
	[super release];
}

@end

