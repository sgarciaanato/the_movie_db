//
//  NetworkManager.m
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

#import "NetworkManager.h"

@implementation NetworkManager

NSString * const baseURL = @"https://api.themoviedb.org";
NSString * const resourcesURL = @"https://image.tmdb.org/t/p/w500";
NSString * const apiKey = @"83124cd7f7e0998f78a774bf642fb2b7";

- (void)performGetWithEndpoint:(NSString *)endpoint parameters:(NSDictionary* __nullable)parameters completionHandler:(void (^)(NSData* __nullable, NSError* __nullable))completion
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@?api_key=%@", baseURL, endpoint, apiKey];
    
    for(id key in parameters) {
        url = [[NSString alloc] initWithFormat:@"%@&%@=%@", url, key, [parameters objectForKey:key]];
    }
    
    NSLog(@"(GET) -> %@", url);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];

    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
        if (error != nil) {
            completion(nil, error);
            return;
        }
        
        if (data == nil) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"no data to be returned" forKey:NSLocalizedDescriptionKey];
            NSError *customError = [NSError errorWithDomain:@"Empty" code:500 userInfo:details];
            completion(nil, customError);
            return;
        }
        
        completion(data, nil);
    }];
    [dataTask resume];
}
- (void)performGetResourceWithEndpoint:(NSString *)endpoint completionHandler:(void (^)(NSData* __nullable, NSError* __nullable))completion
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@", resourcesURL, endpoint];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];

    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
        if (error != nil) {
            completion(nil, error);
            return;
        }
        
        if (data == nil) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"no data to be returned" forKey:NSLocalizedDescriptionKey];
            NSError *customError = [NSError errorWithDomain:@"Empty" code:500 userInfo:details];
            completion(nil, customError);
            return;
        }
        
        completion(data, nil);
    }];
    [dataTask resume];
}

@end
