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
- (id)initWithMatchRange:(FrtMatchRange*)range;
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
            [arr addObject:[[FerretMatch alloc] initWithMatchRange:&vector->matches[i]]];
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
    return [NSString stringWithFormat:@"<FerretMatchVector matches:%@>", matches];
}

@end

@implementation FerretMatch

@synthesize location;
@synthesize offset;
@synthesize score;

- (id)initWithMatchRange:(FrtMatchRange*)frtRange
{
    self = [super init];
    if (self) {
        location = NSMakeRange(frtRange->start, frtRange->end - frtRange->start + 1);
        offset = NSMakeRange(frtRange->start_offset, frtRange->end_offset - frtRange->start_offset + 1);
        score = frtRange->score;
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<FerretMatch: loc:%@ off:%@ score:%.3f>", NSStringFromRange(location), NSStringFromRange(offset), score];
}

@end