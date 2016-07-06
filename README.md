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
9. Once the new Developer Portal has been created, you will receive an email.


#### Installing the IBM API Connect Developer Toolkit

The IBM API Connect Developer Toolking provides both the API Designer UI and a CLI that developers can use to develop APIs
and LoopBack applications, as welll as the tools to publish them to the IBM API Connect runtime. 

Before you get started, you will need to install Node.js version 0.12 or version 4.x, follow the link below for more information details.
[https://www.ibm.com/support/knowledgecenter/en/SSFS6T/com.ibm.apic.toolkit.doc/tapim_cli_install.html](https://www.ibm.com/support/knowledgecenter/en/SSFS6T/com.ibm.apic.toolkit.doc/tapim_cli_install.html)

To install the APIC Connect CLI:

```
npm install -g apiconnect
apic -version
```

That should install the tool and print the version number after the last command.


### Step 2: Obtaining the Application Code


First clone the GIT repository locally:

```
git clone git@github.com:ibm-solution-engineering/refarch-omnichannel-api-node.git
```


There are 5 main folders inside this repository:

**inventory**
* Has loopback Node.js application for the inventory items as well as the API definition that will be used by the Web and Mobile application. It has an in-memory database included.

**socialreview**
* Node.js application for the social review function as well as the API definition that will be used by the Web and Mobile application.

**OAuth**
* Contains artefacts to support OAuth in sample application

**ApicStoreApp**
* The iOS native application implemented in Swift 2.0

**StoreWebApp**
* The Web application consuming the same set of API

### Step 3: Deploy the LoopBack Applications and Publish the API to Bluemix.

There are 2 components that need to be deployed on Bluemix for API(backend):

* The LoopBack Node.js application
* The API definition and product

You will use the APIC CLI to do the deployment.

#### Deploy the LoopBack Application to Bluemix

1. CD into the inventory directory in the GIT repository.
2. Login to your Bluemix APIC environment with: ```apic login``` ( Server: us.apiconnect.ibmcloud.com, credentials: your IBM ID)
3.  Configure the deployment target with:
```apic config:set app=apic-app://us.apiconnect.ibmcloud.com/orgs/{bluemixOrg}-{bluemixSpace}/apps/inventory-loopback-app```
4. Deploy the inventory LoopBack application with: ```apic apps:publish```
5. If you login to your Bluemix control panel you will see the new application is currently running:
![API Running](static/imgs/bluemix_11.png?raw=true)


#### Deploy the SocialReview Application.

1. CD into the socialreview folder in the GIT repository.
2. Configure the deployment target with: ```apic config:set app=apic-app://us.apiconnect.ibmcloud.com/orgs/{bluemixOrg}-{bluemixSpace}/apps/socialreview-loopback-app```
3. Deploy with: ```apic apps:publish```
4. Now in the Bluemix control panel you will see both applications running:
![API Running](static/imgs/bluemix_12.png?raw=true)
