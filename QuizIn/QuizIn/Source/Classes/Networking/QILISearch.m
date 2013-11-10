#import "QILISearch.h"

#import <AuthKit/AKAccountStore.h>

#import "AFNetworkingBlockTypes.h"
#import "AKLinkedInAuthController.h"
#import "LIHTTPClient.h"
#import "QISearchFacet+Factory.h"

@implementation QILISearch

+ (void)getPeopleSearchWithFieldSelector:(NSString *)fieldSelector
                        searchParameters:(NSDictionary *)searchParameters
                            onCompletion:(QISearchResult)onCompletion {
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  
  // Construct path.
  NSMutableString *resourcePath = [@"/v1/people-search" mutableCopy];
  if (fieldSelector) {
    [resourcePath appendFormat:@":(%@)", fieldSelector];
  }
  
  // Build query parameter dictionary.
  NSMutableDictionary *queryParameters = [@{@"secure-urls": @"true"} mutableCopy];
  [queryParameters addEntriesFromDictionary:searchParameters];
  
  // Success block.
  AFHTTPRequestOperationSuccess success = ^(AFHTTPRequestOperation *requestOperation,
                                            NSDictionary *JSON){
    NSDictionary *peopleResultJSON = JSON[@"people"];
    QILISearchResultData *result = [QILISearchResultData new];
    result.count = [peopleResultJSON[@"_count"] integerValue];
    result.start = [peopleResultJSON[@"_start"] integerValue];
    result.total = [peopleResultJSON[@"_total"] integerValue];
    result.peopleJSON = peopleResultJSON[@"values"];
    onCompletion ? onCompletion(result, nil) : NULL;
  };
  // Failure block.
  AFHTTPRequestOperationFailure failure = ^(AFHTTPRequestOperation *requestOperation,
                                            NSError *error){
    
    onCompletion ? onCompletion(nil, error) : NULL;
    // TODO(Rene): Check for unauth responses globally.
    DDLogInfo(@"LinkedIn: ERROR, HTTP Error: %@, for operation, %@", error,requestOperation);
    [[AKLinkedInAuthController sharedController]
     unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };
  
  NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"GET"
                                                      path:resourcePath
                                                parameters:queryParameters];
  
  AFHTTPRequestOperation *operation = [httpClient HTTPRequestOperationWithRequest:urlRequest
                                                                          success:success
                                                                          failure:failure];
  [httpClient enqueueHTTPRequestOperation:operation];
}

+ (void)getPeopleSearchFacets:(NSArray *)facets
         withSearchParameters:(NSDictionary *)searchParameters
                 onCompletion:(QISearchFacetResult)onCompletion {
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  
  // Construct path.
  NSMutableString *resourcePath = [@"/v1/people-search" mutableCopy];
  [resourcePath appendFormat:@":(%@)", @"facets:(name,code,buckets:(code,name,count,selected))"];
  
  // Build query parameter dictionary.
  NSMutableDictionary *queryParameters = [@{@"facets": [facets componentsJoinedByString:@","],
                                            @"secure-urls": @"true"} mutableCopy];
  
  [queryParameters addEntriesFromDictionary:searchParameters];
  
  // Success block.
  AFHTTPRequestOperationSuccess success = ^(AFHTTPRequestOperation *requestOperation,
                                            NSDictionary *JSON){
    NSMutableArray *facets = [NSMutableArray array];
    NSDictionary *facetsResultJSON = JSON[@"facets"];
    NSArray *facetsJSON = facetsResultJSON[@"values"];
    for (NSDictionary *facetJSON in facetsJSON) {
      [facets addObject:[QISearchFacet facetWithJSON:facetJSON]];
    }
    onCompletion ? onCompletion([facets copy], nil) : NULL;
  };
  // Failure block.
  AFHTTPRequestOperationFailure failure = ^(AFHTTPRequestOperation *requestOperation,
                                            NSError *error){
    
    onCompletion ? onCompletion(nil, error) : NULL;
    // TODO(Rene): Check for unauth responses globally.
    DDLogInfo(@"LinkedIn: ERROR, HTTP Error: %@, for operation, %@", error,requestOperation);
    [[AKLinkedInAuthController sharedController]
     unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };
  
  NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"GET"
                                                      path:resourcePath
                                                parameters:queryParameters];
  
  AFHTTPRequestOperation *operation = [httpClient HTTPRequestOperationWithRequest:urlRequest
                                                                          success:success
                                                                          failure:failure];
  [httpClient enqueueHTTPRequestOperation:operation];
}

@end

@implementation QILISearchResultData
@end
