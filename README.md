# payworks payment blocks

Kickstart your development of iOS payment applications with often-used payment application components by payworks! Payworks payment blocks are free-to-use UI components such as fields for capturing customer signatures, … (more to come!) taking the programming burden out of your hands and letting you focus on creating awesome applications.

The payment blocks are made available on our CocoaPod podspec repository. To use the payment blocks, add 
http://github.com/thmp/podspecs.git
as a custom pod repository. If you want to add it using the name 'pwb', you could just execute

    pod repo add pwb http://github.com/thmp/podspecs.git

## SignatureView

The SignatureView enables you to capture a customers signature drawn on the touch screen of an iOS device and receive it as an UIImage. The SignatureView can either be integrated as an UIView in your existing controller or presented modally using the predefined signature controller.

### Prepare your project

To use the SignatureView in your project, you should have an Xcode project with CocoaPods available. Make sure you have added the payworks payment blocks specs repository. Then, in your podfile, add the dependency

    platform :ios, '6.1'
    pod 'PWBSignatureView', '~> 0.2.1'

#link cocoa
#credit guesture+linedrawer
#ios7 storyboard

### Use the predefined signature screen

![signature view](http://thpnetz.de/pw/signature.png "Signature View")

To start right away, you can use the predefined view controller which shows a signature screen with some information to the user. To capture a signature, create a PWBSignatureViewController instance first.

```objectivec
PWBSignatureViewController* signatureViewController = [[PWBSignatureViewController alloc]init];
```

Now, customize logo, title, amount and text beneath the signature line to match your application.

```objectivec
signatureViewController.merchantName = @"Fruit Shop";
signatureViewController.merchantLogo = [UIImage imageNamed:@"merchantFruit.png"];
signatureViewController.amountText = @"5.99 €";
signatureViewController.signatureText = @"Signature";
signatureViewController.signatureColor = [UIColor darkGrayColor];
signatureViewController.payButtonText = @"Pay now";
signatureViewController.cancelButtonText = @"Cancel";
```

Now, register blocks to be executed once the pay or cancel button are pressed. You can access the user's signature by calling the signature method of the view controller.

```objectivec
[signatureViewController registerOnPay:^{  
    UIImage* signature = [signatureViewController signature];
    [signatureViewController dismissViewControllerAnimated:YES completion:nil];
} onCancel:^{
    [signatureViewController dismissViewControllerAnimated:YES completion:nil]; 
}];
```

To capture the signature, you now only have to present the view controller

```objectivec
[self presentViewController:signatureViewController animated:YES completion:nil];
```

### Use the signature field in a custom controller

If you only want to use the field which captures the signature without any of the additional UI components of the predefined signature view, you have to proceed as follows.

First, open the header file of the controller which should hold the signature field and make your view controller extend PWBSignatureFieldViewController

```objectivec
@interface MyViewController : PWBSignatureViewController
```

Since the smooth display of the drawn signature depends on OpenGL, code has to be executed in your controller and the signature field cannot be added as a simple UIView. But we tried to make it as easy as possible for you!

Next, you have to specify the location where your signature field is supposed to be created on the view. In your view controllers implementation file, create the signature field in the viewDidLoad method, you can either use a UIView from your storyboard connected to the controller using an IBOutlet

```objectivec
 - (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSignatureFieldWithView:self.mySigView];
}
```

or specify the signature fields location using a CGRect frame.

```objectivec
 - (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSignatureFieldWithView:CGRectMake(0,0,100,100)];
}
```

By extending PWBSignatureFieldViewController, you can now access the following methods in your view controller:

- (void)clearSignature;
- (UIImage*)signature;
- (void)tearDownSignatureField;