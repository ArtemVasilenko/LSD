
import UIKit
import CoreMotion

class ViewController: UIViewController , GetBalls {
    
    var arrballs = [Ball]()
    var animator = UIDynamicAnimator()
    var gravity = UIGravityBehavior()
    var collison = UICollisionBehavior()
    var timer = Timer()
    var timerMotion = Timer()
    var data: DataBall!
    var motion = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = DataBall(maxX: Int(self.view.frame.width), maxY: Int(self.view.frame.height))
        arrballs = getBalls(data)

        arrballs.forEach {
            self.view.addSubview($0)
        }
        
        self.initGravity()

        //timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(getNewBalls), userInfo: nil, repeats: true)
        
        self.view.becomeFirstResponder()
        
        timerMotion = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(giro), userInfo: nil, repeats: true)
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Woohooo shake shake shake")
            arrballs += getBalls(data)
            
            arrballs.forEach {
                self.view.addSubview($0)
            }
            
            animator = UIDynamicAnimator(referenceView: self.view)
            gravity = UIGravityBehavior(items: arrballs)
            collison = UICollisionBehavior(items: arrballs) //отталкиваются друг от другу
            collison.translatesReferenceBoundsIntoBoundary = true
            
            animator.addBehavior(gravity)
            animator.addBehavior(collison)
        }
    }
    
    
    @objc func giro() {
        
        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = 0.1
            motion.startAccelerometerUpdates(to: .main) {
                (data, error) in
                guard let data = data, error == nil else {return}
                
                let myX = data.acceleration.x
                let myY = data.acceleration.y
                
                let myVector = CGVector(dx: myX, dy: myY * -1)
                
                self.gravity.gravityDirection = myVector
                
//                switch myX {
//                case 0.5...1: self.updateGravity(0.0)
//                case -1...(-0.5): self.updateGravity(.pi)
//                default: print(myX)
//                }
//
//                switch myY {
//                case 0.5...: self.updateGravity(-.pi / 2)
//                case ..<(-0.5): self.updateGravity(.pi / 2)
//                default: print(myY)
//                }
            }
        }
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
        
        gravity.angle = .random(in: 0...(.pi * 2)) //бъет по сторонам
        gravity.magnitude = .random(in: 0...1) //скорость
        
        animator.addBehavior(gravity)
        animator.addBehavior(collison)
    }
    
    
    func initGravity() {
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: arrballs)
        collison = UICollisionBehavior(items: arrballs) //отталкиваются друг от другу
        collison.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(gravity)
        animator.addBehavior(collison)
    }
    
    
    func updateGravity(_ angle: Double) {
        gravity.angle = CGFloat(angle)
    }
    
    
    func getAngle(_ x: Double, _ y: Double) -> CGFloat {
        var angle = CGFloat()
        let tanA = y / x
        angle = CGFloat(atan(tanA))
        return angle
    }
}


