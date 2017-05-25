FROM openshift/base-centos7
# This image provides a Node.JS environment you can use to run your Node.JS applications.

EXPOSE 8080

# This image will be initialized with "npm run $NPM_RUN"
# See https://docs.npmjs.com/misc/scripts, and your repo's package.json
# file for possible values of NPM_RUN
ENV NPM_RUN=start \
    NODE_VERSION=4.8.3 \
    NPM_VERSION=2.15.11 \
    V8_VERSION=4.5.103.47 \
    NODE_LTS=true \
    NPM_CONFIG_LOGLEVEL=info \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    DEBUG_PORT=5858 \
    NODE_ENV=production \
    DEV_MODE=false

LABEL io.k8s.description="Platform for building and running Node.js applications" \
      io.k8s.display-name="Node.js $NODE_VERSION" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nodejs,nodejs-$NODE_VERSION" \
      com.redhat.deployments-dir="/opt/app-root/src" \
      maintainer="Lance Ball <lball@redhat.com>"

COPY ./s2i/ $STI_SCRIPTS_PATH
COPY ./contrib/ /opt/app-root

RUN /opt/app-root/etc/install_node.sh
  
USER 1001

# Set the default CMD to print the usage
CMD ${STI_SCRIPTS_PATH}/usage
