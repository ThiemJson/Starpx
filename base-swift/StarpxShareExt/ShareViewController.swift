//
//  ShareViewController.swift
//  StarpxShareExt
//
//  Created by ThiemNC on 27/05/2024.
//  Copyright © 2024 BaseSwift. All rights reserved.
//

import UIKit
import Social
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        //sometimes the item is a UIImage (i.e., screenshots)
        if let extensionItems = self.extensionContext?.inputItems as? [NSExtensionItem]  {
            let attachments     = extensionItems.first?.attachments ?? []
            let imageType       = UTType.image.identifier
            var imagesURL       : [URL] = [URL]()
            var imagesSize      : [CGSize] = [CGSize]()
            var count = 0
            
            let dispatchGroup = DispatchGroup()
            
            for provider in attachments {
                if provider.hasItemConformingToTypeIdentifier(imageType) {
                    count += 1
                    print("It is an image")
                    
                    dispatchGroup.enter()
                    // this seems only to handle media from photos
                    provider.loadItem(forTypeIdentifier: imageType) { (unsafeFileUrl, error) in
                        print("We have the image")
                        if let url = unsafeFileUrl as? URL {
                            imagesURL.append(url)
                            if let source = CGImageSourceCreateWithURL(url as CFURL, nil) {
                                let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
                                if let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] {
                                    if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
                                       let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
                                        imagesSize.append(CGSize(width: width, height: height))
                                    }
                                }
                            }
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                // create the actual alert controller view that will be the pop-up
                let message = "URL Shared: \(imagesURL.count) \nImages shared: \(imagesSize.count)\n Dimentsion: \(imagesSize)"
                let alertController = UIAlertController(title: "StarPX", message: message, preferredStyle: .alert)
                // add the buttons/actions to the view controller
                let close = UIAlertAction(title: "Close", style: .default) { _ in
                    // this code runs when the user hits the "save" button
                    let inputName = alertController.textFields![0].text
                    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                }

                alertController.addAction(close)

                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
}
