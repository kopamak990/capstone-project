# Launch Template
resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress-launch-template"
  image_id      = "ami-03c3351e3ce9d04eb"
  instance_type = "t3.micro"
  key_name      = var.key_name

  user_data = base64encode(<<-EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo yum install -y mariadb105-server php php-mysqlnd unzip

sudo systemctl start httpd
sudo systemctl enable httpd

sudo systemctl start mariadb
sudo systemctl enable mariadb

cd /var/www/html
sudo wget http://wordpress.org/latest.tar.gz
sudo tar -zxvf latest.tar.gz 
sudo cp -rvf wordpress/* . 
sudo rm -R wordpress 
sudo rm latest.tar.gz

sudo mysqladmin -u root password '${var.db_root_password}'

sudo cp ./wp-config-sample.php ./wp-config.php
sudo sed -i "s/'database_name_here'/'kolade_wordpress_db'/g" wp-config.php 
sudo sed -i "s/'username_here'/'${var.wp_db_user}'/g" wp-config.php 
sudo sed -i "s/'password_here'/'${var.wp_db_password}'/g" wp-config.php

sudo usermod -a -G apache ec2-user 
sudo chown -R ec2-user:apache /var/www 
sudo chmod 2775 /var/www 
sudo find /var/www -type d -exec chmod 2775 {} \; 
sudo find /var/www -type f -exec chmod 0664 {} \; 

echo "CREATE DATABASE kolade_wordpress_db;" >> /tmp/db.setup 
echo "CREATE USER '${var.wp_db_user}'@'localhost' IDENTIFIED BY '${var.wp_db_password}';" >> /tmp/db.setup 
echo "GRANT ALL ON kolade_wordpress_db.* TO '${var.wp_db_user}'@'localhost';" >> /tmp/db.setup 
echo "FLUSH PRIVILEGES;" >> /tmp/db.setup 
sudo mysql -u root --password=${var.db_root_password} < /tmp/db.setup
sudo rm /tmp/db.setup

# Configure WordPress to use RDS database
cat << WP_EOF | sudo tee -a /var/www/html/wp-config.php
define('DB_NAME', 'kolade_wordpress_db');
define('DB_USER', '${var.wp_db_user}');
define('DB_PASSWORD', '${var.wp_db_password}');
define('DB_HOST', '${var.rds_endpoint}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
WP_EOF

# Restart Apache
sudo systemctl restart httpd
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "wordpress-launch-template" }
  }
}
