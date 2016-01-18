public protocol WorkFlow {
    var currentComponent: WorkFlowComponent? { get }
    var nextComponent: WorkFlowComponent? { get }

    init(components: [WorkFlowComponent], finish: WorkFlow -> Void, cancel: WorkFlow -> Void)
    func startWorkFlow()
    func advanceWorkFlow()

    func cancelWorkFlow()
}