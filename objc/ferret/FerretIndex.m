//
//  FerretIndex.m
//  ferret
//
//  Created by Sergey Martynov on 07.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretIndex.h"
#import "FerretInternals.h"

@implementation FerretIndex

@synthesize index;

- (id)initWithFrtIndex:(FrtIndex*)_index
{
    if (!_index) return nil;
    self = [super init];
    if (self) {
        index = _index;
    }
    return self;
}

- (void)dealloc
{
    if (index) {
        frt_index_flush(index);
        frt_index_destroy(index);
    }
    index = NULL;
}

+ (FerretIndex*)indexWithStore:(FerretStore*)store analyzer:(FerretAnalyzer*)analyzer
{
    FrtIndex *idx = frt_index_new(store.store, analyzer.analyzer, frt_hs_new_ptr(NULL), ![store isIndexExists]);
    return [[self alloc] initWithFrtIndex:idx];
}

- (FerretDocument*)documentWithId:(NSInteger)docId
{
    FrtDocument *d = frt_index_get_doc_ts(index, docId);
    FerretDocument *doc = [[FerretDocument alloc] initWithDocument:d];
    doc.index = self;
    return doc;
}

- (FerretQuery*)parseQueryText:(NSString*)text
{
    FrtQuery *q = frt_index_get_query(index, (char*)[text UTF8String]);
    return [[FerretQuery alloc] initWithQuery:q];
}

- (FerretSearchResults*)search:(FerretQuery*)query
{
    FrtTopDocs *td = frt_index_search(index, query.query, query.offset, query.count, NULL, NULL, NULL);
    FerretSearchResults *results = [[FerretSearchResults alloc] initWithTopDocs:td];
    results.index = self;
    return results;
}

- (void)appendDocument:(NSDictionary*)fields
{
    [self appendDocument:fields boost:0];
}

- (void)appendDocument:(NSDictionary*)fields boost:(float)boost
{
    FrtDocument *doc = frt_doc_new();
    if (boost != 0.0f) doc->boost = boost;
    for (id key in fields) {
        NSString *name = [key description];
        id value = [fields objectForKey:key];
        FrtDocField *field = NULL;
        if ([value isKindOfClass:[NSData class]]) {
            field = [FerretField createDocFieldWithName:name data:value];
        } else {
            field = [FerretField createDocFieldWithName:name value:[value description]];
        }
        frt_doc_add_field(doc, field);
    }
    frt_index_add_doc(index, doc);
    frt_doc_destroy(doc);
}

- (void)commit
{
    frt_index_optimize(index);
}

@end
