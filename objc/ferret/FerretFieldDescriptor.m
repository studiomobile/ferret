//
//  FerretFieldDescriptor.m
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretFieldDescriptor.h"
#import "FerretInternals.h"

@implementation FerretFieldDescriptor

@synthesize name, store, index, termVector;

- (id)init
{
    self = [super init];
    if (self) {
        store = FerrertFieldStoreUncompressed;
        index = FerretFieldIndexTokenized;
        termVector = FerretFieldUseTermVector;
    }
    return self;
}

+ (FerretFieldDescriptor*)fieldDescriptorWithName:(NSString*)name
{
    FerretFieldDescriptor *desc = [self new];
    desc.name = name;
    return desc;
}

- (FrtStoreValue)storeValue
{
    switch (store) {
        case FerrertFieldDontStore: return FRT_STORE_NO;
        case FerrertFieldStoreUncompressed: return FRT_STORE_YES;
        case FerrertFieldStoreCompressed: return FRT_STORE_COMPRESS;
    }
}

- (FrtIndexValue)indexValue
{
    switch (index) {
        case FerretFieldDontIndex: return FRT_INDEX_NO;
        case FerretFieldIndexUntokenized: return FRT_INDEX_UNTOKENIZED;
        case FerretFieldIndexUntokenizedOmitNorms: return FRT_INDEX_UNTOKENIZED_OMIT_NORMS;
        case FerretFieldIndexTokenized: return FRT_INDEX_YES;
        case FerretFieldIndexTokenizedOmitNorms: return FRT_INDEX_YES_OMIT_NORMS;
    }
}

- (FrtTermVectorValue)termVectorValue
{
    if (index == FerretFieldDontIndex) return FRT_TERM_VECTOR_NO;
    switch (termVector) {
        case FerretFieldDontUseTermVector: return FRT_TERM_VECTOR_NO;
        case FerretFieldUseTermVector: return FRT_TERM_VECTOR_YES;
        case FerretFieldUseTermVectorWithPositions: return FRT_TERM_VECTOR_WITH_POSITIONS;
        case FerretFieldUseTermVectorWithOffsets: return FRT_TERM_VECTOR_WITH_OFFSETS;
        case FerretFieldUseTermVectorWithPositionsAndOffsets: return FRT_TERM_VECTOR_WITH_POSITIONS_OFFSETS;
    }
}

@end
