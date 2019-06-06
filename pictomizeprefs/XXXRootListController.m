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
    	alertControllerWithTitle:@"Respring"
        message:@"Are You Sure You Want To Respring?"
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

@end
