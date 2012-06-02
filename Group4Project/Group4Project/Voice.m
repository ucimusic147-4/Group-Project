//
//  Voice.m
//  Music147_2012
//
//  Created by Kojiro Umezaki on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Voice.h"

@implementation Voice

@synthesize amp;

-(id)init
{
    self = [super init];
    

    
    return self;
}

-(void)fillSampleBuffer:(Float64*)buffer:(UInt32)num_samples
{
}


-(BOOL)isOn
{
    return NO;
}

-(void)on
{
}

-(void)off
{
}


@end
