//
//  DOUAPIClient+Online.m
//  Online
//
//  Created by liaojinxing on 14-2-21.
//  Copyright (c) 2014年 douban. All rights reserved.
//

#import "DOUAPIClient+Online.h"
#import "AppConstant.h"

@implementation DOUAPIClient(Online)

+ (DOUAPIClient *)createHttpClient
{
  DOUAPIClient *client = [[DOUAPIClient alloc] initWithBaseURL:kAPIBaseURL];
  [client setBodyParameterJSONEncodingEnabled:NO];
  [DOUAPIClient setNetworkActivityIndicatorEnable:YES];
  return client;
}

- (void)getHotOnlinesByCast:(NSString *)cast
                      start:(int)start
                      count:(int)count
                  succeeded:(void (^)(OnlineArray *onlineArray))succeeded
                     failed:(DOUAPIRequestFailErrorBlock)failed
{
  NSParameterAssert(succeeded != NULL);
  NSString *finalPath = [NSString stringWithFormat:@"v2/onlines"];
  
  NSMutableDictionary *parameter = [[NSMutableDictionary alloc]initWithCapacity:3];
  [parameter setObject:cast forKey:@"cate"];
  [parameter setValue:[NSNumber numberWithInt:count] forKey:@"count"];
  [parameter setObject:[NSNumber numberWithInt:start] forKey:@"start"];
  
  [self getPath:finalPath parameters:parameter success:^(NSString *string) {
    NSError* err = nil;
    OnlineArray *array = [[OnlineArray alloc] initWithString:string error:&err];
    if (succeeded && err == nil) {
      succeeded(array);
    }
  } failure:^(DOUError *error) {
    if (failed) {
      failed(error);
    }
  }];
}

- (void)getDailyHotOnlinesWithStart:(int)start
                              count:(int)count
                          succeeded:(void (^)(OnlineArray *onlineArray))succeeded
                             failed:(DOUAPIRequestFailErrorBlock)failed
{
  [self getHotOnlinesByCast:@"day" start:start count:count succeeded:succeeded failed:failed];
}

- (void)getWeeklyHotOnlinesWithStart:(int)start
                               count:(int)count
                           succeeded:(void (^)(OnlineArray *onlineArray))succeeded
                              failed:(DOUAPIRequestFailErrorBlock)failed
{
  [self getHotOnlinesByCast:@"week" start:start count:count succeeded:succeeded failed:failed];
}

- (void)getLatestHotOnlinesWithStart:(int)start
                               count:(int)count
                           succeeded:(void (^)(OnlineArray *onlineArray))succeeded
                              failed:(DOUAPIRequestFailErrorBlock)failed
{
  [self getHotOnlinesByCast:@"latest" start:start count:count succeeded:succeeded failed:failed];
}

@end