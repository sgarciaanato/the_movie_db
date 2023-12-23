//
//  NetworkManager.h
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

- (void)performGetWithEndpoint:(NSString *)endpoint completionHandler:(void (^)(NSData*, NSError*))completion;
- (void)performGetResourceWithEndpoint:(NSString *)endpoint completionHandler:(void (^)(NSData* __nullable, NSError* __nullable))completion;

@end

NS_ASSUME_NONNULL_END
