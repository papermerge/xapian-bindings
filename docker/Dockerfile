ARG XAPIAN_VERSION
FROM papermerge/many-linux-with-xapian:${XAPIAN_VERSION}

ENV PREFIX=/venv
ENV XAPIAN_CONFIG=/venv/bin/xapian-config

COPY setup.py setup.cfg MANIFEST.in /app/
COPY scripts/build_wheel.sh  /build_wheel.sh
COPY xapian/ /app/xapian/

WORKDIR /app
