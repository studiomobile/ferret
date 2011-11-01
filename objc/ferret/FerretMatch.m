//
//  FerretMatch.m
//  ferret
//
//  Created by Sergey Martynov on 08.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretMatch.h"

@implementation FerretMatch

@synthesize byteRange;
@synthesize charRange;
@synthesize score;

- (id)initWithByteRange:(NSRange)_byteRange charRange:(NSRange)_charRange score:(double)_score
{
    self = [super init];
    if (self) {
        byteRange = _byteRange;
        charRange = _charRange;
        score = _score;
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@: chars:%@ bytes:%@ score:%.3f>", NSStringFromClass(self.class), NSStringFromRange(charRange), NSStringFromRange(byteRange), score];
}

@end