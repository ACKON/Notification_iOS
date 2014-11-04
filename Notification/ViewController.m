//
//  ViewController.m
//  Notification
//
//  Created by Hayden on 2014. 10. 29..
//  Copyright (c) 2014년 OliveStory. All rights reserved.
//

#import "ViewController.h"
#import <Ackon/Ackon.h>
@interface ViewController ()<ACKAckonManagerDelegate>
@property (nonatomic, strong) ACKAckonManager *ackonManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //_ackonManager 를 초기화 할때 Ackon 서버 도메인과 serviceIdentifer값을 넣어 초기화 해줍니다.
    //서드파티서버를 따로 구성하지 않았을 경우 initWithServiceIdentifier: 로 초기화 해줍니다.
    _ackonManager = [[ACKAckonManager alloc] initWithServerURL:[NSURL URLWithString:@"http://cms.ackon.co.kr/"] serviceIdentifier:@"SBA14100002"];
    self.ackonManager.delegate = self;
    //유저의 위치정보 수집 동의 후 서버에 유저 등록을 합니다.
    //유저등록은 최초에만 필수 이며 초기화 이후 필요하지 않습니다.
    [self.ackonManager requestEnabled:^(BOOL success, NSError *error) {//유저권한을 등록합니다.
        if(success){
            [self.ackonManager allAckonWithCompletionBlock:^(NSError *error, NSArray *result) {//애콘정보를 불러옵니다.
                [self.ackonManager startMonitoring];//모니터링을 시작합니다.
            }];
            
        }else{//실패시
            [[[UIAlertView alloc] initWithTitle:@"실패" message:error.description delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil] show];
        }
    }];
}

#pragma mark ACKAckonManagerDelegate
- (void)ackonManager:(ACKAckonManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{//비콘에 대한 in/out 시 발생하는 이벤트입니다.
    NSArray *array = [self.ackonManager getAckonInfoArray:(CLBeaconRegion *)region];
    if(state == CLRegionStateInside){//진입 상태일때만 처리
        for(ACKAckon *ackon in array){
            NSString *notiMessage = ackon.actions[@"noti"];//서버에서 UserDefine정보로 등록한 noti값을 찾습니다.
            if(notiMessage){//존재할경우 LocalNoti를 보냅니다.
                UILocalNotification *localNotification = [UILocalNotification new];
                localNotification.alertBody = [NSString stringWithFormat:@"%@(%@,%@) message:%@", [self stateStringFromRegionState:state],ackon.major?ackon.major.stringValue:@"",ackon.minor.stringValue?ackon.minor.stringValue:@"", notiMessage];
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                NSMutableDictionary *dictionary = [NSMutableDictionary new];
                [dictionary setValue:ackon.name forKey:@"name"];
                if(ackon.actions[@"link"]){//링크값이 있을시 userInfo에 담습니다.
                    [dictionary setValue:ackon.actions[@"link"] forKey:@"link"];
                }
                localNotification.userInfo = dictionary;
                localNotification.alertAction = @"Akcon";
                localNotification.repeatInterval = 0;
                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                
            }
        }
    }
}
#pragma mark Utilities
- (NSString *)stateStringFromRegionState:(CLRegionState)regionState{
    NSString *stateString = nil;
    switch (regionState) {
        case CLRegionStateInside:
            stateString = @"Inside";
            break;
        case CLRegionStateOutside:
            stateString = @"Outside";
            break;
        case CLRegionStateUnknown:
            stateString = @"Unkown";
            break;
    }
    return stateString;
}
@end
