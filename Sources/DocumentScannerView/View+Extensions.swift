//
//  View+Extensions.swift
//
//
//  Created by Edon Valdman on 9/23/23.
//

import SwiftUI
import PDFKit

extension View {
    @ViewBuilder
    public func documentScanner(
        isPresented: Binding<Bool>,
        onCompletion: @escaping (Result<[UIImage], Error>) -> Void
    ) -> some View {
        if #available(iOS 14, macCatalyst 14, visionOS 1, *) {
            self.fullScreenCover(isPresented: isPresented) {
                DocumentScannerView(onCompletion: onCompletion)
            }
        } else {
            self.fullScreenCoverCompat(isPresented: isPresented) {
                DocumentScannerView(onCompletion: onCompletion)
            }
        }
    }
    
    @ViewBuilder
    public func documentScanner(
        isPresented: Binding<Bool>,
        onCompletion: @escaping (Result<PDFDocument, Error>) -> Void
    ) -> some View {
        if #available(iOS 14, macCatalyst 14, visionOS 1, *) {
            self.fullScreenCover(isPresented: isPresented) {
                DocumentScannerView(onCompletion: onCompletion)
            }
        } else {
            self.fullScreenCoverCompat(isPresented: isPresented) {
                DocumentScannerView(onCompletion: onCompletion)
            }
        }
    }
}
