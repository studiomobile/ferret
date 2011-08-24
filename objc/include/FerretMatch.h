//
//  FerretMatch.h
//  ferret
//
//  Created by Sergey Martynov on 08.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FerretMatch : NSObject

@property (nonatomic, readonly) NSRange byteRange;
@property (nonatomic, readonly) NSRange charRange;
@property (nonatomic, readonly) double  score;

- (id)initWithByteRange:(NSRange)byteRange charRange:(NSRange)charRange score:(double)score;

@end