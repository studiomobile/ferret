//
//  FerretSearchResults.h
//  ferret
//
//  Created by Sergey Martynov on 07.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretDocument;

@interface FerretSearchResults : NSObject

@property (nonatomic, readonly) NSInteger total;
@property (nonatomic, readonly) NSInteger count;
@property (nonatomic, readonly) float maxScore;

- (float)scoreAtIndex:(NSInteger)index;
- (FerretDocument*)documentAtIndex:(NSInteger)index;

@end

