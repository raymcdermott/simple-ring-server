FROM clojure

WORKDIR /app

COPY project.clj /app

RUN lein deps

COPY src /app/src

EXPOSE 8080

VOLUME /hyperledger/network

CMD ["lein","run"]