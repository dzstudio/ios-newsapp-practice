//
//  Logger.m
//
//

#import "Logger.h"
#import "SynthesizeSingleton.h"

@implementation Logger

SYNTHESIZE_SINGLETON_FOR_CLASS(Logger);

#pragma mark singleton implementation
+ (Logger *)instance {
  return [self sharedLogger];
}

/*
 Description: Initialize the log level.
 */
- (id)init {
  self = [super init];
  if (self) {
    logLevel = NLLInfo;
  }
  return self;
}

/*
 Description: Set log level.
 */
- (void)setLogLevel:(NLLogLevel)loglevel {
  logLevel = loglevel;
}

/*
 Description: Set log level for different modules.
 */
- (void)setLogLevel:(NLLogLevel)loglevel forArea:(NSString *)area {
  if (!logLevelForArea) {
    logLevelForArea = [[NSMutableDictionary alloc] init];
  }
  NSNumber *logLvl = [NSNumber numberWithInt:loglevel];
  NSString *logarea = [NSString stringWithFormat:@"%@", area];
  [logLevelForArea setObject:logLvl forKey:logarea];
}

/*
 Description: Set log level for different function modules and set the format for log.
 */
- (void)nLog:(NLLogLevel)logLvl area:(NSString *)area function:(char *)function stringWithFormat:(NSString *)format, ... {
  int currentLogLvl = logLevel;
  if (logLevelForArea) {
    NSNumber *ll = [logLevelForArea objectForKey:area];
    if (ll) {
      currentLogLvl = [ll intValue];
    }
  }
  if (logLvl >= currentLogLvl) {
    va_list args;
    va_start(args, format);
    NSString *formatString = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSLog(@"%d %@ %s %@", logLvl, area, function, formatString);
  }
}

@end
