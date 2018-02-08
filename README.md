# Manuscripta webapp
eXist-db webapp for manuscripta.se

## Installation instructions

### Install Apache2 with mod_fastcgi

`sudo apt-get install apache2 libapache2-mod-fastcgi`

`sudo a2enmod fastcgi`

`sudo apache2ctl graceful`

### Install build essentials

`sudo apt-get install build-essential git autoconf automake libtool checkinstall pkg-config`

### Install IIP Image Server

Install memcached

`sudo apt-get install memcached libmemcached-dev`

Build IIP

`cd ~/`

`git clone https://github.com/ruven/iipsrv`

`cd iipsrv`

`sudo apt-get install libjpeg-dev libtiff-dev`

`sudo ./autogen.sh`

`sudo ./configure`

`sudo make`

`sudo mkdir /var/www/html/fcgi-bin`

`sudo cp src/iipsrv.fcgi /var/www/html/fcgi-bin/iipsrv.fcgi`

### Configure Apache for IIP

Add the following to /etc/apache2/apache2.conf

```
# Create a directory for the iipsrv binary
ScriptAlias /iipsrv/ "/var/www/html/fcgi-bin/"

# Set the options on that directory
<Directory "/iipsrv/">
   AllowOverride None
   Options None

# Syntax for access is different in Apache 2.4 - uncomment appropriate version
# Apache 2.2
#   Order allow,deny
#   Allow from all

# Apache 2.4
   Require all granted

</Directory>

# Set the module handler
AddHandler fastcgi-script fcg fcgi fpl

# Initialise some variables for the FCGI server
FastCgiServer /var/www/html/fcgi-bin/iipsrv.fcgi \
-initial-env LOGFILE=/tmp/iipsrv.log \
-initial-env VERBOSITY=2 \
-initial-env MAX_IMAGE_CACHE_SIZE=20 \
-initial-env JPEG_QUALITY=90 \
-initial-env MAX_CVT=5000
```

Restart Apache

`sudo service apache2 restart`


### Install Open JDK

`sudo apt-get install ant openjdk-8-jdk`

Set JAVA_HOME

`sudo nano /etc/environment`
Add: JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

Load variable

`source /etc/environment`

### Build eXist-db

Create directory for eXist-db

`sudo mkdir /usr/local/lib/exist`

Create directory for eXist database

`sudo mkdir /usr/local/lib/exist-data`

`sudo chown $USER:staff exist`
`sudo chown $USER:staff exist-data`

Clone eXist-db from GitHub

`cd /usr/local/lib/exist`

`git clone https://github.com/eXist-db/exist .`

`cp build/scripts/build-impl.xml build/scripts/build-impl.xml.backup`

`nano build/scripts/build-impl.xml`

Replace:
`<filter token="dataDir" value="webapp/WEB-INF/data"/>`

With:
`<filter token="dataDir" value="/usr/local/lib/exist-data"/>`

Build eXist-db

`./build.sh`

Edit conf.xml to preserve whitespace in mixed content

`sudo nano /usr/local/eXist/conf.xml`

Change `preserve-whitespace-mixed-content="no"` to `preserve-whitespace-mixed-content="yes"`in
```
<indexer caseSensitive="yes" index-depth="5" preserve-whitespace-mixed-content="yes" 
        stemming="no" suppress-whitespace="none"
        tokenizer="org.exist.storage.analysis.SimpleTokenizer" track-term-freq="yes">
```

Start eXist-db

`sudo service eXist-db start`


### Reverse proxy for eXist-db

`sudo a2enmod proxy proxy_http rewrite`

Add the following to /etc/apache2/apache2.conf

```
<VirtualHost *:80>
	ProxyRequests       off
	ServerName      www.manuscripta.se
	ServerAlias     manuscripta.se
	<Proxy>
	   Order deny,allow
	   Allow from all
	</Proxy>
	ProxyPass       /   http://localhost:8080/exist/apps/manuscripta/
	ProxyPassReverse    /   http://localhost:8080/exist/apps/manuscripta/
	ProxyPassReverseCookieDomain localhost manuscripta.se
	ProxyPassReverseCookiePath / /exist
	RewriteEngine       on
	RewriteRule   ^(.*)$ http://www.manuscripta.se/$1 [R=301,L]
	RewriteRule   ^\/?(.*)$     /$1   [PT]
</VirtualHost>
```

### Enable Jetty logginig through Apache web proxy

`nano /usr/local/lib/exist/tools/jetty/etc/jetty-requestlog.xml`

After:
`<Set name="LogTimeZone"><Property name="jetty.requestlog.timezone" deprecated="requestlog.timezone" default="GMT"/></Set>`

Add:
`<Set name="PreferProxiedForAddress">true</Set>`

Restart eXist-db

`sudo service eXist-db restart`
