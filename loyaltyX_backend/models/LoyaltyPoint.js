import { DataTypes } from "sequelize";
import sequelize from "../db.js";
import Order from "./Order.js";

const LoyaltyPoint = sequelize.define(
  "LoyaltyPoint",
  {
    id: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      primaryKey: true,
    },
    orderId: {
      type: DataTypes.STRING,
      allowNull: false,
      references: {
        model: Order,
        key: "id",
      },
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    },
    pointsEarned: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  },
  {
    tableName: "loyalty_points",
    updatedAt: false,
  }
);

export default LoyaltyPoint;
