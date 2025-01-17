#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
NSString *const IAPHelperProductFailedNotification = @"IAPHelperProductFailedNotification";

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper {
  SKProductsRequest * _productsRequest;
  RequestProductsCompletionHandler _completionHandler;
  NSSet * _productIdentifiers;
  NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
  
  if ((self = [super init])) {
    
    // Store product identifiers
    _productIdentifiers = productIdentifiers;
    
    // Check for previously purchased products
    _purchasedProductIdentifiers = [NSMutableSet set];
    for (NSString * productIdentifier in _productIdentifiers) {
      BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
      if (productPurchased) {
        [_purchasedProductIdentifiers addObject:productIdentifier];
        NSLog(@"Previously purchased: %@", productIdentifier);
      } else {
        NSLog(@"Not purchased: %@", productIdentifier);
      }
    }
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
  }
  return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
  _completionHandler = [completionHandler copy];
  _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
  _productsRequest.delegate = self;
  [_productsRequest start];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
  
  NSLog(@"Loaded list of products...");
  _productsRequest = nil;
  
  NSArray * skProducts = response.products;
  for (SKProduct * skProduct in skProducts) {
    NSLog(@"Found product: %@ %@ %0.2f",
          skProduct.productIdentifier,
          skProduct.localizedTitle,
          skProduct.price.floatValue);
  }
  if (_completionHandler){
    _completionHandler(YES, skProducts);
  }
  _completionHandler = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
  
  NSLog(@"Failed to load list of products.");
  _productsRequest = nil;
  
  _completionHandler(NO, nil);
  _completionHandler = nil;
  
}

- (BOOL)productPurchased:(NSString *)productIdentifier{
  //return YES;
  return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (BOOL)anythingPurchased{
  return [_purchasedProductIdentifiers count] > 0; 
}

- (void)buyProduct:(SKProduct *)product{
  NSLog(@"Buying %@...", product.productIdentifier);
  SKPayment * payment = [SKPayment paymentWithProduct:product];
  [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
  for (SKPaymentTransaction * transaction in transactions) {
    switch (transaction.transactionState)
    {
      case SKPaymentTransactionStatePurchased:
        [self completeTransaction:transaction];
        break;
      case SKPaymentTransactionStateFailed:
        [self failedTransaction:transaction];
        break;
      case SKPaymentTransactionStateRestored:
        [self restoreTransaction:transaction];
      default:
        break;
    }
  };
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error.localizedDescription forKey:@"errorMessage"];
  [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductFailedNotification object:nil userInfo:userInfo];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
  NSLog(@"completeTransaction...");
  
  [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
  NSLog(@"restoreTransaction...");
  
  [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
  
  NSLog(@"failedTransaction...");
  if (transaction.error.code != SKErrorPaymentCancelled)
  {
    NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
  }
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:transaction.error.localizedDescription forKey:@"errorMessage"];
  [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductFailedNotification object:transaction.payment.productIdentifier userInfo:userInfo];
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
  [_purchasedProductIdentifiers addObject:productIdentifier];
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

- (void)restoreCompletedTransactions {
  [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


@end
