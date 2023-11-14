/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {
      colors: {
        primary: {
          100: '#004346',
          200: '#172a3a'
        },
        secondary: {
          100: '#75dddd',
          200: '#508991',
          300: '#09bc8a'
        }
      },
      fontFamily: {
        primary: ['Instrument Sans'],
        secondary: ['Darker Grotesque']
      }
    }
  },
  plugins: []
};