//
//  FerretStore.m
//  ferret
//
//  Created by Sergey Martynov on 04.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretStore.h"
#import "FerretInternals.h"
#import "FerretFieldDescriptor.h"
#import "FerretField.h"

@implementation FerretStore

@synthesize store;

+ (void)initialize
{
    frt_symbol_init();
    atexit(&frt_hash_finalize);
}

- (id)initWithStore:(FrtStore*)_store
{
    if (!_store) return nil;
    self = [super init];
    if (self) {
        store = _store;
    }
    return self;
}

- (void)dealloc
{
    if (store) frt_store_deref(store);
    store = NULL;
}

+ (FerretStore*)openWithDirectory:(NSString*)path
{
    BOOL isDir = NO;
    BOOL exist = [[NSFileManager new] fileExistsAtPath:path isDirectory:&isDir];
    if (!exist || !isDir) return nil;
    FrtStore *store = frt_open_fs_store([path UTF8String]);
    return [[self alloc] initWithStore:store];
}

+ (FerretStore*)createWithDirectory:(NSString*)path
{
    BOOL isDir = NO;
    BOOL exist = [[NSFileManager new] fileExistsAtPath:path isDirectory:&isDir];
    if (!exist || !isDir) return nil;
    FrtStore *store = frt_open_fs_store([path UTF8String]);
    if (!store) return nil;
    store->clear_all(store);
    return [[self alloc] initWithStore:store];
}

+ (FerretStore*)openStoreInMemory:(FerretStore*)otherStore
{
    FrtStore *store = frt_open_ram_store_and_copy(otherStore.store, false);
    return [[self alloc] initWithStore:store];
}

+ (FerretStore*)createInMemory
{
    FrtStore *store = frt_open_ram_store();
    return [[self alloc] initWithStore:store];
}

- (BOOL)isIndexExists
{
    return frt_ir_index_exists(store);
}

- (void)createIndex
{
    FrtFieldInfos *fis = frt_fis_new(FRT_STORE_YES, FRT_INDEX_YES, FRT_TERM_VECTOR_WITH_POSITIONS_OFFSETS);
    frt_index_create(store, fis);
    frt_fis_deref(fis);
}

- (void)createIndexWithFieldDescriptors:(NSArray*)descriptors
{
    FrtFieldInfos *fis = frt_fis_new(FRT_STORE_YES, FRT_INDEX_NO, FRT_TERM_VECTOR_NO);
    for (FerretFieldDescriptor *desc in descriptors) {
        FrtSymbol name = frt_intern([desc.name UTF8String]);
        FrtFieldInfo *fi = frt_fi_new(name, desc.storeValue, desc.indexValue, desc.termVectorValue);
        frt_fis_add_field(fis, fi);
    }
    frt_index_create(store, fis);
    frt_fis_deref(fis);
}

@end
