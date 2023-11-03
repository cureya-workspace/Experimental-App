"use client";

import {
  Button,
  Checkbox,
  Flex,
  Text,
  FormControl,
  FormLabel,
  Heading,
  Input,
  Stack,
  Image,
  FormErrorMessage,
  useToast,
  Spinner,
} from "@chakra-ui/react";
import BGImage from "../../../assets/cc8.png";
import { useMutation } from "react-query";
import { preparedFetchRequest } from "../(shared)/helpers/fetch_helper";
import { Formik } from "formik";
import * as Yup from "yup";
import { useRouter } from "next/navigation";

export default function LoginScreen() {
  const toast = useToast();
  const router = useRouter();

  const { mutate, data, isLoading } = useMutation({
    mutationFn: preparedFetchRequest({
      url: "http://localhost:3000/api/v1/auth/login",
      includeCredentials: true,
      method: "POST",
    }),
    onSuccess(data, variables, context) {
      router.replace("/admin");
    },
    onError(error: any, variables, context) {
      toast({
        status: "error",
        title: "Error",
        description: error.message,
      });
    },
  });

  return (
    <Stack minH={"100vh"} direction={{ base: "column", md: "row" }}>
      <Flex p={8} flex={1} align={"center"} justify={"center"}>
        <Stack spacing={4} w={"full"} maxW={"md"}>
          <Heading fontSize={"3xl"}>
            Sign in as{" "}
            <Text
              bgGradient="linear(to-l, green.300, green.500)"
              bgClip="text"
              as="span"
            >
              {" "}
              Administrator{" "}
            </Text>
          </Heading>
          <Formik
            initialValues={{
              email: "",
              password: "",
              role: 0,
            }}
            validationSchema={Yup.object().shape({
              email: Yup.string().email().required(),
              password: Yup.string().max(20).min(6).required(),
            })}
            onSubmit={(data) => {
              mutate(data);
            }}
          >
            {({ values, errors, handleSubmit, touched, handleChange }) => (
              <form onSubmit={handleSubmit}>
                <FormControl
                  id="email"
                  isInvalid={!!(errors.email && touched.email)}
                >
                  <FormLabel>Email address</FormLabel>
                  <Input
                    name="email"
                    value={values.email}
                    onChange={handleChange}
                    type="email"
                  />
                  {errors.email ? (
                    <FormErrorMessage>{errors.email}</FormErrorMessage>
                  ) : null}
                </FormControl>
                <FormControl
                  id="password"
                  isInvalid={!!(errors.password && touched.password)}
                >
                  <FormLabel>Password</FormLabel>
                  <Input
                    name="password"
                    value={values.password}
                    onChange={handleChange}
                    type="password"
                  />
                  {errors.password ? (
                    <FormErrorMessage>{errors.password}</FormErrorMessage>
                  ) : null}
                </FormControl>
                <Stack spacing={6}>
                  <Stack
                    direction={{ base: "column", sm: "row" }}
                    align={"start"}
                    justify={"space-between"}
                  >
                    <Checkbox>Remember me</Checkbox>
                    <Text color={"blue.500"}>Forgot password?</Text>
                  </Stack>
                  <Button
                    type="submit"
                    isDisabled={isLoading}
                    colorScheme={"blue"}
                    variant={"solid"}
                  >
                    {isLoading ? <Spinner /> : null} Sign in
                  </Button>
                </Stack>
              </form>
            )}
          </Formik>
        </Stack>
      </Flex>
      <Flex flex={1}>
        <Image alt={"Login Image"} objectFit={"cover"} src={BGImage.src} />
      </Flex>
    </Stack>
  );
}
