import { Router } from "express";
import passport from "passport";
import DCTestController from "../controllers/dc-test.controller";

const dCTestRouter:Router = Router()


dCTestRouter.get('',[
    passport.authenticate('jwt', {session: false})
], DCTestController.get);

export default dCTestRouter;