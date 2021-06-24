//
//  MovieTableViewCell.h
//  Flix
//
//  Created by Keng Fontem on 6/23/21.
//

#import <UIKit/UIKit.h>
@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

-(void)setUpFrom: (NSDictionary*) dict;


@end
