import { Request, Response } from "express";
import prismaClient from "../constants/prisma_client_singleton";
import { DCTest } from "@prisma/client";

export default class SearchController {
  static async post(req: Request, res: Response) {
    const {
      pincode,
      city,
      tests,
    }: {
      pincode?: string;
      city?: string;
      tests: string[];
    } = req.body;

    console.log(req.body);

    // Validation block
    try {
    //   if (pincode || city) {
    //     throw new Error("Please provide either pincode or city.");
    //   }
    //   if (!(pincode && city)) {
    //     throw new Error("Please provide either pincode or city.");
    //   }
    //   if (tests.length === 0) {
    //     throw new Error("Please provide atleast one test.");
    //   }
    } catch (error: any) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }

    try {
      const result = await prismaClient.diagnosticCenter.findMany({
        where: {
          pincode: pincode ? pincode : undefined,
          city: city ? city : undefined,
          DCTest: {
            some: {
              global_diagnosis_test_id: {
                in: tests,
              },
            },
          },
        },
        include: {
          DCTest: {
            where: {
              global_diagnosis_test_id: {
                in: tests,
              },
            },
            select: {
              cust_price: true,
              global_diagnosis_test: {
                select: {
                  id: true,
                  test_name: true,
                },
              },
            },
          },
        },
      });

      return res.json({
        success: true,
        data: result,
      });
    } catch (error: any) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  }
}
