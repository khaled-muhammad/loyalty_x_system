import dotenv from 'dotenv'
dotenv.config({quiet:true})

const config = {
  host: process.env.HOST,
  port: process.env.DBPORT,
  user: process.env.USER,
  password: process.env.PASSWORD,
  database: process.env.DATABASE,
}

export default config