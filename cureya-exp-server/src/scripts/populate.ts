import fs from "fs";
import csv from "csv-parser";
import { PrismaClient } from "@prisma/client";
import prismaClient from "../constants/prisma_client_singleton";

class Populate {
  centersData: any[];
  prismaClient: PrismaClient;

  private static async readCSVFile(filePath: string): Promise<object[]> {
    const results: object[] = [];

    return new Promise((resolve, reject) => {
      fs.createReadStream(filePath)
        .pipe(csv())
        .on("data", (data) => results.push(data))
        .on("end", () => resolve(results))
        .on("error", (error) => reject(error));
    });
  }

  private async readCSVFile(filePath: string): Promise<object[]> {
    const results: object[] = [];

    return new Promise((resolve, reject) => {
      fs.createReadStream(filePath)
        .pipe(csv())
        .on("data", (data) => results.push(data))
        .on("end", () => resolve(results))
        .on("error", (error) => reject(error));
    });
  }

  private constructor(
    private kCentersData: any,
    private kPrismaClient: PrismaClient
  ) {
    this.centersData = kCentersData;
    this.prismaClient = kPrismaClient;
  }

  static async init() {
    const data = await this.readCSVFile(
      "src/scripts/fict_data/CENTERS/centers.csv"
    );
    return new Populate(data, prismaClient);
  }

  private async populateDiagnosticCenters() {
    const populateData = this.centersData.map((data: any) => {
      return {
        diagnostic_center_code: data.diagnostic_center_id,
        name: data.title,
        email: "some@emailmail.com",
        phone: data.phone,
        city: data.city,
        address: data.address,
        pincode: data.pincode,
        center_type: "main-center",
        operating_start_time: "9 AM",
        operating_end_time: "6 PM",
      };
    });

    populateData.map(async (data: any) => {
      try {
        await prismaClient.diagnosticCenter.create({ data: data });
      } catch (error) {
        console.log(data.diagnostic_center_code);
      }
    });
  }

  async populateTests() {
    for (let index = 0; index < this.centersData.length; index++) {
      const element = this.centersData[index];

      console.log(`${index+1}/${this.centersData.length}`)

      try {
        const dTests: any[] = await this.readCSVFile(
          `src/scripts/fict_data/DIAGNOSIS_TESTS/${element.diagnostic_center_id}.csv`
        );

        for (let index = 0; index < dTests.length; index++) {
          const dTest = dTests[index];
          // Create a global test if not exist along with parameters
          if (dTest.test_cost.split("  ").length > 1) {
            
            // Has Attributes
            let attribute: string =
              dTest.test_cost.split("  ")[
                dTest.test_cost.split("  ").length - 1
              ];
            attribute = attribute.replace("(", "").replace(")", "");

            const count = await prismaClient.globalDiagnosisTest.count({
              where: {
                AND: {
                  test_name: dTest.test_name,
                  attribute: attribute,
                },
              },
            });
            
            let globalTestId: string;
            if (count === 0) {
            
              globalTestId = (
                await prismaClient.globalDiagnosisTest.create({
                  data: {
                    test_name: dTest.test_name,
                    attribute: attribute,
                  },
                })
              ).id;

            
            } else {
            
              const test = await prismaClient.globalDiagnosisTest.findUnique({
                where: {
                  test_name_attribute: {
                    test_name: dTest.test_name,
                    attribute: attribute,
                  },
                },
              });

              globalTestId = test?.id as string;
            
            }
            const price: string = dTest.test_cost
              .split("  ")[0]
              .split("  ")[0]
              .split("Rs. ")[1];

            const dcId: string = (
              await prismaClient.diagnosticCenter.findUnique({
                where: {
                  diagnostic_center_code: element.diagnostic_center_id,
                },
              })
            )?.id as string;

            await prismaClient.dCTest.create({
              data: {
                diagnostic_center_id: dcId,
                global_diagnosis_test_id: globalTestId,
                cust_price: Number.parseFloat(price),
              },
            });
          } else if (dTest.test_cost.split("  ").length === 1) {
            
            const count = await prismaClient.globalDiagnosisTest.count({
              where: {
                AND: {
                  test_name: dTest.test_name,
                  attribute: null,
                },
              },
            });


            

            let globalTestId: string;
            if (count === 0) {
            
              globalTestId = (
                await prismaClient.globalDiagnosisTest.create({
                  data: {
                    test_name: dTest.test_name,
                  },
                })
              ).id;
            
            } else {
            
              const test = await prismaClient.globalDiagnosisTest.findFirst({
                where: {
                  AND: {
                    test_name: dTest.test_name,
                    attribute: undefined,
                  },
                },
              });

              globalTestId = test?.id as string;

            }

            const price: string = dTest.test_cost
              .split("  ")[0]
              .split("  ")[0]
              .split("Rs. ")[1];

            const dcId: string = (
              await prismaClient.diagnosticCenter.findUnique({
                where: {
                  diagnostic_center_code: element.diagnostic_center_id,
                },
              })
            )?.id as string;

            await prismaClient.dCTest.create({
              data: {
                diagnostic_center_id: dcId,
                global_diagnosis_test_id: globalTestId,
                cust_price: Number.parseFloat(price),
              },
            });
          }

          // add to dc test
        }
      } catch (error: any) {
        console.log("TEST SKIPPED in", element.diagnostic_center_id);
      }
      console.clear()
    }
  }
}

(async () => {
  const a: Populate = await Populate.init();
  await a.populateTests();
})();
