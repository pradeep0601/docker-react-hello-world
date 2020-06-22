# pull official base image
FROM node:latest as builder

# set working directory
WORKDIR /app

# copy source code to the container
COPY . ./

# install dependenices
RUN yarn

# create build
RUN yarn build

# expose port 3000
EXPOSE 3000

# run the app
CMD ["yarn", "start"]

