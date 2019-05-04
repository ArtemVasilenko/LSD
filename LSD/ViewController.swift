
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
        
        //        animator = UIDynamicAnimator(referenceView: self.view)
        //        gravity = UIGravityBehavior(items: arrballs)
        //        collison = UICollisionBehavior(items: arrballs) //отталкиваются друг от другу
        //        collison.translatesReferenceBoundsIntoBoundary = true
        //        gravity.angle = .random(in: 0...(.pi * 2)) //бъет по сторонам
        //        gravity.magnitude = 1 //скорость
        //        animator.addBehavior(gravity)
        //        animator.addBehavior(collison)
        
        data = DataBall(maxX: Int(self.view.frame.width), maxY: Int(self.view.frame.height))
        arrballs = getBalls(data)
        
        arrballs.forEach {
            self.view.addSubview($0)
        }
        
        //timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(getNewBalls), userInfo: nil, repeats: true)
        
        timerMotion = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(giro), userInfo: nil, repeats: true)
    }
    
    @objc func giro() {
        
        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = 1
            motion.startAccelerometerUpdates(to: .main) {
                (data, error) in
                guard let data = data, error == nil else {return}
                
                
                let myX = data.acceleration.x
                let myY = data.acceleration.y
                
                
                //self.initGravity(Double(self.getAngle(myX, -myY)))
                
                switch myX {
                case 0.5...: self.initGravity(0.0)
                case ...(-0.5): self.initGravity(.pi)
                default: print("не отрабатывает x \(myX)")
                }
                
                switch myY {
                case 0.5...: self.initGravity(-.pi / 2)
                case ..<0.5: self.initGravity(.pi / 2)
                default: print(myY)
                }
                
                //                if myX > 0.5 {
                //                    self.initGravity(0.0)
                //                } else if myX < -0.5 {
                //                    self.initGravity(.pi)
                //                } else if myY > 0.5 {
                //                    self.initGravity(-.pi / 2)
                //                } else if myY < -0.5 {
                //                    self.initGravity(.pi/2)
                //                }
                
                //                print(String(format: "%2f", data.acceleration.x), String(format: "%2f", data.acceleration.y), String(format: "%2f", data.acceleration.z))
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
    
    
    func initGravity(_ angle: Double) {
        animator = UIDynamicAnimator(referenceView: self.view)
        
        gravity = UIGravityBehavior(items: arrballs)
        
        collison = UICollisionBehavior(items: arrballs) //отталкиваются друг от другу
        collison.translatesReferenceBoundsIntoBoundary = true
        
        gravity.angle = CGFloat(angle)
        gravity.magnitude = 1 //скорость
        
        animator.addBehavior(gravity)
        animator.addBehavior(collison)
        
    }
    
    
    func getAngle(_ x: Double, _ y: Double) -> CGFloat {
        
        var angle = CGFloat()
        
        //        let c = (x * x + y * y).squareRoot() //гиппотенуза
        //        let sina = y / c
        //        angle = CGFloat(asin(sina))
        //        print("c \(c), sina \(sina), angle \(angle)")
        
        let tanA = y / x
        angle = CGFloat(atan(tanA))
        
        print(tanA, angle)
        return angle
    }
}


