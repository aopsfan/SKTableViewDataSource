//
//  SKAdvancedTestTableViewController.m
//  SKTableViewDataSource
//
//  Created by Bruce Ricketts on 4/13/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import "SKAdvancedTestTableViewController.h"
#import "Transaction.h"

@implementation SKAdvancedTestTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        Transaction *apples = [[[Transaction alloc] initWithTitle:@"Apples" price:2.19 date:[NSDate date]] autorelease];
        Transaction *oranges = [[[Transaction alloc] initWithTitle:@"Four Oranges" price:3.99 date:[NSDate date]] autorelease];
        Transaction *pears = [[[Transaction alloc] initWithTitle:@"Five Pears" price:8.29 date:[NSDate date]] autorelease];
        
        Transaction *lunchable = [[[Transaction alloc] initWithTitle:@"Lunchable!" price:2.99
                                                                date:[NSDate dateWithTimeIntervalSinceNow:86400]] autorelease];
        Transaction *burger = [[[Transaction alloc] initWithTitle:@"Five Guys burger" price:4.99
                                                             date:[NSDate dateWithTimeIntervalSinceNow:86400]] autorelease];
        
        Transaction *plunger = [[[Transaction alloc] initWithTitle:@"Plunger; the old one broke" price:9.99
                                                              date:[NSDate dateWithTimeIntervalSinceNow:-86400]] autorelease];
        
        data = [[NSSet alloc] initWithObjects:apples, oranges, pears, lunchable, burger, plunger, nil];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        dataSource = [[TransactionDataSource alloc] initWithSet:data];
        dataSource.methodSource = self;
        dataSource.sectionOrderAscending = NO;
        dataSource.sortSelector = @selector(displayableDate);
        
        self.tableView.dataSource = dataSource;
        
        self.title = @"Transactions";
    }
    return self;
}

- (void)dealloc
{
    [data release];
    [dataSource release];
    [dateFormatter release];
    [numberFormatter release];
    
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
    return [dateFormatter stringFromDate:(NSDate *)[dataSource identifierForSection:section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Transaction *transaction = (Transaction *)[dataSource objectForIndexPath:indexPath];
    cell.textLabel.text = transaction.title;
    cell.detailTextLabel.text = [numberFormatter stringFromNumber:transaction.price];
    
    return cell;
}

@end
