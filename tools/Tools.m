//
//  Tools.m
//
//  Created by Ben-J
//

#import "Tools.h"

@implementation Tools


+ (void) displayAlertWithMessage:(NSString *)message andTitle:(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

+ (BOOL) isNetworkAvailable
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
        return NO;
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    if (!isReachable && !needsConnection)
        [self displayAlertWithMessage:NSLocalizedString(@"networkError", @"") andTitle:NSLocalizedString(@"alert", @"")];
    return (isReachable && !needsConnection);
}

+ (BOOL) isNetworkAvailableWithoutAlert
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
        return NO;
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection);
}

+ (void) trackPage:(NSString*)page
{
    //[[[GAI sharedInstance] defaultTracker] sendView:page];
}

+ (NSString*) md5encode:(NSString*) str
{
    // Create pointer to the string as UTF8
    const char *ptr = [str UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

+ (NSString*)base64forInt:(int)theInt
{
    return [self base64forString:[NSString stringWithFormat:@"%d", theInt]];
}

+ (NSString*)base64forString:(NSString*)theString {
    return [self base64forData:[theString dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+(NSMutableDictionary *)getPrefDictionary
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentDirectory stringByAppendingPathComponent:@"preference.plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *dictionnary = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if(!dictionnary){
        NSLog(@"error : %@", errorDesc);
        return nil;
    }
    return [NSMutableDictionary dictionaryWithDictionary:[dictionnary objectForKey:@"prefDictionary"]];
}


+(NSString*)getHashForInt:(int)intToHash
{
    return [self getHash:[NSString stringWithFormat:@"%d", intToHash]];
}

+(NSString*)getHash:(NSString*)stringToHash
{
    const char *cKey  = [ipayek cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [stringToHash cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    return [self base64forData:HMAC];
}


+(NSURL*)encodeStringForUrl:(NSString*)callString
{
    return [[NSURL alloc] initWithString:(__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)callString, NULL, (CFStringRef)@"!*'();@+$,%#[]", kCFStringEncodingUTF8 )];
}

+(BOOL)versionIsEqualOrSupAs:(int)version
{
    return [[UIDevice currentDevice].systemVersion floatValue] >= version;
}

+ (NSString*)stringWithDeviceToken:(NSData*)deviceToken {
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    return [token copy];
}

+(NSData*)getDataFromUrl:(NSURL*)url withAlert:(BOOL)alert
{
    NSLog(@"url=%@", [url absoluteString]);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setPersistentConnectionTimeoutSeconds:TIME_OUT];
    [request startSynchronous];
    [request setNumberOfTimesToRetryOnTimeout:2];
    NSError *error = [request error];
    if (!error) {
        return [request responseData];
    }
    else if (alert){
        dispatch_sync(dispatch_get_main_queue(), ^{
            [Tools displayAlertWithMessage:NSLocalizedString(@"serverError", @"") andTitle:NSLocalizedString(@"alert", @"")];
        });
    }
    return nil;
}

+(NSData*)getDataFromStringUrl:(NSString*)link withAlert:(BOOL)alert

{
    return[self getDataFromUrl:[self encodeStringForUrl:link] withAlert:alert];
}

+(BOOL)isIphone5
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0)
        return TRUE;
    return FALSE;
}

+(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(NSString*)replaceEuroInString:(NSString*)str
{
    @try {
        return [str stringByReplacingOccurrencesOfString:@"&euro;" withString:@"€"];
    }
    @catch (NSException *exception) {
        return str;
    }
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(BOOL)isAbleToCall
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:123456789"]];
}

+(BOOL)makeSimpleRequest:(NSString*)url
{
    NSLog(@"url = %@", url);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[Tools encodeStringForUrl:url]];
    NSURLResponse *response = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    return error == nil;
}

@end
