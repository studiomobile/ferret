//
//  FerretMatchVector.h
//  ferret
//
//  Created by Sergey Martynov on 08.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretMatch;

@interface FerretMatchVector : NSObject

@property (nonatomic, readonly, strong) NSArray *matches;

@end


@interface FerretMatch : NSObject

@property (nonatomic, readonly) NSRange location;
@property (nonatomic, readonly) NSRange offset;
@property (nonatomic, readonly) double  score;

@end