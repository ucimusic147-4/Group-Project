//
//  AQPlayer_SynthSF.m
//  Group4Project
//
//  Created by Lab User on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AQPlayer_SynthSF.h"

#import "Voice_Sine.h"
#import "Voice_Wavetable.h"
#import "Voice_WavetableNoise.h"

#import "Effect_Limiter.h"

@implementation AQPlayer_SynthSF

-(id)init
{
    self = [super init];
    
    sf = [[SoundFile alloc] init];
    
    SInt32 pitches[9] = {0,62,66,67,71,74,78,79,81};
    
    
    for (SInt32 i = 2; i < kNumberVoices; i++)
    {
        voices[i] = [[Voice_Wavetable alloc] init];
        voices[i].amp = 1./((kNumberVoices/3));
        ((Voice_Synth*)voices[i]).freq = [Voice_Synth noteNumToFreq:pitches[i]];
    }
    
    voices[1] = [[Voice_WavetableNoise alloc] init];
    voices[1].amp = 1./((kNumberVoices/3));
    ((Voice_Synth*)voices[1]).freq = [Voice_Synth noteNumToFreq:pitches[1]];

    
    voices[0] = sf;
    voices[0].amp = 0.2;
    
    effect[0] = [[Effect_Limiter alloc] init];
    ((Effect_Limiter*)effect[0]).max_amp = 1.0;
    
    
    return self;
}

-(void)changeVoices
{
for (SInt32 i = 1; i < kNumberVoices; i++)
{
    ((Voice_Synth*)voices[i]).freq = ((Voice_Synth*)voices[i]).freq * 2;
}
}

-(void)fillAudioBuffer:(Float64*)buffer:(UInt32)num_samples
{
    for (SInt32 i = 0; i < kNumberVoices; i++)
        if (voices[i] != nil)
        {
            [voices[i] fillSampleBuffer:buffer:num_samples];
            if (i > 0)
            {
            }
        }
    
    [effect[0] process:buffer:num_samples];
}

-(void)filterFreq:(Float64)freq
{
    NSLog(@"filterFreq %lf",freq);
    //[((Effect_Biquad*)effect[1]) biQuad_set:LPF:0.:freq:kSR:1];    
    
}

-(void)playToggle
{
    if ([sf isPaused]) {
        [sf play];
    }
    else {
        [sf pause];
    }
    
}


@end