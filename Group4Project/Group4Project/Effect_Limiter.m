//
//  Effect_Limiter.m
//  Music147_2012
//
//  Created by Kojiro Umezaki on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Effect_Limiter.h"

@implementation Effect_Limiter

@synthesize max_amp;

-(void) process:(Float64*)buffer:(UInt32)num_samples
{
    for (UInt32 i = 0; i < num_samples; i++)
    {
        if (buffer[i] > max_amp)
            buffer[i] = max_amp;
        else if (buffer[i] < -max_amp)
            buffer[i] = -max_amp;
    }
}

@end
