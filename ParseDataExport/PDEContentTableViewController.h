//
//  PDEContentTableViewController.h
//  ParseDataExport
//
//  Created by Matt Salmon on 5/12/12.
//  Copyright (c) 2012 Lab82. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PDEDataStore.h"
@interface PDEContentTableViewController : NSViewController

@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableHeaderView *tableHeaderView;
@property (strong) PDEDataStore *dataStore;

@property (weak) IBOutlet NSMenuItem *exportCSVButton;

- (IBAction)exportCSV:(id)sender;

@end
