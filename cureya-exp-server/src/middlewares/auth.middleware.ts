import {
  Strategy,
  ExtractJwt,
  StrategyOptions,
  VerifiedCallback,
} from "passport-jwt";
import { PassportStatic } from "passport";
import prismaClient from "../constants/prisma_client_singleton";
import { User } from "@prisma/client";

const cookieExtractor = function (req: any) {
  let token: string | null = null;
  if (req && req.cookies) {
    token = req.cookies["Authentication"];
    token = token?.split(" ")[1]!;
  }
  return token;
};

export default (passport: PassportStatic) => {
  let opts: StrategyOptions = {
    jwtFromRequest: ExtractJwt.fromExtractors([
      ExtractJwt.fromAuthHeaderAsBearerToken(),
      cookieExtractor,
    ]),
    secretOrKey: process.env.SECRET_KEY,
  };

  return passport.use(
    new Strategy(opts, async function (jwt_payload, done: VerifiedCallback) {
      const { authToken, userId }: { authToken: string; userId: string } =
        jwt_payload;

      try {
        const user: User | any = await prismaClient.user.findFirst({
          where: {
            AuthToken: {
              every: {
                token: authToken,
              },
            },
          },
        });

        if (user?.id !== userId) {
          throw new Error("Invalid session");
        }

        delete user["password"];

        return done(null, user);
      } catch (error: any) {
        return done(error, false);
      }
    })
  );
};
