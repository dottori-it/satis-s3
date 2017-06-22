FROM composer/satis

RUN apk add --update \
    python \
    py-pip \
  && pip install awscli \
  && rm -rf /var/cache/apk/*

RUN mkdir ~/.ssh \
  && ssh-keyscan -H bitbucket.org >> /root/.ssh/known_hosts \
  && ssh-keyscan -H github.com >> /root/.ssh/known_hosts 

ADD run.sh /satis/run.sh

ENTRYPOINT ["/bin/sh", "/satis/run.sh"]