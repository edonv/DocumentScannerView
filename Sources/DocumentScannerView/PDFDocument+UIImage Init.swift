//
//  PDFDocument+UIImage Init.swift
//  
//
//  Created by Edon Valdman on 9/23/23.
//

import UIKit
import PDFKit

extension PDFDocument {
    public convenience init(_ images: [UIImage]) {
        self.init()
        for i in 0..<images.count {
            let pdfPage = PDFPage(image: images[i])
            self.insert(pdfPage!, at: i)
        }
    }
}
