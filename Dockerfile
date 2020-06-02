FROM clearlinux/machine-learning-ui

ARG swupd_args

RUN swupd bundle-add php-extras wget \
    && sh -c "echo 'precedence ::ffff:0:0/96 100' >> /etc/gai.conf" \
    && pip install bash_kernel \
    && python -m bash_kernel.install \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && mkdir  -p  /usr/local/bin \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && mkdir  -p /etc/php.d \
    && echo "extension=zmq.so" > /etc/php.d/zmq.ini \
    && wget https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar \
    && php ./jupyter-php-installer.phar install /usr/lib/python3.8/site-packages \
    && rm -rf /var/lib/swupd/*

EXPOSE 8888

CMD ["jupyter-notebook"]

COPY jupyter_notebook_config.py /etc/jupyter/
