resource "aws_ecs_cluster" "ecs" {
    name = "app_cluster_test"
}

resource "aws_ecs_service" "service_test"{
    name = "app_service_test"
    cluster = aws_ecs_cluster.ecs.arn
    launch_type = "FARGATE"
    enable_execute_command = true

    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 100
    desired_count = 1
    task_definition = aws_ecs_task_definition.tdv3.arn

    network_configuration {
        assign_public_ip = true
        security_groups = [aws_security_group.sg.id]
        subnets = [aws_subnet.sn1.id]

    }

    
}

resource "aws_ecs_task_definition" "tdv3" {
    container_definitions = jsonencode([
        {
            name = "appv3"
            image = "526222256299.dkr.ecr.ap-south-1.amazonaws.com/docker-nodejs-demo"
            cpu = 256
            memory = 512 
            essential = true
            portMapping = [
                {
                    containerPort = 3000
                    hostPort      = 80

                }
            ]
        }
    ])
    family = "appv3"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    network_mode = "awsvpc"
    task_role_arn = "arn:aws:iam::526222256299:role/ecsTaskExecutionRole"
    execution_role_arn = "arn:aws:iam::526222256299:role/ecsTaskExecutionRole"
}