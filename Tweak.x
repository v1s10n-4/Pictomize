#include <CSColorPicker/CSColorPicker.h>
#include <CSPreferences/libCSPreferences.h>
#define PLIST_PATH @"/var/mobile/Library/Preferences/com.v1s10n4.pictomizeprefs.plist"

bool GetPrefBool(NSString *key) {
	return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}

CGFloat GetPrefFloat(NSString *key) {
	return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] intValue];
}

NSString *GetPrefString(NSString *key) {
    return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] stringValue];
}

@interface SBIconImageView : UIView
-(void) setShowsSquareCorners:(BOOL)square;
@end

%hook SBIconImageView
+ (CGFloat)cornerRadius {
	if (GetPrefBool(@"enabled")) {
		return GetPrefFloat(@"radius");
	}
	return %orig;
}

- (void)layoutSubviews {
    %orig;
    if (GetPrefBool(@"enabled") && ![NSStringFromClass(self.class) isEqual: @"SBFolderIconImageView"]) {
    	[self setShowsSquareCorners:true];
        [self.layer setMasksToBounds:true];
        self.layer.cornerRadius = GetPrefFloat(@"radius");
        self.layer.borderWidth = GetPrefFloat(@"borderWidth");
        self.layer.borderColor = [UIColor cscp_colorFromHexString:GetPrefString(@"borderColor")].CGColor;
        self.clipsToBounds = true;
    }
}
%end

%hook SBFloatyFolderView
+ (CGFloat)defaultCornerRadius {
    if (GetPrefBool(@"folderRadiusEnabled"))
        return GetPrefFloat(@"folderBorderRadius");
    return %orig;
}
%end

@interface SBFloatyFolderBackgroundClipView : UIView
@end

%hook SBFloatyFolderBackgroundClipView
- (void)layoutSubviews {
    %orig;
    if(GetPrefBool(@"folderWidthEnabled")) {
        [self.layer setMasksToBounds:true];
        self.layer.borderWidth = GetPrefFloat(@"folderBorderWidth");
        self.layer.borderColor = [UIColor cscp_colorFromHexString:GetPrefString(@"folderBorderColor")].CGColor;
    }
}
%end

%hook SBMutableIconLabelImageParameters
- (void)setText:(NSString *)text {
	if (GetPrefBool(@"labelEnabled") && ([GetPrefString(@"labelText") length] > 0))
		text = GetPrefString(@"labelText");
	%orig(text);
}

- (void)setFont:(UIFont *)font {
	CGFloat size = GetPrefFloat(@"labelFontSize");
	if (GetPrefBool(@"labelEnabled"))
		font = [UIFont fontWithName:GetPrefString(@"labelFont") size: !size ? 12 : size];
	%orig(font);
}

- (void)setTextColor:(UIColor *)color {
	if (GetPrefBool(@"labelEnabled"))
		color = [UIColor cscp_colorFromHexString:GetPrefString(@"labelFontColor")];
	%orig(color);
}
%end
