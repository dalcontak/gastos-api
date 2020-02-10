FROM oracle/graalvm-ce:19.3.1-java8 as graalvm
#FROM oracle/graalvm-ce:19.3.1-java11 as graalvm # For JDK 11
RUN gu install native-image

COPY . /home/app/gastos-api
WORKDIR /home/app/gastos-api

RUN native-image --no-server --static -cp build/libs/gastos-api-*-all.jar

FROM scratch
EXPOSE 8080
COPY --from=graalvm /home/app/gastos-api/gastos-api /app/gastos-api
ENTRYPOINT ["/app/gastos-api", "-Djava.library.path=/app"]
