//
//  FilteredImageBuilder.swift
//  FaceSnap
//
//  Created by 梅木綾佑 on 2016/09/07.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

final class FilteredImageBuilder {
    
    fileprivate struct PhotoFilter {
        
        static let ColorClamp = "CIColorClamp"
        static let ColorControls = "CIColorControls"
        static let PhotoEffectInstant = "CIPhotoEffectInstant"
        static let PhotoEffectProcess = "CIPhotoEffectProcess"
        static let PhotoEffectNoir = "CIPhotoEffectNoir"
        static let Sepia = "CISepiaTone"
        
        static func defaultFilters() -> [CIFilter] {
            
            // Color Clamp
            let colorClamp = CIFilter(name: PhotoFilter.ColorClamp)!
            colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
            colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
            
            // Color Controls
            let colorControls = CIFilter(name: PhotoFilter.ColorControls)!
            colorControls.setValue(0.1, forKey: kCIInputSaturationKey)
            
            // Photo Effects
            let photoEffectInstant = CIFilter(name: PhotoFilter.PhotoEffectInstant)!
            let photoEffectProcess = CIFilter(name: PhotoFilter.PhotoEffectProcess)!
            let photoEffectNoir = CIFilter(name: PhotoFilter.PhotoEffectNoir)!
            
            // Sepia
            let sepia = CIFilter(name: PhotoFilter.Sepia)!
            sepia.setValue(0.7, forKey: kCIInputIntensityKey)
            
            return [colorClamp, colorControls, photoEffectInstant, photoEffectProcess, photoEffectNoir, sepia]
        }
    }
    
    fileprivate let image: UIImage
    fileprivate let context: CIContext
    
    init(context: CIContext, image: UIImage) {
        self.context = context
        self.image = image
    }
    
    func imageWithDefaultFilters() -> [CIImage] {
        return image(withFilters: PhotoFilter.defaultFilters())
    }
    
    func image(withFilters filters: [CIFilter]) -> [CIImage] {
        return filters.map { image(self.image, withFilter: $0) }
    }
    
    func image(_ image: UIImage, withFilter filter: CIFilter) -> CIImage {
        let inputImage = image.ciImage ?? CIImage(image: image)!
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        
        let outputImage = filter.outputImage!
        
        return outputImage.cropping(to: inputImage.extent)
    }
}



























