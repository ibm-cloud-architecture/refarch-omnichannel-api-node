# OmniChannel Architecture for Mobile and Web


## Introduction

This project provides a guided walkthrough on how to build a modern omnichannel Mobile and Web
application using IBM Bluemix platform and API technologies.

The Application architecture for this application is:

![Application Architecture](static/imgs/mobile_web_arch.png?raw=true)

Explained another way:

![Application Architecture](static/imgs/application_overview.png?raw=true)


## Running The Sample Applications

To run the sample applications you will need to configure your Bluemix enviroment for the API and microservices 
runtimes. Additionally you will need to configure your system to run the iOS and Web Application tier as well.

### Step 1: Environment Setup

#### Provisioning the API Connect service in Bluemix

To provision API Connect you must have a Bluemix account. Login to your Bluemix account or register for a new account [here](https://bluemix.net/registration)

Once you have logged in, create a new space for hosting the application. This application will use LoopBack for provisioning and
the API Connect service for managing the API.

#### Install the Bluemix CLI

In order to complete the rest of this tutorial, many commands will require the Bluemix CLI toolkit to be installed on your local
environment. To install it, follow [these instructions](https://console.ng.bluemix.net/docs/cli/index.html#cli)

#### Create a New Space in Bluemix

1. Click on the Bluemix account in the top right corner of the web interface.
2. Click Create a new space.
3. Enter "mobileweb" for the space name and complete the wizard.


#### Provision the API Connect Service

1. Click on the Bluemix console and select API as shown in the figure below. ![API Info](static/imgs/bluemix_1.png?raw=true)
2. Select the API Connect service as shown below. ![API Info](static/imgs/bluemix_2.png?raw=true)
3. Select the free Essentials plan for this demo.
4. After the API Connect service is created, launch the API Connect service by clicking "Launch API Manager" ![API Info](static/imgs/bluemix_3.png?raw=true)
5.  In the API Manager page, navigate to the API Connect Dashboard and select "Add Catalog" at the top left. You may notice that a 
sandbox has automatically been generated for you. ![API Info](static/imgs/bluemix_4.png?raw=true)
6. Name the catalog "ApicStore Catalog" and press "Add".![API Info](static/imgs/bluemix_5.png?raw=true)
7. Select the catalog and then in the Settings table and the Portal sub-tab.
8. To setup a Portal that your consumers can use to explore your API, select the IBM Developer Portal radio button. This will
provision a portal for you. You should receive a message like the one below. ![API Info](static/imgs/bluemix_9.png?raw=true)