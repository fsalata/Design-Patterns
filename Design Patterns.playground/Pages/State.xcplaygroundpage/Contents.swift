/*:
 # State
 - - - - - - - - - -
 ![State Diagram](State_Diagram.png)
 
 The state pattern is a behavioral pattern that allows an object to change its behavior at runtime. It does so by changing an internal state. This pattern involves three types:
 
 1. The **context** is the object whose behavior changes and has an internal state.
 
 2. The **state protocol** defines a set of methods and properties required by concrete states. If you need stored properties, you can substitute a **base state class** instead of a protocol.
 
 3. The **concrete states** conform to the state protocol, or if a base class is used instead, they subclass the base. They implement required methods and properties to perform whatever behavior is desired when the context is in its state.
 
 ## Code Example
 */
import UIKit
import PlaygroundSupport

// MARK: = Context
class TrafficLight: UIView {
    // MARK: - Instance properties
    private(set) var canisterLayers: [CAShapeLayer] = []
    private(set) var currentState: TrafficLightState
    private(set) var states: [TrafficLightState]
    
    // MARK: - Object Lifecycle
    init(canisterCount: Int = 3, frame: CGRect = .init(x: 0, y: 0, width: 160, height: 420), states: [TrafficLightState]) {
        guard !states.isEmpty else {
            fatalError("states should not be empty")
        }
        self.currentState = states.first!
        self.states = states
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0.86, green: 0.64, blue: 0.25, alpha: 1)
        createCanisterLayers(count: canisterCount)
        
        transition(to: currentState)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func createCanisterLayers(count: Int) {
        let paddingPercentage: CGFloat = 0.2
        let yTotalPadding = paddingPercentage * bounds.height
        let yPadding = yTotalPadding / CGFloat(count + 1)
        let canisterHeight = (bounds.height - yTotalPadding) / CGFloat(count)
        let xPadding = (bounds.width - canisterHeight) / 2.0
        var canisterFrame = CGRect(x: xPadding, y: yPadding, width: canisterHeight, height: canisterHeight)
        
        for _ in 0 ..< count {
            let canisterShape = CAShapeLayer()
            canisterShape.path = UIBezierPath(ovalIn: canisterFrame).cgPath
            canisterShape.fillColor = UIColor.black.cgColor
            layer.addSublayer(canisterShape)
            canisterLayers.append(canisterShape)
            canisterFrame.origin.y += (canisterFrame.height + yPadding)
        }
    }
    
    func transition(to state: TrafficLightState) {
        removeCanisterSublayers()
        currentState = state
        currentState.apply(to: self)
        
        nextState.apply(to: self, after: currentState.delay)
    }
    
    func removeCanisterSublayers() {
        canisterLayers.forEach {
            $0.sublayers?.forEach {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    public var nextState: TrafficLightState {
        guard let index = states.firstIndex(where: {
            $0 === currentState
        }), index + 1 < states.count else {
            return states.first!
        }
        
        return states[index + 1]
    }
}

protocol TrafficLightState: AnyObject {
    var delay: TimeInterval { get }
    
    func apply(to context: TrafficLight)
}

// MARK: - Concrete States
class SolidTrafficLightState {
    let canisterIndex: Int
    let color: UIColor
    let delay: TimeInterval
    
    init(canisterIndex: Int, color: UIColor, delay: TimeInterval) {
        self.canisterIndex = canisterIndex
        self.color = color
        self.delay = delay
    }
}

extension SolidTrafficLightState: TrafficLightState {
    public func apply(to context: TrafficLight) {
        let canisterLayer = context.canisterLayers[canisterIndex]
        let circleShape = CAShapeLayer()
        circleShape.path = canisterLayer.path!
        circleShape.fillColor = color.cgColor
        circleShape.strokeColor = color.cgColor
        canisterLayer.addSublayer(circleShape)
    }
}

extension SolidTrafficLightState {
    public class func greenLight(
        color: UIColor = UIColor(red: 0.21, green: 0.78, blue: 0.35, alpha: 1),
        canisterIndex: Int = 2,
        delay: TimeInterval = 1.0) -> SolidTrafficLightState {
        return SolidTrafficLightState(canisterIndex: canisterIndex, color: color, delay: delay)
    }
    
    public class func yellowLight(
        color: UIColor = UIColor(red: 0.98, green: 0.91, blue: 0.07, alpha: 1),
        canisterIndex: Int = 1,
        delay: TimeInterval = 0.5) -> SolidTrafficLightState {
        return SolidTrafficLightState(canisterIndex: canisterIndex, color: color, delay: delay)
    }
    
    public class func redLight(
        color: UIColor = UIColor(red: 0.88, green: 0, blue: 0.04, alpha: 1),
        canisterIndex: Int = 0,
        delay: TimeInterval = 2.0) -> SolidTrafficLightState {
        return SolidTrafficLightState(canisterIndex: canisterIndex, color: color,  delay: delay)
    }
}

extension TrafficLightState {
    public func apply(to context: TrafficLight, after delay: TimeInterval) {
        let queue = DispatchQueue.main
        let dispatchTime = DispatchTime.now() + delay
        queue.asyncAfter(deadline: dispatchTime) {[weak self, weak context] in
            guard let self = self, let context = context else {
                return
            }
            context.transition(to: self)
        }
    }
}

let greenYellowRed: [SolidTrafficLightState] = [.greenLight(), .yellowLight(), .redLight()]
let trafficLight = TrafficLight(states: greenYellowRed)
PlaygroundPage.current.liveView = trafficLight
