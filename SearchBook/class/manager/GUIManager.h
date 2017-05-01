//
//  GUIManager.h
//  Address
//
//  Created by SungJu on 2017. 3. 18..
//  Copyright © 2017년 Address. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GUIManager : NSObject

typedef void(^PopupViewCompletionBlock)(NSDictionary* dict);

@property (nonatomic, strong) UINavigationController * mainNavigationController;
@property (assign, nonatomic) BOOL isShowSetting;

+ (GUIManager *)sharedInstance;

- (void)setSetting:(NSArray*)array delegate:(id)delegate;
- (void)showSetting;
- (void)hideSetting;
- (void)removeSetting;

- (void)moveToHome;
- (void)moveToController:(UIViewController*)controller animation:(BOOL)isAnimation;
- (void)backControllerWithAnimation:(BOOL)isAnimation;

- (void)showPopup:(UIViewController*)controller animation:(BOOL)isAnimation complete:(PopupViewCompletionBlock)complete;
- (void)hidePopup:(UIViewController*)controller animation:(BOOL)isAnimation completeData:(NSDictionary*)data;

- (void)showAlert:(NSString*)message viewCon:(UIViewController*)viewCon handler:(void (^)(UIAlertAction *action))handler;
- (void)showComfirm:(NSString*)message viewCon:(UIViewController*)viewCon handler:(void (^)(UIAlertAction *action))handler cancelHandler:(void (^)(UIAlertAction *action))cancelHandler;

@end
