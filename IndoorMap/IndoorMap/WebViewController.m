//
//  AppDelegate.h
//  IndoorMap
//
//  Created by 罗吕根 on 2018/8/10.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "WebViewController.h"
#import <TencentLBS/TencentLBSLocationManager.h>

@interface WebViewController()<TencentLBSLocationManagerDelegate>
@property(strong, nonatomic) TencentLBSLocationManager *locationManager;
@property(strong, nonatomic) UIWebView *webView;

//@property NSInteger time;
@end

@implementation WebViewController

- (void)setupWeb
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://lbs.gtimg.com/visual/indoor_map_demos/apph5/index.html?bid=110000221958&cid=110100&key=EAUBZ-J4PRU-JQYVE-B7VGD-TP3JK-APFAI&referer=wjz"]]];
    [self.view addSubview:self.webView];
  
}

-(void)setupLocationManager
{
    self.locationManager = [[TencentLBSLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setApiKey:@"Z7RBZ-HPE6D-7674W-PSCBC-MQKC7-UTBG5"];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    self.locationManager.requestLevel = TencentLBSRequestLevelPoi;
    [self.locationManager setPoiUpdateInterval:1];
    [self.locationManager startUpdatingLocation];
}

- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager didUpdateLocation:(TencentLBSLocation *)location
{
    if(location.name != nil && location.buildingFloor != nil)
    {
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ %@", location.name, location.buildingFloor]];
    }
    [self sendMessage2Js:location Error :nil];

}

- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager didFailWithError:(NSError *)error
{
    if(error.code >= 0 && error.code <= 4)
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:error.domain message:nil preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action){}]];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)sendMessage2Js:(TencentLBSLocation *)location Error:(NSError *)error
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(error != nil && error.code != 0)
    {
        [dict setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"errMsg"];
    } else
    {
        [dict setObject:[NSString stringWithFormat:@"%f", location.location.coordinate.latitude] forKey:@"currentLat"];
        [dict setObject:[NSString stringWithFormat:@"%f", location.location.coordinate.longitude] forKey:@"currentLon"];
        [dict setObject:location.buildingId forKey:@"indoorBuildingId"];
        [dict setObject:location.buildingFloor forKey:@"indoorBuildingFloor"];
        [dict setObject:[NSString stringWithFormat:@"%f", location.location.horizontalAccuracy] forKey:@"currentAccuracy"];
        [dict setObject:[NSString stringWithFormat:@"%f", location.location.course]  forKey:@"currentDirection"];
        [dict setObject:[NSString stringWithFormat:@"%f", location.location.speed] forKey:@"currentSpeed"];
        [dict setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"errMsg"];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"processIndoorMsg(%@)", json]];
}

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupWeb];
    [self setupLocationManager];
    
}

@end
