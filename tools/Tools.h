//
//  Tools.h
//
//  Created by Ben-J
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface Tools : NSObject

+ (void) displayAlertWithMessage:(NSString *)message andTitle:(NSString*)title;
+(BOOL) isNetworkAvailable;
+(void) trackPage:(NSString*)page;
+(NSString*) md5encode:(NSString*) str;
+(NSString*)base64forInt:(int)theInt;
+(NSString*)base64forString:(NSString*)theString;
+(NSString*)base64forData:(NSData*)theData;
+(NSMutableDictionary *)getPrefDictionary;
+(NSString*)getHashForInt:(int)intToHash;
+(NSString*)getHash:(NSString*)stringToHash;
+ (BOOL) isNetworkAvailableWithoutAlert;
+(NSURL*)encodeStringForUrl:(NSString*)callString;
+(BOOL)versionIsEqualOrSupAs:(int)version;
+ (NSString*)stringWithDeviceToken:(NSData*)deviceToken;
+(NSData*)getDataFromUrl:(NSURL*)url withAlert:(BOOL)alert;
+(NSData*)getDataFromStringUrl:(NSString*)link withAlert:(BOOL)alert;
+(BOOL)isIphone5;
+(BOOL) isValidEmail:(NSString *)checkString;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(NSString*)replaceEuroInString:(NSString*)str;
+(UIColor*)colorWithHexString:(NSString*)hex;

@end
