import {v4} from 'uuid'
import jwt from 'jsonwebtoken'
import bcrypt from 'bcryptjs'

import { User } from '../models/index.js'

const generateAccessToken = (userId) => {
    return jwt.sign({userId}, process.env.JWT_SECRET, {expiresIn: '7d'})
}

export const register = async (req, res) => {
    const {username, email, password} = req.body || {}

    if (!email || !password) {
        res
        .status(400)
        .send({ error: "Username or Email or Password fields cannot be empty!" })
        return
    }

    const salt = await bcrypt.genSalt(10)

    const hashedPassword = await bcrypt.hash(password, salt)

    const user = {
        userId: v4(),
        username,
        email,
        password: hashedPassword,
    }

    try {
        const userAlreadyExists = await User.findOne({where: { username }})

        if (userAlreadyExists) {
            res.status(409).send({error: "Username already exists"})
        } else {
            await User.create(user)
            res.status(201).send({ message: "You have registered successfully!" })
        }
    } catch {
        res.status(500).send({ error: error.message })
    }
}

export const login = async (req, res) => {
  const { username, password } = req.body || {};
  if (!username || !password) {
    res
      .status(400)
      .json({ error: "Username or Password fields cannot be empty!" })
    return;
  }

  try {
    const user = await User.findOne({ where: { username } })

    if (user) {
      if (!user.password) {
        res.status(401).send({ error: "Invalid credentials" });
        return;
      }

      const passwordMatch = await bcrypt.compare(
        password,
        user.password
      )

      if (passwordMatch) {
        res.status(200).json({
          userId: user.userId,
          email: user.email,
          username: user.username,
          points: user.points,
          access_token: generateAccessToken(user.userId),
        })
      } else {
        res.status(401).json({ error: "Invalid credentials" })
      }
    } else {
      res.status(401).json({ error: "Invalid credentials" })
    }
  } catch (error) {
    res.status(500).json({ error: error.message })
  }
}

export const me = async (req, res) => {
  try {
    const user = await User.findOne({ where: { userId: req.userId } })
    res.send(user)
  } catch (error) {
    res.status(400).send({'error': 'User not found or session expired!'})
  }
}