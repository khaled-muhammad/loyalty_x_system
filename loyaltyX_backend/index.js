import express from 'express'
import dotenv from 'dotenv'
import cors from 'cors'

import authRoutes from './routes/authRoutes.js'
import cardRoutes from './routes/cardRoutes.js'
import orderRoutes from './routes/orderRoutes.js'

import { verifyToken } from './middlewares/authJWT.js'

dotenv.config()

const port = process.env.PORT

const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: false }))

app.use("/api/auth", authRoutes)
app.use("/api/cards", verifyToken, cardRoutes)
app.use("/api/orders", verifyToken, orderRoutes)

app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on port: ${port}`);
})