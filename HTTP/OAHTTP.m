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


#import "OAHTTP.h"
#import <YYModel/YYModel.h>
#import <AFNetworking/AFNetworking.h>

@implementation OAHTTP

+ (void)requestWithURL:(NSString *)url
                params:(NSDictionary *)params
                  body:(id)body
         responseClass:(Class)responseClass
     responseDataClass:(NSDictionary *)responseDataClass
            completion:(void(^)(id responseObject, NSError *error))completion {
    [OAHTTP requestWithURL:url params:params body:body completion:^(id responseObject, NSError *error) {
        id response = responseObject;
        if (response && responseClass) {
            if ([response isKindOfClass:[NSArray class]]) {
                response = [NSArray yy_modelArrayWithClass:responseClass json:responseObject];
            } else {
                response = [responseClass yy_modelWithJSON:responseObject];
            }
            if (response) {
                NSArray *keys = [responseDataClass allKeys];
                for (NSString *key in keys) {
                    if ([response respondsToSelector:NSSelectorFromString(key)]) {
                        id data = [response valueForKey:key];
                        Class dataClass = [responseDataClass objectForKey:key];
                        if (data && dataClass) {
                            if ([data isKindOfClass:[NSArray class]]) {
                                data = [NSArray yy_modelArrayWithClass:dataClass json:data];
                            } else {
                                data = [dataClass yy_modelWithJSON:data];
                            }
                            if (data) {
                                [response setValue:data forKey:key];
                            }
                        }
                    }
                }
            }
        }
        if (completion) {
            completion(response, error);
        }
    }];
}

+ (void)requestWithURL:(NSString *)url
                params:(NSDictionary *)params
                  body:(id)body
            completion:(void(^)(id responseObject, NSError *error))completion {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //
        NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"application/json"];
        [contentTypes addObject:@"charset=UTF-8"];
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"text/plain"];
        manager.responseSerializer.acceptableContentTypes = contentTypes;
    });
    NSString *query = AFQueryStringFromParameters(params);
    if (query) {
        url = [url stringByAppendingFormat:@"?%@", query];
    }
    if (body == nil) {
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLogD(@"GET %@\n%@", url, [responseObject yy_modelToJSONObject]);
            if (completion) {
                completion(responseObject, nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLogA(@"GET %@\n%@", url, error.localizedDescription);
            if (completion) {
                completion(task.response, error);
            }
        }];
    } else {
        // JSON
        if ([JSONObject isValidJSONObject:body]) {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            params = body;
        } else { // params in body
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            if ([body isKindOfClass:NSData.class]) {
                params = [JSONObject JSONObjectWithData:body];
            } else if ([body isKindOfClass:NSString.class]) {
                params = [JSONObject JSONObjectWithString:body];
            }
            if (params == nil) {
                params = body;
            }
        }
        //
        [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLogD(@"POST %@\n%@", url, [responseObject yy_modelToJSONObject]);
            if (completion) {
                completion(responseObject, nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLogA(@"POST %@\n%@", url, error.localizedDescription);
            if (completion) {
                completion(task.response, error);
            }
        }];
    }
}

+ (void)uploadWithURL:(NSString *)url params:(NSDictionary *)params data:(NSArray<ZXHTTPFormData *> *)data responseClass:(Class)responseClass completion:(void (^)(id, NSError *))completion {
    [ZXHTTPClient POST:url params:params formData:data requestHandler:^(NSMutableURLRequest *request) {
        //
    } completionHandler:^(NSURLSessionDataTask *task, NSData *data, NSError *error) {
        id response = task.response;
        if (data && responseClass) {
            if ([response isKindOfClass:[NSArray class]]) {
                response = [NSArray yy_modelArrayWithClass:responseClass json:data];
            } else {
                response = [responseClass yy_modelWithJSON:data];
            }
        }
        if (completion) {
            completion(response, error);
        }
    }];
}


//from mto

+ (void)requestWithPath:(NSString *)path responseDataClass:(Class)responseDataClass completion:(void(^)(StandardHTTPResponse *response, NSError *error))completion {
    [OAHTTP requestWithPath:path body:nil responseDataClass:responseDataClass completion:completion];
}

