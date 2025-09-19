#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Background the curl requests
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid &
wait

macid=$(cat /tmp/macid)
local_ipv4=$(cat /tmp/local_ipv4)
az=$(cat /tmp/az)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${macid}/vpc-id)
HOST_NAME=$(hostname -f)

# The shell will replace the variables like $local_ipv4 with the values we got from curl.
# Using a "heredoc" (here document) - a cleaner way to write multi-line text
# "cat << EOF" means "output everything until you see 'EOF' on its own line"
# This is easier to read than using echo with quotes, especially for HTML
# '/var/www/html/index.html' is the location of the html script on the new server
cat <<EOF > /var/www/html/index.html
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Details for EC2 instance</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>AWS Instance Details</h1>
        <h2>All done in Terraform with love and Diddy Oil.</h2>
        
        <p>I, Jaune Alcide, thank Suge WAF and My Senpais, For Teaching Me About EC2's in Aws. One Step Closer To Escaping Keisha!</p>
        <p><strong>With This Class, I Will Net >\$500,000 Per Year!</strong></p>

        <div class="image-gallery">
            <img class="content-image" src="https://i.redd.it/cxr15emq1jl51.jpg" alt="Japanese/Brazilian 1">
            <img class="content-image" src="https://preview.redd.it/do7ztf7zqq971.jpg?width=1080&crop=smart&auto=webp&s=3d3012bb4477c629775efc330bc86657d9a3b185" alt="Japanese/Brazilian 2">
        </div>

        <div class="instance-info">
            <p><b>Instance Name:</b> ${HOST_NAME}</p>
            <p><b>Instance Private Ip Address: </b> ${local_ipv4}</p>
            <p><b>Availability Zone: </b> ${az}</p>
            <p><b>Virtual Private Cloud (VPC):</b> ${vpc}</p>
        </div>

        <div class="button-container">
            <a href="https://media.distractify.com/brand-img/b6ZdwIUc-/2160x1131/dank-demoss-posing-1739314188846.jpg" target="_blank" class="repo-button">
                Don't want to read? Great, have this!
            </a>

        <a href="https://github.com/Jae1-alt/c7_250915_simple_ec2.git" target="_blank" class="repo-button">
            This project's GitHub Repo.
        </a>
    </div>
</body>
</html>
EOF

#Create the CSS file using another Heredoc
cat <<EOF > /var/www/html/style.css
body {
  font-family: sans-serif;
  background-image: url('https://wallpapercave.com/wp/wp9099115.jpg');
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center center;
  background-attachment: fixed;
  color: white;
  margin: 0;
  padding: 20px;


  min-height: 100vh; /* Make the body at least the full screen height */
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
  padding: 20px 0; /* Add padding top/bottom */
}

.container {
  max-width: 75%; /* CHANGED: Was 95%, now narrower */
  margin: 0 auto; /* Keep it centered horizontally */
  padding: 30px;
  text-align: center;
  border: 3px solid #3498db;
  border-radius: 15px;
  background-color: rgba(44, 62, 80, 0.85);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
}

h1 {
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
}

.image-gallery {
  display: flex;
  justify-content: center;
  flex-wrap: wrap; /* Allows images to wrap to the next line */
  gap: 20px;
  margin-top: 20px;
  margin-bottom: 20px;
}

.content-image {
  flex: 1 1 360px;  /* CHANGED: Base size increased from 300px to 360px (20% larger) */
  max-width: 420px; /* CHANGED: Max size increased from 350px to 420px (20% larger) */
  height: auto;
  border: 2px solid #ecf0f1;
  border-radius: 5px;
}

.instance-info {
  margin-top: 30px;
  text-align: left;
  display: inline-block;
}

.button-container {
    margin-top: 40px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 15px;
}

.repo-button {
  display: inline-block;
  padding: 15px 30px; /* CHANGED: Padding increased by ~25% for a larger button */
  font-size: 1.1em;   /* CHANGED: Font size increased slightly to match */
  background-image: linear-gradient(45deg, #3498db 0%, #8e44ad 100%);
  color: white;
  text-decoration: none;
  font-weight: bold;
  border-radius: 50px;
  border: none;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.4);
  transition: all 0.3s ease;
}

.repo-button:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.5);
}
EOF

# Clean up the temp files
rm -f /tmp/local_ipv4 /tmp/az /tmp/macid