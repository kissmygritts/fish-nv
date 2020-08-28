const cdk = require('@aws-cdk/core');
const ec2 = require('@aws-cdk/aws-ec2')
const ecs = require('@aws-cdk/aws-ecs')

class InfrastructureStack extends cdk.Stack {
  /**
   *
   * @param {cdk.Construct} scope
   * @param {string} id
   * @param {cdk.StackProps=} props
   */
  constructor(scope, id, props) {
    super(scope, id, props);

    // create VPC
    const vpc = new ec2.Vpc(this, "FishNv-VPC", {
      cidr: '10.0.0.0/24',
      maxAzs: 3
    })
    // Add tag to the VPC (Do you tag this? Are there costs associated with this?)
    cdk.Tags.of(vpc).add('Application', 'FishNV')

    // create ECS cluster in the VPC above
    const cluster = new ecs.Cluster(this, 'FishNv-ECSCluster', {
      vpc: vpc,
      clusterName: 'fishnv'
    })
    // Tag the cluster and associated resources
    cdk.Tags.of(cluster).add('Application', 'FishNV')

    // add service discovery namespace to cluster
    cluster.addDefaultCloudMapNamespace({
      name: 'fishnv-service'
    })

    // Namespace details as DFN output
    const namespaceOutputs = {
      'ARN': cluster.defaultCloudMapNamespace.privateDnsNamespaceArn,
      'NAME': cluster.defaultCloudMapNamespace.privateDnsNamespaceName,
      'ID': cluster.defaultCloudMapNamespace.privateDnsNamespaceId
    }

    // Cluster attributes
    const clusterOutputs = {
      'NAME': cluster.clusterName,
      'SECGRPS': cluster.connections.securityGroups
    }

    // Frontend to backend services on 3000
    // this might need to change as I'm not listening on 3000?
    const servicesSecurityGroup = new ec2.SecurityGroup(this, 'FrontendToBackendSecurityGroup', {
      allowAllOutbound: true,
      description: 'Security group for frontend services to talk to backend services',
      vpc: vpc
    })

    // Allow indound 300 from ALB to frontend
    const secGroupIngressSelf3000 = new ec2.CfnSecurityGroupIngress(
      this, 'InboundSecGrp3000', {
        ipProtocol: 'TCP',
        sourceSecurityGroupId: servicesSecurityGroup.securityGroupId,
        fromPort: 3000,
        toPort: 3000,
        groupId: servicesSecurityGroup.securityGroupId
      }
    )

    // All outputs required for other stacks to build
    new cdk.CfnOutput(this, 'NSArn', {
      value: namespaceOutputs.ARN, 
      exportName: 'NSARN'
    })
    new cdk.CfnOutput(this, 'NSName', {
      value: namespaceOutputs.NAME,
      exportName: 'NSNAME'
    })
    new cdk.CfnOutput(this, 'NSId', {
      value: namespaceOutputs.ID,
      exportName: 'NSID'
    })
    new cdk.CfnOutput(this, 'FE2BESecGrop', {
      value: servicesSecurityGroup.securityGroupId,
      exportName: 'SecGrpId'
    })
    new cdk.CfnOutput(this, 'ECSClusterName', {
      value: clusterOutputs.NAME,
      exportName: 'ECSClusterName'
    })
    new cdk.CfnOutput(this, 'ECSSecGroup', {
      value: clusterOutputs.SECGRPS,
      exportName: 'ECSSecGrpList'
    })
    new cdk.CfnOutput(this, 'ServicesSecGrp', {
      value: servicesSecurityGroup.securityGroupId,
      exportName: 'ServicesSecGrp'
    })
  }
}

module.exports = { InfrastructureStack }
