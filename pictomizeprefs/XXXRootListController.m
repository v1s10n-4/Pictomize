#include "XXXRootListController.h"

@interface NSTask : NSObject

@property (copy) NSArray *arguments;
@property (copy) NSString *currentDirectoryPath;
@property (copy) NSString *launchPath;

- (id)init;
- (void)launch;

@end

@implementation XXXRootListController

-(NSArray *) specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

- (void) respring {
    UIAlertController *alert = [
    	UIAlertController 
    	alertControllerWithTitle:@"Pictomize"
        message:@"This will apply all your current settings"
        preferredStyle:UIAlertControllerStyleActionSheet
    ];
    
    UIAlertAction *respringBtn = [
    	UIAlertAction 
    	actionWithTitle:@"Respring"
        style:UIAlertActionStyleDestructive 
        handler:^(UIAlertAction * action) {
            NSTask *t = [[NSTask alloc] init];
    		[t setLaunchPath:@"/usr/bin/killall"];
    		[t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    		[t launch];
        }];

    UIAlertAction *cancelBtn = [
    	UIAlertAction actionWithTitle:@"Cancel"
        style:UIAlertActionStyleCancel 
        handler:^(UIAlertAction * action) {}
    ];
    [alert addAction:respringBtn];
    [alert addAction:cancelBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)launchTwitter:(id)sender {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/V1s10n_4"] options:@{} completionHandler:nil];
}

- (void)launchGithub:(id)sender {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/vision-4/Pictomize"] options:@{} completionHandler:nil];
}
- (void)launchDonate:(id)sender {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=TYH44YTNFW4M6&source=url"] options:@{} completionHandler:nil];
}
@end
