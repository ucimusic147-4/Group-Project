//
//  Envelope.m
//  Music147
//
//  Created by Kojiro Umezaki on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Envelope.h"

#import "AQPlayer.h"

@implementation Envelope

@synthesize attack;
@synthesize release;

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
}

-(void)off
{
	delta = delta_release;
}

@end
