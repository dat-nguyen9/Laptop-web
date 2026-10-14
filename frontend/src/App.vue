<template>
  <div class="min-h-[100svh] flex flex-col bg-stage-bg text-stage-ink font-sans selection:bg-stage-accent selection:text-white">
    <Navbar />
    <main class="flex-grow">
      <router-view />
    </main>
    <Footer />

    <!-- Global Floating Contact -->
    <FloatingContact />

    <!-- Global Toast Notification Container -->
    <ToastNotification />
  </div>
</template>

<script setup>
import Navbar from '@/components/Navbar.vue'
import Footer from '@/components/Footer.vue'
import FloatingContact from '@/components/FloatingContact.vue'
import ToastNotification from '@/components/ToastNotification.vue'
</script>
