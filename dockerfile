FROM alpine:3.16

EXPOSE 25

RUN apk add --no-cache bash postfix gpg-agent spamassassin spamassassin-client msmtp clamav make perl-app-cpanminus

COPY conf/main.cf /etc/postfix
COPY conf/local.cf /etc/mail/spamassassin
COPY conf/clamd.cf /etc/mail/spamassassin
COPY conf/clamav.pm /etc/mail/spamassassin
COPY run.sh run.sh

RUN cpanm --force File::Scan::ClamAV

RUN ["mkdir", "/run/clamav"]
RUN ["chown", "-R", "clamav:clamav", "/run/clamav"]

RUN ["chmod", "+x", "run.sh"]
ENTRYPOINT ["./run.sh"]