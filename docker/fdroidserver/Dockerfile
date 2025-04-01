FROM 9lukas5/fdroidserver:3.0.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["fdroid"]
CMD ["--help"]
