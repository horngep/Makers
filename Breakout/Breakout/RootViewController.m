//
//  ViewController.m
//  Breakout
//
//  Created by I-Horng Huang on 31/07/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "RootViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"

#define ARC4RANDOM_MAX      0x100000000


@interface RootViewController () <UICollisionBehaviorDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet PaddleView *paddleView;
@property (weak, nonatomic) IBOutlet BallView *ballView;
@property (weak, nonatomic) IBOutlet BlockView *blockView;
@property UIDynamicAnimator *dynamicAnimator;
@property UIPushBehavior *pushBehavior;
@property UICollisionBehavior *collisionBehavior;
@property UICollisionBehavior *collisionBehavior1;
@property UIDynamicItemBehavior *paddleDynamic;
@property UIDynamicItemBehavior *ballDynamic;
@property UIDynamicItemBehavior *blockDynamic;
@property NSMutableArray *blockArray;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property int score;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property int timeInSeconds;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.blockArray = [[NSMutableArray alloc] init];
    [self makeBlocks];
    [self enableDynamics];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];

}

#pragma mark - helper method

- (void)animateAndDelete:(BlockView *)item
{
    BlockView *blockView = (BlockView *)item;

    if ([blockView.backgroundColor isEqual:[UIColor greenColor]]){
        blockView.backgroundColor = [UIColor redColor];
        [self countScoreAndDisplay:[UIColor greenColor]];
    } else {
        [self.collisionBehavior removeItem:blockView];

        blockView.backgroundColor = [UIColor grayColor];

        [UIView animateWithDuration:0.2 animations:^{

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                blockView.alpha = 0;
            } completion:^(BOOL finished) {
                [self countScoreAndDisplay:[UIColor redColor]];
                [self removeBlocks:item];
                [self shouldStartAgain];
            }];
        }];
    }
}

- (void)countScoreAndDisplay:(id)condition
{
    if (condition == [UIColor redColor]) {
        self.score += 1;
    }else if (condition == [UIColor greenColor]) {
        self.score += 3;
    }else if ([condition isEqualToString:@"dead"]) {
        self.score -= 30;
    }
    self.scoreLabel.text = @(self.score).description;
}

- (BOOL)shouldStartAgain
{
    if (self.blockArray.count == 0){
        [self showAlert];
        return YES;
    }else{
        return NO;
    }
}

-(void)showAlert
{
    NSString *score = [NSString stringWithFormat:@"%d",self.score];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"You win" message:score delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"RESTART", nil];
    [alertView show];
}

#pragma mark - blocks
- (void)makeBlocks
{
    for (int h = 0; h < 8; h++) {
        for (int v = 0; v < 4; v++) {
            BlockView *block = [[BlockView alloc] initWithFrame:CGRectMake(5 + h*40, 20 + v*35, 30, 15)];
            int rand = arc4random_uniform(100);
            if (rand > 70) {
                block.backgroundColor = [UIColor redColor];
            } else if (rand <= 70) {
                block.backgroundColor = [UIColor greenColor];
            }
            [self.view addSubview:block];
            [self.blockArray addObject:block];
        }
    }
}

- (void)removeBlocks:(BlockView *)blockView
{
    [blockView removeFromSuperview];
    [self.blockArray removeObjectAtIndex:[self.blockArray indexOfObject:blockView]];
}

-(void)timer
{
    self.timeInSeconds += 1;
    self.timeLabel.text = [NSString stringWithFormat:@"Time:%d",self.timeInSeconds];
    [self generateBlockOverTime];
}

