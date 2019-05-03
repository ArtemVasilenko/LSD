import Foundation

protocol GetBalls {
    func getBalls(_ dataBall: DataBall) -> [Ball]
}

extension GetBalls {
    
    func getBalls(_ dataBall: DataBall) -> [Ball] {
        var balls = [Ball]()
        
        for _ in 0...Int.random(in: 5...15) {
            balls.append(Ball(dataBall: dataBall))
        }
        return balls
    }
    
}
