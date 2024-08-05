# Use a imagem base do Node.js
FROM node:18-bullseye

# Crie um diretório de trabalho
WORKDIR /usr/src/app

# Copie os arquivos de configuração
COPY package*.json ./

# Instale as dependências
RUN npm install

# Copie o restante do código da aplicação
COPY . .

ARG DB_HOST
ARG DB_PORT
ARG DB_USER
ARG DB_PASSWORD
ARG DB_NAME
RUN sed -i "s/host: '127.0.0.1'/host: '$DB_HOST'/" knexfile.ts && \
    sed -i "s/port: 3306/port: $DB_PORT/" knexfile.ts && \
    sed -i "s/user: 'overlayAdmin'/user: '$DB_USER'/" knexfile.ts && \
    sed -i "s/password: 'overlay123'/password: '$DB_PASSWORD'/" knexfile.ts && \
    sed -i "s/database: 'overlay'/database: '$DB_NAME'/" knexfile.ts
RUN mv entrypoint.sh /entrypoint.sh && chmod +x /entrypoint.sh

# Exponha a porta que a aplicação usa
EXPOSE 8080
RUN apt -y update && apt -y install nano net-tools
# Comando para rodar a aplicação
ENTRYPOINT /entrypoint.sh
