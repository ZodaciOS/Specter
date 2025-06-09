#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

%hook SpringBoard

// After SpringBoard launches, trigger horror if .specter_trigger exists
- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/.specter_trigger"]) {
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/.specter_trigger" error:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self activateSpecterMode];
        });
    }
}

// After unlock, open Safari if prank was triggered
- (void)_lockScreenDidDisappear:(id)arg1 {
    %orig;

    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/.specter_open_site"]) {
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/.specter_open_site" error:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:@"https://yourwebsite.com"];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        });
    }
}

%new
- (void)activateSpecterMode {
    // Set scary wallpaper
    UIImage *scaryImage = [UIImage imageWithContentsOfFile:@"/var/mobile/horror.jpg"];
    [[%c(SBWallpaperController) sharedInstance] setWallpaperImage:scaryImage forLocations:3];

    // Hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    // Play horror music
    system("avplay /var/mobile/horror.mp3 &");

    // Glitch effect after 10 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self startGlitchAnimation];
    });

    // Set post-prank flag to launch Safari later
    [[NSFileManager defaultManager] createFileAtPath:@"/var/mobile/.specter_open_site" contents:nil attributes:nil];

    // Userspace reboot after 12 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 12 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        system("/var/jb/usr/bin/ldrestart");
    });
}

%new
- (void)startGlitchAnimation {
    UIView *glitch = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    glitch.backgroundColor = [UIColor redColor];
    glitch.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:glitch];

    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        glitch.alpha = 0.9;
    } completion:nil];
}

%end
