FROM gitlab/gitlab-ce:8.5.5-ce.0
RUN sudo apt-get install -y jq && sudo apt-get clean
COPY scripts/* /assets/
RUN chmod +x /assets/*.sh
RUN /bin/bash /assets/build-configure.sh
CMD ["/assets/run.sh"]
