//
//  FerretQuery.h
//  ferret
//
//  Created by Sergey Martynov on 07.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretDocument;

@interface FerretQuery : NSObject

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;

- (NSArray*)matchesForDocument:(FerretDocument*)doc field:(NSString*)field;

@end
