//
//  FerretField.h
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretFieldDescriptor.h"

@interface FerretField : NSObject

@property (nonatomic, readonly, strong) FerretFieldDescriptor *descriptor;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) float boost;

- (id)initWithFieldDescriptor:(FerretFieldDescriptor*)descriptor;

@end
