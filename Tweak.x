// #include <CSColorPicker/CSColorPicker.h>
#define PLIST_PATH @"/var/mobile/Library/Preferences/com.v1s10n4.pictomizeprefs.plist"

bool GetPrefBool(NSString *key) {
	return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}

CGFloat GetPrefFloat(NSString *key) {
	return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] intValue];
}

@interface SBIconImageView : UIView
-(void) setShowsSquareCorners:(BOOL)square;
@end

%hook SBIconImageView
+(CGFloat) cornerRadius {
	if (GetPrefBool(@"enabled")) {
		return GetPrefFloat(@"radius");
	}
	return %orig;
}

-(void) layoutSubviews {
    %orig;

    NSLog(@"radius = %f", GetPrefFloat(@"radius"));
    NSLog(@"enabled = %d", GetPrefBool(@"enabled"));
    if (GetPrefBool(@"enabled") && ![NSStringFromClass(self.class) isEqual: @"SBFolderIconImageView"]) {
    	[self setShowsSquareCorners:true];
        self.layer.cornerRadius = GetPrefFloat(@"radius");
        self.layer.borderWidth = GetPrefFloat(@"borderWidth");
        self.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3].CGColor;
        self.clipsToBounds = true;
    }
}
%end