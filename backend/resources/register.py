from flask_restful import Resource
from flask import request
from models import db, User, UserSchema

users_schema = UserSchema(many=True)
user_schema = UserSchema()


class Register(Resource):
    def get(self):
       
        users = User.query.all()
        users = users_schema.dump(users).data
        return{"status": "success", "data":users}, 200

    def post(self):
        json_data = request.get_json(force=True)
        if not json_data:
               return {'message': 'No input data provided'}, 400
        # data desirialization and validation
        data, errors = user_schema.load(json_data)
        if errors:
            return errors, 422
        
        user = User.query.filter_by(username=data['username']).first()
        if user:
            return{'message': 'username already exists'}, 400

        user = User.query.filter_by(email=data['email']).first()
        if user:
            return{'message': 'the email already exists'}, 400

            
        user = User(
            username=json_data['username'],
            first_name= json_data['first_name'],
            last_name= json_data['last_name'],
            email= json_data['email'],
            password= json_data['password']
        )

        db.session.add(user)
        db.session.commit()

        result = user_schema.dump(user).data

        return{'status': 'success', 'data': result}, 201
        
        # data = request.get_json() 
        # username = data['username']
        # password = data['password']
        # email = data['email']

        # return{"message": "registering {}".format(username)}