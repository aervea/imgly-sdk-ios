//
//  IMGLYStickerFilter.swift
//  imglyKit
//
//  Created by Sascha Schwabbauer on 24/03/15.
//  Copyright (c) 2015 9elements GmbH. All rights reserved.
//

import UIKit
import CoreImage

public class IMGLYStickerFilter: CIFilter {
    /// A CIImage object that serves as input for the filter.
    public var inputImage: CIImage?
    /// The sticker that should be rendered.
    public var sticker: UIImage?
    /// The relative frame of the sticker within the image.
    public var frame = CGRect()
    
    override init() {
        super.init()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Returns a CIImage object that encapsulates the operations configured in the filter. (read-only)
    public override var outputImage: CIImage! {
        if inputImage == nil {
            return CIImage.emptyImage()
        }
        
        if sticker == nil {
            return inputImage
        }
        
        var stickerImage = createStickerImage()
        var stickerCIImage = CIImage(CGImage: stickerImage.CGImage)
        var filter = CIFilter(name: "CISourceOverCompositing")
        filter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        filter.setValue(stickerCIImage, forKey: kCIInputImageKey)
        return filter.outputImage
    }
    
    private func createStickerImage() -> UIImage {
        var rect = inputImage!.extent()
        var imageSize = rect.size
        UIGraphicsBeginImageContext(imageSize)
        UIColor(white: 1.0, alpha: 0.0).setFill()
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height))

        let stickerRect = CGRect(x: frame.origin.x * imageSize.width, y: frame.origin.y * imageSize.height, width: frame.size.width * imageSize.width, height: frame.size.height * imageSize.width)
        sticker?.drawInRect(stickerRect)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
}

extension IMGLYStickerFilter: NSCopying {
    public override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! IMGLYStickerFilter
        copy.inputImage = inputImage?.copyWithZone(zone) as? CIImage
        copy.sticker = sticker
        copy.frame = frame
        return copy
    }
}
