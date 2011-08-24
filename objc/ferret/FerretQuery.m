//
//  FerretQuery.m
//  ferret
//
//  Created by Sergey Martynov on 07.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretQuery.h"
#import "FerretInternals.h"

@implementation FerretQuery

@synthesize query;
@synthesize offset;
@synthesize count;

- (id)initWithQuery:(FrtQuery*)_query
{
    if (!_query) return nil;
    self = [super init];
    if (self) {
        query = _query;
        offset = 0;
        count = 10;
    }
    return self;
}

- (void)dealloc
{
    if (query) frt_q_deref(query);
    query = NULL;
}

- (NSArray*)matchesForDocument:(FerretDocument*)doc field:(NSString*)field
{
    return [doc matchesForQuery:self field:field];
}

@end
