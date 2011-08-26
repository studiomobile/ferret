//
//  FerretField.m
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretField.h"
#import "FerretInternals.h"

@implementation FerretField

@synthesize descriptor;
@synthesize data;
@synthesize value;
@synthesize boost;

+ (void)initialize
{
    [FerretStore class]; // force class loading - ferret initialization
}

- (id)initWithFieldDescriptor:(FerretFieldDescriptor*)desc
{
    if (!desc) return nil;
    self = [super init];
    if (self) {
        descriptor = desc;
    }
    return self;
}

- (FrtDocField*)createDocField
{
    FrtDocField *field = frt_df_new(frt_intern([descriptor.name UTF8String]));
    if (data) {
        frt_df_add_data_len(field, (char*)data.bytes, data.length);
    } else {
        frt_df_add_data(field, (char*)[value UTF8String]);
    }
    if (boost != 0) field->boost = boost;
    return field;
}

@end
