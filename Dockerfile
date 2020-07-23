FROM    centos:7
###updating the packages

RUN yum -y update
###installing the apache packages
RUN yum install -y httpd

###installing some basic packages
RUN yum install -y lynx wget rsync vim bash-completion curl unzip net-tools

###Exporting the port to the externel
EXPOSE  8091
###Creating the new ssh user for accessing the application
RUN adduser test1
###Directory Environment for project
RUN mkdir -p /home/test1/{backup,public_html,logs,tmp}
###Sample test file for testing the environment
RUN touch /home/test1/public_html/index.html
###adding the content to the sample file
RUN echo "this site is working fine" > /home/test1/public_html/index.html
###changing the ownership of the directories
RUN chown -R test1:test1 /home/test1/*
###changing the permissions of the project directory
RUN chmod -R 755 /home/*
RUN chmod -R 775 /home/test1/*
##### custom apache port ##########################
 RUN sed -i 's/Listen 80/Listen 8091/g' /etc/httpd/conf/httpd.conf


####this is the virtual host configuration for the projects
RUN echo "<VirtualHost *:8091>" >> /etc/httpd/conf/httpd.conf
RUN echo "DocumentRoot /var/www/html" >> /etc/httpd/conf/httpd.conf
RUN echo "ServerName 172.105.51.125" >> /etc/httpd/conf/httpd.conf
RUN echo "</VirtualHost>" >> /etc/httpd/conf/httpd.conf
####################################################################################
###enabling the user home directory for the project
RUN sed -i 's/AllowOverride FileInfo AuthConfig Limit Indexes/#    AllowOverride FileInfo AuthConfig Limit Indexes/g' /etc/httpd/conf.d/userdir.conf
RUN sed -i 's/Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec/AllowOverride all/g' /etc/httpd/conf.d/userdir.conf
RUN sed -i 's/Require method GET POST OPTIONS/Require all granted/g' /etc/httpd/conf.d/userdir.conf
RUN sed -i 's/UserDir disabled/# UserDir disabled/g' /etc/httpd/conf.d/userdir.conf
RUN sed -i 's/#UserDir public_html/UserDir public_html/g' /etc/httpd/conf.d/userdir.conf
##################### test1.baryons.net ##########################
RUN touch /etc/httpd/conf.d/test1.conf
RUN echo "##### test1.baryons.net ###########" >> /etc/httpd/conf.d/test1.conf
RUN echo "<VirtualHost *:8091>" >> /etc/httpd/conf.d/test1.conf
RUN echo "       DocumentRoot    /home/test1/public_html" >> /etc/httpd/conf.d/test1.conf
RUN echo "       ServerName      test1.com" >> /etc/httpd/conf.d/test1.conf
RUN echo "       ErrorLog        /home/test1/logs/edflix-error_log" >> /etc/httpd/conf.d/test1.conf
RUN echo "       TransferLog     /home/test1/logs/edflix-access_log" >> /etc/httpd/conf.d/test1.conf
RUN echo "</VirtualHost>" >> /etc/httpd/conf.d/test1.conf
RUN echo "######################" >> /etc/httpd/conf.d/test1.conf
##########################################################################################
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]

