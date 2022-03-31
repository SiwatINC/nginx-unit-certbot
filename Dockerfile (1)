FROM nginx/unit:1.26.1-minimal
ADD ./ /software
RUN apt update -y && apt install -y certbot
RUN mkdir -p /ssl/certbotroot
WORKDIR /software
RUN chmod +x /software/entrypoint.sh
CMD /software/entrypoint.sh
