FROM ubuntu:latest
ENV debian_frontend noninteractive
RUN apt-get update && apt-get install -y curl unzip less
WORKDIR /tmp
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip"; \
    unzip awscliv2.zip; \
    ./aws/install
RUN \
    arch=$(if [ "$(uname -m)" = "aarch64" ];then echo "arm64"; else $(uname -m); fi); \
    curl -O https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_${arch}/amazon-ssm-agent.deb; \
    dpkg -i amazon-ssm-agent.deb
RUN mkdir -vp /var/lib/amazon/ssm
WORKDIR /work
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["bash"]
