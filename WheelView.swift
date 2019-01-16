import UIKit
import SpriteKit

func centerFrame(_ frame: CGRect) -> CGPoint {
    return CGPoint(x: (frame.maxX - frame.minX) / 2,
                   y: (frame.maxY - frame.minY) / 2)
}


let wheelSize: CGFloat = 300
/*
 class InnerCircle: SKShapeNode {
 
 
 let size: CGFloat
 
 
 init(circleOfRadius: CGFloat) {
 self.size = circleOfRadius
 
 
 super.init()
 
 }
 
 required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 }
 */
class Wedge: SKShapeNode {
    let size: CGFloat
    let angle: CGFloat
    let label: SKLabelNode
    
    init(size: CGFloat, angle: CGFloat, label: SKLabelNode) {
        self.size = size
        self.angle = angle
        self.label = label
        super.init()
        
        self.label.position = CGPoint(x: 0, y: size * 3 / 4)
        addChild(self.label)
        let halfAngle = angle / 2
        let centerAngle = CGFloat.pi / 2
        let path = UIBezierPath(arcCenter: CGPoint.zero,
                                radius: size,
                                startAngle: centerAngle - halfAngle,
                                endAngle: centerAngle + halfAngle,
                                clockwise: true)
        path.addLine(to: CGPoint.zero)
        path.close()
        self.path = path.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Wheel: SKShapeNode {
    let size: CGFloat = 1024
    let colors: [UIColor]
    
    init(colors: [UIColor]) {
        self.colors = colors
        super.init()
        
        
        let wedges = colors.count
        let angle = 2 * CGFloat.pi / CGFloat(wedges)
        
        for start in 0..<wedges {
            let label = SKLabelNode()
            label.fontSize *= size / 256
            switch start {
            case 1, 3, 5: label.text = UserDefaults.standard.string(forKey:"Input1")
            default     : label.text = String(start)
            }
            let wedge = Wedge(size: size, angle: angle, label: label)
            wedge.zRotation = CGFloat(start) * angle
            wedge.fillColor = colors[start]
            wedge.name = String(start)
            addChild(wedge)
            
            
            // addChild(innercircle)
            // addChild(circlebutton)
            // addChild(outerbutton)
        }
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: size,
                                         center: centerFrame(self.frame))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class WheelScene: SKScene {
    //"Initial" creation of wheel
    //
    // No air quotes necessary, for each instance of `WheelScene` this is
    // the initial (and only) creation of `Wheel`
    
    let wheel: Wheel = Wheel(colors: [.red, .blue, .red, .blue, .red, .blue])
    let buttonw = SKShapeNode(circleOfRadius: 35)
    let innerC = SKShapeNode(circleOfRadius: 40)
    let spin = SKLabelNode(fontNamed:"Chalkduster")
    let del = WheelDelegate()
    override init(size: CGSize) {
        super.init(size: size)
        
        self.delegate = del
        self.scaleMode = .aspectFit
        self.physicsWorld.gravity = CGVector.zero
        self.backgroundColor = .white
        
        
        wheel.position = centerFrame(self.frame)
        wheel.physicsBody?.angularVelocity = 0
        wheel.physicsBody?.angularDamping = 0.5
        let scale = min(size.width, size.height) / (2 * wheel.size)
        wheel.xScale = scale
        wheel.yScale = scale
        wheel.zPosition = 0.4
        buttonw.position = CGPoint(x: frame.midX, y:frame.midY)
        buttonw.zPosition = 0.6
        
        buttonw.fillColor = .white
        innerC.position = CGPoint(x: frame.midX, y:frame.midY)
        innerC.zPosition = 0.5
        innerC.fillColor = .darkGray
        spin.text = "SPIN!"
        spin.position = CGPoint(x: frame.midX, y:frame.midY-9)
        spin.zPosition = 0.65
        spin.fontSize = 22
        spin.fontColor = .red
        addChild(wheel)
        addChild(innerC)
        addChild(buttonw)
        addChild(spin)
        
        // print(atPoint(CGPoint(x: frame.midX, y:frame.midY+125)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class WheelDelegate: NSObject, SKSceneDelegate {
    func didSimulatePhysics(for scene: SKScene) {
        
        guard let wheelScene = scene as? WheelScene else { return }
        if (wheelScene.wheel.physicsBody?.angularVelocity ?? 0.0) > 0.0 {
            print(wheelScene.wheel.physicsBody?.angularVelocity)
            if(wheelScene.wheel.physicsBody?.angularVelocity ?? 0.0) < 1.0 {
                wheelScene.wheel.physicsBody?.angularVelocity = 0.0
                if(wheelScene.wheel.physicsBody?.angularVelocity ?? 0.0) == 0.0 {
                    // print(wheelScene.wheel.physicsBody?.angularVelocity)
                    print("I HATE SWIFT")
                    // let otherViewController: Main = Main()
                    // let result = otherViewController.yelped()
                    
                    
                }
                
                // do wheel stopped stuff here
            }
        }
    }
}

class WheelView: SKView, SKViewDelegate {
    

    var wheel: Wheel { return (self.scene as! WheelScene).wheel }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
   
        let scene = WheelScene(size: frame.size)
        self.backgroundColor = SKColor.white
     
        self.presentScene(scene)
        print(wheel.atPoint(CGPoint(x: frame.midX, y:frame.midY)))
        
    }
}