- (void)generateBlockOverTime
{

    if (self.timeInSeconds == 2){
        for (int h = 0; h < 8; h++) {
            for (int v = 0; v < 2; v++) {

                int rand = arc4random_uniform(100);
                if (rand > 40){
                    BlockView *block = [[BlockView alloc] initWithFrame:CGRectMake(5 + h*40, 160 + v*35, 30, 15)];
                    block.backgroundColor = [UIColor redColor];
                    [self.view addSubview:block];
                    [self.blockArray addObject:block];
                    [self enableDynamics];

                }
            }
        }
    }
    if (self.timeInSeconds == 5){
        for (int h = 0; h < 8; h++) {
            for (int v = 0; v < 2; v++) {

                int rand = arc4random_uniform(100);
                if (rand > 40){
                    BlockView *block = [[BlockView alloc] initWithFrame:CGRectMake(5 + h*40, 230 + v*35, 30, 15)];
                    block.backgroundColor = [UIColor greenColor];
                    [self.view addSubview:block];
                    [self.blockArray addObject:block];
                    [self enableDynamics];

                }
            }
        }
    }
}


#pragma mark - dynamics

- (void)enableDynamics {
    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];

    //PUSH BEHAVIOR ON BALL
    self.pushBehavior = [[UIPushBehavior alloc]initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.pushDirection = CGVectorMake(0.2, -1.0);
    self.pushBehavior.magnitude = 0.04;
    self.pushBehavior.active = YES;
    [self.dynamicAnimator addBehavior:self.pushBehavior];

    //BALL DYNAMICS
    self.ballDynamic = [[UIDynamicItemBehavior alloc]initWithItems:@[self.ballView]];
    self.ballDynamic.allowsRotation = NO;
    self.ballDynamic.elasticity = 1.0;
    self.ballDynamic.friction = 0;
    self.ballDynamic.resistance = 0;
    [self.dynamicAnimator addBehavior:self.ballDynamic];

    //PADDLE DYNAMICS
    self.paddleDynamic = [[UIDynamicItemBehavior alloc]initWithItems:@[self.paddleView]];
    self.paddleDynamic.allowsRotation = NO;
    self.paddleDynamic.density = 50000;
    [self.dynamicAnimator addBehavior:self.paddleDynamic];

    //BLOCKS DYNAMICS
    self.blockDynamic = [[UIDynamicItemBehavior alloc]initWithItems:self.blockArray];
    self.blockDynamic.allowsRotation = YES;
    self.blockDynamic.density = 50000;
    [self.dynamicAnimator addBehavior:self.blockDynamic];

    //COLLISION BEHAVIOR
    NSMutableArray *itemArray = [[NSMutableArray alloc]initWithObjects:self.paddleView,self.ballView, nil];
    [itemArray addObjectsFromArray:self.blockArray];
    self.collisionBehavior = [[UICollisionBehavior alloc]initWithItems:itemArray];
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionDelegate = self;    //collision delegation
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
}

#pragma mark - delegation
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        //restart
        [self makeBlocks];
        [self.ballView setFrame:CGRectMake(160, 288, 10, 10)];
        self.timeInSeconds = 0;
        [self enableDynamics];
    }
}

//THIS HAPPEND WHEN BALL COLLIDE WITH WALL, AND GOES OUT
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    //if the ball hit the bottom of the view
    CGPoint point = CGPointMake(self.ballView.center.x, self.ballView.center.y);
    if (point.y > 550){  //That is bad
        //reset the ball position
        [self.ballView setFrame:CGRectMake(160, 288, 10, 10)];
        [self countScoreAndDisplay:@"dead"];

    }
    [self.dynamicAnimator updateItemUsingCurrentState:self.ballView];
}

//THIS HAPPEND WHEN 2 ITEM COLLIDE (BALL AND BLOCK)
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{
    if(![item1 isKindOfClass:[self.paddleView class]] && ![item2 isKindOfClass:[self.paddleView class]]){

        if ([item1 isKindOfClass:[self.blockView class]]) {
            [self animateAndDelete:(BlockView *)item1];
        } else {
            [self animateAndDelete:(BlockView *)item2];
        }
    }
}

#pragma mark - gesture

- (IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer
{
    self.paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x, self.paddleView.center.y);
    [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}
@end
