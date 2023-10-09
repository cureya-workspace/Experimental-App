import assert from "assert";
import { NextFunction, Response, Request } from "express";
import { User } from "@prisma/client";
import { hash } from "bcrypt";
import prismaClient from "../constants/prisma_client_singleton";


export class UserController {
  static async get(req: Request, res: Response) {
    return res.json(req.user);
  }

  static async post(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<any> {
    // Validations
    const { first_name, last_name, email, password, phone }: any = req.body;

    console.log(req.body);

    const emailRegex: RegExp =
      /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
    const phoneRegex: RegExp = /^(?:\+\d{1,3})?(?:\d{10,15})$/;

    try {
      assert(first_name, "Please provide first name");
      assert(last_name, "Please provide last name");
      assert(email, "Please provide email");
      assert(password, "Please provide password");
      assert(phone, "Please provide phone no");

      if (!emailRegex.test(email)) {
        throw new Error("Provide a valid email address");
      }

      if (!phoneRegex.test(phone)) {
        throw new Error("Provide a valid phone number");
      }

      if (first_name < 3 || first_name > 30) {
        throw new Error("Provide a valid first name");
      }

      if (last_name < 3 || last_name > 30) {
        throw new Error("Provide a valid first name");
      }

      if (password.length <= 6) {
        throw new Error("Password should be greater than 5 characters.");
      }
    } catch (error: any) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }

    // Create new User.
    try {
      const encryptedPassword = await hash(password, 12);

      let newUser: User | any = await prismaClient.user.create({
        data: {
          first_name: first_name,
          last_name: last_name,
          email: email,
          password: encryptedPassword,
          phone: phone,
        },
      });
      delete newUser["password"];

      return res.json(newUser);
    } catch (error: any) {
      if( error.message.length > 50) {
        return res.status(500).json({
          success: false,
          message: 'Something went wrong!',
        });
      } else {
        return res.status(500).json({
          success: false,
          message: error.message,
        });
      }
    }
  }

  static async put(req: Request, res: Response) {
    return res.json({});
  }

  static async delete(req: Request, res: Response): Promise<Response> {
    return res.json({});
  }
}
