  //
  //  main.m
  //  CustomXCTestRunnerObjC
  //
  //  Created by Stanislav Pankevich on 30.03.18.
  //  Copyright © 2018 Stanislav Pankevich. All rights reserved.
  //

#import "CustomXCTestRunner.h"

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@interface TestCase1 : XCTestCase
- (void)testHelloWorld1;
@end

@implementation TestCase1
- (void)testHelloWorld1 {
  XCTAssert(YES);
}
@end

int main(int argc, const char * argv[]) {
  int testRunResult = 0;
  @autoreleasepool {
    NSLog(@"Hello, World!");

    testRunResult = CustomXCTestRunnerRun();
  }
  return testRunResult;
}

