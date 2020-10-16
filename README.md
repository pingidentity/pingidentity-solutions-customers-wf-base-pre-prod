# Workforce360 Solution

## Overview

TBD

## Deploying using Docker-Compose

1. Deploy the Workforce360 solution stack:

   > For your initial deployment of the stack, we recommend you make no changes to the `docker-compose.yaml` file to ensure you have a successful first-time deployment.

   a. To start the stack, go to your local `ping-celero/workforce360/` directory and enter:

   ```shell
   docker-compose up -d
   ```

   The full set of our DevOps images is automatically pulled from our repository, if you haven't already pulled the images from [Docker Hub](https://hub.docker.com/u/pingidentity/).

   b. Use this command to display the logs as the stack starts:

   ```shell
   docker-compose logs -f
   ```

   Enter `Ctrl+C` to exit the display.

   c. Use either of these commands to display the status of the Docker containers in the stack:

   * `docker ps` (enter this at intervals)
   * `watch "docker container ls --format 'table {{.Names}}\t{{.Status}}'"`

   Refer to the [Docker Compose documentation](https://docs.docker.com/compose/) for more information.

2. Log in to the management consoles for the products:

   * Ping Data Console for PingDirectory
     * Console URL: `https://localhost:8443/console`
     * Server: pingdirectory
     * User: Administrator
     * Password: 2FederateM0re

   * PingFederate
     * Console URL: `https://localhost:9999/pingfederate/app`
     * User: Administrator
     * Password: 2FederateM0re

   * Ping Data Console for DataGovernance
     * Console URL: `https://localhost:8443/console`
     * Server: pingdatagovernance
     * User: Administrator
     * Password: 2FederateM0re

   * PingCentral
     * Console URL: `https://localhost:9022`
     * User: Administrator
     * Password: 2Federate

   * PingDelegator
     * Console URL: `https://localhost:6443`
     * User: Administrator
     * Password: 2FederateM0re

3. How to test a SAML application/connection:
    - From the PingFederate home page, select "SP Connections"
    - Next, select the "Sample SAML Connection"
    - Click on the "SSO Application Endpoint" URL presented at the top portion of the screen
    - You will then be redirected to a Sign On screen
    - Next, enter in a sample username, followed by the sample password. The sample users file can be found (the location below) within the PingDirectory Server Profile.
      => ./server-profile/pingdirectory/pd.profile/ldif/userRoot/12-sampleusers.ldif
    - After logging in with the sample username and password, you should be brought to a webpage containing a JSON object.
    - You can now verify the SAML test was successful if a "SAMLResponse" is present in the "form" value

4. How to test OAuth with a Sample User:
    - Navigate to this URL (use localhost unless otherwise specified)
      => <hostname>:9031/OAuthPlayground
    - Select the "Submit" button at the bottom of the screen
    - You will then be redirected to a Sign On screen
    - Next, enter in a sample username, followed by the sample password. The sample users file can be found (the location below) within the PingDirectory Server Profile.
      => ./server-profile/pingdirectory/pd.profile/ldif/userRoot/12-sampleusers.ldif
    - You will then be redirected back to a similar screen. From here, click the "Submit" button once more.
    - Step 3: TOKEN ENDPOINT page will then be presented. If the OAuth request and response was valid, you will see a "Parsed Response" of "HTTP Status: 200 OK" on the top right of your screen.

5. When you no longer want to run the solution, you can either stop or remove the stack.

   To stop the running stack (doesn't remove any of the containers or associated Docker networks), enter:

   ```bash
   docker-compose stop
   ```

   To stop the stack and remove all of the containers and associated Docker networks, enter:

   ```bash
   docker-compose down
   ```

   To remove the persisted volumes (removing any configuration changes you may have done)

   ```bash
   docker volume prune
   ```