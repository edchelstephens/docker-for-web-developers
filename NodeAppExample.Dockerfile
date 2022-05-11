FROM    node
LABEL   author="Edchel Stephen Nini"
COPY    . /var/www
WORKDIR     /var/www
RUN     npm install
EXPOSE 8080
ENTRYPOINT [ "node", "server.js" ]