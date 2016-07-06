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

1. Click on the Bluemix console and select API as shown in the figure below ![API Info](static/imgs/bluemix_1.png?raw=true)
