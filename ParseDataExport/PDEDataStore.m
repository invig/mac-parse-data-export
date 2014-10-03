//
//  PDEDataStore.m
//  ParseDataExport
//
//  Created by Matt Salmon on 5/12/12.
//  Copyright (c) 2012 Lab82. All rights reserved.
//

#import "PDEDataStore.h"

@implementation PDEDataStore

@synthesize className = _className;
@synthesize tableData = _tableData;
@synthesize keyNames = _keyNames;

+ (NSArray *)classNames {
  return @[ @"Colleges", @"_User", @"Post" ];
}

- (id)initWithClassName:(NSString *)className keyNames:(NSArray *)keynames {
  if (self = [super init]) {
    if ([[PDEDataStore classNames] containsObject:className]) {
      _className = className;
      _keyNames = keynames;
      [self fetchObjectsForClass:_className skipping:0 intoMutableArray:nil];
    } else {
      return nil;
    }
  }

  return self;
}

- (void)setClassName:(NSString *)className {
  @synchronized(self) {
    if (className != _className) {
      _className = className;
      self.tableData = nil;
      [self fetchObjectsForClass:className skipping:0 intoMutableArray:nil];
    }
  }
}

- (NSString *)className {
  @synchronized(self) {
    return _className;
  }
}

- (void)fetchObjectsForClass:(NSString *)className
                    skipping:(NSInteger)skip
            intoMutableArray:(NSMutableArray *)array {
  NSLog(@"Fetch objects for class: %@", className);

  if (array == nil) {
    array = [[NSMutableArray alloc] init];
  }

  PFQuery *query = [PFQuery queryWithClassName:className];
  query.limit = 1000;

  if ([className isEqualToString:@"_User"]) {
    [query includeKey:@"college"];
  }

  if (self.keyNames) {
    [query selectKeys:self.keyNames];
  }
  
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
        for (id object in objects) {
          PFObject *the_object = (PFObject *)object;
          [the_object fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {}];
        }
        
        [array addObjectsFromArray:objects];
        
        if (objects.count == query.limit + skip) {
          [self fetchObjectsForClass:className
                            skipping:(skip + objects.count)
                    intoMutableArray:array];
        } else {
          self.tableData = [NSArray arrayWithArray:array];
          [self postUpdateNotification];
        }
      }
  }];
}

- (void)postUpdateNotification {
  NSLog(@"update notification");
  NSNotification *note =
      [NSNotification notificationWithName:@"PDEDataUpdated"
                                    object:self
                                  userInfo:@{ @"Class" : @"ALL" }];
  [[NSNotificationCenter defaultCenter] postNotification:note];
}

@end
