//
//  PDEDataStore.h
//  ParseDataExport
//
//  Created by Matt Salmon on 5/12/12.
//  Copyright (c) 2012 Lab82. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseOSX/Parse.h>

@interface PDEDataStore : NSObject

@property (atomic, strong) NSString *className;
@property (atomic, strong) NSArray* tableData;
@property (atomic, strong) NSArray* keyNames;

+ (NSArray *)classNames;
- (id)initWithClassName:(NSString *)className keyNames:(NSArray *)keynames;

@end
