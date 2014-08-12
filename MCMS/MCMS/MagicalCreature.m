//
//  MagicalCreature.m
//  MCMS
//
//  Created by I-Horng Huang on 29/07/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "MagicalCreature.h"


@implementation MagicalCreature


- (instancetype)initWithName:(NSString *)name image:(UIImage *)image  andDescription:(NSString *)description
{
    if(self = [super init]) {
        self.name = name;
        self.description = description;
        self.image = image;
    }
    return self;
}
@end
