FROM php:7-apache

ARG COCKPIT_VERSION="next"

RUN apt-get update \
    && apt-get install -y \
    wget zip unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    sqlite3 libsqlite3-dev \
    libssl-dev \
    libzip-dev \
    && pecl install mongodb \
    && pecl install redis \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) iconv gd pdo zip opcache pdo_sqlite \
    && a2enmod rewrite expires

RUN echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini
RUN echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

RUN wget https://github.com/agentejo/cockpit/archive/${COCKPIT_VERSION}.zip -O /tmp/cockpit.zip; unzip /tmp/cockpit.zip -d /tmp/; rm /tmp/cockpit.zip
RUN mv /tmp/cockpit-${COCKPIT_VERSION}/.htaccess /var/www/html/.htaccess
RUN mv /tmp/cockpit-${COCKPIT_VERSION}/* /var/www/html/
RUN rm -R /tmp/cockpit-${COCKPIT_VERSION}/
RUN echo "\n\nphp_value post_max_size 256M" >> /var/www/html/.htaccess
RUN echo "\nphp_value  upload_max_filesize 256M" >> /var/www/html/.htaccess

RUN wget https://github.com/agentejo/LayoutComponents/archive/master.zip -O /tmp/LayoutComponents.zip; unzip /tmp/LayoutComponents.zip -d /tmp/; rm /tmp/LayoutComponents.zip
RUN mkdir -p /var/www/html/addons/LayoutComponents
RUN mv /tmp/LayoutComponents-master/* /var/www/html/addons/LayoutComponents/
RUN rm -R /tmp/LayoutComponents-master/

RUN wget https://github.com/agentejo/Detektivo/archive/master.zip -O /tmp/Detektivo.zip; unzip /tmp/Detektivo.zip -d /tmp/; rm /tmp/Detektivo.zip
RUN mkdir -p /var/www/html/addons/Detektivo
RUN mv /tmp/Detektivo-master/* /var/www/html/addons/Detektivo/
RUN rm -R /tmp/Detektivo-master/

RUN wget https://github.com/agentejo/Lokalize/archive/master.zip -O /tmp/Lokalize.zip; unzip /tmp/Lokalize.zip -d /tmp/; rm /tmp/Lokalize.zip
RUN mkdir -p /var/www/html/addons/Lokalize
RUN mv /tmp/Lokalize-master/* /var/www/html/addons/Lokalize/
RUN rm -R /tmp/Lokalize-master/

RUN wget https://github.com/fabien/cockpit_GROUPS/archive/master.zip -O /tmp/cockpit_GROUPS.zip; unzip /tmp/cockpit_GROUPS.zip -d /tmp/; rm /tmp/cockpit_GROUPS.zip
RUN mkdir -p /var/www/html/addons/Groups
RUN mv /tmp/cockpit_GROUPS-master/Groups/* /var/www/html/addons/Groups/
RUN rm -R /tmp/cockpit_GROUPS-master/

RUN wget https://github.com/serjoscha87/cockpit_GroupBoundAssets/archive/master.zip -O /tmp/cockpit_GroupBoundAssets.zip; unzip /tmp/cockpit_GroupBoundAssets.zip -d /tmp/; rm /tmp/cockpit_GroupBoundAssets.zip
RUN mkdir -p /var/www/html/addons/GroupBoundAssets
RUN mv /tmp/cockpit_GroupBoundAssets-master/GroupBoundAssets/* /var/www/html/addons/GroupBoundAssets/
RUN rm -R /tmp/cockpit_GroupBoundAssets-master/

RUN wget https://github.com/raffaelj/cockpit_WhiteLabel/archive/master.zip -O /tmp/cockpit_WhiteLabel.zip; unzip /tmp/cockpit_WhiteLabel.zip -d /tmp/; rm /tmp/cockpit_WhiteLabel.zip
RUN mkdir -p /var/www/html/addons/WhiteLabel
RUN mv /tmp/cockpit_WhiteLabel-master/* /var/www/html/addons/WhiteLabel/
RUN rm -R /tmp/cockpit_WhiteLabel-master/

RUN wget https://github.com/raffaelj/cockpit_rljUtils/archive/master.zip -O /tmp/cockpit_rljUtils.zip; unzip /tmp/cockpit_rljUtils.zip -d /tmp/; rm /tmp/cockpit_rljUtils.zip
RUN mkdir -p /var/www/html/addons/rljUtils
RUN mv /tmp/cockpit_rljUtils-master/* /var/www/html/addons/rljUtils/
RUN rm -R /tmp/cockpit_rljUtils-master/

RUN wget https://github.com/raffaelj/cockpit_UniqueSlugs/archive/master.zip -O /tmp/cockpit_UniqueSlugs.zip; unzip /tmp/cockpit_UniqueSlugs.zip -d /tmp/; rm /tmp/cockpit_UniqueSlugs.zip
RUN mkdir -p /var/www/html/addons/UniqueSlugs
RUN mv /tmp/cockpit_UniqueSlugs-master/* /var/www/html/addons/UniqueSlugs/
RUN rm -R /tmp/cockpit_UniqueSlugs-master/

RUN wget https://github.com/raffaelj/cockpit_SelectRequestOptions/archive/master.zip -O /tmp/cockpit_SelectRequestOptions.zip; unzip /tmp/cockpit_SelectRequestOptions.zip -d /tmp/; rm /tmp/cockpit_SelectRequestOptions.zip
RUN mkdir -p /var/www/html/addons/SelectRequestOptions
RUN mv /tmp/cockpit_SelectRequestOptions-master/* /var/www/html/addons/SelectRequestOptions/
RUN rm -R /tmp/cockpit_SelectRequestOptions-master/

COPY src /var/www/html/

RUN chown -R www-data:www-data /var/www/html

COPY ./entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint

VOLUME ["/var/www/html/storage"]

ENTRYPOINT ["entrypoint"]
CMD ["apache2-foreground"]
