//
//  Movie.h
//  Flix
//
//  Created by Keng Fontem on 6/23/21.
//
#import <UIKit/UIKit.h>
@interface MovieHelper: NSObject

//Define a block as a custom type
typedef void(^getMoviesBlock)(NSArray<NSDictionary*>* movie, bool status);

//Implement the block
+ (void) getMoviesNowPlaying: (getMoviesBlock)completion;
+ (NSURL*) getMovieURLFromPath: (NSString*)movie;
@end
