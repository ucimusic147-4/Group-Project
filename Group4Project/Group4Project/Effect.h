//
//  Effect.h
//  Music147_2012
//
//  Created by Kojiro Umezaki on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Effect : NSObject

-(void) process:(Float64*)buffer:(UInt32)num_samples;

@end
