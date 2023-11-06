import UIKit

class ViewController: UIViewController {
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()

    let blankVC = ModalViewController()

    var animator1: UIViewPropertyAnimator!
    var animator2: UIViewPropertyAnimator!
    var animator3: UIViewPropertyAnimator!

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        animator1 = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [button1] in
            button1.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }

        animator2 = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [button2] in
            button2.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }

        animator3 = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [button3] in
            button3.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        [
            button1,
            button2,
            button3
        ].forEach {
            view.addSubview($0)
        }

        if let image = UIImage(systemName: "arrow.right.circle.fill")?.withRenderingMode(.alwaysTemplate) {
            setupButton(button: button1 , text: "Text", image: image)
            setupButton(button: button2 , text: "Very loooooooooooong Text", image: image)
            setupButton(button: button3 , text: "nrml Text", image: image)
        }

        button3.addTarget(self, action: #selector(showViewController), for: .touchDown)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        [
            button1,
            button2,
            button3
        ].forEach {
            $0.sizeToFit()
        }

        var position = view.center
        position.y = 140

        button1.center = position

        position.y += 70
        button2.center = position

        position.y += 70
        button3.center = position
    }

    override func loadView() {
        view = ContentView()
        view.backgroundColor = .white
    }

    func setupButton(button: UIButton, text: String, image: UIImage) {
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)

        button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = .systemBlue

        button.setTitle(text, for: .normal)
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        button.tintColor = .white

        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(small), for: .touchDown)
        button.addTarget(self, action: #selector(big), for: .touchUpInside)
    }

    @objc
    func showViewController() {
        self.present(blankVC, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.animator3.stopAnimation(true)
            self?.button3.transform = .identity
        }
    }

    @objc
    func small(_ button: UIButton) {
        var animator = animator1

        if button.isEqual(button2) {
            animator = animator2
        } else if button.isEqual(button3) {
            animator = animator3
        }
        
        guard var animator else { return }

        switch animator.state {
        case .active:
            animator.stopAnimation(true)

            animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [button] in
                button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }

            animator.startAnimation()
        case .stopped,.inactive:
            animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [button] in
                button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }
            animator.startAnimation()
        @unknown default: 
            break

        }
    }

    @objc
    func big(_ button: UIButton) {
        var animator = animator1

        if button.isEqual(button2) {
            animator = animator2
        } else if button.isEqual(button3) {
            animator = animator3
        }
        
        guard var animator else { return }

        switch animator.state {
        case .active:
            animator.stopAnimation(true)

            animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [button] in
                button.transform = .identity
            }

            animator.startAnimation()
        case .stopped,.inactive:
            animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [button] in
                button.transform = .identity
            }
            animator.startAnimation()
        @unknown default:
            break

        }
    }
}

class ContentView: UIView {
    let tintBlue = UIColor.systemBlue

    override func tintColorDidChange() {
        super.tintColorDidChange()

        subviews.forEach { subview in
            if let button = subview as? UIButton {
                if tintColor == tintBlue {
                    button.backgroundColor = .systemBlue
                    button.tintColor = .white
                    button.imageView?.tintColor = .white
                    button.setTitleColor(.white, for: .normal)
                    button.setTitleColor(.white, for: .selected)
                } else {
                    button.backgroundColor = .systemGray2
                    button.tintColor = .systemGray3
                    button.imageView?.tintColor = .systemGray3
                    button.setTitleColor(.systemGray3, for: .normal)
                }
            }
        }
    }
}
