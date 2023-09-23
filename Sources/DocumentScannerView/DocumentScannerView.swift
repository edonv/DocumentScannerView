//
//  DocumentScannerView.swift
//
//
//  Created by Edon Valdman on 9/23/23.
//

import SwiftUI
import VisionKit
import PDFKit

/// A view that scans documents.
public struct DocumentScannerView: UIViewControllerRepresentable {
//    @Environment(\.dismiss)
//    var dismissAction
    
    /// `UIImage` representations of the pages scanned.
    ///
    /// Depending on ``scanSaveMode-swift.property``, successful scans will either append pages to, or overwrite entirely, this property. Either way, this property won't be emptied automatically.
    @Binding public var scannedPages: [UIImage]
    
    /// The way in which scanned pages should be saved to ``scannedPages``.
    public var scanSaveMode: ScanSaveMode
    
    /// Creates a scanner that scans documents.
    /// - Parameters:
    ///   - scannedPages: Image representations of scanned pages.
    ///   - scanSaveMode: The method of which to save scanned pages.
    public init(scannedPages: Binding<[UIImage]>, scanSaveMode: ScanSaveMode = .replace) {
        self._scannedPages = scannedPages
        self.scanSaveMode = scanSaveMode
    }
    
    public func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = context.coordinator
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func dismiss() {
//        dismissAction()
    }
    
    /// A Boolean variable that indicates whether or not the current device supports document scanning.
    ///
    /// This class method returns `false` for unsupported hardware.
    public static var isSupported: Bool {
        VNDocumentCameraViewController.isSupported
    }
}

extension DocumentScannerView {
    public class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentScannerView
        
        init(_ parent: DocumentScannerView) {
            self.parent = parent
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let pages = (0..<scan.pageCount).map(scan.imageOfPage(at:))
            
            switch parent.scanSaveMode {
            case .replace:
                parent.scannedPages = pages
            case .append:
                parent.scannedPages.append(contentsOf: pages)
            }
            
            parent.dismiss()
        }
        
        public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.dismiss()
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Error:", error)
            parent.dismiss()
        }
    }
}
