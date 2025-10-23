FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
ARG CHINA_MIRROR=false

RUN if [ "$CHINA_MIRROR" = "true" ] ; then \
        sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
        sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list ; \
    fi

COPY build_setup.sh /tmp/build_setup.sh
RUN apt update \
&& apt install -y --no-install-recommends wget ca-certificates gettext locales sudo zsh \
&& /bin/bash /tmp/build_setup.sh \
&& rm /tmp/build_setup.sh

ENV CLANGPDB_BIN=/usr/lib/llvm-38/bin/
ENV CLANGPDB_AARCH64_PREFIX=aarch64-linux-gnu-

RUN rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8
ENV LANG=en_US.utf8
WORKDIR /build

COPY pip-requirements.txt /tmp/pip-requirements.txt
RUN rm /usr/lib/python3.*/EXTERNALLY-MANAGED \
    && pip install --upgrade -r /tmp/pip-requirements.txt \
    && git config --global --add safe.directory '*'

CMD ["/bin/bash"]
