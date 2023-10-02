import assert from "assert";
import { Request, Response } from "express";

export default class DiagnosticCenterDiagnosisTestController {
    static async get(req: Request, res: Response) {
    }
    static async post(req: Request, res: Response) {
        const {
            diagnostic_center_id,
            global_diagnosis_test_id,
            cust_price
        }: any = req.body;

        try {
            assert(diagnostic_center_id, 'Please provide diagnostic center id');
            assert(global_diagnosis_test_id, 'Please provide global_diagnosis_test_id');
            assert(cust_price, 'Please provide cust_price');
        } catch (error: any) {
            return res.status(400).json({
                success: false,
                message: error.message
            });
        }

        try {
            // TODO: add to database
        } catch (error: any) {
            
        }  
    }
    static async put() {}
    static async delete() {}
}