import assert from "assert";
import { Request, Response } from "express";
import prismaClient from "../constants/prisma_client_singleton";

export default class DCTestController {
  static async get(req: Request, res: Response) {
    const query: { diagnostic_center_id?: string; page?: string } =
      req.query as any;

    // Validation block
    try {
      // Some validation
    } catch (error: any) {
      return res.send(400).json({
        success: false,
        message: error.message,
      });
    }

    try {
      const page = Number.parseInt(query.page!) || 1;
      const LIMIT =
        Number.parseInt(process.env.ENTITY_COUNT_PER_PAGE as string) || 10;

      const resultCount = await prismaClient.dCTest.count({
        where: {
          diagnostic_center_id: query.diagnostic_center_id
            ? query.diagnostic_center_id
            : undefined,
        },
      });
      const result = await prismaClient.dCTest.findMany({
        include: {
          global_diagnosis_test: {
            select: {
              test_name: true,
              attribute: true
            }
          }
        },
        where: {
          diagnostic_center_id: query.diagnostic_center_id
            ? query.diagnostic_center_id
            : undefined,
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
              }${
                query.diagnostic_center_id
                  ? "&diagnostic_center_id=" + query.diagnostic_center_id
                  : ""
              }`
            : null,
          previous: hasPreviousData
            ? `${req.protocol}://${req.get("host")}${req.baseUrl}?page=${
                page - 1
              }${
                query.diagnostic_center_id
                  ? "&diagnostic_center_id=" + query.diagnostic_center_id
                  : ""
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
    const { diagnostic_center_id, global_diagnosis_test_id, cust_price }: any =
      req.body;

    try {
      assert(diagnostic_center_id, "Please provide diagnostic center id");
      assert(
        global_diagnosis_test_id,
        "Please provide global_diagnosis_test_id"
      );
      assert(cust_price, "Please provide cust_price");
    } catch (error: any) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }

    try {
      const result = await prismaClient.dCTest.create({
        data: {
          diagnostic_center_id: diagnostic_center_id,
          cust_price: Number.parseFloat(cust_price),
          global_diagnosis_test_id: global_diagnosis_test_id,
        },
      });

      return res.json({
        success: false,
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
