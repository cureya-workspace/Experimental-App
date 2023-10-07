import assert from "assert";
import { Response, Request } from "express";
import prismaClient from "../constants/prisma_client_singleton";

export default class GlobalDiagnosisTestController {
  static async get(req: Request, res: Response) {
    const { page: paramPage, search }: { page: string, search?:string } = req.query as any;
    const LIMIT =
      Number.parseInt(process.env["ENTITY_COUNT_PER_PAGE"] as string) || 10;
    const page = Number.parseInt(paramPage) || 1;

    try {
      const resultCount = await prismaClient.globalDiagnosisTest.count({
        where: {
          test_name: {
            startsWith: search ? `%${search}%` : undefined,
          }
        },
      });
      const result = await prismaClient.globalDiagnosisTest.findMany({
        where: {
          test_name: {
            startsWith: search ? `%${search}%` : undefined,
          }
        },
        skip: (page - 1) * LIMIT,
        take: LIMIT,
      });

      const totalPages = Math.ceil(resultCount / LIMIT);
      const hasNextData = totalPages > page;
      const hasPreviousData = page !== 1;

      const response = {
        success: true,
        paging: {
          totalPages: totalPages,
          totalCount: resultCount,
          next: hasNextData
            ? `${req.protocol}://${req.get("host")}${req.baseUrl}?page=${
                page + 1
              }`
            : null,
          previous: hasPreviousData
            ? `${req.protocol}://${req.get("host")}${req.baseUrl}?page=${
                page - 1
              }`
            : null,
        },
        data: result,
      };

      return res.json(response);
    } catch (error: any) {
      return res.status(500).json({
        success: false,
        message: error.message,
      });
    }
  }

  static async post(req: Request, res: Response) {
    const data = req.body;

    try {
      assert(data.test_name, "Please provide test name");
    } catch (err: any) {
      return res.status(400).json({
        success: false,
        message: err.message,
      });
    }

    try {
      // index validate
      const duplicates = await prismaClient.globalDiagnosisTest.count({
        where: {
          test_name: data.test_name,
          attribute: data.attribute ? data.attribute : undefined,
        },
      });

      if (duplicates) {
        throw new Error("Duplicates already exist");
      }

      const result = await prismaClient.globalDiagnosisTest.create({
        data: {
          test_name: data.test_name,
          attribute: data.attribute ? data.attribute : undefined,
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

  static async put() {}
  static async delete() {}
}
