//
//  PosterViewController.m
//  Flix
//
//  Created by Keng Fontem on 6/24/21.
//

#import "PosterViewController.h"
#import "SVProgressHUD.h"
#import "MovieHelper.h"
#import "PosterCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "LargePosterViewController.h"
#import "ZoomAnimatorDelegate.h"
@interface PosterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ZoomAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation PosterViewController

NSIndexPath *selectedIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationController];
    [self setUpCollectionView];
    [self getMoviesNowPlaying];
    [self configureRefreshControl];
    [SVProgressHUD show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        LargePosterViewController *vc = segue.destinationViewController;
       self.navigationController.delegate = vc.transitionController;
        vc.transitionController.fromDelegate = self;
        vc.transitionController.toDelegate = vc;
        NSURL *url = [MovieHelper getMovieURLFromPath:self.movies[selectedIndexPath.row][@"poster_path"]];
    vc.photoURL = url;
}

-(void)setUpNavigationController{
    self.navigationItem.title = @"Posters";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
}

-(void)getMoviesNowPlaying{
    [MovieHelper getMoviesNowPlaying:^(NSArray *movies, bool status) {
        if (status){
            
            self.movies = movies;
            [self.collectionView reloadData];
            [SVProgressHUD dismiss];
            if (self.refreshControl.isRefreshing){
                [self.refreshControl endRefreshing];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"Failed to get movies"];
        }
    }];
}

-(void)configureRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(getMoviesNowPlaying) forControlEvents:UIControlEventValueChanged];
}

-(void)setUpCollectionView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    
    double width = self.view.frame.size.width/3.0;
    layout.itemSize = CGSizeMake(width, width * 1.5);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PosterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PosterCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    NSURL *movieURL = [MovieHelper getMovieURLFromPath:movie[@"poster_path"]];
    [cell.posterImageView setImageWithURL:movieURL];
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"ShowPosterPageView" sender:self];
}
//MARK:- Zoom Animator Delegate
- (nonnull UIImageView *)refereneImageViewFor:(nonnull ZoomAnimator *)zoomAnimator {
    PosterCollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:selectedIndexPath];
    return cell.posterImageView;
}

- (nonnull CGRect *)refereneImageViewFrameInTransitioningViewFor:(nonnull ZoomAnimator *)zoomAnimator {
    PosterCollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:selectedIndexPath];
    CGRect rect = [self.collectionView convertRect:cell.frame toView:self.view];
    return &rect;
    
}

- (void)transitionDidEndWith:(nonnull ZoomAnimator *)zoomAnimator {
    
}

- (void)transitionWillStartWith:(nonnull ZoomAnimator *)zoomAnimator {
    
}
@end
