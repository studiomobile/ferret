//
//  FerretField.m
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretField.h"
#import "FerretInternals.h"
#import "FerretFieldDescriptor.h"

@implementation FerretField

@synthesize field;

+ (void)initialize
{
    [FerretStore class]; // force class loading - ferret initialization
}

+ (FrtDocField*)createDocFieldWithName:(NSString*)name value:(NSString*)value
{
    FrtDocField *field = frt_df_new(frt_intern([name UTF8String]));
    frt_df_add_data(field, (char*)[value UTF8String]);
    return field;
}

+ (FrtDocField*)createDocFieldWithName:(NSString*)name data:(NSData*)data
{
    FrtDocField *field = frt_df_new(frt_intern([name UTF8String]));
    frt_df_add_data_len(field, (char*)data.bytes, data.length);
    return field;
}

- (id)initWithFieldDescriptor:(FerretFieldDescriptor*)desc
{
    if (!desc) return nil;
    self = [super init];
    if (self) {
        FrtSymbol name = frt_intern([desc.name UTF8String]);
        field = frt_fi_new(name, desc.storeValue, desc.indexValue, desc.termVectorValue);
    }
    return self;
}

- (id)initWithField:(FrtFieldInfo*)_field
{
    if (!_field) return nil;
    self = [super init];
    if (self) {
        field = _field;
    }
    return self;
}

- (void)dealloc
{
    if (field) frt_fi_deref(field);
    field = NULL;
}

@end
