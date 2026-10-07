#import <UIKit/UIKit.h>

static NSString *const kCreditText = @"@Ryuma";
static NSString *const kTelegramLink = @"https://t.me/ryumahackff";

static UIWindow *FindKeyWindow(void) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *window in ((UIWindowScene *)scene).windows) {
            if (window.isKeyWindow) return window;
        }
    }
    return nil;
}

static void ShowTelegramButton(int attempt) {
    UIWindow *window = FindKeyWindow();
    if (!window) {
        if (attempt < 25) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                ShowTelegramButton(attempt + 1);
            });
        }
        return;
    }

    if ([window viewWithTag:987654]) return;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = 987654;
    [btn setTitle:kCreditText forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    btn.layer.cornerRadius = 8;
    btn.clipsToBounds = YES;
    btn.contentEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);

    [btn addAction:[UIAction actionWithHandler:^(__kindof UIAction *action) {
        NSURL *url = [NSURL URLWithString:kTelegramLink];
        if (url) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }] forControlEvents:UIControlEventTouchUpInside];

    [btn sizeToFit];
    
    CGFloat top = window.safeAreaInsets.top + 6;
    btn.frame = CGRectMake(10, top, btn.frame.size.width + 8, 28);
    
    [window addSubview:btn];
}

__attribute__((constructor))
static void InitTelegramButton(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        ShowTelegramButton(0);
    });
}
