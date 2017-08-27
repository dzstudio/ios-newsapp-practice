//
//  SynthesizeSingleton.h
//
//

#if __has_feature(objc_arc) // ARC Version

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname)   \
\
+ (classname *)shared##classname\
{\
static classname *shared##classname = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
shared##classname = [[classname alloc] init];\
});\
return shared##classname;\
}

#else // Non-ARC Version

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
static classname *shared##classname = nil; \
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
return nil; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
- (id)retain \
{ \
return self; \
} \
- (NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
- (oneway void)release \
{ \
} \
- (id)autorelease \
{ \
return self; \
}

#endif