#!/usr/bin/env node

const cdk = require('@aws-cdk/core');
const { InfrastructureStack } = require('../lib/infrastructure-stack');

const stackName = 'FishNVStack'
const env = {
  account: process.env.CDK_DEPLOY_ACCOUNT || process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEPLOY_REGION || process.env.CDK_DEFAULT_REGION
}

const app = new cdk.App();
new InfrastructureStack(app, stackName, { env });
