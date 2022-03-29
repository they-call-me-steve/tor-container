FROM alpine:3.13.5 as builder
LABEL MAINTAINER "Stephen Hunter" <steve@the-steve.com>
RUN apk --update upgrade && \
    apk add tor && \
    mkdir -p /var/lib/tor

FROM scratch
LABEL MAINTAINER "Stephen Hunter" <steve@the-steve.com>
COPY --from=builder /usr/bin/tor /bin/
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/libssl.so.1.1 /lib/libcrypto.so.1.1 /usr/lib/libevent-2.1.so.7 /usr/lib/liblzma.so.5 /usr/lib/libzstd.so.1 /lib/
COPY --from=builder /lib/libz.so.1.2.11 /lib/libz.so.1
COPY --from=builder /etc/tor /etc/tor
COPY --from=builder /var/lib/tor /var/lib/tor
COPY --from=builder /var/lib/tor /var/log/tor
ENV PATH=/bin/
EXPOSE 9050/tcp
ENTRYPOINT ["tor"]
