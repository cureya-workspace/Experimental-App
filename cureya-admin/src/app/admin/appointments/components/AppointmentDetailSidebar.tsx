import { preparedFetchRequest } from "@/app/(shared)/helpers/fetch_helper";
import {
  Badge,
  Button,
  Divider,
  Drawer,
  DrawerBody,
  DrawerCloseButton,
  DrawerContent,
  DrawerFooter,
  DrawerHeader,
  DrawerOverlay,
  HStack,
  Spacer,
  Select,
  Text,
  VStack,
  Stack,
} from "@chakra-ui/react";
import React from "react";
import { FiMail, FiPhoneCall, FiUser } from "react-icons/fi";
import { QueryClient, useMutation, useQuery, useQueryClient } from "react-query";
import { Formik } from "formik";

export default function AppointmentDetailSidebar({
  appointmentId,
  isOpen,
  onOpen,
  onClose,
  btnRef,
}: {
  appointmentId: string;
  isOpen: any;
  onOpen: any;
  onClose: any;
  btnRef: any;
}) {
  const { data, error, isLoading, refetch } = useQuery({
    queryKey: ["appointment", appointmentId],
    queryFn: (() => {
      return preparedFetchRequest({
        includeCredentials: true,
        method: "GET",
        url: `http://localhost:3000/api/v1/appointment/${appointmentId}`,
      });
    })(),
  });

  return (
    <Drawer
      size="md"
      isOpen={isOpen}
      placement="right"
      onClose={onClose}
      finalFocusRef={btnRef}
    >
      <DrawerOverlay />
      <DrawerContent>
        <DrawerCloseButton />
        <DrawerHeader>Appointment Details</DrawerHeader>
        <DrawerBody>
          <HStack>
            <Badge colorScheme="blue" borderRadius="full" p="2">
              <FiUser style={{ fontSize: "12px" }} />
            </Badge>
            <Text ml="1">
              {" "}
              {data?.data.user.first_name} {data?.data.user.last_name}
            </Text>
          </HStack>
          <HStack mt="2">
            <Badge colorScheme="blue" borderRadius="full" p="2">
              <FiPhoneCall style={{ fontSize: "12px" }} />
            </Badge>
            <Text ml="1"> {data?.data.user.phone}</Text>
          </HStack>
          <HStack mt="2">
            <Badge colorScheme="blue" borderRadius="full" p="2">
              <FiMail style={{ fontSize: "12px" }} />
            </Badge>
            <Text ml="1"> {data?.data.user.email}</Text>
          </HStack>
          <Divider mt="4" />
          <Text mt="2" fontWeight="bold" fontSize="lg">
            {data?.data.diagnostic_centre.name}
          </Text>
          <Text mt="2" fontSize="md">
            <Text as="span" fontWeight="semibold">
              Phone:{" "}
            </Text>{" "}
            {data?.data.diagnostic_centre.phone}
          </Text>
          <Text fontSize="md">
            <Text as="span" fontWeight="semibold">
              Address:
            </Text>{" "}
            {data?.data.diagnostic_centre.address}
          </Text>
          <Divider mt="2" />
          <Text mt="2" mb="2" fontWeight="bold" fontSize="lg">
            Tests
          </Text>
          {data?.data.AppointmentDiagnosisTest.map((e: any, i: number) => (
            <HStack justify="stretch" key={i}>
              <Text>{e.dc_test.global_diagnosis_test.test_name}</Text>
              <Spacer />
              <Text>Rs. {e.dc_test.cust_price}</Text>
            </HStack>
          ))}
          <Divider mt="2" />
          <Text mt="2" mb="2" fontWeight="bold" fontSize="lg"></Text>
          <Text mt="2" mb="2" fontWeight="bold" fontSize="lg">
            Change Status
          </Text>
          {!isLoading ? (
            <ChangeAppointmentStatus refetch={refetch} appointment={data?.data} />
          ) : null}
        </DrawerBody>
        <DrawerFooter>
          <Button variant="outline" mr={3} onClick={onClose}>
            Cancel
          </Button>
        </DrawerFooter>
      </DrawerContent>
    </Drawer>
  );
}

const ChangeAppointmentStatus = function ({
  refetch,
  appointment,
}: {
  refetch: any,
  appointment: any;
}) {
  const date = Date.parse(appointment.visit_date.split("T")[0]);
  const datetime = new Date(date);
  const { mutateAsync, isLoading } = useMutation({
    mutationFn: preparedFetchRequest({
      includeCredentials: true,
      method: "PUT",
      url: `http://localhost:3000/api/v1/appointment/${appointment.id}`,
    }),
  });

  const queryClient = useQueryClient();

  return (
    <Stack direction="column">
      <HStack justify="stretch">
        <Text> Visit Date: </Text>
        <Spacer />
        <Text>{datetime.toLocaleDateString()}</Text>
      </HStack>

      <Formik
        initialValues={{
          status: appointment.status,
          slot: appointment.slot,
        }}
        onSubmit={async (values) => {
          await mutateAsync(values);
          refetch();
          await queryClient.refetchQueries(['appointments'])
        }}
      >
        {({ handleChange, values, handleSubmit }) => (
          <form onSubmit={handleSubmit}>
            <HStack justify='stretch'>
              <Text as="span" fontWeight="semibold">
                Slot:
              </Text>
              <Spacer />
              <Select
                size="xs"
                onChange={handleChange}
                value={values.slot}
                name="slot"
              >
                <option value="morning">Morning</option>
                <option value="afternoon">Afternoon</option>
                <option value="evening">Evening</option>
              </Select>
            </HStack>
            <HStack mt="2" justify='space-between'>
              <Text as="span" fontWeight="semibold">
                Status:
              </Text>
              <Spacer />
              <Select
                size="xs"
                onChange={handleChange}
                value={values.status}
                name="status"
              >
                <option value="Could not Connect">Could not Connect</option>
                <option value="Payment Pending">Payment Pending</option>
                <option value="Confirmed">Confirmed</option>
              </Select>
            </HStack>
            <Button mt='4' size='sm' type='submit' >Submit</Button>
          </form>
        )}
      </Formik>
    </Stack>
  );
};
