# Pakai official Node.js 18 image sebagai base
FROM node:18

# Set working directory di container
WORKDIR /app

# Salin file package.json dan package-lock.json (kalau ada)
COPY package*.json ./

# Install dependencies
RUN npm install

# Salin seluruh source code ke dalam container
COPY . .

# Expose port default Docusaurus
EXPOSE 3000

# Jalankan Docusaurus dengan binding ke 0.0.0.0 supaya bisa diakses dari luar container
CMD ["npm", "start", "--", "--host", "0.0.0.0"]
