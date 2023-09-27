import { Request, Response, Router } from "express";
import { UserController } from "../controllers/user.controller";
import passport from "passport";

const userRouter: Router = Router();

userRouter.post("", UserController.post);
userRouter.get(
  "",
  passport.authenticate("jwt", { session: false }),
  UserController.get
);

export default userRouter;
