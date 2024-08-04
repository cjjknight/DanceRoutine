import SwiftUI

struct AddNewStepView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var routineManager: RoutineManager
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var videoURL: URL?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Step Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    // You can add a file picker for the video URL if needed
                }
                
                Button("Save Step") {
                    let newStep = DanceStep(name: name, description: description, videoURL: videoURL)
                    routineManager.availableSteps.append(newStep)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add New Step")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddNewStepView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewStepView().environmentObject(RoutineManager())
    }
}
