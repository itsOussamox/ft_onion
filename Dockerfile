FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        nginx tor openssh-server \
    && rm -rf /var/lib/apt/lists/*

# A normal user for SSH (CHANGE THE PASSWORD)
RUN useradd -m -s /bin/bash onion && echo "onion:onion" | chpasswd

# sshd needs this directory to exist
RUN mkdir -p /run/sshd

COPY index.html  /var/www/html/index.html
COPY nginx.conf  /etc/nginx/nginx.conf
COPY sshd_config /etc/ssh/sshd_config
COPY torrc       /etc/tor/torrc
COPY start.sh    /start.sh
RUN chmod +x /start.sh

EXPOSE 80 4242
CMD ["/start.sh"]