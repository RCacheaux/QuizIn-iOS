#import "QILIPeople.h"

#import <AuthKit/AKAccountStore.h>
#import <linkedin-sdk/LISDK.h>

#import "AFNetworkingBlockTypes.h"
#import "AKLinkedInAuthController.h"
#import "LIHTTPClient.h"
#import "QIPerson+Factory.h"
#import "QIConnectionsStore.h"
#import "QIPerson.h"
#import "QIPerson+Factory.h"
#import "QILocation.h"
#import "QILocation+Factory.h"
#import "QIPosition.h"
#import "QIPosition+Factory.h"
#import "QICompany.h"
#import "QICompany+Factory.h"

typedef void (^LISDKResponse)(LISDKAPIResponse *response);
typedef void (^LISDKErrorResponse)(LISDKAPIError *error);

@implementation QILIPeople

+ (void)getProfileForAuthenticatedUserWithFieldSelector:(NSString *)fieldSelector
                                           onCompletion:(QIProfileResult)onCompletion {
  // Construct path.
  NSMutableString *resourcePath = [@"people/~" mutableCopy];
  [self getProfileWithResourcePath:resourcePath fieldSelector:fieldSelector onCompletion:onCompletion];
}

+ (void)getProfileForPersonWithID:(NSString *)personID
                withFieldSelector:(NSString *)fieldSelector
                     onCompletion:(QIProfileResult)onCompletion {
  // Construct path.
  NSMutableString *resourcePath = [[NSString stringWithFormat:@"people/id=%@", personID] mutableCopy];
  [self getProfileWithResourcePath:resourcePath fieldSelector:fieldSelector onCompletion:onCompletion];
}

+ (void)getProfileWithResourcePath:(NSMutableString *)resourcePath
                     fieldSelector:(NSString *)fieldSelector
                      onCompletion:(QIProfileResult)onCompletion {
  /*
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  
  // Construct path.
  if (fieldSelector) {
    [resourcePath appendFormat:@":(%@)", fieldSelector];
  }
  
  // Build query parameter dictionary.
  NSDictionary *queryParameters = @{@"secure-urls": @"true"};
  
  // Success block.
  AFHTTPRequestOperationSuccess success = ^(NSURLSessionDataTask *task,
                                            NSDictionary *personJSON){
    
    QIPerson *person = [QIPerson personWithJSON:personJSON];
    QILocation *location = [QILocation locationWithJSON:personJSON[@"location"]];
    person.location = location;
    
    // TODO(Rene): Test if JSON has no positions in values.
    NSArray *positionsJSON = personJSON[@"positions"][@"values"];
    NSMutableSet *positions =
    [NSMutableSet setWithCapacity:[personJSON[@"positions"][@"_total"] intValue]];
    for (NSDictionary *positionJSON in positionsJSON) {
      QIPosition *position = [QIPosition positionWithJSON:positionJSON];
      NSDictionary *companyJSON = positionJSON[@"company"];
      QICompany *company = [QICompany companyWithJSON:companyJSON];
      position.company = company;
      [positions addObject:position];
    }
    person.positions = [positions copy];
    onCompletion ? onCompletion(person, nil) : NULL;
  };
  
  // Failure block.
  AFHTTPRequestOperationFailure failure = ^(NSURLSessionDataTask *task,
                                            NSError *error){
    
    onCompletion ? onCompletion(nil, error) : NULL;
    // TODO(Rene): Check for unauth responses globally.
    DDLogInfo(@"LinkedIn: ERROR, HTTP Error: %@, for task, %@", error, task);
    [[AKLinkedInAuthController sharedController]
     unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };
  
  [httpClient GET:[resourcePath copy] parameters:queryParameters success:success failure:failure];
   */
  
  // Construct path.
  if (fieldSelector) {
    [resourcePath appendFormat:@":(%@)", fieldSelector];
  }
  
  NSURLComponents *components = [NSURLComponents componentsWithString:resourcePath];
  //NSURLQueryItem *secure = [NSURLQueryItem queryItemWithName:@"secure-urls" value:@"true"];
  //components.queryItems = @[secure];
  NSURL *url = components.URL;
  NSString *finalURL = [@"https://api.linkedin.com/v1/" stringByAppendingString:resourcePath];
  
  LISDKResponse success = ^(LISDKAPIResponse *response){
    NSLog(@"HI: success called %@", response.data);
    NSDictionary *personJSON = [NSJSONSerialization JSONObjectWithData:[response.data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

    QIPerson *person = [QIPerson personWithJSON:personJSON];
    QILocation *location = [QILocation locationWithJSON:personJSON[@"location"]];
    person.location = location;
    
    // TODO(Rene): Test if JSON has no positions in values.
    NSArray *positionsJSON = personJSON[@"positions"][@"values"];
    NSMutableSet *positions =
    [NSMutableSet setWithCapacity:[personJSON[@"positions"][@"_total"] intValue]];
    for (NSDictionary *positionJSON in positionsJSON) {
      QIPosition *position = [QIPosition positionWithJSON:positionJSON];
      NSDictionary *companyJSON = positionJSON[@"company"];
      QICompany *company = [QICompany companyWithJSON:companyJSON];
      position.company = company;
      [positions addObject:position];
    }
    person.positions = [positions copy];
    onCompletion ? onCompletion(person, nil) : NULL;

  };
  
  LISDKErrorResponse failure = ^(LISDKAPIError *error){
     NSLog(@"HI: error called %@", error.description);
  };
  
  [[LISDKAPIHelper sharedInstance] apiRequest:finalURL
                                       method:@"GET"
                                         body:[@"" dataUsingEncoding:NSUTF8StringEncoding]
                                      success:success
                                        error:failure];
}

@end
