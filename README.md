# Workforce Base Pre-Prod


## Overview



pingidentity-solutions-customers-wf-base-pre-prod is designed for pre-production customer environments in workforce use cases.


## Deploying using Docker-Compose



### 1. How to deploy the Workforce Base Pre-Prod solution stack:



> For your initial deployment of the stack, we recommend you make no changes to the **docker-compose.yaml** file to ensure you have a successful first-time deployment.

#### a. To start the stack, go to your local **Workforce Base Pre-Prod** directory and enter:

   `docker-compose up -d`



The full set of our DevOps images is automatically pulled from our repository, if you haven't already pulled the images from [Docker Hub](https://hub.docker.com/u/pingidentity/).



#### b. Use this command to display the logs as the stack starts:



`docker-compose logs -f`





Enter **Ctrl+C** to exit the display.





#### c. Use either of these commands to display the status of the Docker containers in the stack:





* `docker ps` (enter this at intervals)





* `watch "docker container ls --format 'table {{.Names}}\t{{.Status}}'"`





Refer to the [Docker Compose documentation](https://docs.docker.com/compose/) for more information.





Refer to the [Devops GitBook](https://pingidentity-devops.gitbook.io/devops/) for more information on using Ping Identity DevOps.





### 2. How to log in to the product management consoles:





#### Ping Data Console for PingDirectory





* Console URL: `https://localhost:8443/console`





* Server: `pingdirectory`





* User: `Administrator`





* Password: `2FederateM0re`





#### PingFederate





* Console URL: `https://localhost:9999/pingfederate/app`





* User: `Administrator`





* Password: `2FederateM0re`





#### Ping Data Console for DataSync





* Console URL: `https://localhost:8443/console`





* Server: `pingdatasync`





* User: `Administrator`





* Password: `2FederateM0re`





#### PingCentral





* Console URL: `https://localhost:9022`





* User: `Administrator`





* Password: `2Federate`





#### PingDelegator





* Console URL: `https://localhost:6443`





 * User: `Administrator`

  * Password: `2FederateM0re`


### 3. How to test a SAML application/connection:

- From the PingFederate home page, select **SP Connections**.

- Next, select the **Ping SAML Consumer**.

- Click on the **SSO Application Endpoint** hyperlink presented at the top portion of the screen.

- You will be redirected to a Sign On screen.

- Next, enter in sampleapptester for the username, followed by the sample password. The sample user(s) for specific use cases can be found within the PingDirectory Server Profile located at:

  `./server-profile/pingdirectory/pd.profile/ldif/userRoot/12-sampleusers.ldif`


- After logging in with the sample username and password, you will be brought to a webpage labeled **Assertion Validator**.

- You can now verify the SAML test was successful if a **Success** message is present.


### 4. How to test OAuth with a Sample User:

- Navigate to the following URL:

  `https://localhost:9031/OAuthPlayground`

  *(use `localhost` unless otherwise specified)*

- Select the **Submit** button at the bottom of the screen.


- You will then be redirected to a Sign On screen.

- Next, enter in a sample username, followed by the sample password. The sample users file can be found within the PingDirectory Server Profile located at:


  `./server-profile/pingdirectory/pd.profile/ldif/userRoot/20-sampleusers.ldif`


- You will then be redirected back to a similar screen. From here, click the **Submit** button once more.


- **TOKEN ENDPOINT** page will then be presented. If the OAuth request and response was valid, you will see a **Parsed Response** of **HTTP Status: 200 OK** on the top right of your screen.


### 5. How to view your sample users in PingDelegator:


- Navigate to the following URL:


  `https://localhost:6443`

    *(use `localhost` unless otherwise specified)*

- Log into the administrator account:

  Username: `Administrator`
  Password: `2FederateM0re`

- You will then be brought to a **Search Users** page.


- To view all users, click inside the **Search Users by...** text box.


- Hit the return (or Enter) key to display all users from PingDirectory.

### 6. For information on using Identity Adapters for specific use cases, see example application files in assets directory:

Complete list of adapters included:

- PingID SDK integration kit
- Ping IDaaS directory connector
- Office 365 Connector 2.2
- Google Apps Connector 3.1.1
- Salesforce Connector 7.0.1
- Slack Connector 3.0.2
- Box Connector 2.5
- Zoom Connector 1.0
- AWS Connector 2.0
- Agentless Integration Kit 1.5.2
- WebEx SSO Integration
- Atlassian Integration Kit

### 7. How to stop or remove the stack:

- To stop the running stack (does not remove any containers or associated Docker networks):

  `docker-compose stop`

- To stop the stack and remove all of the containers and associated Docker networks:

  `docker-compose down`

- To remove the persistent volumes (removing any configuration changes you may have done):

  `docker volume prune`
