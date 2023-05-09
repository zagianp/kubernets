Simple Steps For Implementing The CI/CD Process With One .NET Core Application
Let’s deploy this application in 2 different environments:

Azure App services
On-premise /Self-Hosted server
Before we start with building a new project, please check below prerequisite points and make sure you have all things available:

Microsoft Azure account with DevOps. You can start it free from here
Visual Studio 2019
Azure Repos
On-premise server
Internet connection
the whole process is divided into 4 parts:

Setup project in source control
Configure Azure CI/CD pipelines to deploy the application in Azure Services
Configure Release pipeline to deploy same application parallelly in on-premise/Self-Hosted server
Run Azure DevOps Pipeline to deploy the application in 2 environments
7.1 Setup Project in Source Control
Sign into the Microsoft Azure portal. I have used Azure Repos as source control for demo projects. Azure DevOps supports a vast range of source controls available in the market. You can use any of them.

1. Let’s create a new .NET Core Project in Visual Studio 2019. You can also use your existing project. Here, I’m using a template project with basic coding for example and demo purposes.

configure your new project
2. Commit the source code in Azure Repository that is already configured with Visual Studio. [Some steps are skipped to make this article smaller.]

7.2 Configure Azure CI/CD Pipelines to Deploy The Application in Azure Services
1. Visual studio 2019 provides a default feature for configuring CI-CD in any project. You can find this feature by right-clicking on the project solution file and selecting Configure continues delivery to azure. Other than this you can also find this feature under Team Explorer as images are given below.

Configure continues delivery to azure
Team Explorer
2. By following previous steps, one popup for Setup Azure Pipeline will open in which you can select the appropriate branch and App Service.

Setup Azure Pipeline
You can also change the advanced setting for App service by clicking on the Edit button given besides an App service drop-down.
After all necessary steps click the OK button, it will run some background processes to create Azure Pipeline.
You can track this ongoing background process in the Output window as shown in the below image.
Output
3. Open Azure DevOps portal and navigate to the Azure Pipelines section to see the newly created Azure pipeline by Visual Studio. Follow the steps shown as per below image to edit the pipeline.

Pipelines
You can see the edit pipeline screen where you can edit the configuration of the build pipeline in the future as you wish.
In the task tab, you will be able to add/edit tasks and agent jobs as per your requirement for your new project  as per below image. These task tabs are created automatically as we have setup the pipeline from Visual Studio. You can create such tasks manually also.
setup the pipeline from Visual Studio
You can add/edit variables or variable groups to be used in various tasks in the Variables tab.
variable groups
In the Triggers tab, you can set the trigger to indicate when to run the build pipeline. You can also set specific branches from the CI process, path filters and schedules for the pipeline to run, etc.
Triggers tab
4. Follow the below steps to see a newly created Release Pipeline (CD) by Azure DevOps Project and also edit as per your need.

Release Pipeline
After this in the next screen, follow the steps as per below screen to go to the edit task.
edit task
Here you can add/edit tasks or phases in the release pipeline.
phases in the release pipeline
Now, we can deploy a .NET Core application in Azure App Services using the Azure CI/CD process. Let’s see the steps to deploy the same application on a local server.

7.3 Configure Release Pipeline to Deploy Same Application Parallelly in On-Premise/Self-Hosted Server
Before we start configuring the pipeline, you will have to perform a few tasks in your on-premise server to add it to the deployment group of Azure DevOps. And then you can add the same stage/phase in the release pipeline to deploy a build-in IIS server.

1. Go to the deployment group in Azure DevOps. And click on add a deployment group to add a new one.

add a deployment group
Add an appropriate name and description then click on the Create button to create a new one.
deployment groups
It will open the screen to register your on-premises server, so select the type of machine which you are targeting, check the checkbox and click on the Copy to Clipboard button as suggested in the image. It will copy the power shell command in the clipboard.
Copy to Clipboard
Open PowerShell console as an Administrator and paste the script copied in the previous step.
Run the script and wait for some time to execute it completely.
PowerShell console
Run the script
Run the script
So now, it’s registered successfully. You can verify it in the Azure DevOps deployment group section where you can find the target status is Online. See the below image for reference.
Online
2. Now, add a new stage in the release pipeline to deploy the build in this server. For that go back to the release pipeline section and click on the Edit button to edit a pipeline. Then follow the steps shown as per image to add a new stage in the pipeline.

add a new stage 
Select the template for IIS Website Deployment as we are going to publish build on IIS server of self-hosted server.
IIS Website Deployment
After this, it will open a new popup, give the appropriate name to the newly created stage.
new popup
Go to the Tasks tab to edit the template as shown in the image. Change the bindings and website name as you require.
edit the template
Edit the IIS Deployment agent, here you have to set the deployment group to what we have created in previous steps.
IIS Deployment
Go to task IIS Web App Manage, change the physical path where you want to deploy your build. Fields that are not editable are already set in previous steps.
IIS Deployment
Select task IIS Web App Deploy, browse the path where the build is placed and set it to Package or folder field, check the option of Remove additional files at destinations.
IIS Web App Deploy
After following all the above steps, don’t forget to click on the Save button. That’s it, you are all set to deploy applications on a self-hosted server using Azure Pipelines.

Let see how you can run your pipeline and where you can see the status of these pipelines in the Azure DevOps portal.

7.4 Run Azure Pipeline to Deploy The Application in 2 Environments
1. You can set up your Pipeline to be run when any changes are committed in a particular branch in the repository as shown earlier in this article.

2. You can also manually run this pipeline from the Azure DevOps portal. Follow the below steps to run it.

Open Azure DevOps Portal, navigate to your project.
Click on “Pipelines” to open the window.
Find your pipeline from Recent or All.
Click on ellipsis as shown in the below image and then click on “Run Pipeline”.
Run Pipeline
Click on the title of your Pipeline to open it where you will see all your runs in descending order – latest run on top.
runs in descending order
Select any of the runs to see details of that run.
Summary
In the Releases tab, you will find a release pipeline run for this instance.
Releases tab
Further going deeper by clicking on the release title, you will finally reach your release summary, where you can see all executed jobs. You can also find errors if they occurred during deployment.
release summary
Clicking on each job will get you a console to see all steps executed.
You have seen simple steps for deploying an application in 2 different environments. There are many other factors involved that I haven’t covered and you will find when you deploy an application in a production environment.

8. Conclusion
In the entire discussion of Azure DevOps Pipelines, we understood the variety of services that they are capable of offering to streamline overall business operations and optimize each process. This process will equally divide all the workflows into manageable formats using a robust and scalable Azure platform to deploy solutions in pipelines using continuous integration and continuous deployment methods.

The best thing about this is that you have been doing all this manually by now which was very time-consuming with high possibilities for errors. But now you can automate your release activities on a vast range of environments supported in Azure DevOps as well as Azure Pipelines and avoid the same boring work of deployment.
