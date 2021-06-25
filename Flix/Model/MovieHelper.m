//
//  Movie.m
//  Flix
//
//  Created by Keng Fontem on 6/23/21.
//

#import <Foundation/Foundation.h>
#import "MovieHelper.h"
@implementation MovieHelper: NSObject
//MARK:- Get Movies
/*
 -I made it static so this method can be easily access anywhere in the program
 
 -I tried to make a MovieHelper class to handle this logic, but for some reason Xcode didn't recognize "Movie" as an object, so I couldn't use it in the completion handler.
 */
//MARK:- Get Moves That Are Now Playing
+ (void) getMoviesNowPlaying: (getMoviesBlock)completion{
    //Get's the movies that are now playing
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               //If the network task fails, it sends false in the completion handler
               completion([[NSArray alloc]init], NO);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               completion(dataDictionary[@"results"], YES);
           }
       }];
    [task resume];
}

//MARK:- GET NSURL FROM DICTIONARY
+ (NSURL *)getMovieURLFromPath:(NSString *)posterURLString{
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [[NSURL alloc]initWithString:fullPosterURLString];
    return posterURL;
}

@end
