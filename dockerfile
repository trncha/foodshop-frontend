# ขั้นตอนที่ 1: Build ระยะเวลา
# ใช้ Node.js 18 ที่เป็น official image จาก Docker Hub
FROM node:18-alpine as build

# ตั้งค่า working directory ใน container
WORKDIR /app

# คัดลอก package.json และ package-lock.json (หรือ yarn.lock ถ้าใช้ yarn)
COPY package*.json ./

# ติดตั้ง dependencies
RUN npm install

# คัดลอกทุกไฟล์จาก project ไปยัง working directory ใน container
COPY . .

COPY .env.production .env
# Build แอพพลิเคชันสำหรับ production
RUN npm run build

# ขั้นตอนที่ 2: Serve ระยะเวลา
# ใช้ Nginx สำหรับ serving ไฟล์ static
FROM nginx:stable-alpine as production

# คัดลอกไฟล์ static จาก build stage
COPY --from=build /app/dist /usr/share/nginx/html

# ตั้งค่า port
EXPOSE 80

# เริ่มต้น Nginx และ serve content
CMD ["nginx", "-g", "daemon off;"]
