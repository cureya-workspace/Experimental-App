import { preparedFetchRequest } from "@/app/(shared)/helpers/fetch_helper";
import {
  Badge,
  Box,
  Button,
  Center,
  Skeleton,
  Spacer,
  Stack,
  StackDivider,
  Text,
  useColorModeValue,
  useDisclosure,
} from "@chakra-ui/react";
import React, { useState } from "react";
import { useInfiniteQuery } from "react-query";
import AppointmentDetailSidebar from "./AppointmentDetailSidebar";

export default function AppointmentList() {
  const [appointmentId, setAppointmentId] = useState<string | null>(null);
  const { isOpen, onOpen, onClose } = useDisclosure();
  const btnRef = React.useRef();

  const [page, setPage] = useState(1);
  const { data, isLoading } = useInfiniteQuery({
    queryKey: ["appointments"],
    queryFn: () => {
      return preparedFetchRequest({
        url: `http://localhost:3000/api/v1/appointment`,
        method: "GET",
        headers: {},
        includeCredentials: true,
      })();
    },
    getNextPageParam: (lastPage) => {
      return lastPage.paging.next;
    },
    getPreviousPageParam: (page) => page.paging.previous,
  });

  return (
    <>
     { appointmentId ? <AppointmentDetailSidebar
        appointmentId={appointmentId!}
        btnRef={btnRef}
        onClose={onClose}
        onOpen={onOpen}
        isOpen={isOpen}
      /> : null } 
      <Box
        borderRadius="md"
        bgColor={useColorModeValue("white", "whiteAlpha.50")}
        borderWidth="1px"
      >
        <Stack p={2} direction="column" divider={<StackDivider />}>
          {isLoading ? (
            <Stack>
              <Skeleton height="50px" />
              <Skeleton height="50px" />
              <Skeleton height="50px" />
              <Skeleton height="50px" />
              <Skeleton height="50px" />
              <Skeleton height="50px" />
              <Skeleton height="50px" />
              <Skeleton height="50px" />
              <Skeleton height="50px" />
              <Skeleton height="50px" />
            </Stack>
          ) : null}
          {data?.pages[0].data.length === 0 ? (
            <Center p="3">
              <Badge colorScheme="blue">No Appointments</Badge>
            </Center>
          ) : null}
          {data?.pages[page - 1].data.map((e: any, i: number) => (
            <Stack direction="row" justify="space-between" key={i}>
              <Box>
                <Text fontWeight="semibold">
                  {e.diagnostic_centre.name}, {e.diagnostic_centre.city}
                </Text>
                <Text mt="1" fontSize="smaller">
                  User: {e.user.first_name} {e.user.last_name} [{e.user.phone}]
                </Text>
                <Text fontSize="smaller">Slot: {e.slot}</Text>
              </Box>
              <Spacer />
              <Box>
                <Badge p="1" px="2" borderRadius="md">
                  {e.status}
                </Badge>
                <Button
                  size="xs"
                  onClick={() => {
                    setAppointmentId(e.id);
                    onOpen();
                  }}
                  colorScheme="blue"
                  m="2"
                >
                  Options
                </Button>
              </Box>
            </Stack>
          ))}
        </Stack>
      </Box>
    </>
  );
}
