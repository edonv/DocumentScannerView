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
    @Environment(\.presentationMode)
    private var presentationMode
    
    public var onCompletion: (Result<[UIImage], Error>) -> Void
    
    /// Creates a scanner that scans documents.
    /// - Parameter onCompletion: A callback that will be invoked when the scanning operation has succeeded or failed.
    public init(onCompletion: @escaping (Result<[UIImage], Error>) -> Void) {
        self.onCompletion = onCompletion
    }
    
    /// Creates a scanner that scans documents.
    /// - Parameter onCompletion: A callback that will be invoked when the scanning operation has succeeded or failed.
    public init(onCompletion: @escaping (Result<PDFDocument, Error>) -> Void) {
        self.onCompletion = { result in
            switch result {
            case .success(let images):
                onCompletion(.success(PDFDocument(images)))
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
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
        presentationMode.wrappedValue.dismiss()
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
            parent.onCompletion(.success((0..<scan.pageCount).map(scan.imageOfPage(at:))))
            parent.dismiss()
        }
        
        public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.dismiss()
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Error:", error)
            parent.onCompletion(.failure(error))
            parent.dismiss()
        }
    }
}
