//
//  AQPlayer_Synth.m
//  MySecondApp
//
//  Created by Kojiro Umezaki on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AQPlayer_Synth.h"

#import "Voice_Sine.h"
#import "Voice_Wavetable.h"

#import "Effect_Biquad.h"
#import "Effect_Limiter.h"

@implementation AQPlayer_Synth

-(id)init
{
    self = [super init];
    
    for (SInt32 i = 0; i < 4; i++)
    {
        voices[i] = [[Voice_Wavetable alloc] init];
        voices[i].amp = 1./kNumberVoices;
        ((Voice_Synth*)voices[i]).freq = [Voice_Synth noteNumToFreq:45+(12*i)];
    }

    effect[0] = [[Effect_Limiter alloc] init];
    ((Effect_Limiter*)effect[0]).max_amp = 1.0;
    
    effect[1] = [[Effect_Biquad alloc] init];
    [((Effect_Biquad*)effect[1]) biQuad_set:LPF:0.:5000.:kSR:1];    
    
    return self;
}

-(void)fillAudioBuffer:(Float64*)buffer:(UInt32)num_samples
{
    for (SInt32 i = 0; i < kNumberVoices; i++)
        if (voices[i] != nil)
            [voices[i] fillSampleBuffer:buffer:num_samples];
    
    for (SInt32 i = 0; i < kNumberEffects; i++)
        if (effect[i] != nil)
            [effect[i] process:buffer:num_samples];
}

@end
