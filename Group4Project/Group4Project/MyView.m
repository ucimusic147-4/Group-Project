//
//  MyView.m
//  Music147_2012
//
//  Created by Kojiro Umezaki on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyView.h"

#import "AQPlayer.h"
#import "Singleton.h"


#import "Voice_Wavetable.h"


extern AQPlayer *aqp;
extern Singleton* gSing;


@implementation MyView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)playToggle:(id)sender
{
    NSLog(@"playToggle");
    [gSing playToggle];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%d",touches.count);
    for (UITouch* t in touches)
    {
        CGPoint pt = [t locationInView:self];
        
        //set voice number based on current position in the y-direction
        if (pt.y<=57)
            currentVoice=1;
		if (pt.y>57 && pt.y<=114)
            currentVoice=2;
		if (pt.y>114 && pt.y<=171)
            currentVoice=3;
		if (pt.y>171 && pt.y<=228)
            currentVoice=4;
		if (pt.y>228 && pt.y<=285)
            currentVoice=5;
		if (pt.y>285 && pt.y<=342)
            currentVoice=6;
		if (pt.y>342 && pt.y<=399)
            currentVoice=7;
		if (pt.y>399 && pt.y<=456)
            currentVoice=8;
        [aqp voiceOn: currentVoice];
        pitchUp = NO;
        pitchDown = NO;
        touchEnd = NO;
        originalPosition = pt.x;
        NSLog(@"%lf,%lf",pt.x,pt.y);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%d",touches.count);
    for (UITouch* t in touches)
    {
        CGPoint pt = [t locationInView:self];
        NSLog(@"%lf,%lf,%lf,%lf",pt.x,pt.y,self.bounds.size.width,self.bounds.size.height);
        NSLog(@"%lf,%lf",pt.x/self.bounds.size.width,pt.y/self.bounds.size.height);
        NSLog(@"OP: %lf, OP: %lf",pt.x,originalPosition);
        

        //bend pitch up or down when user slides finger right or left
        if(pitchUp==NO && pt.x>=originalPosition+20.0)
        {
                
            [aqp voiceOff:currentVoice];
            [aqp voiceOn:++currentVoice];
            NSLog(@"NEW VOICE ON");
            pitchUp = YES;
            pitchDown = NO;
        }
        
        if(pitchDown==NO && pt.x<=originalPosition-20.0)
        {
            
            [aqp voiceOff:currentVoice];
            [aqp voiceOn:--currentVoice];
            NSLog(@"NEW VOICE ON");
            pitchDown = YES;
            pitchUp = NO;
        }
        
        //[gSing touchX:pt.x/self.bounds.size.width];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //originally duplicated code from touchesBegan, but this caused errors in turning off the voice
    [aqp voiceOff:currentVoice];
    touchEnd=YES;
    
    NSLog(@"Voice off at %lf",event.timestamp);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}


@end
