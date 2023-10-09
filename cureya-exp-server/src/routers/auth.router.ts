import { Router } from "express";
import AuthController from "../controllers/auth.controller";
import passport from "passport";

const authRouter: Router = Router();

authRouter.post('/login', AuthController.login);
authRouter.delete('/logout', passport.authenticate('jwt', {session: false}), AuthController.logout);
export default authRouter