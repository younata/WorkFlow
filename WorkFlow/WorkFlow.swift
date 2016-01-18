public protocol WorkFlow {
    var currentComponent: WorkFlowComponent? { get }
    var nextComponent: WorkFlowComponent? { get }

    init(components: [WorkFlowComponent], advance: WorkFlow -> Void, finish: WorkFlow -> Void, cancel: WorkFlow -> Void)
    func startWorkFlow()
    func advanceWorkFlow()

    func cancelWorkFlow()
}

public protocol WorkFlowComponent {
    func beginWork(workFlow: WorkFlow)
}