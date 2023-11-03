import { Box, Divider, Heading, Text, useColorModeValue } from "@chakra-ui/react";

export default function InfoHead({
  title,
  desc,
  showDivider,
}: {
  title: string;
  desc?: string;
  showDivider?: boolean;
}) {
  return (
    <Box>
      <Heading color={useColorModeValue('gray.700', 'white')}
        fontSize={'2xl'}
        fontFamily={'body'}>
        {title}
      </Heading>
      <Text fontWeight="thin" fontSize="sm">
        {desc}
      </Text>
      {showDivider === false ? null : <Divider my="2" mb="4" />}
    </Box>
  );
}