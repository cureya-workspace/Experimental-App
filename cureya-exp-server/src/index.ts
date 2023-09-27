import express, { Express } from "express";
import dotenv from "dotenv";
import baseRouter from "./routers/base.router";
import passport from "passport";
import cookieParser from "cookie-parser";
import authMiddleware from "./middlewares/auth.middleware";
import morgan from 'morgan';
import handleError from "./middlewares/error-handler.middleware";

dotenv.config();

// Initialize
const app: Express = express();

// Middlewares
app.use(express.json());
app.use(cookieParser());
app.use(passport.initialize());
authMiddleware(passport);
app.use(morgan('tiny'))

// Router
app.use("/api/v1", baseRouter);


// ErrorHandler
app.use(handleError);

app.listen(process.env.PORT, () => {
  console.log(
    `[server]: Server is running at http://localhost:${process.env.PORT}`
  );
});
