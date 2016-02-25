FROM fedora:23
RUN dnf install -y jq
RUN dnf clean all
COPY scripts/* /assets/
RUN chmod +x /assets/*.sh
CMD ["/assets/configure.sh"]
