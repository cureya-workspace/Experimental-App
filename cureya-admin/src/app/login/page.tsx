'use client'

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
} from '@chakra-ui/react'
import BGImage from '../../../assets/cc8.png';
import { useMutation } from 'react-query';

export default function LoginScreen() {

  const {} = useMutation({
    
  });

  return (
    <Stack minH={'100vh'} direction={{ base: 'column', md: 'row' }}>
      <Flex p={8} flex={1} align={'center'} justify={'center'}>
        <Stack spacing={4} w={'full'} maxW={'md'}>
          <Heading fontSize={'3xl'}>Sign in as <Text bgGradient='linear(to-l, green.300, green.500)' bgClip='text' as='span'> Administrator </Text></Heading>
          <FormControl id="email">
            <FormLabel>Email address</FormLabel>
            <Input type="email" />
          </FormControl>
          <FormControl id="password">
            <FormLabel>Password</FormLabel>
            <Input type="password" />
          </FormControl>
          <Stack spacing={6}>
            <Stack
              direction={{ base: 'column', sm: 'row' }}
              align={'start'}
              justify={'space-between'}>
              <Checkbox>Remember me</Checkbox>
              <Text color={'blue.500'}>Forgot password?</Text>
            </Stack>
            <Button colorScheme={'blue'} variant={'solid'}>
              Sign in
            </Button>
          </Stack>
        </Stack>
      </Flex>
      <Flex flex={1}>
        <Image
          alt={'Login Image'}
          objectFit={'cover'}
          src={BGImage.src}
        />
      </Flex>
    </Stack>
  )
}