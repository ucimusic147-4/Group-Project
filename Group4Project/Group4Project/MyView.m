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

-(IBAction)toggleVoice1:(id)sender
{
    NSLog(@"toggleVoice1");
  //  [aqp voiceToggle:1];
}

-(IBAction)toggleVoice2:(id)sender
{
    NSLog(@"toggleVoice2");
  //  [aqp voiceToggle:2];
}

-(IBAction)toggleVoice3:(id)sender
{
    NSLog(@"toggleVoice3");
   // [aqp voiceToggle:3];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%d",touches.count);
    for (UITouch* t in touches)
    {
        CGPoint pt = [t locationInView:self];
        
        if ((pt.x<=160)&&(pt.y<=115))
            [aqp voiceOn:1];
        if ((pt.x>160) && (pt.y<=115))
            [aqp voiceOn:2];
        if ((pt.x<=160) && (pt.y>115 && pt.y<=230))
            [aqp voiceOn:3];
        if ((pt.x>160) && (pt.y>115 && pt.y<=230))
            [aqp voiceOn:4];
        
        NSLog(@"%lf,%lf",pt.x,pt.y);
    }
    NSLog(@"%lf",event.timestamp);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%d",touches.count);
    for (UITouch* t in touches)
    {
        CGPoint pt = [t locationInView:self];
        NSLog(@"%lf,%lf,%lf,%lf",pt.x,pt.y,self.bounds.size.width,self.bounds.size.height);
        NSLog(@"%lf,%lf",pt.x/self.bounds.size.width,pt.y/self.bounds.size.height);
        [gSing touchX:pt.x/self.bounds.size.width];
    }
    NSLog(@"%lf",event.timestamp);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%d",touches.count);
    for (UITouch* t in touches)
    {
        CGPoint pt = [t locationInView:self];
        
        if ((pt.x<=160)&&(pt.y<=115))
            [aqp voiceOff:1];
        if ((pt.x>160) && (pt.y<=115))
            [aqp voiceOff:2];
        if ((pt.x<=160) && (pt.y>115 && pt.y<=230))
            [aqp voiceOff:3];
        if ((pt.x>160) && (pt.y>115 && pt.y<=230))
            [aqp voiceOff:4];
        
        NSLog(@"%lf,%lf",pt.x,pt.y);
       // [aqp voiceToggle:1];

    }
    NSLog(@"%lf",event.timestamp);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end
