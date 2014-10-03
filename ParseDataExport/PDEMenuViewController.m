//
//  PDEMenuViewController.m
//  ParseDataExport
//
//  Created by Matt Salmon on 5/12/12.
//  Copyright (c) 2012 Lab82. All rights reserved.
//

#import "PDEMenuViewController.h"

@interface PDEMenuViewController ()

@end

@implementation PDEMenuViewController

@synthesize view = _view;
@synthesize data = _data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        NSLog(@"Init happened");
        [self setup];
    }
    
    return self;
}

- (void)setup
{
   // _data = @[@"One",@"Two",@"Three"];
    _data = [PDEDataStore classNames];
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) { //item is nil when the outline view wants to inquire for root level items
        return [self.data objectAtIndex:index];
    }
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [[item objectForKey:@"children"] objectAtIndex:index];
    }
    
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item isKindOfClass:[NSDictionary class]]) {
        return YES;
    }else {
        return NO;
    }
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) { //item is nil when the outline view wants to inquire for root level items
        return [self.data count];
    }
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [[item objectForKey:@"children"] count];
    }
    
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return item;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    NSLog(@"Item selected: %@", item);
    NSNotification *note = [NSNotification notificationWithName:@"PDEUpdateTable" object:self userInfo:@{@"Class" : item}];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    return YES;
}

@end
