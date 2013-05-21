tools-by-benj
=============

Tools helper class for ios (iPhone, iPod, iPad)

This class will help you to:

Display alert pop up
+ (void) displayAlertWithMessage:(NSString *)message andTitle:(NSString*)title;

Check if the network is available
+(BOOL) isNetworkAvailable;

Use a google tracker
+(void) trackPage:(NSString*)page;

Encode in MD5
+(NSString*) md5encode:(NSString*) str;

Encode in base64
+(NSString*)base64forInt:(int)theInt;
+(NSString*)base64forString:(NSString*)theString;
+(NSString*)base64forData:(NSData*)theData;

Get preference dictionnary
+(NSMutableDictionary *)getPrefDictionary;

Encode in SHA 256
+(NSString*)getHashForInt:(int)intToHash;
+(NSString*)getHash:(NSString*)stringToHash;

Encode string for url
+(NSURL*)encodeStringForUrl:(NSString*)callString;

Check system version
+(BOOL)versionIsEqualOrSupAs:(int)version;

Get device token
+ (NSString*)stringWithDeviceToken:(NSData*)deviceToken;

Get data from url
+(NSData*)getDataFromUrl:(NSURL*)url withAlert:(BOOL)alert;

Get data from string
+(NSData*)getDataFromStringUrl:(NSString*)link withAlert:(BOOL)alert;

Check if the device is an iPhone 5
+(BOOL)isIphone5;

Check if a mail is valid
+(BOOL) isValidEmail:(NSString *)checkString;

Get color from hex string
+(UIColor*)colorWithHexString:(NSString*)hex;
