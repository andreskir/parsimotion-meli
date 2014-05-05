module.exports =
  port: process.env.PORT or 4000

  mongodb:
    uri: process.env.MONGOHQ_URL or 'mongodb://localhost/widgets'

  parsimotionApi:
    uri: process.env.PARSIMOTION_API_URL  

  auth:
    user: process.env.USER or "admin"
    password: process.env.PASSWORD or "admin"
