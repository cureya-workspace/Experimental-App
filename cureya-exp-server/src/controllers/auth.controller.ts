import assert from "assert";
import { Request, Response } from "express";
import prismaClient from "../constants/prisma_client_singleton";
import { compare } from "bcrypt";
import { sign } from "jsonwebtoken";

export default class AuthController {
  static async login(req: Request, res: Response): Promise<Response> {
    console.log(req.body);
    const { email, password, role } = req.body;
    const emailRegex: RegExp =
      /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

    // validate
    try {

      assert(password, "Please provide password");

      if (!emailRegex.test(email)) {
        throw new Error("Provide a valid email address");
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

    // Perform Login
    try {
      const loginUser: any = await prismaClient.user.findUnique({
        where: {
          email: email,
        },
      });

      if (!loginUser) {
        throw new Error("User with email " + email + " not found");
      }

      // Validate role
      console.log(loginUser.role, role)
      if (loginUser.role != role) {
        throw new Error("Invalid user!");
      }

      // Validate password
      const isValidPassword = await compare(password, loginUser.password);
      if (!isValidPassword) {
        throw new Error("Incorrect password");
      }

      // Prepare JWT Token
      await prismaClient.authToken.deleteMany({
        where: {
          user_id: loginUser.id,
        }
      }); // Clear previous sessions
      const authToken = await prismaClient.authToken.create({
        data: {
          user_id: loginUser.id,
        },
      });

      const jwtPayload = {
        authToken: authToken.token,
        userId: loginUser.id,
      };

      const jwt: string = sign(jwtPayload, process.env.SECRET_KEY as string, {
      });

      delete loginUser['password'];
      delete loginUser['id'];

      return res
        .cookie("Authentication", `Bearer ${jwt}`, {
          httpOnly: false,
          secure: true,
          sameSite: 'none'
        })
        .json({ success: true,
          user: loginUser,
          token:  `Bearer ${jwt}`
        });
    } catch (error: any) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  }

  static async logout(req: Request, res: Response): Promise<Response> {    
    await prismaClient.authToken.deleteMany({
      where: {
        user_id: (req.user! as any).id,
      },
    });
    res.clearCookie('Authentication');
    return res.json({
      success: true,
      message: 'successfully logged out'
    });
  }
}
