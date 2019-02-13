# TF Lab

This repository contains the notebooks, scripts and the ARM template to get you started and run the lab on your own Azure subscription. 

Please deploy the ARM template using the following command -
**Note:** You need the latest PowerShell Azure Module on you system. This deployment doesn't work in Cloud Shell. Please use Azure CLI command mentioned below if you are using the Cloud Shell.

```
New-AzDeployment -Location eastus2 -TemplateFile https://raw.githubusercontent.com/sagar027/readylabs/master/TF-LAB-ARM-Template.json -rgName <resource-group-name> -rgLocation eastus2
```

If using Azure CLI, use the following command -

```
wget https://raw.githubusercontent.com/sagar027/readylabs/master/TF-LAB-ARM-Template.json
az deployment create -n mydeployment --location westus --template-file ./TF-LAB-ARM-Template.json --parameters rgName=<resource-group-name> rgLocation=westus
```

Once the deployment is complete, you will the output from the template which shows the credentials you can use as well as the Jupyter URL and SSH information.

You can now point your browser to the Jupyter URL displayed and log in. Go to the ready-labs folder and start the **Ready-Notebook.ipynb** to start your experiment. After you are done with the training and a model has been created, you can launch the **deploy_model.ipynb** notebook and deploy your model as a web service to Azure Container Instance.

If you want to run this notebook in your own DSVM instance, you can clone this repo using the following command -

```
git clone https://github.com/sagar027/readylabs.git
```

After this is done, please run Jupyter on your system and access the **Ready-Notebook.ipynb** in your browser to learn more about the experiment and to run the commands.
