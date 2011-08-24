//
//  FerretTokenStream.h
//  ferret
//
//  Created by Sergey Martynov on 18.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FerretAnalyzer.h"

@class FerretToken;

@interface FerretTokenStream : NSObject
@property (nonatomic, readonly, strong) NSString *text;

- (id)initWithText:(NSString*)text analyzer:(FerretAnalyzer*)analyzer;
+ (FerretTokenStream*)tokenStreamForText:(NSString*)text analyzer:(FerretAnalyzer*)analyzer;

- (FerretToken*)next;
- (void)reset;

- (NSArray*)collectAll;

@end

@interface FerretToken : NSObject

@property (nonatomic, readonly, strong) NSString *text;
@property (nonatomic, readonly) NSRange byteRange;

@end