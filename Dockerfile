FROM hwdsl2/ipsec-vpn-server

RUN apk update && apk add \
  iputils \
  iproute2

CMD ["bash"]
