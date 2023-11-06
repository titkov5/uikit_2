import UIKit

class ModalViewController: UIViewController {
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    var onDissmiss: ( () -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
    }

    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)

        if panGesture.state == .began {
          originalPosition = view.center
          currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
              x: 0,
              y: translation.y
            )
        } else if panGesture.state == .ended {
          let velocity = panGesture.velocity(in: view)

          if velocity.y >= 1500 {
            UIView.animate(withDuration: 0.2
              , animations: {
                self.view.frame.origin = CGPoint(
                  x: self.view.frame.origin.x,
                  y: self.view.frame.size.height
                )
              }, completion: { (isCompleted) in
                if isCompleted {
                    self.onDissmiss?()
                    self.dismiss(animated: true, completion: nil)
                }
            })
          } else {
            UIView.animate(withDuration: 0.2, animations: {
              self.view.center = self.originalPosition!
            })
          }
        }
      }

}
