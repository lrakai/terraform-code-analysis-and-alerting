# terraform-code-analysis-and-alerting

Demo of using code analysis and alerting for infrastructure as code (Terraform) in a CI/CD pipeline (Jenkins)

![Final environment](https://user-images.githubusercontent.com/3911650/39840823-f4718b7e-539d-11e8-9c01-96f2aa706b8d.png)

## Getting Started

Deploy the CloudFormation `infrastructure/cloudformation.json` template. The template creates a user with the following credentials and minimal required permisisons to complete the Lab:

- Username: _student_
- Password: _password_

## Instructions

1. In the Cloud9 environment, download the sample Terraform configuration files:

    ```sh
    wget https://github.com/cloudacademy/terraform-highly-available-website-on-aws/blob/master/config.zip?raw=true -O tf.zip
    unzip tf.zip -d tf
    ```

1. Run TFLint on the configuration files:

    ```sh
    docker run -v $(pwd):/tf --workdir=/tf --rm wata727/tflint:0.5.4 --error-with-issues
    ```

1. Create an Amazon SNS Topic and subscribe to it. Copy the Topic ARN for later.

1. Create a new Jenkins project that watches a Git repo at `git://localhost/lab.git` with `Poll SCM` enabled and the following execute shell build step:

    ```sh
    #!/bin/bash
    docker run -v $(pwd):/src --workdir=/src --rm wata727/tflint:0.5.4 --error-with-issues
    ```

1. Add a post-build action for Amazon SNS Notifier using the Topic ARN you copied earlier.

1. Clone the Jenkins server Git repo:

    ```sh
    cd ~/environment
    repo_url=$(aws ec2 describe-instances --filters "Name=tag:Type,Values=Build" --query "Reservations[0].Instances[0].PublicDnsName" \
            | sed 's/"\(.*\)"/git:\/\/\1\/lab.git/')
    git clone $repo_url src
    ```

1. Add, commit, and push the configuration files to the remote Git repo

1. Check your emails and inspect the build failure using the link in the email

## Cleaning Up

Delete the CloudFormation stack to remove all the resources used in the Lab.