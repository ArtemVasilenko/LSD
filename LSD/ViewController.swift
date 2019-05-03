
import UIKit

class ViewController: UIViewController , GetBalls {
    
    var arrballs = [Ball]()
    var animator = UIDynamicAnimator()
    var gravity = UIGravityBehavior()
    var collison = UICollisionBehavior()
    var timer = Timer()
    var data: DataBall!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = DataBall(maxX: Int(self.view.frame.width), maxY: Int(self.view.frame.height))
        arrballs = getBalls(data)
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(getNewBalls), userInfo: nil, repeats: true)
    }
    
    
    @objc func getNewBalls() {
        
        arrballs += getBalls(data)

        
        arrballs.forEach {
            self.view.addSubview($0)
        }
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: arrballs)
        collison = UICollisionBehavior(items: arrballs) //отталкиваются друг от другу
        collison.translatesReferenceBoundsIntoBoundary = true
        
        gravity.angle = .random(in: 0...(.pi * 2))
        
        animator.addBehavior(gravity)
        animator.addBehavior(collison)
    }
    
}

