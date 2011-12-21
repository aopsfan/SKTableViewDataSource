# SKTableViewDataSource

## Overview

`SKTableViewDataSource` is an Objective-C library that simplifies `NSFetchedResultsController`. Many times we need a quick way to display an array of custom object data in a sectioned list; this now very straight-forward. `SKTableViewDataSource` also implements certain `UITableViewDataSource` protocol methods so you don't have to. In short, it sorts a collection into a displayable list. Please note that `SKTableViewDataSource` is designed only for `UIKit`, so it won't work on your Mac apps.

## Compared to NSFetchedResultsController

`NSFetchedResultsController` uses a complex key-value system to sort your `UITableView`. `SKTableViewDataSource` relies on a single `sortSelector`. This way, you can section your table by non-accessor values. For instance, if you have a collection of `Dude` objects, you could sort them by the first letter of their last name (like in the Contacts app) with a `-initial` method on `Dude`. This is much less of a hassle than creating a `initial` instance variable and having to update him whenever the appropriate `Dude` 's name changes.

## Getting SKTableViewDataSource in your project

Check out the [Installation Guide](https://github.com/aopsfan/SKTableViewDataSource/wiki/Installation-Guide).

## How it works

SKTableViewDataSource takes an NSSet of custom objects, and, given a selector to sort with, creates an organized UITableView.  It implements `numberOfSectionsInTableView` and `numberOfRowsInSection:`, and produces helpful convenience methods so you can customize your table, such as `identifierForSection:` and `objectForIndexPath:`.

## Example

Let's say you have a collection of Dude objects, and your Dude.h file looks like this:

<pre><code>@interface Dude : NSObject {
    NSString *name;
    UIColor *hairColor;
    NSNumber *height;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) UIColor *hairColor;
@property (nonatomic, retain) NSNumber *height;

- (id)initWithName:(NSString *)aName hairColor:(UIColor *)aHairColor height:(NSNumber *)aHeight;

@end
</code></pre>

To create a table displaying Dudes and organized by height, here are the necessary steps:

1. Create a `compare:` method on Dude. SKTableViewDataSource automatically calls this method on each of your Dudes to sort the cells for each section:

<pre><code>- (NSString *)lastName {
    NSArray *arrayOfNames = [self.name componentsSeparatedByString:@" "]; // Get an array of names (i.e. @"Guy", @"Moron", @"Idiot" from @"Guy Moron Idiot");
    return [arrayOfNames objectAtIndex:[arrayOfNames count]-1]; // Return the last one
}

- (NSComparisonResult)compare:(Dude *)otherDude {
    NSComparisonResult comparisonResult = [[self lastName] compare:[otherDude lastName]]; // Compare the last names
    
    if (comparisonResult == NSOrderedSame) {
        return [[self name] compare:[otherDude name]]; // If the last names are the same, use the first name for ordering as well.
    }
    
    return comparisonResult;
}</code></pre>

This will order Dude objects in each section by their name.

2. Update your UITableViewController's header file to subclass SKTableViewController:

<pre><code>#import "SKTableViewDataSource.h"

@interface SKTestTableViewController : SKTableViewController
@end</code></pre>

3. Update your controller's `.m` file to use SKTableViewDataSource:

In `initWithStyle`:
<pre><code>Dude *emily      = [[[Dude alloc] initWithName:@"Emily Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]] autorelease];
Dude *tom        = [[[Dude alloc] initWithName:@"Tom Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]] autorelease];
Dude *emilysTwin = [[[Dude alloc] initWithName:@"Ylime Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]] autorelease];
Dude *tomsTwin   = [[[Dude alloc] initWithName:@"Mot Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]] autorelease];
Dude *guy        = [[[Dude alloc] initWithName:@"Guy Moron Idiot" hairColor:[UIColor blackColor] height:[NSNumber numberWithInt:67]] autorelease];

[dataSource setObjects:[NSSet setWithObjects:emily, tom, emilysTwin, tomsTwin, guy, nil]];
dataSource.sortSelector = @selector(height);

self.title = @"Dudes";
</code></pre>

`dataSource setObjects` lets your data source know what set of data to format for your tables.
<code>dataSource.sortSelector = @selector(height)</code> tells the dataSource to section the table by the height method on Dude. (Remember, getters are still methods.)

Make sure the `numberOfSectionsInTableView` and `numberOfRowsInSection:` methods are not implemented; SKTableViewDataSource will do this job.

If you'd like section headers, implement `titleForHeaderInSection:`

<pre><code>- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [(NSNumber *)[dataSource identifierForSection:section] stringValue];
}</code></pre>

Since we're sectioning Dudes by their height, which is an `NSNumber`, we must convert it to an NSString.

In `cellForRowAtIndexPath:`

<pre><code>Dude *dude = (Dude *)[dataSource objectForIndexPath:indexPath];
cell.textLabel.text = dude.name;</code></pre>

Here we use SKTableViewDataSource's `objectForIndexPath:` method to find a Dude object, then display his name.

### Thats It! Your table should look like this:

![That didn't take long](https://github.com/aopsfan/SKTableViewDataSource/raw/master/screenshot.png)

## Doing More

### cellForObject:

If you're implementing the SKTableViewDataSource protocol (this is automatic when subclassing `SKTableViewController`), you can implement `- (UITableViewCell *)cellObject:(id)object` instead of `tableView:cellForRowAtIndexPath:`. You can then replace your cell configuration lines with this one:

<pre><code>cell.textLabel.text = [(Dude *)object name];</code></pre>

### Ascending and Descending

If you'd like to order your sections descending, simply add this line to your `initWithStyle:` method in your controller:

<pre><code>dataSource.sectionOrderAscending = NO;</code></pre>

Likewise, run <code>dataSource.rowOrderAscending = NO;</code> to order the rows in each section descending.

### Fun with the sortSelector

If you'd like to section Dudes by the first letter of their last name, follow these steps:

1: Implement an `initial` method on Dude:

<pre><code>- (NSString *)initial {
    NSArray *arrayOfNames = [self.name componentsSeparatedByString:@" "];
    NSString *lastName = [arrayOfNames objectAtIndex:[arrayOfNames count]-1];
    unichar newChar = [lastName characterAtIndex:0];
    NSString *initial = [NSString stringWithFormat:@"%C", newChar];
    
    return initial;
}</code></pre>

2. Change your `dataSource` 's `sortSelector`:

<pre><code>dataSource.sortSelector = @selector(initial);</code></pre>

3. Update `titleForHeaderInSection:`

<pre><code>return (NSString *)[dataSource identifierForSection:section];</code></pre>

### SKTableViewDataSource protocol

If you's like to have more control over your table, you can try out the SKTableViewDataSource protocol, which includes delegate-like methods for you to implement. So far, the protocol includes the following methods: `contentUpdated`, `objectAdded:`, and `objectDeleted:`. Other than conforming to the `SKTableViewDataSource` protocol in your controller's `.h` file, no additional setup is required; in fact, even this isn't necessary when subclassing `SKTableViewController`.

### Filtering data

If you would like to filter out certain `Dude` objects, you can use an `SKDataFilter`. For instance, to exclude dudes with a height of 67, you can run this code:

<pre><code>SKDataFilter *filter = [SKDataFilter where:@"height" isNotEqualTo:[NSNumber numberWithInt:67]];
[dataSource addFilter:filter];
[self.tableView reloadData];</code></pre>

You can then run `[dataSource removeFilter:filter]` to restore it to it's original data.
