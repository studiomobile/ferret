//
//  FerretMatchVector.m
//  ferret
//
//  Created by Sergey Martynov on 08.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretMatchVector.h"
#import "FerretInternals.h"

@interface FerretMatch ()
@property (nonatomic, assign) FrtMatchRange range;
- (id)initWithMatchRange:(FrtMatchRange)range;
@end

@implementation FerretMatchVector

@synthesize vector;
@synthesize matches;

- (id)initWithMatchVector:(FrtMatchVector*)_vector;
{
    if (!_vector) return nil;
    self = [super init];
    if (self) {
        vector = _vector;
        NSMutableArray *arr = [NSMutableArray new];
        for (int i = 0; i < vector->size; ++i) {
            [arr addObject:[[FerretMatch alloc] initWithMatchRange:vector->matches[i]]];
        }
        matches = [arr copy];
    }
    return self;
}

- (void)dealloc
{
    if (vector) frt_matchv_destroy(vector);
    vector = NULL;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@", matches];
}

@end

@implementation FerretMatch

@synthesize range;
@synthesize location;
@synthesize offset;

- (id)initWithMatchRange:(FrtMatchRange)_range
{
    self = [super init];
    if (self) {
        range = _range;
    }
    return self;
}

- (NSRange)location { return NSMakeRange(range.start, range.end - range.start + 1); }

- (NSRange)offset { return NSMakeRange(range.start_offset, range.end_offset - range.start_offset + 1); }

- (double)score { return range.score; }

- (NSString*)description
{
    return [NSString stringWithFormat:@"<FerretMatch: loc:[%d..%d] off:[%d..%d] score:%.3f>", range.start, range.end, range.start_offset, range.end_offset, range.score];
}

@end