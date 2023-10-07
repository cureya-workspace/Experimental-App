import { Router } from "express";
import passport from "passport";
import SearchController from "../controllers/search.controller";

const searchRouter: Router = Router();

searchRouter.post(
  "/",
  passport.authenticate("jwt", { session: false }),
  SearchController.post
);

export default searchRouter;
