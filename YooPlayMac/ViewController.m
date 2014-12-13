//
//  ViewController.m
//  YooPlayMac
//
//  Created by bejoy on 14/11/20.
//  Copyright (c) 2014年 zeng. All rights reserved.
//

#import "ViewController.h"
#import "IPDetector.h"
#import "DemoHTTPStreamingServer.h"


#define KServerPath @"serverPath"

@implementation ViewController


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    NSLog( @"%@", object);
    
}


- (void)directoryDidChange:(DirectoryWatcher *)folderWatcher
{
    
    isChangeIndex  = !isChangeIndex;


    if ( isChangeIndex ) {
        NSLog(@"%@", @"索引 改变");
        [self buildPathFile];
    }

}



- (void)obServerServerPath {
    self.docWatcher = [DirectoryWatcher watchFolderWithPath:serverPath delegate:self];
}


- (void)getIP {
    [IPDetector getLANIPAddressWithCompletion:^(NSString *IPAddress) {
        NSLog(@"%@", IPAddress);


        if (IPAddress) {
            self.ipTextLabel.stringValue = IPAddress;
            NSString *ipString = [IPAddress componentsSeparatedByString:@"."][3] ;
            self.ipSubTextLabel.stringValue = ipString;
            
        }
        
        //    生产索引目录
        //    index.html
        //    allfile.json
        //    allfile.html
        [self buildPathFile];
    }];
    
}

- (void)setSerVerPath {
    self.serverPathTextLabel.stringValue = serverPath;
//    serverPath = self.serverPathTextLabel.stringValue;
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web"];
    
    webPath = serverPath;
    [[DemoHTTPStreamingServer sharedInstance] setDocumentRoot:webPath];
    
    
    [self obServerServerPath];

}

- (void)startServer {
    isStart = YES;
    self.serverStatusLabel.stringValue = @"正在运行...";
    self.serverStatusLabel.textColor = [NSColor greenColor];
    
    [[DemoHTTPStreamingServer sharedInstance] start];
    
    [self.controlButton setTitle: @"停止服务"];

}

- (void)stopServer {
    
    isStart = NO;
    self.serverStatusLabel.stringValue = @"已停止";
    self.serverStatusLabel.textColor = [NSColor redColor];
    [[DemoHTTPStreamingServer sharedInstance] stop];

    
    [self.controlButton setTitle: @"开始服务"];
}


- (void)buildPath {
    
    NSFileManager *filemgr;
    NSString *pathString;
    filemgr = [NSFileManager defaultManager];
    
    pathString = [NSHomeDirectory() stringByAppendingPathComponent:@"Yoo同步盘"];
    
    NSLog(@"%@", pathString);
    serverPath = pathString;
    
    [[NSUserDefaults standardUserDefaults] setObject:serverPath forKey:KServerPath];
    
    
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:serverPath];
    
    

    NSError *error;
    bool isSuccess =  [filemgr createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
    
    if ( ! isSuccess) {
        NSLog(@"创建同步盘文件夹错误");
    }
    

}

- (void)buildPathFile {
    
    

    NSFileManager *filemgr;
    NSString *pathString;
    
    filemgr = [NSFileManager defaultManager];
    
    pathString = serverPath;
    
    NSDirectoryEnumerator *direnum = [filemgr enumeratorAtPath:pathString];

    
    
    NSMutableArray *files = [NSMutableArray arrayWithCapacity:42];
//    数据字典
    NSMutableDictionary *htmlDicts = [NSMutableDictionary dictionary];
    
    NSString *filename ;
    while (filename = [direnum nextObject]) {
        if (  [[[filename pathExtension] lowercaseString] isEqualTo:@"wmv"]
            || [[[filename pathExtension] lowercaseString] isEqualTo:@"avi"]
            || [[[filename pathExtension] lowercaseString]  isEqualTo:@"rmvb"]
            || [[[filename pathExtension] lowercaseString]  isEqualTo:@"rm"]
            || [[[filename pathExtension] lowercaseString]  isEqualTo:@"asf"]
            || [[[filename pathExtension] lowercaseString]  isEqualTo:@"mpg"]
            || [[[filename pathExtension] lowercaseString]  isEqualTo:@"mpeg"]
            || [[[filename pathExtension] lowercaseString]  isEqualTo:@"mp4"]
            || [[[filename pathExtension] lowercaseString]  isEqualTo:@"mkv"]
            || [[[filename pathExtension] lowercaseString]  isEqualTo:@"m4v"]
            || [[[filename pathExtension] lowercaseString]  isEqualTo:@"ts"]
            || [[[filename pathExtension] lowercaseString]  isEqualTo:@"xvid"]
            || [[[filename pathExtension] lowercaseString]  isEqualTo:@"dvix"]
            ) { //[[filename pathExtension] isEqualTo:@"jpg"]
            
            [files addObject: filename];
//            文件名
            NSString* theFileName = [filename lastPathComponent];
//            网络地址
            [htmlDicts setValue:filename forKey:theFileName];
            
        }
    }
    
//    NSEnumerator *fileenum;
//    fileenum = [files objectEnumerator];
//    
//    while (filename = [fileenum nextObject]) {
//        NSLog(@"%@", filename);
//    }
    
//    保存html
    NSString *allFileHtml = [NSString stringWithFormat:@"%@/allFile.html", serverPath];
    NSString *indexHtml = [NSString stringWithFormat:@"%@/index.html", serverPath];
    NSString *allFilePlist = [NSString stringWithFormat:@"%@/allFile.plist", serverPath];

    NSMutableString *htmlString = [NSMutableString string];
    
    [htmlString appendFormat:@"<html>"];
    [htmlString appendFormat:@"<head>"];
    [htmlString appendFormat:@"<meta charset=\"utf-8\">"];
    [htmlString appendFormat:@"<title>所有文件</title>"];
    [htmlString appendFormat:@"</head>"];
    [htmlString appendFormat:@"<body>"];
    [htmlDicts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [htmlString appendFormat:@"<a href=\"/%@\"> %@</a><br />", obj, key];
    }];
    [htmlString appendFormat:@"</body>"];
    [htmlString appendFormat:@"</html>"];
    
    
    [htmlString writeToFile:allFileHtml atomically:YES encoding:NSUTF8StringEncoding error:nil];
    

