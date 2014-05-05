request = require 'supertest'
expect = require("chai").should()
app = require("../lib/app").app
restler = require "restler"
sinon = require "sinon"

describe "POST /notifications", ->
  agent = request.agent app

  it "when the user_id of the notification doesn't exist on the DB, it should return 200 and the error", (done) ->
    request(app)
    .post("/notifications")
    .send(user_id: 123456)
    .expect(error: "Parsimotion token not found for user 123456")
    .expect(200, done)

  describe "", ->
    before ->
      sinon.stub restler, "postJson", -> on: (_, block) -> block message: "OK!"
    
    after ->
      restler.postJson.restore()

    it "when the request to Parsimotion API succeeds, it should return 200 and the log entry", (done) ->
      expectedResponse =
        notification:
          user_id: 158002882
        response: 
          message: "OK!"

      request(app)
      .post("/notifications")
      .send(user_id: 158002882)
      .expect(200)
      .end (err, res) ->
        return done(err) if err

        res.body.notification.should.deep.equal expectedResponse.notification
        res.body.response.should.deep.equal expectedResponse.response

        done()

  describe "", ->
    before ->
      sinon.stub restler, "postJson", -> on: (_, block) -> block()

    after ->
      restler.postJson.restore()

    it "when an orders notification is received, it should issue a request to importer/orders/:id", (done) ->
      request(app)
      .post("/notifications")
      .send(user_id: 158002882, resource: "/orders/123456")
      .end (err, res) ->
        if (err) then return done err
        
        restler.postJson.calledWithMatch(/\/meli\/importer\/orders\/123456/).should.equal true
        done()

    it "when a listing notification is received, it should issue a request to importer/listings/:id", (done) ->
      request(app)
      .post("/notifications")
      .send(user_id: 158002882, resource: "/listings/123456")
      .end (err, res) ->
        if (err) then return done err
        
        restler.postJson.calledWithMatch(/\/meli\/importer\/listings\/123456/).should.equal true
        done()
