#include <CSColorPicker/CSColorPicker.h>
#include <CSPreferences/libCSPreferences.h>

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.v1s10n4.pictomizeprefs.plist"
#define ZALGO_DOWN @[@"̖",@"̗",@"̘",@"̙",@"̜",@"̝",@"̞",@"̟",@"̠",@"̤",@"̥",@"̦",@"̩",@"̪",@"̫",@"̬",@"̭",@"̮",@"̯",@"̰",@"̱",@"̲",@"̳",@"̹",@"̺",@"̻",@"̼",@"ͅ",@"͇",@"͈",@"͉",@"͍",@"͎",@"͓",@"͔",@"͕",@"͖",@"͙",@"͚",@"̣"]
#define ZALGO_MID @[@"̕",@"̛",@"̀",@"́",@"͘",@"̡",@"̢",@"̧",@"̨",@"̴",@"̵",@"̶",@"͏",@"͜",@"͝",@"͞",@"͟",@"͠",@"͢",@"̸",@"̷",@"͡",@"҉"]
#define ZALGO_UP @[@"̍",@"̎",@"̄",@"̅",@"̿",@"̑",@"̆",@"̐",@"͒",@"͗",@"͑",@"̇",@"̈",@"̊",@"͂",@"̓",@"̈́",@"͊",@"͋",@"͌",@"̃",@"̂",@"̌",@"͐",@"̀",@"́",@"̋",@"̏",@"̒",@"̓",@"̔",@"̽",@"̉",@"ͣ",@"ͤ",@"ͥ",@"ͦ",@"ͧ",@"ͨ",@"ͩ",@"ͪ",@"ͫ",@"ͬ",@"ͭ",@"ͮ",@"ͯ",@"̾",@"͛",@"͆",@"̚"]

static bool GetPrefBool(NSString *key) {
	return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}

static CGFloat GetPrefFloat(NSString *key) {
	return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] intValue];
}

static NSString *GetPrefString(NSString *key) {
    return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] stringValue];
}

static NSString *randZalgo(NSArray *array) {
	return [array objectAtIndex: arc4random_uniform([array count])];
}

// Thanks to cihancimen to be smarter than me:
// https://gist.githubusercontent.com/cihancimen/4146056/raw/b0a51825a6027c35d7ea8deb571d5a63619174fa/string_contains_emoji
static BOOL stringContainsEmoji(NSString *string) {
	__block BOOL returnValue = NO;
	[string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
	^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		const unichar hs = [substring characterAtIndex:0];
		if (0xd800 <= hs && hs <= 0xdbff) {
			if (substring.length > 1) {
				const unichar ls = [substring characterAtIndex:1];
				const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
				if (0x1d000 <= uc && uc <= 0x1f77f) {
					returnValue = YES;
				}
			}
		} else if (substring.length > 1) {
			const unichar ls = [substring characterAtIndex:1];
			if (ls == 0x20e3) {
				returnValue = YES;
			}
		} else {
			if (0x2100 <= hs && hs <= 0x27ff) {
				returnValue = YES;
			} else if (0x2B05 <= hs && hs <= 0x2b07) {
				returnValue = YES;
			} else if (0x2934 <= hs && hs <= 0x2935) {
				returnValue = YES;
			} else if (0x3297 <= hs && hs <= 0x3299) {
				returnValue = YES;
			} else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
				returnValue = YES;
			}
		}
	}];
	return returnValue;
}

static NSString *zalgoString(NSString *string) {
	if (stringContainsEmoji(string) && GetPrefBool(@"labelZalgoExcludeEmojiEnabled"))
		return string;
	NSString *newstring = @"";
	BOOL isRand = GetPrefBool(@"labelZalgoRandEnabled");
	NSInteger labelzalgoUp = GetPrefFloat(@"labelzalgoUp");
	NSInteger labelzalgoMid = GetPrefFloat(@"labelzalgoMid");
	NSInteger labelzalgoDown = GetPrefFloat(@"labelzalgoDown");	
	for (NSInteger i = 0; i < string.length; i++) {
		newstring = [newstring stringByAppendingString:[string substringWithRange:NSMakeRange(i, 1)]];
		NSInteger num_up = isRand ? arc4random_uniform(labelzalgoUp) : labelzalgoUp;
		NSInteger num_mid = isRand ? arc4random_uniform(labelzalgoMid) : labelzalgoMid;
		NSInteger num_down = isRand ? arc4random_uniform(labelzalgoDown) : labelzalgoDown;
		for (NSInteger j = 0; j < num_up; j++)
			newstring = [newstring stringByAppendingString:randZalgo(ZALGO_UP)];
		for (NSInteger j = 0; j < num_mid; j++)
			newstring = [newstring stringByAppendingString:randZalgo(ZALGO_MID)];
		for (NSInteger j = 0; j < num_down; j++)
			newstring = [newstring stringByAppendingString:randZalgo(ZALGO_DOWN)];
	}
	return newstring;
}

@interface SBIconImageView : UIView
-(void) setShowsSquareCorners:(BOOL)square;
@end

@interface SBFloatyFolderBackgroundClipView : UIView
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
	if (GetPrefBool(@"labelEnabled") && GetPrefBool(@"labelZalgoEnabled"))
		text = zalgoString(text);
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
