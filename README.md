# OmniChannel Architecture for Mobile and Web


## Introduction

This project provides a guided walkthrough on how to build a modern omnichannel Mobile and Web
application using IBM Bluemix platform and API technologies.

The Application architecture for this application is:

![Application Architecture](static/imgs/mobile_web_arch.png?raw=true)

The reference implementation uses Loopback as Node.js framework and run as a Bluemix Clound Foundry app. For simplicity, the data store is implemented as a Loopback in-memory DB.

## Running The Sample Applications

To run the sample applications you will need to configure your Bluemix enviroment for the API and microservices 
runtimes. Additionally you will need to configure your system to run the iOS and Web Application tier as well.

### Step 1: Environment Setup

#### Provisioning the API Connect service in Bluemix

To provision API Connect you must have a Bluemix account. Login to your Bluemix account or register for a new account [here](https://bluemix.net/registration)

Once you have logged in, create a new space for hosting the application. This application will use LoopBack framework as microservices implementation and
the API Connect service for managing the API.

#### Install the Bluemix CLI

In order to complete the rest of this tutorial, many commands will require the Bluemix CLI toolkit to be installed on your local
environment. To install it, follow [these instructions](https://console.ng.bluemix.net/docs/cli/index.html#cli)

This walkthrough uses the cf tool.

#### Create a New Space in Bluemix

1. Click on the Bluemix account in the top right corner of the web interface.
2. Click Create a new space.
3. Enter "mobileweb" for the space name and complete the wizard.


#### Provision the API Connect Service

1. Click on the Bluemix console and select API as shown in the figure below. ![API Info](static/imgs/bluemix_1.png?raw=true)
2. Select the API Connect service as shown below. ![API Info](static/imgs/bluemix_2.png?raw=true)
3. Click "Create" in the Getting Started with API Connect page. In API Connect creation page, specify the Service name anything you like or keep the default. Then select the free Essentials plan for this walkthrough.
4. After the API Connect service is created, launch the API Connect service by clicking "Launch API Manager" ![API Info](static/imgs/bluemix_3.png?raw=true)
5.  In the API Manager page, navigate to the API Connect Dashboard and select "Add Catalog" at the top left. You may notice that a 
sandbox has automatically been generated for you. ![API Info](static/imgs/bluemix_4.png?raw=true)
6. Name the catalog "ApicStore Catalog" and press "Add".![API Info](static/imgs/bluemix_5.png?raw=true)
7. Select the catalog and then navigate to the Settings tab and click the Portal sub-tab.
8. To setup a Developer Portal that your consumers can use to explore your API, select the IBM Developer Portal radio button. Then click the "Save" button to top right menu section. This will
provision a portal for you. You should receive a message like the one below. ![API Info](static/imgs/bluemix_9.png?raw=true)
9. Once the new Developer Portal has been created, you will receive an email.


#### Installing the IBM API Connect Developer Toolkit

The IBM API Connect Developer Toolkit provides both the API Designer UI and a CLI that developers can use to develop APIs
and LoopBack applications, as welll as the tools to publish them to the IBM API Connect runtime. 

Before getting started, you will need to install Node.js version 0.12 or version 4.x, follow the link below for more information details.
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
2. install all node.js dependencies 
```npm install```
3. Login to your Bluemix APIC environment with: ```apic login``` ( Server: us.apiconnect.ibmcloud.com, credentials: your IBM ID)
4.  Configure the deployment target with:
```apic config:set app=apic-app://us.apiconnect.ibmcloud.com/orgs/{bluemixOrg}-{bluemixSpace}/apps/inventory-loopback-app```
5. Deploy the inventory LoopBack application with: ```apic apps:publish```
6. From the response message, note down the API target urls for the inventory app since you will need it next to update the API defination. For example: ```apiconnect-12d0327b-003f-420d-9e9e-f8ef635099d5.gangchenusibmcom-apic.apic.mybluemix.net```
7. Open the definations/inventory.yaml file in a text editor, find the section "TARGET_HOST:", after the line "value: >-", after the https://, replace the hostname value to the urls you copied above. Save the file. (This target_host variable tells the API gateway how to connect the API to the actual microservice endpoint)
8.If you login to your Bluemix control panel you will see the new application is currently running:

![API Running](static/imgs/bluemix_11.png?raw=true)


#### Deploy the SocialReview Application.

1. CD into the socialreview folder in the GIT repository.
2. install all node.js dependencies 
```npm install```
3. Configure the deployment target with: ```apic config:set app=apic-app://us.apiconnect.ibmcloud.com/orgs/{bluemixOrg}-{bluemixSpace}/apps/socialreview-loopback-app```
4. Deploy with: ```apic apps:publish```
5. From the response message, note down the API target urls for the socialreview app since you will need it later to update the API defination.
6. Open the definations/socialreviews.yaml file in a text editor, find the section "TARGET_HOST:", after the line "value: >-",  after the https://, replace the hostname value to the urls you copied above. Save the file.
7. Now in the Bluemix control panel you will see both applications running:

![API Running](static/imgs/bluemix_12.png?raw=true)


#### Publish the APIs

With IBM API Connect you publish the APIs to a specific Catalog. Start by visiting the ApicStore catalog endpoint you
created earlier.

Logon to Bluemix API manager console, navigate to Dashboard. Click the “link” and copy the url from the popup window. you will need that later.

![API Running](static/imgs/bluemix_13.png?raw=true)


1. cd Into the inventory directory in the GIT repository.
2. Set the API publishing endpoint by copying and pasting the catalog endpoint you obtained earlier. It should look something like this:
```
apic config:set catalog=apic-catalog://us.apiconnect.ibmcloud.com/orgs/gangchenusibm.com-apic/catalogs/apicstore-catalog
```
3. Publish the inventory API product with: ```apic publish definitions/inventory-product.yaml```
4. Now publish the socialreview APIs, start by CD'ing to the socialreview directory.
5. Set the API publishing endpoint by copying the catalog information again. A sample: ``` $ apic config:set catalog=apic-catalog://us.apiconnect.ibmcloud.com/orgs/gangchenusibm.com-apic/catalogs/apicstore-catalog```
6. Publish the socialreviews API product with ```apic publish definitions/socialreviews-product.yaml```
7. Now launch the Bluemix API management console and navigating to "Dashboard" from the top navigation pane. Click "ApicStore Catalog",
you should see both Inventory and SocialReviews products in the state of Published in Bluemix.
![API Running](static/imgs/bluemix_14.png?raw=true)

(**Optional**) In the sample application, the API Connect OAuth provider relies on a dummy authenticating application to validate user credentials.
We have deployed the authentication application and configured the OAuth provider already. If you would like to deploy your own authentication servivces follow this 
section. Otherwiswe move to step 5.

1. Update the Cloud Foundry definition file locted under the repositories' OAuth/authentication-app/ folder ( manifest.yml ).
Update the name and host fields to a unique value. For example {Your bluemix ID}-authenticate.
2. In a command line navigate to the OAuth/authenticaiton-app folder.
3. Login to your Bluemix account ```cf login```, select your Bluemix organization and space ( can be found in your User Profile in the web portal.)
4. Deploy the app with: ```cf push```

### Step 4: Subscribe to the API in the Developer Portal

The Developer Portal enables API providers to build a customized consumer portal for their application developers. It also provides
the interface for API consumers to discover APIs and subscribe to a consumption plan by which the API is consumed in either the Mobile
or traditional Web application.

1. Open the API Connect Developer Portal. You will need to open your Portal URL. Obtain it by navigating to the ApicStore catalog from the Bluemix API manager console. Click "Settings", then "Portal".
![API Running](static/imgs/bluemix_15.png?raw=true)
2. Open the API Connnect Portal in another browser window. You should see the portal home page with both the inventory and the socialreviews APIs highlighted.
3. Click "Create an account" from the upper right menu bar.
4. In the create an account wiard, enter the credentials of your Bluemix login ID and MobileWeb-App-Dev as your developer organization. Finally click "Create new account"
5. In your developer portal, click "Login".
6. Click on the menu tab "Apps" on top. Click on the link to "Register a new Application."
![API Running](static/imgs/bluemix_16.png?raw=true)
7. Enter the fields of "Title" and "Description". Enter "org.apic://example.com" for the OAuth URI redirection page as shown below then click submit.
![API Running](static/imgs/bluemix_17.png?raw=true) ( Store the client ID, you will need it later)
8. In the developer portal, navigate to Apps -> MobileWeb-App-Dev. Below the application, you will see a link to take you to the 
currently available APIs. CLick on that.
9. Click on the Inventory ( V1.0.0 ) API.
10. Click "Subscribe" in the API page.
![API Running](static/imgs/bluemix_18.png?raw=true)
11. Subscribe to the social review API as well ( you can choose the silver or gold plan)
12. Go back to the Apps -> MobileWeb-App-Dev page, you will see that both APIs are subscriped in your Application page.

### Step 5: Run the MobileiOS Application

Note this section requires an Apple computer running MacOS with Apple Xcode IDE installed.

1. In Finder, navigate to the folder ApicStoreApp in the GIT repository.
2. Double click the "ApicStoreApp.xcodeproj" file to open the iOS project in Xcode.
3. You need to specify the API endpoint configuration for your Bluemix API Connect deployment.  Edit the ApiStoreApp / Supporting Files / Config.plist file. The Config.plist file contains all of the API endpoint URLs as well as the clientId registered earlier in Developer Portal. 
![API Running](static/imgs/bluemix_19.png?raw=true)
4. Click the "Play" button in the upper left corner to run the application in a simulated iPhone ( be sure to select iphone6 or 6plus).
5. The application will display a list of items returned from the inventory API. Click on one of them to see the detail of an item.
6. In detail page, you should see item detail as well as existing review comments. Click the "Add Review" Button at lower left corner, this will trigger the OAuth flow.
7. In the OAuth login screen, enter "foo" as username and "bar" as password. Upon successful login, grant the access to the Mobile app.
8. Click Open back in ApicStore app, here you can add a review comment. Click Add will navigate you back to the item detail page where you should see your comment posted.

Feel free to play around and explore the mobile inventory application.

### Step 6: Run the Web Application.

The consumer Web app provides the basic function to allow user to browse the  Inventory items. The sample web app is built as a Node.js application that uses Express framework and Jade templates. 

To set it up:

1. Navigate to the web app root folder in the git repository (StoreWebApp)
2. Edit the config/default.json file to configure the API endpoints
    * client_id
    * host 
    * org
    ![API Running](static/imgs/bluemix_23.png?raw=true)
3. CD to the StoreWebApp directory.
4. Install the node modules with ```npn install```
5. Run the web app with ```npm start```


That's it!

