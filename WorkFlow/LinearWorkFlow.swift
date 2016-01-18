public final class LinearWorkFlow: WorkFlow {
    private let components: [WorkFlowComponent]
    private var currentComponentIndex: Int = 0

    public private(set) var currentComponent: WorkFlowComponent? = nil
    public private(set) var nextComponent: WorkFlowComponent? = nil

    private var cancelled: Bool = false

    private let onFinish: WorkFlow -> Void
    private let onCancel: WorkFlow -> Void

    public init(components: [WorkFlowComponent], finish: WorkFlow -> Void, cancel: WorkFlow -> Void) {
        self.components = components
        self.onFinish = finish
        self.onCancel = cancel
    }

    public func startWorkFlow() {
        guard self.components.isEmpty == false else { return }
        self.currentComponentIndex = 0
        self.cancelled = false
        let component = self.components[self.currentComponentIndex]
        self.currentComponent = component
        self.setNextComponentIfPossible()
        component.beginWork(self)
    }

    public func advanceWorkFlow() {
        guard !self.cancelled else { return }
        self.currentComponentIndex += 1
        if self.currentComponentIndex == self.components.count {
            self.currentComponent = nil
            self.onFinish(self)
        }
        else if self.currentComponentIndex < self.components.count {
            let component = self.components[self.currentComponentIndex]
            self.currentComponent = component
            self.setNextComponentIfPossible()
            component.beginWork(self)
        }
    }

    public func cancelWorkFlow() {
        self.nextComponent = nil
        self.currentComponent = nil
        self.cancelled = true

        self.onCancel(self)
    }

    private func setNextComponentIfPossible() {
        let index = self.currentComponentIndex + 1
        if index < self.components.count {
            self.nextComponent = self.components[index]
        } else {
            self.nextComponent = nil
        }
    }
}
