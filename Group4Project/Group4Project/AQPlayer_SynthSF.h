//
//  AQPlayer_SynthSF.h
//  Group4Project
//
//  Created by Lab User on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AQPlayer.h"
#import "SoundFile.h"

@interface AQPlayer_SynthSF : AQPlayer{
    
    SoundFile* sf;
    
    /* member variables */
    Float64 theta;
    Float64 deltaTheta;
}

// methods
-(void)fillAudioBuffer:(Float64*)buffer:(UInt32)num_samples;

-(void)filterFreq:(Float64)freq;

-(void)playToggle;
-(void)changeVoices;

@end