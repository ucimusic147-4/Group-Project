//
//  Envelope_Kick.m
//  Group4Project
//
//  Created by Lab User on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Envelope_Kick.h"
#import "AQPlayer.h"

@implementation Envelope_Kick

@synthesize attack;
@synthesize release;
@synthesize sustain;

@synthesize output;

-(void)setAttack:(Float64)seconds
{
	attack = seconds;
	delta_attack = 1. / (seconds * kSR);
}

-(void)setRelease:(Float64)seconds
{
	release = seconds;
	delta_release = -1. / (seconds * kSR);
}

-(void)update:(UInt32)num_samples
{
	output += (delta * num_samples);
    
	if (output >= 1.0) { output = 1.0; delta = 0.0; }
	else if (output <= 0.0) { output = 0.0; delta = 0.0; }
}

-(void)on
{
	delta = delta_attack;
    [self performSelector:@selector(off)  withObject:nil afterDelay:sustain];
}

-(void)off
{
	delta = delta_release;
}


@end
