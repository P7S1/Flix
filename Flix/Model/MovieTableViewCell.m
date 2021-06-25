//
//  MovieTableViewCell.m
//  Flix
//
//  Created by Keng Fontem on 6/23/21.
//

#import "MovieTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieHelper.h"
@implementation MovieTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpFrom:(NSDictionary *)movie{
    self.titleLabel.text = movie[@"title"];
    self.descriptionLabel.text = movie[@"overview"];
    NSURL *posterURL = [MovieHelper getMovieURLFromPath:movie[@"poster_path"]];
    self.movieImageView.image = nil;
    [self.movieImageView setImageWithURL:posterURL];
}

@end
