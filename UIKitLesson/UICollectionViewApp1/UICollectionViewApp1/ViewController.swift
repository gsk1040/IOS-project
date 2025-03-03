import UIKit

// 먼저 CustomCollectionViewCell 클래스 정의
class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 셀 초기화 코드
    }
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let items = Array(1...12).map {"card\($0)"}
    let images = Array(1...6).map {UIImage(named: "card\($0)") ?? UIImage()} // nil 방지용 빈 이미지 추가
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // CustomCollectionViewCell 등록
        let nib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 셀 개수 반환
        return images.count
    }
    
    // MARK: - UICollectionViewDataSource
    // 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        // 인덱스에 맞는 이미지 설정 (범위 체크 추가)
        if indexPath.row < images.count {
            cell.imageView.image = images[indexPath.row]
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    // 셀 크기 지정 (3열 레이아웃)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 3  // 3열 설정 (여백 포함)
        return CGSize(width: width, height: width) // 정사각형 셀
    }
    
    // 행 간 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // 같은 행 내 셀 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
