//
//  PDEAppDelegate.m
//  ParseDataExport
//
//  Created by Matt Salmon on 5/12/12.
//  Copyright (c) 2012 Lab82. All rights reserved.
//

#import "PDEAppDelegate.h"

@implementation PDEAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"parsekeys" ofType:@"plist"];
    NSDictionary* plistDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSString *appId = [plistDict objectForKey:@"appId"];
    NSString *clientKey = [plistDict objectForKey:@"clientKey"];
    [Parse setApplicationId:appId
                  clientKey:clientKey];
}


@end
