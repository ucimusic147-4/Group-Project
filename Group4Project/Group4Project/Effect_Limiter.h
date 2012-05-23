//
//  Effect_Limiter.h
//  Music147_2012
//
//  Created by Kojiro Umezaki on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Effect.h"

@interface Effect_Limiter : Effect {
    Float64 max_amp;
}

@property Float64 max_amp;

-(void) process:(Float64*)buffer:(UInt32)num_samples;

@end
