import { NextFunction, Request, Response } from "express";
import { Role } from "../constants/enums";
import { User } from "@prisma/client";

export const RBACValidator = (allowedRoles: Role[]) => {
    return function (req: Request, res: Response, next: NextFunction) {
        const user: User = req.user as User;

        if (allowedRoles.includes(user.role)) {
            return next();
        } else {
            return res.status(401).json({
                success: false,
                message: "Unauthorized user type"
            })
        }
    }
}