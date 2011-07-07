//
//  FerretSearchResults.m
//  ferret
//
//  Created by Sergey Martynov on 07.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretSearchResults.h"
#import "FerretInternals.h"

@implementation FerretSearchResults

@synthesize topdocs;
@synthesize searcher;
@synthesize index;

- (id)initWithTopDocs:(FrtTopDocs*)_topdocs
{
    if (!_topdocs) return nil;
    self = [super init];
    if (self) {
        topdocs = _topdocs;
    }
    return self;
}

- (void)dealloc
{
    if (topdocs) frt_td_destroy(topdocs);
    topdocs = NULL;
}

- (NSInteger)total { return topdocs->total_hits; }
- (NSInteger)count { return topdocs->size; }
- (float)maxScore  { return topdocs->max_score; }

- (float)scoreAtIndex:(NSInteger)idx
{
    if (idx < 0 || idx >= topdocs->size) return 0;
    return topdocs->hits[idx]->score;
}

- (FerretDocument*)documentAtIndex:(NSInteger)idx
{
    if (idx < 0 || idx >= topdocs->size) return nil;
    int doc = topdocs->hits[idx]->doc;
    return searcher ? [searcher documentWithId:doc] : [index documentWithId:doc];
}

@end

