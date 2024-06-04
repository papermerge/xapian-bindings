#!/bin/bash
set -e -u -x

PREFIX=/venv
XAPIAN_CONFIG=/venv/bin/xapian-config

mkdir -p tmp/src
curl -SL http://oligarchy.co.uk/xapian/${XAPIAN_VERSION}/xapian-bindings-${XAPIAN_VERSION}.tar.xz \
    | tar -xJC /tmp/src

case $PYVER in
  3.11)
    PYBIN=/opt/python/cp311-cp311/bin
    PYSITE=/opt/python/cp311-cp311/lib/python3.11/site-packages/
    ;;
  3.10)
    PYBIN=/opt/python/cp310-cp310/bin
    PYSITE=/opt/python/cp310-cp310/lib/python3.10/site-packages/
    ;;
  3.9)
    PYBIN=/opt/python/cp39-cp39/bin
    PYSITE=/opt/python/cp39-cp39/lib/python3.10/site-packages/
    ;;
  3.8)
    PYBIN=/opt/python/cp38-cp38/bin
    PYSITE=/opt/python/cp38-cp38/lib/python3.10/site-packages/
    ;;
  3.7)
    PYBIN=/opt/python/cp37-cp37m/bin
    PYSITE=/opt/python/cp37-cp37m/lib/python3.10/site-packages/
    ;;
esac

echo $PYBIN
echo $PYSITE

export PATH="${PYBIN}:$PATH"

${PYBIN}/pip install sphinx

/tmp/src/xapian-bindings-${XAPIAN_VERSION}/configure \
    --prefix=${PREFIX} \
    --with-python3  \
    && make \
    && make install

cp ${PYSITE}/xapian/*.so /app/xapian/
cp ${PYSITE}/xapian/*.py /app/xapian/

TODAY=$(date +"%y%m%d%H%m")
echo "__version__ = '${XAPIAN_VERSION}.post${TODAY}'" > /app/xapian/bindings.py

python setup.py bdist_wheel
auditwheel repair dist/*.whl
