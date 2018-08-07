//
//  Person+Engineer.h
//  MCRnRExploration
//
//  Created by M君 on 06/08/2018.
//  Copyright © 2018 M君. All rights reserved.
//

#import "Person.h"

@interface NSArray (BeyondBoundsException)
/** 利用Runtime替换objectAtIndex实现，防止数组访问越界 */
-(id)OoR_objectAtIndex:(NSUInteger)index;
@end

@interface Person (Engineer)

@property NSString *job;

- (void)repairMechine;

@end
