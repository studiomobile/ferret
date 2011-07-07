//
//  FerretFieldDescriptor.h
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FerrertFieldDontStore,
    FerrertFieldStoreUncompressed,
    FerrertFieldStoreCompressed,
} FerrertFieldStore;

typedef enum {
    FerretFieldDontIndex,
    FerretFieldIndexUntokenized,
    FerretFieldIndexUntokenizedOmitNorms,
    FerretFieldIndexTokenized,
    FerretFieldIndexTokenizedOmitNorms,
} FerretFieldIndex;

typedef enum {
    FerretFieldDontUseTermVector,
    FerretFieldUseTermVector,
    FerretFieldUseTermVectorWithPositions,
    FerretFieldUseTermVectorWithOffsets,
    FerretFieldUseTermVectorWithPositionsAndOffsets,
} FerretFieldTermVector;


@interface FerretFieldDescriptor : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) FerrertFieldStore store; // default FerrertFieldStoreUncompressed
@property (nonatomic, assign) FerretFieldIndex index; // default FerretFieldIndexTokenized
@property (nonatomic, assign) FerretFieldTermVector termVector; // default FerretFieldUseTermVector

+ (FerretFieldDescriptor*)fieldDescriptorWithName:(NSString*)name;

@end
