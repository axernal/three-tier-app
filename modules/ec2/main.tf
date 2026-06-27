locals {
  backend_private_ip = aws_instance.backend.private_ip
}

# Frontend EC2 instance (Availability Zone 1)
resource "aws_instance" "frontend_1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.app_public_subnet_az1_id
  vpc_security_group_ids = [var.frontend_sg_id]
  key_name               = var.key_name

  user_data = <<-EOF
#!/bin/bash

exec > /var/log/user-data.log 2>&1

apt-get update -y
apt-get install -y nginx

cat <<'HTML' > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Todo App</title>
<style>
body {
  font-family: Arial;
  max-width: 600px;
  margin: 40px auto;
}
input {
  width: 70%;
  padding: 8px;
}
button {
  padding: 8px;
}
li {
  margin: 10px 0;
}
</style>
</head>
<body>

<h1>Todo Application - Frontend Server 1</h1>

<input id="task" placeholder="Enter task">
<button onclick="addTask()">Add</button>

<ul id="todoList"></ul>

<script>

const API="/api";

async function loadTasks(){

  const response = await fetch(API + "/todos");

  const data = await response.json();

  let html="";

  data.forEach(todo=>{

    html += `
      <li>
        $${todo.task}
        <button onclick="deleteTask($${todo.id})">
          Delete
        </button>
      </li>
    `;
  });

  document.getElementById("todoList").innerHTML=html;
}

async function addTask(){

  const task=document.getElementById("task").value;

  await fetch(API + "/todos",{
    method:"POST",
    headers:{
      "Content-Type":"application/json"
    },
    body:JSON.stringify({
      task:task
    })
  });

  document.getElementById("task").value="";

  loadTasks();
}

async function deleteTask(id){

  await fetch(API + "/todos/" + id,{
    method:"DELETE"
  });

  loadTasks();
}

loadTasks();

</script>

</body>
</html>
HTML
cat <<NGINX > /etc/nginx/sites-available/default
server {

    listen 80;

    location / {
        root /var/www/html;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    location /api/ {
    rewrite ^/api/(.*)$ /$1 break;

    proxy_pass http://${local.backend_private_ip}:3000;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
}
NGINX
systemctl enable nginx
systemctl restart nginx
EOF

  tags = {
    Name = "${var.environment}-frontend-server-1"
  }
}

# Frontend EC2 instance (Availability Zone 2)
resource "aws_instance" "frontend_2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.app_public_subnet_az2_id
  vpc_security_group_ids = [var.frontend_sg_id]
  key_name               = var.key_name

  user_data = <<-EOF
#!/bin/bash

exec > /var/log/user-data.log 2>&1

apt-get update -y
apt-get install -y nginx

cat <<'HTML' > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Todo App</title>
<style>
body {
  font-family: Arial;
  max-width: 600px;
  margin: 40px auto;
}
input {
  width: 70%;
  padding: 8px;
}
button {
  padding: 8px;
}
li {
  margin: 10px 0;
}
</style>
</head>
<body>

<h1>Todo Application - Frontend Server 2</h1>

<input id="task" placeholder="Enter task">
<button onclick="addTask()">Add</button>

<ul id="todoList"></ul>

<script>

const API="/api";

async function loadTasks(){

  const response = await fetch(API + "/todos");

  const data = await response.json();

  let html="";

  data.forEach(todo=>{

    html += `
      <li>
        $${todo.task}
        <button onclick="deleteTask($${todo.id})">
          Delete
        </button>
      </li>
    `;
  });

  document.getElementById("todoList").innerHTML=html;
}

async function addTask(){

  const task=document.getElementById("task").value;

  await fetch(API + "/todos",{
    method:"POST",
    headers:{
      "Content-Type":"application/json"
    },
    body:JSON.stringify({
      task:task
    })
  });

  document.getElementById("task").value="";

  loadTasks();
}

async function deleteTask(id){

  await fetch(API + "/todos/" + id,{
    method:"DELETE"
  });

  loadTasks();
}

loadTasks();

</script>

</body>
</html>
HTML
cat <<NGINX > /etc/nginx/sites-available/default
server {

    listen 80;

    location / {
        root /var/www/html;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    location /api/ {
    rewrite ^/api/(.*)$ /$1 break;

    proxy_pass http://${local.backend_private_ip}:3000;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
NGINX
systemctl enable nginx
systemctl restart nginx
EOF

  tags = {
    Name = "${var.environment}-frontend-server-2"
  }
}

# Bastion host EC2 instance (public subnet for secure admin access)
resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.backend_public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name               = var.key_name

  tags = {
    Name = "${var.environment}-bastion-host"
  }
}

# Backend EC2 instance (application server connecting to RDS)
resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.backend_private_subnet_id
  vpc_security_group_ids = [var.backend_sg_id]
  key_name               = var.key_name

  user_data = <<-EOF
#!/bin/bash

apt update -y

apt install -y nodejs npm mysql-client

mkdir -p /opt/backend

cat <<'APP' > /opt/backend/app.js
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();

app.use(express.json());
app.use(cors());

const db = mysql.createConnection({
    host: '${var.rds_endpoint}',
    user: '${var.db_username}',
    password: '${var.db_password}',
    database: '${var.db_name}'
});

db.connect((err) => {

    if(err){
        console.log(err);
        return;
    }

    console.log("Database Connected");

    db.query(`
        CREATE TABLE IF NOT EXISTS todos(
            id INT AUTO_INCREMENT PRIMARY KEY,
            task VARCHAR(255) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    `);
});



app.get('/todos',(req,res)=>{

    db.query(
        'SELECT * FROM todos ORDER BY id DESC',
        (err,rows)=>{

            if(err){
                return res.status(500).json(err);
            }

            res.json(rows);
        }
    );
});

app.post('/todos',(req,res)=>{

    const task = req.body.task;

    db.query(
        'INSERT INTO todos(task) VALUES(?)',
        [task],
        (err)=>{

            if(err){
                return res.status(500).json(err);
            }

            res.json({
                message:'Task Added'
            });
        }
    );
});

app.delete('/todos/:id',(req,res)=>{

    db.query(
        'DELETE FROM todos WHERE id=?',
        [req.params.id],
        (err)=>{

            if(err){
                return res.status(500).json(err);
            }

            res.json({
                message:'Task Deleted'
            });
        }
    );
});

app.listen(3000,'0.0.0.0',()=>{
    console.log('Server running on port 3000');
});
APP

cd /opt/backend

npm init -y

npm install express mysql2 cors

cat <<ENV > /opt/backend/.env
DB_HOST=${var.rds_endpoint}
DB_USER=${var.db_username}
DB_PASSWORD=${var.db_password}
DB_NAME=${var.db_name}
ENV

export DB_HOST=${var.rds_endpoint}
export DB_USER=${var.db_username}
export DB_PASSWORD=${var.db_password}
export DB_NAME=${var.db_name}
nohup node /opt/backend/app.js > /opt/backend/app.log 2>&1 &
EOF

  tags = {
    Name = "${var.environment}-backend-server"
  }
}