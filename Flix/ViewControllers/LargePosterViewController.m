//
//  LargePosterViewController.m
//  Flix
//
//  Created by Keng Fontem on 6/24/21.
//

#import "LargePosterViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ZoomAnimatorDelegate.h"
@interface LargePosterViewController ()<ZoomAnimatorDelegate>
@end

@implementation LargePosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView setImageWithURL:self.photoURL];
}

- (UIImageView *)refereneImageViewFor:(ZoomAnimator *)zoomAnimator{
    return self.imageView;
}
- (CGRect *)refereneImageViewFrameInTransitioningViewFor:(ZoomAnimator *)zoomAnimator{
    CGRect rect = [self.view convertRect:self.imageView.frame toView:self.view];
    return &rect;
}

- (void)transitionDidEndWith:(ZoomAnimator *)zoomAnimator {
    
}


- (void)transitionWillStartWith:(ZoomAnimator *)zoomAnimator {
    
}

@end
