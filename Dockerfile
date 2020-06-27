FROM clearlinux/machine-learning-ui

ARG swupd_args
ARG PASSWORD

RUN swupd bundle-add php-extras wget git nodejs-basic \
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
    && mkdir -p /opt/jupyter-php/pkgs/vendor/litipk/jupyter-php/src/ \
    && ln -s /usr/lib/python3.8/site-packages/pkgs/vendor/litipk/jupyter-php/src/kernel.php /opt/jupyter-php/pkgs/vendor/litipk/jupyter-php/src/ \
    && pip install --upgrade jupyterlab-git \
    && jupyter-lab build --minimize=False \
    && rm -rf /var/lib/swupd/*

EXPOSE 8888

CMD ["jupyter-lab"]

COPY jupyter_notebook_config.py /etc/jupyter/
