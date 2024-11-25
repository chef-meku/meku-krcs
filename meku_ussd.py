import os
from flask import Flask, request

app = Flask(__name__)

@app.route("/ussd", methods=['POST'])
def ussd():
    # Read the variables sent via POST from our API
    session_id = request.values.get("sessionId", None)
    serviceCode = request.values.get("serviceCode", None)
    phone_number = request.values.get("phoneNumber", None)
    text = request.values.get("text", "default")

    # Split the text to navigate the menu levels
    inputs = text.split('*')

    # Main menu
    if text == '':
        response = "CON Select an option: \n"
        response += "1. Register \n"
        response += "2. Log Vitals \n"
        response += "3. Set Appointment \n"
        response += "4. Change Language"
    
    # Registration flow
    elif inputs[0] == '1':
        if len(inputs) == 1:  # Prompt for name
            response = "CON Enter your name:"
        elif len(inputs) == 2:  # Prompt for ID
            response = "CON Enter your ID number:"
        elif len(inputs) == 3:  # Registration confirmation
            name = inputs[1]
            response = f"END You have been signed up, {name}. You will receive confirmation shortly."

    # Log Vitals flow
    elif inputs[0] == '2':
        if len(inputs) == 1:  # Vitals menu
            response = "CON Select an option: \n"
            response += "1. Log Blood Pressure (BP) \n"
            response += "2. Log Blood Sugar"
        elif len(inputs) == 2:
            if inputs[1] == '1':  # Log Blood Pressure
                response = "CON Enter your BP reading:"
            elif inputs[1] == '2':  # Log Blood Sugar
                response = "CON Enter your blood sugar reading:"
            else:
                response = "END Invalid choice"
        elif len(inputs) == 3:
            response = "END Thank you! Your vitals have been logged."

    # Set Appointment flow
    elif inputs[0] == '3':
        response = "END You will receive a notification of your next appointment shortly."

    # Change Language flow
    elif inputs[0] == '4':
        if len(inputs) == 1:  # Language menu
            response = "CON Select language: \n"
            response += "1. English \n"
            response += "2. Kiswahili"
        elif len(inputs) == 2:
            if inputs[1] == '1':
                response = "END Language changed to English."
            elif inputs[1] == '2':
                response = "END Lugha imebadilishwa kuwa Kiswahili."
            else:
                response = "END Invalid choice"

    # Invalid input handling
    else:
        response = "END Invalid choice"

    # Send the response back to the API
    return response

if __name__ == '__main__':
    app.run(debug=True)
