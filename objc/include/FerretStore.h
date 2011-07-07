//
//  FerretStore.h
//  ferret
//
//  Created by Sergey Martynov on 04.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FerretStore : NSObject

+ (FerretStore*)openWithDirectory:(NSString*)path;
+ (FerretStore*)createWithDirectory:(NSString*)path;

+ (FerretStore*)openStoreInMemory:(FerretStore*)otherStore;
+ (FerretStore*)createInMemory;

@property (nonatomic, readonly, getter = isIndexExists) BOOL indexExists;

- (void)createIndex;
- (void)createIndexWithFieldDescriptors:(NSArray*)descriptors;

@end
