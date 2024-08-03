import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: DanceStepsView()) {
                    Text("View Dance Steps")
                }
                .padding()
                
                NavigationLink(destination: RoutineBuilderView()) {
                    Text("Build Dance Routine")
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
