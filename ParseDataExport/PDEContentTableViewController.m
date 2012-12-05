//
//  PDEContentTableViewController.m
//  ParseDataExport
//
//  Created by Matt Salmon on 5/12/12.
//  Copyright (c) 2012 Lab82. All rights reserved.
//

#import "PDEContentTableViewController.h"

@interface PDEContentTableViewController ()

@end

@implementation PDEContentTableViewController

@synthesize dataStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"Table view awaken");
    [self setup];
}

- (void)setup
{
    [self.exportCSVButton setEnabled:NO];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateClass:) name:@"PDEUpdateTable" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:@"PDEDataUpdated" object:nil];
}

- (void)updateClass:(id)sender
{
    NSString *className = [[sender userInfo] objectForKey:@"Class"];

    if (!self.dataStore)
        self.dataStore = [[PDEDataStore alloc] initWithClassName:className];
    else
        self.dataStore.className = className;
    
    NSLog(@"update class now...");
}

- (void)updateData:(id)sender
{
    //[self.exportCSVButton setEnabled:YES];

    NSLog(@"update data now...");
    NSArray *columns = [[dataStore.tableData lastObject] allKeys];
   
    for (NSString *columnName in columns)
    {
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:columnName];
        [column.headerCell setTitle:columnName];
        [self.tableView addTableColumn:column];
    }
 
    [self.tableView reloadData];
}


- (id) tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    if (!dataStore.tableData)
        return nil;
    
    return [[dataStore.tableData objectAtIndex:rowIndex] objectForKey:aTableColumn.identifier];
}


// just returns the number of items we have.
- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    if (!dataStore.tableData)
        return 0;
    
    int result = (int)dataStore.tableData.count;
    return result;
}


- (NSString*)dataAsTabDelimitedString
{
    // returns the current data content of the array as a tab-delimited
    // string. The string is formatted into lines with each line representing
    // a row. Each
    // element in the array contributes by supplying its value using the -
    // stringValue method.
    
    unsigned  j, k, c;
    NSMutableString* string = [NSMutableString string];
    id  object;
    
    for( c = 0; c < self.tableView.numberOfColumns; ++c)
    {
        NSString *keyName = [[dataStore.tableData lastObject] allKeys][c];
                
        [string appendFormat:@"%@\t", keyName];
    }
    [string appendString:@"\n"];
    
    for( j = 0; j < [self numberOfRowsInTableView:self.tableView]; ++j )
    {
        for( k = 0; k < self.tableView.numberOfColumns; ++k )
        {
            NSString *keyName = [[dataStore.tableData lastObject] allKeys][k];
            object = [[dataStore.tableData objectAtIndex:j] objectForKey:keyName];

            NSString *objectString = nil;
            
            if ([object isKindOfClass:[NSString class]])
            {
                objectString = object;
            }
            else if ([object isNotEqualTo:[NSNull null]] && object != nil && [object respondsToSelector:@selector(stringValue)])
            {
                objectString = [object stringValue];
            }
            
            [string appendFormat:@"%@\t", objectString];
        }
        [string appendString:@"\n"];
    }
    
    NSLog(@"CSV: %@", string);
    return string;
}

- (IBAction)exportCSV:(id)sender {
    [self dataAsTabDelimitedString];
}

- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem
{
    if (self.dataStore.tableData)
        return YES;
    
    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"PDEUpdateTable"];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"PDEDataUpdated"];
}



@end
