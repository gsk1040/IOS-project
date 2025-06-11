//
//  CameraView.swift
//  MediCompanion
//
//  Created by 원대한 on 6/5/25.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            // 카메라 프리뷰
            CameraPreviewView(session: viewModel.session)
                .edgesIgnoringSafeArea(.all)
            
            // 오버레이 및 컨트롤
            VStack {
                CameraHeaderView(viewModel: viewModel)
                
                Spacer()
                
                CameraGuideFrameView()
                
                Spacer()
                
                CameraControlsView(viewModel: viewModel)
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("확인") {}
        } message: {
            Text(viewModel.alertMessage)
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(selectedImage: $viewModel.capturedImage)
        }
        .onAppear(perform: viewModel.checkCameraPermission)
        .onDisappear(perform: viewModel.stopSession)
        .onChange(of: viewModel.capturedImage) { newImage in
            if let image = newImage {
                analyzeImage(image: image)
            }
        }
    }
    
    private func analyzeImage(image: UIImage) {
        if let user = authViewModel.user, !user.isPremium {
            authViewModel.useFreeScan()
        }
        appState.capturedImage = image
        appState.navigateTo(.processing)
    }
}

// MARK: - 하위 뷰 (컴포넌트)
private struct CameraHeaderView: View {
    @ObservedObject var viewModel: CameraViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack {
            Button(action: { appState.navigateBack() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .bold))
            }
            Spacer()
            Button(action: viewModel.toggleFlash) {
                Image(systemName: viewModel.flashMode == .on ? "bolt.fill" : "bolt.slash.fill")
                    .font(.system(size: 22))
                    .foregroundColor(viewModel.flashMode == .on ? .yellow : .white)
            }
        }
        .foregroundColor(.white)
        .padding()
    }
}

private struct CameraGuideFrameView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: 2, dash: [10, 10]))
            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.4)
            .overlay(
                Text("건강검진표를 프레임 안에 맞춰주세요")
                    .font(theme.typography.body)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
                    .offset(y: (UIScreen.main.bounds.height * 0.2) + 25)
            )
    }
}

private struct CameraControlsView: View {
    @ObservedObject var viewModel: CameraViewModel

    var body: some View {
        HStack {
            ControlButton(systemName: "photo.on.rectangle", action: viewModel.openGallery)
            Spacer()
            CaptureButton(isCapturing: viewModel.isCapturing, action: viewModel.capturePhoto)
            Spacer()
            ControlButton(systemName: viewModel.isAutoScanEnabled ? "a.circle.fill" : "m.circle.fill", action: viewModel.toggleAutoScan)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
    }
}

private struct ControlButton: View {
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
        }
    }
}

private struct CaptureButton: View {
    let isCapturing: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(Color.white).frame(width: 70, height: 70)
                Circle().stroke(Color.white, lineWidth: 4).frame(width: 85, height: 85)
            }
        }
        .disabled(isCapturing)
    }
}

// MARK: - UIKit 연동 뷰
private struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

private struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
