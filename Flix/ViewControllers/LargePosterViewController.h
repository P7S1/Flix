//
//  LargePosterViewController.h
//  Flix
//
//  Created by Keng Fontem on 6/24/21.
//

#import <UIKit/UIKit.h>
#import "ZoomTransitionController.h"
NS_ASSUME_NONNULL_BEGIN

@interface LargePosterViewController : UIViewController<ZoomAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSURL* photoURL;
@property (nonatomic, strong) ZoomTransitionController* transitionController;
@end

NS_ASSUME_NONNULL_END
