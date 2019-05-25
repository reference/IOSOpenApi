//
// NSFileManager+ZXToolbox.h
// https://github.com/xinyzhao/ZXToolbox
//
// Copyright (c) 2019 Zhao Xin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (ZXToolbox)

// Bundle
+ (NSString*)bundleFile:(NSString*)file;

// Caches
+ (NSString*)cachesDirectory;
+ (NSString*)cachesDirectory:(NSString *)subpath;
+ (NSString*)cachesFile:(NSString*)file;
+ (NSString*)cachesFile:(NSString*)file inDirectory:(NSString *)subpath;

// Documents
+ (NSString*)documentDirectory;
+ (NSString*)documentDirectory:(NSString *)subpath;
+ (NSString*)documentFile:(NSString*)file;
+ (NSString*)documentFile:(NSString *)file inDirectory:(NSString *)subpath;

// Temporary
+ (NSString *)temporaryDirectory;
+ (NSString *)temporaryDirectory:(NSString *)subpath;
+ (NSString *)temporaryFile:(NSString *)file;
+ (NSString *)temporaryFile:(NSString *)file inDirectory:(NSString *)subpath;

// File size
+ (uint64_t)fileSizeAtPath:(NSString *)path;

// Create && Remove
- (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError **)error;
- (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error exclude:(NSArray *)exclusions;

@end
