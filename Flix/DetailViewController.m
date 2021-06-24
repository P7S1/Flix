//
//  DetailViewController.m
//  Flix
//
//  Created by Keng Fontem on 6/24/21.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieHelper.h"
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewFromMovie];
}

-(void) setUpViewFromMovie{
    self.titleLabel.text = self.movie[@"title"];
    self.detailLabel.text = self.movie[@"overview"];
    
    NSURL *movieURL = [MovieHelper getMovieURLFromPath:self.movie[@"poster_path"]];
    [self.movieImageView setImageWithURL: movieURL];
    
    NSURL *backdropURL = [MovieHelper getMovieURLFromPath:self.movie[@"backdrop_path"]];
    [self.backdropImageView setImageWithURL: backdropURL];
}

@end
	
