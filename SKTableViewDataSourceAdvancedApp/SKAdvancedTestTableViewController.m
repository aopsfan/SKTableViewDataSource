//
//  SKAdvancedTestTableViewController.m
//  SKTableViewDataSource
//
//  Created by Bruce Ricketts on 4/13/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import "SKAdvancedTestTableViewController.h"
#import "Dude.h"

@implementation SKAdvancedTestTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        Dude *emily      = [[[Dude alloc] initWithName:@"Emily Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]] autorelease];
        Dude *tom        = [[[Dude alloc] initWithName:@"Tom Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]] autorelease];
        Dude *emilysTwin = [[[Dude alloc] initWithName:@"Ylime Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]] autorelease];
        Dude *tomsTwin   = [[[Dude alloc] initWithName:@"Mot Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]] autorelease];
        Dude *guy        = [[[Dude alloc] initWithName:@"Guy Moron Idiot" hairColor:[UIColor blackColor] height:[NSNumber numberWithInt:67]] autorelease];
        data = [[NSSet alloc] initWithObjects:emily, tom, emilysTwin, tomsTwin, guy, nil];
        
        dataSource = [[SKTableViewDataSource alloc] initWithSet:data];
        dataSource.methodSource = self;
        dataSource.sectionOrderAscending = YES;
        dataSource.sortSelector = @selector(initial);
        
        self.tableView.dataSource = dataSource;
        
        self.title = @"Dudes";
    }
    return self;
}

- (void)dealloc
{
    [data release];
    [dataSource release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *segmentedControl = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Name", @"Height", nil]] autorelease];
    UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithCustomView:segmentedControl] autorelease];
    
    self.toolbarItems = [NSArray arrayWithObject:item];
    self.navigationController.toolbarHidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - SKTableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (NSString *)[dataSource objectForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Dude *dude = (Dude *)[dataSource objectForIndexPath:indexPath];
    cell.textLabel.text = dude.name;
    
    // Configure the cell...
    
    return cell;
}

@end
