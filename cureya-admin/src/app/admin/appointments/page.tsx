'use client'

import InfoHead from '@/app/(shared)/components/InfoHead'
import { Box } from '@chakra-ui/react'
import React from 'react'
import AppointmentList from './components/AppointmentList'

export default function AppointmentsPage() {
  return (
    <Box>
      <InfoHead title='Appointments' desc='Manage Appointments' />
      <AppointmentList/>
    </Box>
  )
}
