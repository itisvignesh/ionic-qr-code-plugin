//
//  QRReaderPlugin.m
//  Ionic Plugin QRCode Reader
//
//  Created by Vigneshwaran Murugesan on 01/01/19.
//  Copyright © 2019 Vigneshwaran Murugesan. All rights reserved.
//

#import "CommonQRPlugin.h"
@implementation CommonQRPlugin
NSString *commandCallbackID;

- (void)cameraplugin:(CDVInvokedUrlCommand*)command
{
    commandCallbackID = command.callbackId;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QRReaderViewController *qrReaderViewcontroller = [mainStoryboard instantiateViewControllerWithIdentifier:@"readerviewcontroller"];
    [qrReaderViewcontroller setDelegate:self];
    [self.viewController presentViewController:qrReaderViewcontroller animated:YES completion:nil];
    
}

-(void)didReadData:(NSString *)qrData{
[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:qrData] callbackId:commandCallbackID];
}

-(void)didfailToRead:(NSString *)qrData{
[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error in reading QR data"] callbackId:commandCallbackID];
}
-(void)galleryplugin:(CDVInvokedUrlCommand *) command{
    commandCallbackID = command.callbackId;
    UIImagePickerController *imagePickerController =  [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerController setDelegate:self];
    [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    CIImage *pickedCIImage = [[CIImage alloc] initWithImage:pickedImage];
    NSDictionary *ciContextOptions = @{CIDetectorAccuracy:CIDetectorAccuracyHigh};
    CIContext *ciContext = [[CIContext alloc] initWithOptions:ciContextOptions];
    CIDetector *ciDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:nil];
    if([[pickedCIImage properties]valueForKey:(NSString *)kCGImagePropertyOrientation]==nil){
        ciContextOptions = @{CIDetectorImageOrientation:@1};
    }else{
        ciContextOptions = @{CIDetectorImageOrientation:[[pickedCIImage properties]valueForKey:(NSString *) kCGImagePropertyOrientation]};
    }
    NSArray *pickedImageFeatures = [ciDetector featuresInImage:pickedCIImage options:ciContextOptions];
    if(pickedImageFeatures!=nil && pickedImageFeatures.count>0){
        for(CIQRCodeFeature *qrCodeFeatures in pickedImageFeatures){
         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:qrCodeFeatures.messageString] callbackId:commandCallbackID];
        }
    }else{
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error reading QR code or invalid image selected"] callbackId:commandCallbackID];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
