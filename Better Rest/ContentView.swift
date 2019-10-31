//
//  ContentView.swift
//  Better Rest
//
//  Created by dominator on 30/10/19.
//  Copyright © 2019 dominator. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //to track when does user want to wake up
    @State private var wakeUp = defaultWakeUp
    
    //to track how much user want to sleep in hours
    @State private var sleepAmount = 8.0
    
    //to track number of cup of daily coffe intake
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    
    @State private var alertMessage = ""
    
    @State private var showAlert = false
    
    static var defaultWakeUp: Date{
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        //to hide the label
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }.addBackgroundStyle()
                
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }.addBackgroundStyle()
                
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Stepper(value: $coffeeAmount, in: 1...20){
                        if coffeeAmount == 1{
                            Text("1 cup ☕️")
                        }else{
                            Text("\(coffeeAmount) cups ☕️☕️")
                        }
                    }
                }.addBackgroundStyle()
            }
            
            .navigationBarTitle("Better Rest")
            .navigationBarItems(trailing: Button(action: calculateBedtime){
                Text("Calculate")
            })
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
                })
        }
    }
    
    func calculateBedtime(){
        let model = SleepCalculator()
        
        let dateComponents = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
        let hoursInSeconds = (dateComponents.hour ?? 0) * 60 * 60
        let minutesInSeconds = (dateComponents.minute ?? 0) * 60
        
        do{
            let prediction = try model.prediction(wake: Double(hoursInSeconds + minutesInSeconds), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            alertMessage = "\(dateFormatter.string(from: sleepTime))"
            alertTitle = "Your ideal sleeptime is..."
        }catch{
            alertTitle = "Error"
            alertMessage = "Sorry there was a problem calculating your bedtime!"
            print(error)
            //something went wrong
        }
        showAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
