
import UIKit

class ViewController: UIViewController {
    var isZoom = false
    var imageOn: UIImage?
    var imageOff: UIImage?
    
    @IBOutlet weak var btnZoom: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // #imageLiteral( --> 산모양 아이콘 더블클릭
        imageOn = UIImage(named: "lamp_on")
        imageOff = UIImage(named: "lamp_off")
        
        imgView.image = imageOff
    }

    @IBAction func btnResizeImage(_ sender: UIButton) {
        var w: CGFloat = 0
        var h: CGFloat = 0
        let scale: CGFloat = 1.6
        
        if isZoom {
            print("축소 됩니다.")
            btnZoom.setTitle( "확대", for: .normal)
            //처리 후에 isZoom 상태 변경
            //isZoom = false
            
            w = imgView.frame.width / scale
            h = imgView.frame.height / scale
            
            
        } else {
            print("확대 됩니다.")
            btnZoom.setTitle( "축소", for: .normal)
            // 확대시키기
            // 현재 이미지의 사이즈에 * 2배
            w = imgView.frame.size.width * scale
            h = imgView.frame.size.height * scale
            imgView.frame.size = CGSize(width: w, height: h)
            
        }
        imgView.frame.size = CGSize(width: w, height: h)
        isZoom = !isZoom
    }
    @IBAction func switchImageOnOff(_ sender: UISwitch) {
            if sender.isOn {
                imgView.image = imageOn ?? imageOff
            }else {
                imgView.image = imageOff ?? imageOn
            }
        }
        
    }

