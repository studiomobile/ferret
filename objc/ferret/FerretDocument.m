//
//  FerretDocument.m
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretDocument.h"
#import "FerretInternals.h"

@implementation FerretDocument

@synthesize doc;
@synthesize lazyDoc;
@synthesize docId;
@synthesize index;
@synthesize searcher;

- (id)initWithLazyDoc:(FrtLazyDoc*)lazy docId:(NSInteger)_docId
{
    if (!lazy) return nil;
    self = [super init];
    if (self) {
        lazyDoc = lazy;
        docId = _docId;
    }
    return self;
}

- (id)initWithDocument:(FrtDocument*)_doc docId:(NSInteger)_docId
{
    if (!_doc) return nil;
    self = [super init];
    if (self) {
        doc = _doc;
        docId = _docId;
    }
    return self;
}

- (void)dealloc
{
    if (lazyDoc) frt_lazy_doc_close(lazyDoc);
    lazyDoc = NULL;
    if (doc) frt_doc_destroy(doc);
    doc = NULL;
}

- (NSString*)stringValueOfField:(NSString*)fieldName
{
    NSData *data = [self dataValueOfField:fieldName];
    return data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
}

- (NSData*)dataValueOfField:(NSString*)fieldName
{
    if (lazyDoc) {
        FrtLazyDocField *field = frt_lazy_doc_get(lazyDoc, frt_intern([fieldName UTF8String]));
        if (!field) return nil;
        NSMutableData *data = [[NSMutableData alloc] initWithCapacity:field->len];
        for (int i = 0; i < field->size; ++i) {
            [data appendBytes:frt_lazy_df_get_data(field, i) length:field->data[i].length];
        }
        return data;
    }
    
    FrtDocField *field = frt_doc_get_field(doc, frt_intern([fieldName UTF8String]));
    if (!field) return nil;
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:field->capa];
    for (int i = 0; i < field->size; ++i) {
        [data appendBytes:field->data[i] length:field->lengths[i]];
    }
    return data;
}

- (FerretMatchVector*)matchVectorForQuery:(FerretQuery*)query field:(NSString*)fieldName
{
    FrtMatchVector *v = NULL;
    if (index) {
        v = frt_index_get_match_vector(index.index, query.query, docId, frt_intern([fieldName UTF8String]));
    } else if (searcher) {
        v = frt_searcher_get_match_vector(searcher.searcher, query.query, docId, frt_intern([fieldName UTF8String]));
    }
    return v ? [[FerretMatchVector alloc] initWithMatchVector:v] : nil;
}

@end
