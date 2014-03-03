//
//  AppManager.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "AppManager.h"

@interface AppManager()
@end

@implementation AppManager
static AppManager* sharedInstance = nil;
 
+ (id)sharedManager
{
    //static SingletonTest* sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppManager alloc]init];
    });
    return sharedInstance;
}

- (id)init
{
    AppManager *manager = [super init];
    if (manager) {
        [self initWithSettings];
    }
    return manager;
}

- (void)initWithSettings
{
    self.takenImage = [UIImage imageNamed:@"abc.jpg"];
    self.selectedStamps = [[NSMutableArray alloc] init];
    self.stamps = [[NSMutableArray alloc] init];
    
    self.selectedStampIdx = NOT_SELECTED_STAMP_IDX;
    
    // スタンプを読み込む
    [self updateStamps];
}

/**
* @brief スタンプの情報を読み込む
*/
- (void)updateStamps
{
    // jsonファイルを読み込む
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"stamps" ofType:@"json"];
    NSError *error = nil;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUnicodeStringEncoding];
    // jsonを配列に変換する
    error = nil;
    NSArray *stamps = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
    for (NSString *stampName in stamps) {
        [_stamps addObject:stampName];
    }
}

@end
