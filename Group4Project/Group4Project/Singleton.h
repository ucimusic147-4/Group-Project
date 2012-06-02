//
//  Singleton.h
//  MySecondApp
//
//  Created by Kojiro Umezaki on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AQPlayer.h"
#import "Sequencer.h"

#define kFilteringFactor 0.1

@interface Singleton : NSObject <UIAccelerometerDelegate> {
    
    AQPlayer*   aqp;
    
    Sequencer*  q;
    
    BOOL flipover;

    // creating basic filter object    
    BOOL adaptive;
	UIAccelerationValue x, y, z; 

}

-(void)updateTime:(Float64)elapsed_time;

-(void)touchX:(Float64)x;

-(void)playToggle;


@end
