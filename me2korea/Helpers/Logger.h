//
//  Logger.h
//
#ifdef DEBUG
#define NAILog(logArea, format, ...) [[Logger instance] nLog:NLLInfo area:logArea function:(char *)__PRETTY_FUNCTION__ stringWithFormat:format, ##__VA_ARGS__];
#define NADLog(logArea, format, ...) [[Logger instance] nLog:NLLDebug area:logArea function:(char *)__PRETTY_FUNCTION__ stringWithFormat:format, ##__VA_ARGS__];
#define NAELog(logArea, format, ...) [[Logger instance] nLog:NLLError area:logArea function:(char *)__PRETTY_FUNCTION__ stringWithFormat:format, ##__VA_ARGS__];
#else
#define NILog(format, ...)
#define NDLog(format, ...)
#define NELog(format, ...)
#define NAILog(logArea, format, ...)
#define NADLog(logArea, format, ...)
#define NAELog(logArea, format, ...)
#endif

#define LOGGER [Logger instance]

#import <Foundation/Foundation.h>

typedef enum { NLLInfo = 1, NLLDebug = 3, NLLWarning = 5, NLLError = 7, NLLCritical = 9 } NLLogLevel;

@interface Logger : NSObject {
  NLLogLevel logLevel;
  NSMutableDictionary *logLevelForArea;
}

- (void)nLog:(NLLogLevel)logLvl area:(NSString *)area function:(char *)function stringWithFormat:(NSString *)format, ...;
+ (Logger *)instance;

- (void)setLogLevel:(NLLogLevel)loglevel;
- (void)setLogLevel:(NLLogLevel)loglevel forArea:(NSString *)area;

@end
