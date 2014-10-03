//
//  PDEContentTableViewController.m
//  ParseDataExport
//
//  Created by Matt Salmon on 5/12/12.
//  Copyright (c) 2012 Lab82. All rights reserved.
//

#import "PDEContentTableViewController.h"
#import <ParseOSX/Parse.h>

@interface PDEContentTableViewController ()

@end

@implementation PDEContentTableViewController

@synthesize dataStore;

- (id)initWithNibName:(NSString*)nibNameOrNil
               bundle:(NSBundle*)nibBundleOrNil
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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateClass:)
                                                 name:@"PDEUpdateTable"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateData:)
                                                 name:@"PDEDataUpdated"
                                               object:nil];
}

- (void)updateClass:(id)sender
{
    NSString* className = [[sender userInfo] objectForKey:@"Class"];

    if (!self.dataStore) {
        self.dataStore = [[PDEDataStore alloc] initWithClassName:className keyNames:@[ @"name", @"imageFile" ]];
    } else {
        self.dataStore.className = className;
    }

    NSLog(@"update class now...");
}

- (void)updateData:(id)sender
{
    NSArray* columns = [[dataStore.tableData firstObject] allKeys];
    for (NSString* columnName in columns) {
        NSTableColumn* column =
            [[NSTableColumn alloc] initWithIdentifier:columnName];
        [column.headerCell setTitle:columnName];
        [self.tableView addTableColumn:column];
    }

    [self.tableView reloadData];
}

- (id)tableView:(NSTableView*)aTableView
    objectValueForTableColumn:(NSTableColumn*)aTableColumn
                          row:(int)rowIndex
{
    if (!dataStore.tableData)
        return nil;

    if ([aTableColumn.identifier isEqualToString:@"imageFile"]) {
        [[dataStore.tableData objectAtIndex:rowIndex] fetchIfNeeded];
        id object = [[dataStore.tableData objectAtIndex:rowIndex]
            objectForKey:aTableColumn.identifier];
        if (object) {
            if ([object isKindOfClass:[PFFile class]]) {
                PFFile* file = (PFFile*)object;
                if (file) {
                    return [file url];
                } else {
                    return @"";
                }
            }
        }
    } else {
        id object = [[dataStore.tableData objectAtIndex:rowIndex]
            objectForKey:aTableColumn.identifier];

        if (![object isKindOfClass:[PFRelation class]] && ![object isKindOfClass:[PFFile class]] && ![object isKindOfClass:[PFUser class]]) {
            if ([object isKindOfClass:[PFObject class]]) {
                PFObject* pfobject = (PFObject*)object;
                NSString* className = @"Colleges";
                if ([pfobject.parseClassName isEqualToString:className]) {
                    [pfobject fetchIfNeeded];
                    return [pfobject objectForKey:@"name"];
                }
            } else {
                return object;
            }
        }
    }

    return @"";
}

// just returns the number of items we have.
- (int)numberOfRowsInTableView:(NSTableView*)aTableView
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

    NSMutableString* string = [NSMutableString string];

    // Add titles
    //  for (c = 0; c < self.tableView.numberOfColumns; ++c) {
    //    NSString *keyName = [[dataStore.tableData firstObject] allKeys][c];
    //    [string appendFormat:@"%@\t", keyName];
    //    NSLog(@"Key name %@", keyName);
    //
    //  }
    //  [string appendString:@"\n"];

    //  - (id)tableView:(NSTableView *)aTableView
    //objectValueForTableColumn:(NSTableColumn *)aTableColumn
    //row:(int)rowIndex {

    for (int i = 0; i < self.tableView.numberOfRows; i++) {
        // for each row.
        for (int c = 0; c < self.tableView.numberOfColumns; c++) {
            if (self.dataStore.keyNames.count >= c) {
                NSTableColumn* tc = [[NSTableColumn alloc] initWithIdentifier:[self.dataStore.keyNames objectAtIndex:c]];

                id printableValue = [self tableView:self.tableView objectValueForTableColumn:tc row:i];
                if ([printableValue isKindOfClass:[NSString class]]) {
                    [string appendFormat:@"%@\t", printableValue];
                }
            }
        }
        [string appendString:@"\n"];
    }

    //
    //
    //
    //  for (j = 0; j < [self numberOfRowsInTableView:self.tableView]; ++j) {
    //    for (k = 0; k < self.tableView.numberOfColumns; ++k) {
    //      NSString *keyName = [[dataStore.tableData firstObject] allKeys][k];
    //      NSLog(@"Key name %@", keyName);
    //      NSString *objectString = nil;
    //
    //      if ([keyName isEqualToString:@"imageFile"]) {
    //        [[dataStore.tableData objectAtIndex:j] fetchIfNeeded];
    //        id object = [[dataStore.tableData objectAtIndex:j]
    //                     objectForKey:keyName];
    //        if (object) {
    //          if ([object isKindOfClass:[PFFile class]]) {
    //            PFFile *file = (PFFile *)object;
    //            if (file) {
    //              objectString = [file url];
    //            }
    //          }
    //        }
    //      } else {
    //        object = [[dataStore.tableData objectAtIndex:j] objectForKey:keyName];
    //        if ([object isKindOfClass:[PFObject class]]) {
    //          PFObject *pfobject = (PFObject *)object;
    //          NSString *className = @"Colleges";
    //          if ([pfobject.parseClassName isEqualToString:className]) {
    //            [pfobject fetchIfNeeded];
    //            objectString = [pfobject objectForKey:@"name"];
    //          }
    //        } else if ([object isKindOfClass:[NSString class]]) {
    //          objectString = object;
    //        } else if ([object isNotEqualTo:[NSNull null]] && object != nil &&
    //                   [object respondsToSelector:@selector(stringValue)]) {
    //          objectString = [object stringValue];
    //        }
    //      }
    //      [string appendFormat:@"%@\t", objectString];
    //    }
    //    [string appendString:@"\n"];
    //  }

    return string;
}

- (IBAction)exportCSV:(id)sender
{

    NSSavePanel* save = [NSSavePanel savePanel];
    [save setAllowedFileTypes:[NSArray arrayWithObject:@"csv"]];
    [save setAllowsOtherFileTypes:NO];

    NSInteger result = [save runModal];

    if (result == NSOKButton) {
        NSString* selectedFile = [[save URL] path];
        NSString* csv = [self dataAsTabDelimitedString];

        NSError* error = nil;
        [csv writeToFile:selectedFile
              atomically:NO
                encoding:NSUTF8StringEncoding
                   error:&error];
        if (error) {
            // This is one way to handle the error, as an example
            [NSApp presentError:error];
        }
    }
}

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem
{
    if (self.dataStore.tableData)
        return YES;

    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                              forKeyPath:@"PDEUpdateTable"];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                              forKeyPath:@"PDEDataUpdated"];
}

@end
