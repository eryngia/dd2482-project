FROM eclipse-temurin:17-jre

RUN groupadd --system app && useradd --system --gid app --no-create-home app
WORKDIR /app
COPY --chown=app:app target/*.jar app.jar
USER app

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD curl -fs http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]