//    保存 plist
    
    [files writeToFile:allFilePlist atomically:YES];
    
//    生成 index.html 文件
    

    htmlString = nil;
    htmlString = [NSMutableString string];
    
    [htmlString appendFormat:@"<html>"];
    [htmlString appendFormat:@"<head>"];
    [htmlString appendFormat:@"<meta charset=\"utf-8\">"];
    [htmlString appendFormat:@"<title>Yoo的同步盘~</title>"];
    [htmlString appendFormat:@"</head>"];
    [htmlString appendFormat:@"<body>"];
    
    [htmlString appendFormat:@"<h1> %@</h1><br />", @"启动成功"];
    [htmlString appendFormat:@"<a href=\"/allFile.html\"> %@</a><br />", @"查看所有文件"];

    
    [htmlString appendFormat:@"</body>"];
    [htmlString appendFormat:@"</html>"];

    
    
    
    [htmlString writeToFile:indexHtml atomically:YES encoding:NSUTF8StringEncoding error:nil];

    
    
    isChangeIndex  = YES;


}



- (IBAction)serverControl:(id)sender {
    
    
    if ( isStart ) {
        [self stopServer];
    }
    else
        [self startServer];
    
    
}

- (IBAction)openWebSite:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:1314", self.ipTextLabel.stringValue];
    NSURL *url = [NSURL URLWithString:urlString];
    if( ![[NSWorkspace sharedWorkspace] openURL:url] )
        NSLog(@"Failed to open url: %@",[url description]);
    
    
    
}

- (IBAction)openFilesFinder:(id)sender {
    
    [[NSWorkspace sharedWorkspace] selectFile:serverPath inFileViewerRootedAtPath:nil];
    
    
}


#pragma mark -  handoff acitiy

//
//// set actiivy
//- (void)initActivity {
//
//    
//    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.yooyoi.yooplay"];
//    userActivity.title = @"server url";
//    userActivity.userInfo = @{ @"message": @"192.168.1.999" };
//    
//    [userActivity becomeCurrent];
//    [userActivity invalidate];
//    
//    userActivity.delegate = self;
//    userActivity.needsSave = YES;
//
//
//    _userActivity = userActivity;
//    
//    [self setUserActivity:_userActivity];
//
//    
//    
//}
//
//- (void)updateUserActivityState:(NSUserActivity *)userActivity  {
//    [userActivity setTitle: @"new server url"];
//    [userActivity addUserInfoEntriesFromDictionary: @{ @"server": @"192.11.1.1" }];
//}
//
//- (void)userActivity:(NSUserActivity *)userActivity didReceiveInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
//    
//}
//
//- (void)userActivityWasContinued:(NSUserActivity *)userActivity {
//    
//}
//
//- (void)userActivityWillSave:(NSUserActivity *)userActivity {
//    
//}

#pragma mark - view cycle

- (void)loadView {
    [super loadView];
    
//    生成用户目录
    [self buildPath];


//    获取本地ip
    [self getIP];
    
//  设置服务器的 根目录
    [self setSerVerPath];

    
//    启动服务
    [self startServer];



//    [self initActivity];
    

    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
