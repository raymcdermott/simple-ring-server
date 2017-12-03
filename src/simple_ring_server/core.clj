(ns simple-ring-server.core
  (:use ring.adapter.jetty
        ring.middleware.file)
  (:require [environ.core :refer [env]]))

(defn handler [request]
  {:status  404
   :headers {"Content-Type" "text/plain"}})

(def app
  (wrap-file handler "/hyperledger/network" {:index-files? false}))

(defn start-server []
  (run-jetty app {:port (or (env :port) 8080) :join? false}))

(defn stop-server [server]
  (.stop server))


(defn -main
  "Entry point when using an Uberjar"
  [& args]
  (start-server))
