source /home/ec2-user/.bash_profile
cd /home/ec2-user/app
pm2 restart baseball
curl -X POST -d 'testNumber=7' http://ec2-54-237-158-152.compute-1.amazonaws.com:3000/api/run-test