+ (void)requestWithPath:(NSString *)path body:(id)body responseDataClass:(Class)responseDataClass completion:(void(^)(StandardHTTPResponse *response, NSError *error))completion {
    [OAHTTP requestWithPath:path params:nil body:body responseDataClass:responseDataClass completion:completion];
}

+ (void)requestWithPath:(NSString *)path params:(NSDictionary *)params responseDataClass:(Class)responseDataClass completion:(void(^)(StandardHTTPResponse *response, NSError *error))completion {
    [OAHTTP requestWithPath:path params:params body:nil responseDataClass:responseDataClass completion:completion];
}

+ (void)requestWithPath:(NSString *)path params:(NSDictionary *)params body:(id)body responseDataClass:(Class)responseDataClass completion:(void(^)(StandardHTTPResponse *response, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"%@%@", HOST, path];
    [OAHTTP requestWithURL:url params:params body:body responseDataClass:responseDataClass completion:completion];
}

+ (void)requestWithURL:(NSString *)url params:(NSDictionary *)params body:(id)body responseDataClass:(Class)responseDataClass completion:(void(^)(StandardHTTPResponse *response, NSError *error))completion {
    [OAHTTP requestWithURL:url params:params body:body responseClass:[StandardHTTPResponse class] completion:^(id responseObject, NSError *error) {
        if ([responseObject isKindOfClass:[StandardHTTPResponse class]]) {
            StandardHTTPResponse *response = responseObject;
            if (response.data && responseDataClass) {
                if ([response.data isKindOfClass:[NSArray class]]) {
                    response.data = [NSArray yy_modelArrayWithClass:responseDataClass json:response.data];
                } else {
                    response.data = [responseDataClass yy_modelWithJSON:response.data];
                }
            }
            if (response.code && response.msg) {
                error = [NSError errorWithDomain:@"HTTP" code:response.code userInfo:@{NSLocalizedDescriptionKey:response.msg}];
                if (response.code == 100403) {
                    error = [NSError errorWithDomain:@"HTTP" code:response.code userInfo:@{NSLocalizedDescriptionKey:@"账号已过期，请登录后重试"}];
                }
            }
            if (completion) {
                completion(response, error);
            }
        } else {
            if ([responseObject isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *response = responseObject;
                if (response.statusCode == 403) {
                    error = [NSError errorWithDomain:@"HTTP" code:response.statusCode userInfo:@{NSLocalizedDescriptionKey:@"账号已过期，请登录后重试"}];
                }
            }
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

+ (void)requestWithURL:(NSString *)url params:(NSDictionary *)params body:(id)body responseClass:(Class)responseClass completion:(void(^)(id response, NSError *error))completion {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    if (params.count > 0) {
        NSMutableArray *pairs = [[NSMutableArray alloc] init];
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *pair = [NSString stringWithFormat:@"%@=%@", key, obj];
            [pairs addObject:pair];
        }];
        NSString *query = [pairs componentsJoinedByString:@"&"];
        if (query) {
            url = [url stringByAppendingFormat:@"?%@", query];
        }
    }
    if (body == nil) {
        //        manager.requestSerializer.timeoutInterval = 15;
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id response = responseObject;
            if (response && responseClass) {
                if ([response isKindOfClass:[NSArray class]]) {
                    response = [NSArray yy_modelArrayWithClass:responseClass json:responseObject];
                } else {
                    response = [responseClass yy_modelWithJSON:responseObject];
                }
            }
            NSLogD(@"GET %@\n%@", url, [responseObject yy_modelToJSONObject]);
            if (completion) {
                completion(response, nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLogA(@"GET %@\n%@", url, error.localizedDescription);
            if (completion) {
                completion(task.response, error);
            }
        }];
    } else {
        id json = [body yy_modelToJSONObject];
        //        manager.requestSerializer.timeoutInterval = 15;
        [manager POST:url parameters:json progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id response = responseObject;
            if (response && responseClass) {
                if ([response isKindOfClass:[NSArray class]]) {
                    response = [NSArray yy_modelArrayWithClass:responseClass json:responseObject];
                } else {
                    response = [responseClass yy_modelWithJSON:responseObject];
                }
            }
            NSLogD(@"POST %@\n%@", url, [responseObject yy_modelToJSONObject]);
            if (completion) {
                completion(response, nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLogA(@"POST %@\n%@", url, error.localizedDescription);
            if (completion) {
                completion(task.response, error);
            }
        }];
    }
}

@end
