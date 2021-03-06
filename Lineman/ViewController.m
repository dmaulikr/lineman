//
//  ViewController.m
//  TrackpadTest
//
//  Created by Matt Luedke on 6/19/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import "ViewController.h"
#import "DotMaster.h"
#import "DetectorView.h"
#import "MirrorDetectorView.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self.view setAcceptsTouchEvents:YES];
        
    }
    
    return self;
}

-(void)resize:(NSNotification *)notif {
    
    [self.view setFrame:NSMakeRect([[notif.userInfo objectForKey:@"x"] floatValue], [[notif.userInfo objectForKey:@"y"] floatValue], [[notif.userInfo objectForKey:@"w"] floatValue], [[notif.userInfo objectForKey:@"h"] floatValue])];
    
    for (NSView *subview in self.view.subviews)
    {
        if([subview.class isSubclassOfClass:[DetectorView class]]){
            [subview setFrame:self.view.frame];
            detectorView = (DetectorView *)subview;
            [detectorView redefinePts];
            [detectorView setNeedsDisplay:YES];
        }
        else if([subview.class isSubclassOfClass:[NSImageView class]]){
            NSRect imageFrame = subview.frame;
            imageFrame.origin = self.view.frame.origin;
            [subview setFrame:imageFrame];
        }
    }
    
    // recreate the points!
    
//    NSLog(@"resized to: height:%.2f, width: %.2f", [[notif.userInfo objectForKey:@"height"] floatValue], [[notif.userInfo objectForKey:@"width"] floatValue]);
    
}

-(void)loadView {
    
    [super loadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resize:) name:@"window_resized" object:nil];
        
    NSRect frame = self.view.frame;
    
    DetectorView *standardDetectorView = [[DetectorView alloc] initWithFrame:frame];
    MirrorDetectorView *mirrorDetectorView = [[MirrorDetectorView alloc] initWithFrame:frame];
    
    // create a view
    int r = arc4random() % 2;
    switch (r) {
        case 0:
            // initialize a standard detectorView
            detectorView = standardDetectorView;
            [self.view addSubview:detectorView];
            break;
        case 1:
            // initialize a mirror detectorView
            detectorView = mirrorDetectorView;
            [self.view addSubview:detectorView];
            break;
        default:
            break;
    }
    
    // TODO: find out why the ball starts off the screen, if anywhere at all? it seems like the y value is way too low!!!
    DotMaster *dotMaster = [DotMaster dotMaster];
    dotMaster.dot = [[NSImageView alloc] initWithFrame:NSMakeRect(31, 31, 30, 30)];
    [dotMaster.dot setImage:[NSImage imageNamed:@"stat_happy.png"]];
    [self.view addSubview:dotMaster.dot];
    //[self.attackDot1 setFrame:NSMakeRect(31, 31, 30, 30)];
    
    [self initializeTimer];
}


-(void)initializeTimer {
    DotMaster *dotMaster = [DotMaster dotMaster];
    dotMaster.attackDot1Movement = CGPointMake(1.0, 1.0);
    
    float theInterval = 1.0/60.0;
    theTimer = [NSTimer scheduledTimerWithTimeInterval:theInterval target:self selector:@selector(ballMovementLogic) userInfo:nil repeats:YES];
    
}

-(void)ballMovementLogic {
    
    DotMaster *dotMaster = [DotMaster dotMaster];
    
    NSRect newFrame = dotMaster.dot.frame;
    newFrame.origin = CGPointMake(dotMaster.dot.frame.origin.x + dotMaster.attackDot1Movement.x, dotMaster.dot.frame.origin.y + dotMaster.attackDot1Movement.y);
     
    [dotMaster.dot setFrame:newFrame];
    
    
    //  NSLog(@"lineRect2:%.2f,%.2f,%.2f,%.2f", detectorView.lineRect.origin.x, detectorView.lineRect.origin.y, detectorView.lineRect.size.height, detectorView.lineRect.size.width);
    
     // collision with line 
     // hopefully we can access the line?
     
    // maybe use: http://makemacgames.com/2005/10/24/collision-detection-with-cocoa/
    
 //   NSRect collisionRect = NSIntersectionRect(detectorView.lineRect, attackDot1.frame);
    
   // NSLog(@"collision logic:lineRect=%.2f,%.2f,%.2f,%.2f and collisionRect=%.2f,%.2f,%.2f,%.2f", detectorView.lineRect.origin.x, detectorView.lineRect.origin.y, detectorView.lineRect.size.height, detectorView.lineRect.size.width, attackDot1.frame.origin.x, attackDot1.frame.origin.y, attackDot1.frame.size.width, attackDot1.frame.size.height);
   
    /*
    if ( !NSIsEmptyRect(collisionRect) ) {
        // collision!
        attackDot1Movement.x = -attackDot1Movement.x;
        attackDot1Movement.y = -attackDot1Movement.y;
    }
     */
    
    /*
     
     BOOL attackDotCollision = ball.center.y >= paddle.center.y - 32 && ball.center.y <=paddle.center.y + 32 && ball.center.x > paddle.center.x - 120 && ball.center.x < paddle.center.x + 120;
     
     if (paddleCollision) {
     
     ballMovement.y = -ballMovement.y;
     
     if (ball.center.y >= paddle.center.y - 32 && ballMovement.y < 0) {
     ball.center = CGPointMake(ball.center.x, paddle.center.y- 32);
     }
     else if (ball.center.y <= paddle.center.y + 32 && ballMovement.y >0) {
     ball.center = CGPointMake(ball.center.x, paddle.center.y + 32);
     }
     else if (ball.center.x >= paddle.center.x - 120 && ballMovement.x < 0) {
     ball.center = CGPointMake(paddle.center.x - 120, ball.center.y);
     }
     else if (ball.center.x <= paddle.center.x + 120 && ballMovement.x > 0) {
     ball.center = CGPointMake(paddle.center.x + 120, ball.center.y);
     }
     
     }
     */
    
    // window edge collision
     
     if ((dotMaster.dot.frame.origin.x + dotMaster.dot.frame.size.width) > (self.view.frame.origin.x + self.view.frame.size.width) || dotMaster.dot.frame.origin.x < self.view.frame.origin.x) {
         CGPoint newDirections = dotMaster.attackDot1Movement;
         newDirections.x = -dotMaster.attackDot1Movement.x;
         dotMaster.attackDot1Movement = newDirections;
     }
     
     if (dotMaster.dot.frame.origin.y < self.view.frame.origin.y || (dotMaster.dot.frame.origin.y + dotMaster.dot.frame.size.height) > (self.view.frame.origin.y + self.view.frame.size.height)) {
         CGPoint newDirections = dotMaster.attackDot1Movement;
         newDirections.y = -dotMaster.attackDot1Movement.y;
         dotMaster.attackDot1Movement = newDirections;
     }
    
     /*
     if (ball.center.y > 568) {
     [self pauseGame];
     isPlaying = NO;
     lives--;
     livesLabel.text = [NSString stringWithFormat:@"Lives: %i", lives];
     
     if(!lives) {
     messageLabel.text = @"Game Over";
     } else {
     messageLabel.text = @"Ball Out of Bounds";
     }
     messageLabel.hidden = NO;
     }

     
     */
    
}

@end
