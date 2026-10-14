/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Schibsted Grotesk', 'system-ui', 'sans-serif'],
        display: ['Schibsted Grotesk', 'system-ui', 'sans-serif'],
      },
      colors: {
        stage: {
          bg: '#141517',
          surface: '#1E2024',
          lift: '#282B31',
          ink: '#F7F7F8',
          muted: '#8E929B',
          accent: '#D72626',
          blue: '#2563EB',
        }
      }
    },
  },
  plugins: [],
}
