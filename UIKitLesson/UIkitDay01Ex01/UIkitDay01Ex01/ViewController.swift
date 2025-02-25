import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblHello: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 화면이 실행 되고 바로 적용 되는 초기화 영역
        
        // Hello를 안녕하세요로 보이게 변경
        lblHello.text = "Hello!"
    }

    @IBAction func changeGreeting(_ sender: UIButton) {
        print("버튼 탭 했다!")
        if btnSend == sender {
            print("버튼이 Send인 경우!")
            // guard let name = txtName.text else { return }
            let name = txtName.text ?? "익명"
            print("텍스트 필드에 입력된 이름은 \(name)입니다.")
            lblHello.text = "\(name)님 안녕하세요!"
        } else {
            print("Reset 버튼 탭!")
            // Reset 버튼을 누르면 모두 초기화 되도록
            lblHello.text = "Hello!"
            txtName.text = ""
        }
    }
    
}
