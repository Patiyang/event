from flask_restful import Resource
from flask import request

class Register(Resource):
    def get(self):
        return{"mesage": "registering user"}

    def post(self):
        data = request.get_json() 
        username = data['username']
        password = data['password']
        email = data['email']

        return{"message": "registering {}".format(username)}