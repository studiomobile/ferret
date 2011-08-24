//
//  FerretDocument.m
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretDocument.h"
#import "FerretInternals.h"
#import "FerretMatch.h"
#import <unicode/utext.h>

@interface FerretDocument ()
@property (nonatomic, readonly, strong) NSMutableDictionary *fieldData;
@end

@implementation FerretDocument

@synthesize doc;
@synthesize lazyDoc;
@synthesize docId;
@synthesize index;
@synthesize searcher;
@synthesize fieldData;

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
    NSMutableData *data = [fieldData objectForKey:fieldName];
    if (data) return data;

    if (lazyDoc) {
        FrtLazyDocField *field = frt_lazy_doc_get(lazyDoc, frt_intern([fieldName UTF8String]));
        if (!field) return nil;
        data = [[NSMutableData alloc] initWithCapacity:field->len];
        for (int i = 0; i < field->size; ++i) {
            [data appendBytes:frt_lazy_df_get_data(field, i) length:field->data[i].length];
        }
    } else {
        FrtDocField *field = frt_doc_get_field(doc, frt_intern([fieldName UTF8String]));
        if (!field) return nil;
        data = [[NSMutableData alloc] initWithCapacity:field->capa];
        for (int i = 0; i < field->size; ++i) {
            [data appendBytes:field->data[i] length:field->lengths[i]];
        }
    }

    if (!fieldData) fieldData = [NSMutableDictionary new];
    [fieldData setObject:data forKey:fieldName];

    return data;
}

- (NSArray*)matchesForQuery:(FerretQuery*)query field:(NSString*)fieldName
{
    FrtMatchVector *v = NULL;
    if (index) {
        v = frt_index_get_match_vector(index.index, query.query, docId, frt_intern([fieldName UTF8String]));
    } else if (searcher) {
        v = frt_searcher_get_match_vector(searcher.searcher, query.query, docId, frt_intern([fieldName UTF8String]));
    }
    if (!v) return NULL;

    NSData *fd = [self dataValueOfField:fieldName];
    if (!fd) {
        frt_matchv_destroy(v);
        return nil;
    }

    UErrorCode status = U_ZERO_ERROR;
    UText *text = utext_openUTF8(NULL, fd.bytes, fd.length, &status);
    int32_t charIdx = 0;

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:v->size];

    for (int i = 0; i < v->size; ++i) {
        FrtMatchRange range = v->matches[i];

        while (utext_getNativeIndex(text) < range.start_offset) {
            utext_moveIndex32(text, 1);
            charIdx += 1;
        }
        int32_t start = charIdx;

        while (utext_getNativeIndex(text) < range.end_offset) {
            utext_moveIndex32(text, 1);
            charIdx += 1;
        }
        int32_t end = charIdx;

        NSRange charRange = NSMakeRange(start, end - start);
        NSRange byteRange = NSMakeRange(range.start_offset, range.end_offset - range.start_offset);
        [arr addObject:[[FerretMatch alloc] initWithByteRange:byteRange charRange:charRange score:range.score]];
    }

    if (text)
        utext_close(text);

    frt_matchv_destroy(v);
    return arr;
}

@end
