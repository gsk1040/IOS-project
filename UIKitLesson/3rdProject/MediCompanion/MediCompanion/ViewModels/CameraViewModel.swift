//
//  CameraViewModel.swift
//  MediCompanion
//
//  Created by 원대한 on 6/12/25.
//

import SwiftUI
import AVFoundation

// MARK: - 카메라 뷰 모델
class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var isCapturing = false
    @Published var capturedImage: UIImage?
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var flashMode: AVCaptureDevice.FlashMode = .off
    
    // 갤러리 및 스캔 모드 기능
    @Published var showImagePicker = false
    @Published var isAutoScanEnabled = false
    
    private let photoOutput = AVCapturePhotoOutput()
    
    // MARK: - 권한 및 세션 설정
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCamera()
                    } else {
                        self?.showPermissionAlert()
                    }
                }
            }
        default:
            showPermissionAlert()
        }
    }
    
    private func showPermissionAlert() {
        alertTitle = "카메라 권한 필요"
        alertMessage = "설정에서 카메라 접근을 허용해주세요."
        showAlert = true
    }
    
    func setupCamera() {
        session.beginConfiguration()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoInput),
              session.canAddOutput(photoOutput) else {
            session.commitConfiguration()
            print("카메라 설정에 실패했습니다.")
            return
        }
        
        session.addInput(videoInput)
        session.addOutput(photoOutput)
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    // MARK: - 카메라 컨트롤
    func toggleFlash() {
        flashMode = (flashMode == .on) ? .off : .on
    }
    
    func capturePhoto() {
        guard !isCapturing else { return }
        isCapturing = true
        
        let settings = AVCapturePhotoSettings()
        if photoOutput.supportedFlashModes.contains(flashMode) {
            settings.flashMode = flashMode
        }
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        DispatchQueue.main.async {
            self.isCapturing = false
            if let error = error {
                self.alertTitle = "촬영 오류"
                self.alertMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
                self.alertTitle = "이미지 처리 오류"
                self.alertMessage = "사진을 처리할 수 없습니다."
                self.showAlert = true
                return
            }
            self.capturedImage = image
        }
    }
    
    // MARK: - 추가 기능
    func openGallery() {
        showImagePicker = true
    }
    
    func toggleAutoScan() {
        isAutoScanEnabled.toggle()
    }
}
