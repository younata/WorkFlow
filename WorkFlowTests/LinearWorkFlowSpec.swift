import Quick
import Nimble
import WorkFlow

class LinearWorkFlowSpec: QuickSpec {
    override func spec() {
        var subject: LinearWorkFlow!

        var firstComponent: FakeWorkFlowComponent!
        var secondComponent: FakeWorkFlowComponent!
        var thirdComponent: FakeWorkFlowComponent!

        var finishCallCount = 0
        var cancelCallCount = 0

        beforeEach {
            firstComponent = FakeWorkFlowComponent()
            secondComponent = FakeWorkFlowComponent()
            thirdComponent = FakeWorkFlowComponent()

            finishCallCount = 0
            cancelCallCount = 0

            subject = LinearWorkFlow(components: [
                firstComponent,
                secondComponent,
                thirdComponent,
                ],
                finish: { _ in finishCallCount += 1 },
                cancel: { _ in cancelCallCount += 1 }
            )
        }

        it("doesn't call beginWork on any components just yet") {
            expect(firstComponent.beginWorkCallCount) == 0
            expect(secondComponent.beginWorkCallCount) == 0
            expect(thirdComponent.beginWorkCallCount) == 0
        }

        it("returns nil for the current component") {
            expect(subject.currentComponent).to(beNil())
        }

        it("returns nil for the next component") {
            expect(subject.nextComponent).to(beNil())
        }

        it("doesn't call either finish or cancel") {
            expect(finishCallCount) == 0
            expect(cancelCallCount) == 0
        }

        describe("calling startWorkFlow") {
            beforeEach {
                subject.startWorkFlow()
            }

            it("sets the current component") {
                expect(subject.currentComponent as? FakeWorkFlowComponent).to(equal(firstComponent))
            }

            it("sets the second component as the next component") {
                expect(subject.nextComponent as? FakeWorkFlowComponent).to(equal(secondComponent))
            }

            it("calls beginWork on the first component") {
                expect(firstComponent.beginWorkCallCount) == 1
                expect(secondComponent.beginWorkCallCount) == 0
                expect(thirdComponent.beginWorkCallCount) == 0
            }

            it("doesn't call either finish or cancel") {
                expect(finishCallCount) == 0
                expect(cancelCallCount) == 0
            }

            context("calling advanceWorkFlow") {
                beforeEach {
                    subject.advanceWorkFlow()
                }

                it("sets the current component") {
                    expect(subject.currentComponent as? FakeWorkFlowComponent).to(equal(secondComponent))
                }

                it("sets the third component as the next component") {
                    expect(subject.nextComponent as? FakeWorkFlowComponent).to(equal(thirdComponent))
                }

                it("calls beginWork on the next component") {
                    expect(firstComponent.beginWorkCallCount) == 1
                    expect(secondComponent.beginWorkCallCount) == 1
                    expect(thirdComponent.beginWorkCallCount) == 0
                }

                it("doesn't call either finish or cancel") {
                    expect(finishCallCount) == 0
                    expect(cancelCallCount) == 0
                }

                it("returns nil as the next component when we advance the workflow to the final component") {
                    subject.advanceWorkFlow()
                    expect(subject.nextComponent).to(beNil())
                }

                context("when everything is done") {
                    beforeEach {
                        subject.advanceWorkFlow()
                        subject.advanceWorkFlow()
                    }

                    it("returns nil for the current component") {
                        expect(subject.currentComponent).to(beNil())
                    }

                    it("returns nil as the next component") {
                        expect(subject.nextComponent).to(beNil())
                    }

                    it("calls the finish handler") {
                        expect(finishCallCount) == 1
                    }

                    it("doesn't call cancel") {
                        expect(cancelCallCount) == 0
                    }

                    it("does not advance the workflow any more when asked to advance again") {
                        expect(firstComponent.beginWorkCallCount) == 1
                        expect(secondComponent.beginWorkCallCount) == 1
                        expect(thirdComponent.beginWorkCallCount) == 1
                    }
                }

                context("starting the workflow again") {
                    beforeEach {
                        subject.startWorkFlow()
                    }

                    it("calls beginWork on the first component again") {
                        expect(firstComponent.beginWorkCallCount) == 2
                        expect(secondComponent.beginWorkCallCount) == 1
                        expect(thirdComponent.beginWorkCallCount) == 0
                    }
                }

                context("cancelling the workflow") {
                    beforeEach {
                        subject.cancelWorkFlow()
                    }

                    it("returns nil for the current component") {
                        expect(subject.currentComponent).to(beNil())
                    }

                    it("returns nil as the next component") {
                        expect(subject.nextComponent).to(beNil())
                    }

                    it("calls the cancel handler") {
                        expect(cancelCallCount) == 1
                    }

                    it("doesn't call finish") {
                        expect(finishCallCount) == 0
                    }

                    it("does not allow further advancement through the workflow") {
                        subject.advanceWorkFlow()

                        expect(firstComponent.beginWorkCallCount) == 1
                        expect(secondComponent.beginWorkCallCount) == 1
                        expect(thirdComponent.beginWorkCallCount) == 0
                        expect(subject.currentComponent).to(beNil())
                        expect(subject.nextComponent).to(beNil())
                        expect(finishCallCount) == 0
                        expect(cancelCallCount) == 1

                    }
                }
            }
        }
    }
}
