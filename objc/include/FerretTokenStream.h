//
//  FerretTokenStream.h
//  ferret
//
//  Created by Sergey Martynov on 18.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretToken;

@interface FerretTokenStream : NSObject

- (FerretToken*)next;
- (void)reset;

@end

@interface FerretToken : NSObject

@property (nonatomic, readonly, strong) NSString *text;
@property (nonatomic, readonly) NSRange range;
@property (nonatomic, readonly) NSInteger pos;
@property (nonatomic, readonly) NSInteger posInc;

@end