//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "DemoHTTPStreamingServer.h"
#import "HTTPServer.h"


@implementation DemoHTTPStreamingServer

+ (instancetype)sharedInstance {
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
    [sharedInstance initialize];
  });
  
  return sharedInstance;
}

- (void)initialize {
  self.httpServer = [[HTTPServer alloc] init];
	[self.httpServer setType:@"_http._tcp."];
    [self.httpServer setPort:1314];

}

- (void)setDocumentRoot:(NSString *)webPath {
    
    
    [self.httpServer setDocumentRoot:webPath];
}

- (void)start {
  
  NSError *error;
	if([self.httpServer start:&error])
	{
        NSLog(@"%@",  self.httpServer.connectionClass);
        
//        [self.httpServer setConnectionClass:1000];
		NSLog(@"Started HTTP Server on port %hu", [self.httpServer listeningPort]);
	}
	else
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
}

- (void)stop {
  [self.httpServer stop];
}



@end
