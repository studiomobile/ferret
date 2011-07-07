//
//  FerretIndexReader.m
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretIndexReader.h"
#import "FerretInternals.h"

@implementation FerretIndexReader

@synthesize reader;

- (id)initWithIndexReader:(FrtIndexReader*)_reader
{
    if (!_reader) return nil;
    self = [super init];
    if (self) {
        reader = _reader;
    }
    return self;
}

- (void)dealloc
{
    if (reader) frt_ir_close(reader);
    reader = NULL;
}

+ (FerretIndexReader*)readIndexWithStore:(FerretStore*)store
{
    if (!store.isIndexExists) return nil;
    FrtIndexReader *reader = frt_ir_open(store.store);
    return [[self alloc] initWithIndexReader:reader];
}

- (void)deleteDocumentWithId:(NSInteger)docId
{
    frt_ir_delete_doc(reader, docId);
}

- (void)commit
{
    frt_ir_commit(reader);
}

- (void)undeleteAll
{
    frt_ir_undelete_all(reader);
}

@end
