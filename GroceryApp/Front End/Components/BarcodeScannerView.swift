//
//  BarcodeScannerView.swift
//  GroceryApp
//
//  Created by Yash Shah on 11/17/24.
//

import SwiftUI
import AVFoundation
import Vision

struct BarcodeProduct: Codable {
    let name: String
    let brand: String
    let description: String
    let imageURL: String?
}

import Foundation

func fetchBarcodeProductDetails(for barcode: String, completion: @escaping (Result<BarcodeProduct, Error>) -> Void) {
    // Example API URL (replace with the actual API you choose)
    let urlString = "https://api.upcitemdb.com/prod/trial/lookup?upc=\(barcode)"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 1, userInfo: nil)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("ad4407684665bcaef89ac4c169ba5ee4", forHTTPHeaderField: "Authorization") // Add API key if required

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No Data", code: 1, userInfo: nil)))
            return
        }

        do {
            let decodedResponse = try JSONDecoder().decode([String: [BarcodeProduct]].self, from: data)
            if let product = decodedResponse["items"]?.first {
                completion(.success(product))
            } else {
                completion(.failure(NSError(domain: "Product Not Found", code: 1, userInfo: nil)))
            }
        } catch {
            completion(.failure(error))
        }
    }.resume()
}




struct BarcodeScannerView: UIViewControllerRepresentable {
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: BarcodeScannerView
        private lazy var visionRequest: VNDetectBarcodesRequest = {
            VNDetectBarcodesRequest { [weak self] request, error in
                if let results = request.results as? [VNBarcodeObservation],
                   let firstBarcode = results.first {
                    DispatchQueue.main.async {
                        self?.parent.onBarcodeDetected?(firstBarcode.payloadStringValue ?? "Unknown")
                    }
                }
            }
        }()

        init(parent: BarcodeScannerView) {
            self.parent = parent
            super.init()
        }

        func captureOutput(
            _ output: AVCaptureOutput,
            didOutput sampleBuffer: CMSampleBuffer,
            from connection: AVCaptureConnection
        ) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            do {
                try requestHandler.perform([visionRequest])
            } catch {
                print("Error performing barcode detection: \(error)")
            }
        }
    }


    var onBarcodeDetected: ((String) -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = CameraViewController()
        viewController.captureOutputDelegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class CameraViewController: UIViewController {
    var captureOutputDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    private func setupCamera() {
        let session = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            print("Camera setup failed")
            return
        }

        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(captureOutputDelegate, queue: DispatchQueue(label: "cameraQueue"))
        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
        self.captureSession = session

        session.startRunning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
    }
}
