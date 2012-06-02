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
    
    pos = 1;
    

    pitches[0][0] =  0;
    pitches[0][1] =  59;
    pitches[0][2] =  62;
    pitches[0][3] =  64;
    pitches[0][4] =  66;
    pitches[0][5] =  67;
    pitches[0][6] =  67;
    pitches[0][7] =  69;
    pitches[0][8] =  71;
    pitches[0][9] =  73;
    pitches[0][10] = 74;
    pitches[0][11] = 76;
    pitches[0][12] = 78;
    pitches[0][13] = 79;
    pitches[0][14] = 79;
    pitches[0][15] = 81;
    pitches[0][16] = 83;
    pitches[0][17] = 85;
    pitches[1][0] =  0;
    pitches[1][1] =  61;
    pitches[1][2] =  63;
    pitches[1][3] =  65;
    pitches[1][4] =  66;
    pitches[1][5] =  67;
    pitches[1][6] =  68;
    pitches[1][7] =  68;
    pitches[1][8] =  69;
    pitches[1][9] =  70;
    pitches[1][10] = 70;
    pitches[1][11] = 72;
    pitches[1][12] = 73;
    pitches[1][13] = 74;
    pitches[1][14] = 75;
    pitches[1][15] = 78;
    pitches[1][16] = 80;
    pitches[1][17] = 81;
    /*
    pitches[2][0] =  
    pitches[2][1] =  
    pitches[2][2] =  
    pitches[2][3] =  
    pitches[2][4] =  
    pitches[2][5] =  
    pitches[2][6] =  
    pitches[2][7] =  
    pitches[2][8] =  
    pitches[2][9] =  
    pitches[2][10] = 
    pitches[2][11] = 
    pitches[2][12] = 
    pitches[2][13] = 
    pitches[2][14] = 
    pitches[2][15] = 
    pitches[2][16] = 
    pitches[2][17] = 
     */
    
    
    for (SInt32 i = 1; i < kNumberVoices; i++)
    {
        voices[i] = [[Voice_WavetableNoise alloc] init];
        voices[i].amp = 0.5;
        ((Voice_Synth*)voices[i]).freq = [Voice_Synth noteNumToFreq:pitches[pos][i]];
    }
    
    /* Old Multi-Voice Code
    
    for (SInt32 i = 1; i < kNumberVoices/2; i++)
    {
        voices[i*2] = [[Voice_Wavetable alloc] init];
        voices[i*2].amp = 1./((kNumberVoices/6));
        ((Voice_Synth*)voices[i*2]).freq = [Voice_Synth noteNumToFreq:pitches[pos][i*2]];
    }
    
    
    for (SInt32 i = 1; i < kNumberVoices/2; i++)
    {
        voices[(i*2)-1] = [[Voice_WavetableNoise alloc] init];
        voices[(i*2)-1].amp = 1./((kNumberVoices/6));
        ((Voice_Synth*)voices[(i*2)-1]).freq = [Voice_Synth noteNumToFreq:pitches[pos][(i*2)-1]];
    }
     */
    
    voices[0] = sf;
    voices[0].amp = 0.5;
    
    effect[0] = [[Effect_Limiter alloc] init];
    ((Effect_Limiter*)effect[0]).max_amp = 1.0;
    
    
    return self;
}

-(void)changeVoices
{
    
     if (pos > 0) 
     {
     pos = 0;
         for (SInt32 i = 1; i < kNumberVoices; i++)
         {
             voices[i] = [[Voice_Wavetable alloc] init];
             voices[i].amp = 1./((kNumberVoices/6));
             ((Voice_Synth*)voices[i]).freq = [Voice_Synth noteNumToFreq:pitches[pos][i]];
         }
         
     }
     else
     {
     pos = 1;
         for (SInt32 i = 1; i < kNumberVoices; i++)
         {
             voices[i] = [[Voice_WavetableNoise alloc] init];
             voices[i].amp = 1./((kNumberVoices/6));
             ((Voice_Synth*)voices[i]).freq = [Voice_Synth noteNumToFreq:pitches[pos][i]];
         }
     }
     
    
    [sf swapSF:pos];
    

    
    
 


   /* old code to do octave switches 
    if (range > 1) 
    {
        range = 0.5;
    }
     else
     {
         range = 2.0;
     }

    for (SInt32 i = 1; i < kNumberVoices; i++)
    {
    ((Voice_Synth*)voices[i]).freq = ((Voice_Synth*)voices[i]).freq * range;
    }
        */
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