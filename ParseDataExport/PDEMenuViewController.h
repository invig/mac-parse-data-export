//
//  PDEMenuViewController.h
//  ParseDataExport
//
//  Created by Matt Salmon on 5/12/12.
//  Copyright (c) 2012 Lab82. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PDEDataStore.h"

@interface PDEMenuViewController : NSViewController
<NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (strong) NSArray * data;
@property (weak) IBOutlet NSView *view;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSOutlineView *outlineView;

@end
