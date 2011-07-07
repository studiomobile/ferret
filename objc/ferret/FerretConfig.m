//
//  FerretConfig.m
//  ferret
//
//  Created by Sergey Martynov on 04.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretConfig.h"
#import "FerretInternals.h"

@implementation FerretConfig

@synthesize config;

- (id)init
{
    self = [super init];
    if (self) {
        config = frt_default_config;
    }
    return self;
}

+ (FerretConfig*)defaultConfig
{
    return [self new];
}

@end
