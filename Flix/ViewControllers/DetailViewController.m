//
//  DetailViewController.m
//  Flix
//
//  Created by Keng Fontem on 6/24/21.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieHelper.h"
#import "SimilarPosterCollectionViewCell.h"
#import "SVProgressHUD.h"
@interface DetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, nullable) NSNumber *movieId;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureRefreshControl];
    [self setUpViewFromMovie];
    [self setUpCollectionView];
    [self getSimilarMovies];
    [self setUpBlurView];
}

-(void)setUpBlurView{
    //only apply the blur if the user hasn't disabled transparency effects
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //always fill the view
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [self.view insertSubview:blurEffectView aboveSubview: self.backgroundImageView]; //if you have more UIViews, use an insertSubview API to place it where needed
    } else {
        self.view.backgroundColor = [UIColor blackColor];
    }
}
-(void)configureRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(getMoviesNowPlaying) forControlEvents:UIControlEventValueChanged];
}

-(void)setUpActivityIndicator{
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.collectionView addSubview:self.activityIndicator];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                                 [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.collectionView.centerYAnchor],
                                                 [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.collectionView.centerXAnchor]
                                                 ]] ;
    
}

-(void) setUpViewFromMovie{
    self.titleLabel.text = self.movie[@"title"];
    self.detailLabel.text = self.movie[@"overview"];
    
    NSURL *movieURL = [MovieHelper getMovieURLFromPath:self.movie[@"poster_path"]];
    [self.movieImageView setImageWithURL: movieURL];
    
    NSURL *backdropURL = [MovieHelper getMovieURLFromPath:self.movie[@"backdrop_path"]];
    [self.backdropImageView setImageWithURL: backdropURL];
    //self.tabBarController 
    [self.backgroundImageView setImageWithURL:backdropURL];
    [self.movieImageView layoutIfNeeded];
    self.movieImageView.clipsToBounds = true;
    self.movieImageView.layer.masksToBounds = true;
    self.movieImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.movieImageView.layer.borderColor = [UIColor.systemBackgroundColor CGColor];
    self.movieImageView.layer.borderWidth = 1.0;
    self.navigationItem.title = @"  ";
}

-(void)getSimilarMovies{
    self.movieId = self.movie[@"id"];
    if (self.movieId ==  nil){
        return;
    }
    [self.activityIndicator startAnimating];
    for (id key in self.movie) {
        NSLog(@"key: %@, value: %@ \n", key, [self.movie objectForKey:key]);
    }
    NSString* movieIdString = self.movieId.stringValue;
    [MovieHelper getSimilarMovies:movieIdString completionHandler:^(NSArray<NSDictionary *> *movies, bool status) {
        if (status){
            self.movies = movies;
            [self.collectionView reloadData];
            
            
            if (self.refreshControl.isRefreshing){
                [self.refreshControl endRefreshing];
            }
            [self.activityIndicator stopAnimating];
        }else{
            [SVProgressHUD showErrorWithStatus:@"Failed to get movies"];
        }
    }];
}

-(void)setUpCollectionView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake(100, 150);
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SimilarPosterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SimilarPosterCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    NSString* posterPath = movie[@"poster_path"];
    if (posterPath != nil){
        NSURL *movieURL = [MovieHelper getMovieURLFromPath:posterPath];
        [cell.imageView setImageWithURL:movieURL];
    }else{
        cell.imageView.image = nil;
    }
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *movie = self.movies[indexPath.row];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailViewController"];
    vc.movie = movie;
    [self.navigationController pushViewController:vc animated:true];
}



@end
	
