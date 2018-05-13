//
//  CustomXCTestRunner.h
//  CustomXCTestRunner (Objective-C)
//
//  Created by Stanislaw Pankevich on 30/03/18.
//  Copyright © 2016 Lowlevelbits.org. All rights reserved.
//

#import "CustomXCTestRunner.h"

#import <XCTest/XCTest.h>
#import <XCTest/XCTestObservationCenter.h>

#import <objc/runtime.h>

@interface CustomXCTestObserver : NSObject <XCTestObservation>
@property (assign, nonatomic) NSUInteger testsFailed;
@end

@implementation CustomXCTestObserver

- (instancetype)init {
  self = [super init];

  self.testsFailed = 0;

  return self;
}

//- (void)testBundleWillStart:(NSBundle *)testBundle {
//  NSLog(@"testBundleWillStart: %@", testBundle);
//}
//
//- (void)testBundleDidFinish:(NSBundle *)testBundle {
//  NSLog(@"testBundleDidFinish: %@", testBundle);
//}
//
//- (void)testSuiteWillStart:(XCTestSuite *)testSuite {
//  NSLog(@"testSuiteWillStart: %@", testSuite);
//}
//
//- (void)testCaseWillStart:(XCTestCase *)testCase {
//  NSLog(@"testCaseWillStart: %@", testCase);
//}
//
//- (void)testSuiteDidFinish:(XCTestSuite *)testSuite {
//  NSLog(@"testSuiteDidFinish: %@", testSuite);
//}
//
//- (void)testSuite:(XCTestSuite *)testSuite didFailWithDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber {
//  NSLog(@"testSuite:didFailWithDescription:inFile:atLine: %@ %@ %@ %tu",
//        testSuite, description, filePath, lineNumber);
//}
//
- (void)testCase:(XCTestCase *)testCase didFailWithDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber {
  //NSLog(@"testCase:didFailWithDescription:inFile:atLine: %@ %@ %@ %tu",
  //      testCase, description, filePath, lineNumber);
  self.testsFailed++;
}

//- (void)testCaseDidFinish:(XCTestCase *)testCase {
//  NSLog(@"testCaseWillFinish: %@", testCase);
//}

@end

static void ObjCEnumerateRuntimeClasses(void(^callback)(Class)) {
  int numClasses;
  numClasses = objc_getClassList(NULL, 0);

  if (numClasses == 0) {
    return;
  }

  Class * classes = (Class *)malloc(sizeof(Class) * numClasses);
  numClasses = objc_getClassList(classes, numClasses);

  for (int i = 0; i < numClasses; i++) {
    Class runtimeClass = classes[i];

    callback(runtimeClass);
  }

  free(classes);
}

int CustomXCTestRunnerRunAll(void) {
  int exitResult = 0;

  @autoreleasepool {
    CustomXCTestObserver *testObserver = [CustomXCTestObserver new];

    Class xcTestCaseClass = NSClassFromString(@"XCTestCase");
    NSCAssert(xcTestCaseClass, nil);

    XCTestSuite *customXCTestRunnerSuite =
      [[XCTestSuite alloc] initWithName:@"CustomXCTestRunner Suite"];

    ObjCEnumerateRuntimeClasses(^(__unsafe_unretained Class runtimeClass) {
      if (class_getSuperclass(runtimeClass) != xcTestCaseClass) {
        return;
      }

      XCTestSuite *suite = [XCTestSuite testSuiteForTestCaseClass:runtimeClass];

      [customXCTestRunnerSuite addTest:suite];
    });

    XCTestObservationCenter *center = [XCTestObservationCenter sharedTestObservationCenter];
    [center addTestObserver:testObserver];

    [customXCTestRunnerSuite runTest];

  //  NSLog(@"RunXCTests: tests failed: %tu", testObserver.testsFailed);

    if (testObserver.testsFailed > 0) {
      exitResult = 1;
    }
  }

  return exitResult;
}
