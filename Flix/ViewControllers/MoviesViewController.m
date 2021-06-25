//
//  ViewController.m
//  Flix
//
//  Created by Keng Fontem on 6/23/21.
//

#import "MoviesViewController.h"
#import "MovieHelper.h"
#import "MovieTableViewCell.h"
#import "DetailViewController.h"
#import "SVProgressHUD.h"
@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation MoviesViewController

//MARK:- Viewcontroller lifecycle functions
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self configureRefreshControl];
    [self setUpNavigationController];
    [SVProgressHUD show];
    [self getMoviesNowPlaying];
}

//MARK:- View Setup and control functions
-(void)configureRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(getMoviesNowPlaying) forControlEvents:UIControlEventValueChanged];
}
-(void)setUpTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
-(void)setUpNavigationController{
    self.navigationItem.title = @"Now Playing";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
}
-(void)getMoviesNowPlaying{
    [MovieHelper getMoviesNowPlaying:^(NSArray *movies, bool status) {
        if (status){
            self.movies = movies;
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            if (self.refreshControl.isRefreshing){
                [self.refreshControl endRefreshing];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"Failed to get movies"];
        }
    }];
}



//MARK:- View Transition Logic
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSMutableDictionary *movie = self.movies[indexPath.row];
    DetailViewController *detailViewController = segue.destinationViewController;
    detailViewController.movie = movie;
}

//MARK:- UITableView Delegate/Datasource Functions
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    [cell setUpFrom:movie];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
