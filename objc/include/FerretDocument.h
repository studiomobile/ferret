//
//  FerretDocument.h
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretQuery;

@interface FerretDocument : NSObject

@property (nonatomic, readonly) NSInteger docId;

- (NSString*)stringValueOfField:(NSString*)fieldName;
- (NSData*)dataValueOfField:(NSString*)fieldName;

- (NSArray*)matchesForQuery:(FerretQuery*)query field:(NSString*)fieldName;

@end
