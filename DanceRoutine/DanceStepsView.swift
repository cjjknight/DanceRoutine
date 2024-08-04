import SwiftUI

struct DanceStepsView: View {
    @EnvironmentObject var routineManager: RoutineManager
    @State private var showingAddNewStep = false
    @State private var showingEditStep = false
    @State private var selectedStep: DanceStep?
    
    var body: some View {
        List {
            ForEach(routineManager.availableSteps) { step in
                VStack(alignment: .leading) {
                    Text(step.name)
                        .font(.headline)
                    Text(step.description)
                        .font(.subheadline)
                }
                .swipeActions {
                    Button("Edit") {
                        selectedStep = step
                        showingEditStep.toggle()
                    }
                    .tint(.blue)
                    
                    Button("Delete", role: .destructive) {
                        if let index = routineManager.availableSteps.firstIndex(where: { $0.id == step.id }) {
                            routineManager.availableSteps.remove(at: index)
                        }
                    }
                }
            }
            
            Button("Add New Step") {
                showingAddNewStep.toggle()
            }
            .sheet(isPresented: $showingAddNewStep) {
                AddNewStepView().environmentObject(routineManager)
            }
        }
        .navigationTitle("Dance Steps")
        .sheet(item: $selectedStep) { step in
            EditStepView(step: step).environmentObject(routineManager)
        }
    }
}

struct DanceStepsView_Previews: PreviewProvider {
    static var previews: some View {
        DanceStepsView().environmentObject(RoutineManager())
    }
}
