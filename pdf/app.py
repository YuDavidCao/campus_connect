import os
import flask
from flask import Flask, request, abort, jsonify, send_file

import firebase
from flask_socketio import SocketIO, emit


app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")
s = firebase.FirebaseFirestore(socketio)

@app.route('/', )
def home():
    return "PDF"

# every functions that uses firebase in our app, we will replicate the same function in the flask server

@app.route('/signup', methods=['POST'])
def signup():
    email = flask.request.json.get("email")
    password = flask.request.json.get("password")
    if not email or not password:
        print("Missing 'email' or 'password' in request data")
        abort(400, description="Missing 'email' or 'password' in request data")
    val = s.create_user_with_email_and_password(email, password)
    return jsonify(val)


@app.route('/generate_pdf', methods=['POST'])
def generate():
    data = request.json
    docId = data.get("docId")
    
    if not docId:
        abort(400, description="Missing 'docId' in request data")
    
    try:
        print(docId)
        print(type(docId))
        s.generate_pdf(docId)
        file_path = f"{docId}_report.pdf"
        
        if os.path.exists(file_path):
            return send_file(file_path, as_attachment=True)
        else:
            abort(404, description="PDF file not found")
    except Exception as e:
        app.logger.error(f"Error generating PDF: {e}")
        abort(500, description="Internal server error")
   
@socketio.on('connect')
def handle_connect():
    print("Client connected")

@socketio.on('disconnect')
def handle_disconnect():
    print("Client disconnected")
        
if __name__ == '__main__':
    # app.run(debug=True)
    socketio.run(app, host='0.0.0.0', port=5000)