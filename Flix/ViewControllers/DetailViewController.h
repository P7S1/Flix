//
//  DetailViewController.h
//  Flix
//
//  Created by Keng Fontem on 6/24/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSDictionary *movie;
@end

NS_ASSUME_NONNULL_END
