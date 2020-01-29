FROM oracle/graalvm-ce:19.3.0-java8 as graalvm
#FROM oracle/graalvm-ce:19.3.0-java11 as graalvm # For JDK 11
COPY . /home/app/gastos-api
WORKDIR /home/app/gastos-api
RUN gu install native-image
RUN native-image --no-server --static -cp build/libs/gastos-api-*-all.jar

FROM frolvlad/alpine-glibc
EXPOSE 8080
COPY --from=graalvm /home/app/gastos-api/gastos-api /app/gastos-api
ENTRYPOINT ["/app/gastos-api", "-Djava.library.path=/app"]
