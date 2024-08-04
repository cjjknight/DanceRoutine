import SwiftUI

struct EditStepView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var routineManager: RoutineManager
    
    @State private var name: String
    @State private var description: String
    @State private var videoURL: URL?
    
    var step: DanceStep

    init(step: DanceStep) {
        _name = State(initialValue: step.name)
        _description = State(initialValue: step.description)
        self.step = step
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Step Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    // You can add a file picker for the video URL if needed
                }
                
                Button("Save Changes") {
                    if let index = routineManager.availableSteps.firstIndex(where: { $0.id == step.id }) {
                        routineManager.availableSteps[index].name = name
                        routineManager.availableSteps[index].description = description
                        routineManager.availableSteps[index].videoURL = videoURL
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Edit Step")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct EditStepView_Previews: PreviewProvider {
    static var previews: some View {
        EditStepView(step: DanceStep(name: "Sample Step", description: "Sample Description", videoURL: nil)).environmentObject(RoutineManager())
    }
}
