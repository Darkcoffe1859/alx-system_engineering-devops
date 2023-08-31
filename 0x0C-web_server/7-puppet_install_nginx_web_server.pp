# 7-puppet_install_nginx_web_server.pp

# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Define Nginx configuration file
file { '/etc/nginx/sites-available/default':
  ensure  => present,
  content => "
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ =404;
    }

    location /redirect_me {
        return 301 http://example.com/new_url;
    }
}
",
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Ensure Nginx service is running and enabled
service { 'nginx':
  ensure    => running,
  enable    => true,
  require   => Package['nginx'],
  subscribe => File['/etc/nginx/sites-available/default'],
}

