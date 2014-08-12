//
//  MagicalCreature.h
//  MCMS
//
//  Created by I-Horng Huang on 29/07/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MagicalCreature : NSObject

@property NSString *name;
@property NSString *description;
@property UIImage *image;

- (instancetype)initWithName:(NSString *)name image:(UIImage *)image andDescription:(NSString *)description;

@end
