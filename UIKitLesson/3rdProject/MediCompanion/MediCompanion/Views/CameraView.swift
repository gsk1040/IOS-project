// Views/CameraView.swift
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
                // 상단 헤더
                HStack {
                    Button(action: {
                        appState.navigateBack()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    if viewModel.flashMode == .on {
                        Button(action: {
                            viewModel.toggleFlash()
                        }) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.yellow)
                                .padding()
                        }
                    } else {
                        Button(action: {
                            viewModel.toggleFlash()
                        }) {
                            Image(systemName: "bolt.slash.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
                
                Spacer()
                
                // 가이드 프레임
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: 2, dash: [10, 10]))
                        .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.4)
                }
                .overlay(
                    Text("건강검진표를 프레임 안에 맞춰주세요")
                        .font(AppTheme.Typography.Body().font)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                        .padding(.top, UIScreen.main.bounds.height * 0.4 + 20)
                )
                
                Spacer()
                
                // 하단 컨트롤
                HStack {
                    Spacer()
                    
                    // 촬영 버튼
                    Button(action: {
                        viewModel.capturePhoto()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                            
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(width: 85, height: 85)
                        }
                    }
                    .disabled(viewModel.isCapturing)
                    
                    Spacer()
                }
                .padding(.bottom, 30)
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("확인"))
            )
        }
        .onAppear {
            viewModel.checkCameraPermission()
        }
        .onDisappear {
            viewModel.stopSession()
        }
        .onChange(of: viewModel.capturedImage) { newImage in
            if newImage != nil {
                analyzeImage()
            }
        }
    }
    
    func analyzeImage() {
        if let user = authViewModel.user, !user.isPremium {
            authViewModel.useFreeScan()
        }
        
        // 캡처한 이미지를 앱 상태에 저장 - 수정된 부분
        if let image = viewModel.capturedImage {
            appState.capturedImage = image
        }
        
        appState.navigateTo(.processing)
    }
    
}

// 카메라 프리뷰 뷰
struct CameraPreviewView: UIViewRepresentable {
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
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
}

// 카메라 관련 비즈니스 로직을 처리하는 뷰모델
class CameraViewModel: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var isCapturing = false
    @Published var capturedImage: UIImage?
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var flashMode: AVCaptureDevice.FlashMode = .off
    
    private let photoOutput = AVCapturePhotoOutput()
    
    override init() {
        super.init()
    }
    
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
                        self?.handleCameraPermissionDenied()
                    }
                }
            }
        case .denied, .restricted:
            handleCameraPermissionDenied()
        @unknown default:
            handleCameraPermissionDenied()
        }
    }
    
    private func handleCameraPermissionDenied() {
        DispatchQueue.main.async {
            self.alertTitle = "카메라 접근 권한 필요"
            self.alertMessage = "설정에서 카메라 접근 권한을 허용해주세요."
            self.showAlert = true
        }
    }
    
    func setupCamera() {
        session.beginConfiguration()
        
        // 입력 설정
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            session.commitConfiguration()
            return
        }
        
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }
        
        // 출력 설정
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    func toggleFlash() {
        flashMode = flashMode == .on ? .off : .on
    }
    
    func capturePhoto() {
        guard !isCapturing else { return }
        isCapturing = true
        
        // 사진 촬영 설정
        let photoSettings = AVCapturePhotoSettings()
        
        // 플래시 설정
        if photoOutput.supportedFlashModes.contains(flashMode) {
            photoSettings.flashMode = flashMode
        }
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
}

// 사진 캡처 델리게이트
extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        isCapturing = false
        
        if let error = error {
            DispatchQueue.main.async {
                self.alertTitle = "사진 촬영 오류"
                self.alertMessage = "사진을 촬영하는 중 오류가 발생했습니다: \(error.localizedDescription)"
                self.showAlert = true
            }
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            DispatchQueue.main.async {
                self.alertTitle = "이미지 처리 오류"
                self.alertMessage = "촬영한 이미지를 처리할 수 없습니다."
                self.showAlert = true
            }
            return
        }
        
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}

// 가장자리만 둥글게 처리하는 확장
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
