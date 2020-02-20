[![Build Status](https://travis-ci.com/Gepardec/openshift-letsencrypt.svg?branch=master)](https://travis-ci.com/Gepardec/openshift-letsencrypt)
![](https://img.shields.io/docker/cloud/build/gepardec/openshift-letsencrypt)
![](https://img.shields.io/docker/cloud/automated/gepardec/openshift-letsencrypt)
![](https://img.shields.io/docker/pulls/gepardec/openshift-letsencrypt)
![](https://img.shields.io/badge/license-GPL%20v3.0-brightgreen.svg)
![](https://img.shields.io/maintenance/yes/2020)

<p align="right">
<img alt="gepardec" width=100px src="https://github.com/Gepardec/branding/raw/master/logo/gepardec.png">
</p>

# openshift-letsencrypt

Let's secure OpenShift 4.x ingress with letsencrypt certificates that are renewed on the fly through a cronjob running within OpenShift itself. We are using AWS Rout53 for our DNS. As such our example here will use AWS as an example. However you can easily alter the behavior to fit your particular setup. We will get to that in a bit.

## What is Let's Encrypt?!

Let’s Encrypt is a free, automated, and open certificate authority (CA), run for the public’s benefit. It is a service provided by the Internet Security Research Group (ISRG) with its goal defined as follows

> We give people the digital certificates they need in order to enable HTTPS (SSL/TLS) for websites, for free, in the most user-friendly way we can. We do this because we want to create a more secure and privacy-respecting Web.

That's is perfect for us. The key principles behind Let’s Encrypt are:

* Free: Anyone who owns a domain name can use Let’s Encrypt to obtain a trusted certificate at zero cost.
* Automatic: Software running on a web server can interact with Let’s Encrypt to painlessly obtain a certificate, securely configure it for use, and automatically take care of renewal.
* Transparent: All certificates issued or revoked will be publicly recorded and available for anyone to inspect.
* Cooperative: Much like the underlying Internet protocols themselves, Let’s Encrypt is a joint effort to benefit the community, beyond the control of any one organization.

---

## Preflight

Here is what you need to get started. First of you will need `bash`, `docker` on your workstation.

You got `bash` and `docker` already installed? Wonderful! Next we need to source the bashrc of this repository for easy of use. You can either do it manually via 

```
source ./bashrc
```

Or you can put it in your `~/.bashrc` file like this

```
[ -f /PATH/TO/GEPARDEC/OPENSHIFT/LETSENCRYPT/bashrc ] && source /PATH/TO/GEPARDEC/OPENSHIFT/LETSENCRYPT/bashrc
```

and source your `~/.bashrc` again in order to enable the changes in your current session.

Some commands require openshift and/or aws credentials. In order to not repeat the login proecedures over and over in the following sections we have added them here in the preflight section.

### Login to OpenShift

From your workstation log in to the OpenShift cluster via

```
oc login
```

If you do not have the `oc` binary on your machine you can execute 

```
openshift-letsencrypt oc login
```

instead.

### Login to AWS

In our example we will use AWS Route 53 api to create the certificate. For this purpose we need to login to aws via cli. From your workstation simply execute

```
aws configure
```

If you do not have the `aws` binary on your machine you can execute 

```
openshift-letsencrypt aws configure
```

instead.

---

## Available commands

```
openshift-letsencrypt

openshift-letsencrypt-build

openshift-letsencrypt-issue
openshift-letsencrypt-install
openshift-letsencrypt-renew
openshift-letsencrypt-cron

openshift-letsencrypt-setup
```

**Hint:** do not forget to source the bashrc

---

## Create a new certificate for OpenShift ingress

To create a new certificte for your OpenShift cluster you need to be logged in with a user that has access to the `openshift-ingress-operator` namespace. If you are using aws Route 53 like us you need to login to aws as well. Please check the preflights section on how to login to OpenShift and AWS via the cli.

Once you are logged in via the cli to OpenShift and AWS you can execute 

```
openshift-letsencrypt-issue --dns dns_aws
```

The command will create a certificate folder next to the `openshift-letsencrypt/bashrc` file populated with the certificate files.

## Install the newly created certificate

To install a certificte created in the previous step cluster you need to be logged in with a user that has access to the `openshift-ingress` and `openshift-ingress-operator` namespace. Please check the preflights section on how to login to OpenShift and AWS via the cli.

```
openshift-letsencrypt-install
```

## Renew a certificate

To renew a new certificte for your OpenShift cluster you need to be logged in with a user that has access to the `openshift-ingress-operator` namespace. If you are using aws Route 53 like us you need to login to aws as well. Please check the preflights section on how to login to OpenShift and AWS via the cli.

```
openshift-letsencrypt-renew --dns dns_aws
```


<!--
## Create a cronjob to automatically renew your certificate
## All in one
## Build the docker image
## Repository folder structur
## Container folder structure

---

### Sources:

* 
-->
