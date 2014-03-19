//
//  PDEAppDelegate.h
//  ParseDataExport
//
//  Created by Matt Salmon on 5/12/12.
//  Copyright (c) 2012 Lab82. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ParseOSX/Parse.h>
#import "PDEContainerViewController.h"
#import "PDEMenuViewController.h"
#import "PDEContentTableViewController.h"

@interface PDEAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSSplitView *splitView;
@property (strong) IBOutlet PDEContainerViewController *containerViewController;
@property (strong) IBOutlet PDEMenuViewController *menuViewController;
@property (strong) IBOutlet PDEContentTableViewController *contentViewController;
@property (weak) IBOutlet NSTreeController *treeController;


@property (atomic, strong) NSData *data;


@end
