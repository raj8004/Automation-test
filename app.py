from flask import Flask, request, jsonify

app = Flask(__name__)

# Home route to handle login form submission
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # Get the form data (email and password)
        email = request.form['email']
        password = request.form['password']
        
        # Create a response with the submitted data
        response = {
            'email': email,
            'password': password
        }
        
        # Return the response as JSON
        return jsonify(response)
    
    # For GET requests, just return a simple message
    return jsonify({'message': 'Please send a POST request with email and password'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
