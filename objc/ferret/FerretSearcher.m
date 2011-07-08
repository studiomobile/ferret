//
//  FerretSearcher.m
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretSearcher.h"
#import "FerretInternals.h"

@interface FerretSearcher ()
@property (nonatomic, strong) FerretIndexReader *reader;
@end

@implementation FerretSearcher

@synthesize searcher;
@synthesize reader;

- (id)initWithSearcher:(FrtSearcher*)_searcher
{
    if (!_searcher) return nil;
    self = [super init];
    if (self) {
        searcher = _searcher;
    }
    return self;
}

- (void)dealloc
{
    if (searcher) frt_searcher_close(searcher);
    searcher = nil;
}

+ (FerretSearcher*)searcherWithIndexReader:(FerretIndexReader*)reader
{
    if (!reader) return nil;
    FrtSearcher *searcher = frt_isea_new(reader.reader);
    FerretSearcher *fs = [[self alloc] initWithSearcher:searcher];
    fs.reader = reader;
    return fs;
}

- (FerretDocument*)documentWithId:(NSInteger)docId
{
    if (docId < 0 || docId > frt_searcher_max_doc(searcher)) return nil;
    FrtLazyDoc *doc = frt_searcher_get_lazy_doc(searcher, docId);
    FerretDocument *d = [[FerretDocument alloc] initWithLazyDoc:doc docId:docId];
    d.searcher = self;
    return d;
}

- (FerretSearchResults*)search:(FerretQuery*)query
{
    FrtQuery *q = query.query;
    FrtTopDocs *docs = searcher->search(searcher, q, query.offset, query.count, NULL, NULL, NULL, false);
    FerretSearchResults *results = [[FerretSearchResults alloc] initWithTopDocs:docs];
    results.searcher = self;
    return results;
}

@end
