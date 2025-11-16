import jwt from "jsonwebtoken"
import dotenv from 'dotenv'
import { User, Card } from "../models/index.js"

dotenv.config({quiet:true})

const SECRET = process.env.JWT_SECRET

export const verifyToken = async (req, res, next) => {
    const token = req.headers["authorization"]
 
    if (!token) {
        return res.status(403).send({ message: "No token provided!" })
    }
 
    try {
        const decoded = jwt.verify(token.replace("Bearer ", ""), SECRET)
        req.userId = decoded.userId
 
        const user = await User.findByPk(req.userId)
        if (!user) {
            return res.status(401).send({ message: "Unauthorized!" })
        }
 
        next()
    } catch (err) {
        return res.status(401).send({ message: "Unauthorized!" })
    }
};