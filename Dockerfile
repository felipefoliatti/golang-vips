FROM golang:1.11-alpine
WORKDIR /tmp

ENV LIBVIPS_VERSION=8.8.0

RUN apk update && \
    apk upgrade && \
    apk add \
    zlib libxml2 libxslt glib libexif lcms2 fftw ca-certificates curl git \
    giflib libpng libwebp orc tiff poppler-glib librsvg wget && \

    apk add --no-cache --virtual .build-dependencies autoconf automake build-base \
    libtool nasm zlib-dev libxml2-dev libxslt-dev glib-dev \
    libexif-dev lcms2-dev fftw-dev giflib-dev libpng-dev libwebp-dev orc-dev tiff-dev \
    poppler-dev librsvg-dev wget && \

# Install mozjpeg
    cd /tmp && \
    git clone git://github.com/mozilla/mozjpeg.git && \
    cd /tmp/mozjpeg && \
    git checkout 9a1d32095bb6d7c359c8eb8f8f116469197433aa && \
    autoreconf -fiv && ./configure --prefix=/usr && make install && \

# Install libvips
    wget -O- https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.gz | tar xzC /tmp/ && \
    cd /tmp/vips-${LIBVIPS_VERSION} && \
    ./configure --prefix=/usr \
                --without-python \
                --without-gsf \
                --enable-debug=no \
                --disable-dependency-tracking \
                --disable-static \
                --enable-silent-rules && \
    make -s install-strip && \

# Cleanup
    rm -rf /tmp/vips-${LIBVIPS_VERSION} && \
    rm -rf /tmp/mozjpeg && \
    rm -rf /var/cache/apk/*
