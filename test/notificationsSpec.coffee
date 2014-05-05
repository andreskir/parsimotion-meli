request = require 'supertest'
expect = require("chai").should()
app = require("../lib/app").app

describe "POST /notifications", ->
  agent = request.agent app

  describe "should return 200", ->
    it "and the error reason when an error occurs", (done) ->
      request(app)
      .post("/notifications")
      .send(user_id: 123456)
      .expect(error: "Parsimotion token not found for user 123456")
      .expect(200, done)

    it "and the notification when the request succeeds", (done) ->
      expectedResponse =
        notification:
          user_id: 158002882

      request(app)
      .post("/notifications")
      .send(user_id: 158002882)
      .expect(200)
      .end (err, res) ->
        return done(err) if err

        res.body.notification.should.deep.equal expectedResponse.notification
        done()
