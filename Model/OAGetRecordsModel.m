/**
 MIT License
 
 Copyright (c) 2018 Scott Ban (https://github.com/reference/IOSOpenApi)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "OAGetRecordsModel.h"
#import <StandardHTTPResponse/StandardHTTPResponse.h>
#import "OAHTTP.h"

@implementation OAGetRecordsModel

+ (void)requestWithSymbol:(NSString *)symbol
                   period:(NSInteger)period
               completion:(void(^)(NSArray<NSArray<NSNumber *> *> *records, NSError *error))completion
{
    NSString *path = @"/open/api/get_records";
    [OAHTTP requestWithPath:path params:@{@"symbol":symbol,@"period":@(period)} responseDataClass:nil completion:^(StandardHTTPResponse *response, NSError *error) {
        if (completion) {
            completion(response.data,error);
        }
    }];
}
@end
