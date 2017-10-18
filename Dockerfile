FROM centos:7

RUN yum install -y \
      gcc \
      lua-devel \
      ncurses-devel \
      perl-devel \
      perl-ExtUtils-Embed \
      python-devel \
      ruby-devel \
      @'Development Tools' && \
    yum clean all
