FROM kameshsampath/ow-scf-base

ENV RUN_SCRIPT=run-java.app.sh

ADD ./contrib/bin/run-java.app.sh /deployments/run-java.sh

USER root

RUN chown -R 1001 /deployments && \
    chmod 755 /deployments/run-java.sh

USER user
