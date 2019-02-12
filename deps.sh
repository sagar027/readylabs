#!/bin/bash
sudo apt-get update -y
sudo apt-get install npm nodejs python3-pip zip -y
sudo apt-get install python3-setuptools -y
sudo sh -c "wget -O azcopy.tar.gz https://aka.ms/downloadazcopylinux64 && tar -xf azcopy.tar.gz && ./install.sh"
sudo npm install -g configurable-http-proxy
sudo chown -R 'labadmin' ~/.npm
sudo -u labadmin python3 -m pip install notebook jupyterhub tensorflow
echo 'export PATH=$PATH:~labadmin/.local/bin' >>/etc/bash.bashrc
echo 'export PYTHONPATH=$PYTHONPATH:~labadmin/ready-labs/tf-files/research:~labadmin/ready-labs/tf-files/research/slim'  >>/etc/bash.bashrc
echo "changing to ~labadmin/ready-labs..."
sudo -u labadmin mkdir -p ~labadmin/ready-labs
sudo -u labadmin mkdir -p ~labadmin/ready-labs/artefacts
echo "changing to ~labadmin/ready-labs/tf-files/artefacts..."
cd ~labadmin/ready-labs/artefacts
sudo -u labadmin wget faster_rcnn_resnet101_coco_2018_01_28.tar.gz http://download.tensorflow.org/models/object_detection/faster_rcnn_resnet101_coco_2018_01_28.tar.gz
echo "changing to ~labadmin/ready-labs..."
cd ~labadmin/ready-labs
sudo -u labadmin git clone https://github.com/tensorflow/models.git ~labadmin/ready-labs/tf-files
echo "changing to ~labadmin/ready-labs/tf-files/research..."
cd ~labadmin/ready-labs/tf-files/research
sudo -u labadmin git clone https://github.com/cocodataset/cocoapi.git
cd cocoapi/PythonAPI
sed -i 's/python/python3/' Makefile
sudo -u labadmin make
cp -r pycocotools ~labadmin/ready-labs/tf-files/research/
cd ~labadmin/ready-labs/tf-files/research/
sudo -u labadmin python3 -m pip install --user Cython contextlib2 pillow lxml jupyter matplotlib azure-cognitiveservices-search-imagesearch
sudo -u labadmin wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip
sudo -u labadmin unzip protobuf.zip -d ~labadmin/ready-labs/tf-files/research
rm protobuf.zip
cd ~labadmin/ready-labs/tf-files/research
sudo -u labadmin ./bin/protoc object_detection/protos/*.proto --python_out=.
cd ~labadmin
cd ~labadmin/ready-labs/tf-files/research/object_detection/
mkdir custom-training
mkdir custom-training/fine_tuned_model
mkdir custom-training/model_files
cd custom-training/model_files
wget http://download.tensorflow.org/models/object_detection/faster_rcnn_resnet101_coco_2018_01_28.tar.gz
tar xvf faster_rcnn_resnet101_coco_2018_01_28.tar.gz
cd ~labadmin/ready-labs/tf-files/research/object_detection/custom-training/fine_tuned_model
#get from storare
azcopy --source https://aciblob.blob.core.windows.net/sagar/fine_tuned_model --destination . --recursive --quiet
cd ~labadmin/ready-labs/tf-files/research/object_detection/custom-training/model_files
#get from storage
azcopy --source https://aciblob.blob.core.windows.net/sagar/model_final --destination . --recursive --quiet
cd ~labadmin
mkdir temp-folder
cd temp-folder
git clone https://github.com/sagar027/readylabs.git ready-labs
cp -r ready-labs/tf-files/research/object_detection/custom-training/data2 ~labadmin/ready-labs/tf-files/research/object_detection/custom-training/
cp ready-labs/tf-files/research/object_detection/custom-training/faster_rcnn_resnet101_coco.config ~labadmin/ready-labs/tf-files/research/object_detection/custom-training/
cp ready-labs/tf-files/research/object_detection/custom-training/resize.py ~labadmin/ready-labs/tf-files/research/object_detection/custom-training/
cp -r ready-labs/tf-files/research/object_detection/test_images ~labadmin/ready-labs/tf-files/research/object_detection/
cp ready-labs/tf-files/research/object_detection/custom-training/export_inference_graph.py ~labadmin/ready-labs/tf-files/research/object_detection/custom-training
cp ready-labs/Ready-Notebook.ipynb ~labadmin/ready-labs
cp ready-labs/deploy_model.ipynb ~labadmin/ready-labs
sudo -u labadmin python3 -m pip install azure-cognitiveservices-search-imagesearch
sudo -u labadmin python3 -m pip install azureml-sdk==1.0.8
cd ~labadmin
sudo -u labadmin wget https://aciblob.blob.core.windows.net/script/tf_obj_det.ipynb
sudo -u labadmin wget https://aciblob.blob.core.windows.net/script/jhub.sh
sudo -u labadmin wget https://aciblob.blob.core.windows.net/sagar/tfeval.tar
tar xvf tfeval.tar && rm tfeval.tar
sudo chown -R labadmin:labadmin ~labadmin/
cd ~labadmin/.local/bin
sudo -u labadmin ~labadmin/.local/bin/jupyterhub --generate-config
echo "c.Spawner.env_keep = ['PATH', 'PYTHONPATH', 'CONDA_ROOT', 'CONDA_DEFAULT_ENV', 'VIRTUAL_ENV', 'LANG', 'LC_ALL']" >>~labadmin/.local/bin/jupyterhub_config.py
sudo PATH=$PATH:~labadmin/.local/bin PYTHONPATH=$PYTHONPATH:~labadmin/ready-labs/tf-files/research:~labadmin/ready-labs/tf-files/research/slim -b -u labadmin ~labadmin/.local/bin/jupyterhub
