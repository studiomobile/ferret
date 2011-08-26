//
//  FerretIndexWriter.m
//  ferret
//
//  Created by Sergey Martynov on 06.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretIndexWriter.h"
#import "FerretIndexReader.h"
#import "FerretStore.h"
#import "FerretAnalyzer.h"
#import "FerretIndexReader.h"
#import "FerretInternals.h"

@interface FerretIndexWriter ()
@property (nonatomic, strong) FerretStore *store;
@property (nonatomic, strong) FerretAnalyzer *analyzer;
@end

@implementation FerretIndexWriter

@synthesize writer;
@synthesize store;
@synthesize analyzer;

- (id)initWithWriter:(FrtIndexWriter*)_writer
{
    if (!_writer) return nil;
    self = [super init];
    if (self) {
        writer = _writer;
    }
    return self;
}

- (void)dealloc
{
    if (writer) frt_iw_close(writer);
    writer = NULL;
}

+ (FerretIndexWriter*)writeIndexWithStore:(FerretStore*)store analyzer:(FerretAnalyzer*)analyzer config:(FerretConfig*)config
{
    FrtConfig cfg = config.config;
    FrtIndexWriter *iw = frt_iw_open(store.store, analyzer.analyzer, &cfg);
    FerretIndexWriter *writer = [[self alloc] initWithWriter:iw];
    writer.store = store;
    writer.analyzer = analyzer;
    return writer;
}

- (NSInteger)count
{
    return frt_iw_doc_count(writer);
}

- (FerretIndexReader*)readIndex
{
    FerretIndexReader *reader = [FerretIndexReader readIndexWithStore:store];
    FrtIndexReader *r = reader.reader;
    frt_iw_add_readers(writer, &r, 1);
    return reader;
}

- (void)appendDocumentFields:(NSArray*)fields
{
    [self appendDocumentFields:fields boost:0];
}

- (void)appendDocumentFields:(NSArray*)fields boost:(float)boost
{
    FrtDocument *doc = frt_doc_new();
    if (boost != 0.0f) doc->boost = boost;
    for (FerretField *field in fields) {
        FrtDocField *docField = [field createDocField];
        frt_doc_add_field(doc, docField);
    }
    frt_iw_add_doc(writer, doc);
    frt_doc_destroy(doc);
}

- (void)commit { frt_iw_commit(writer); }

- (void)optimize { frt_iw_optimize(writer); }

@end
