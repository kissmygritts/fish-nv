const cdk = require('@aws-cdk/core')
const ec2 = require('@aws-cdk/aws-ec2')
const ecs = require('@aws-cdk/aws-ecs')
const ecsPatterns = require('@aws-cdk/aws-ecs-patterns')
const servicediscovery = require('@aws-cdk/aws-servicediscovery')
// const iam = require('@aws-cdk/aws-iam')

// load infra stack from base build
const InfrastructureStack = require('../../infrastructure/lib/infrastructure-stack.js')

class FrontendServiceStack extends cdk.Stack {
  /**
   *
   * @param {cdk.Construct} scope
   * @param {string} id
   * @param {cdk.StackProps=} props
   */
  constructor(scope, id, props) {
    super(scope, id, props);
    
    /* Lookup resources in aws to build upon in this stack */
    // Lookup the VPC that was created in the base stack: https://docs.aws.amazon.com/cdk/api/latest/docs/@aws-cdk_aws-ec2.Vpc.html#static-from-wbr-lookupscope-id-options
    const vpc = ec2.Vpc.fromLookup(this, 'VPC', {
      vpcName: 'FishNVStack/FishNv-VPC'
    })

    // Lookup ECS cluster to deploy tasks 
    const cluster = ecs.Cluster.fromClusterAttributes(this, 'ECSCluster', {
      vpc: vpc,
      clusterName: 'fishnv',
      defaultCloudMapNamespace: 'fishnv-service' 
    })

    // Lookup Cloud Map Namespace
    //    fromPrivateDnsNamespaceAttributes: https://docs.aws.amazon.com/cdk/api/latest/docs/@aws-cdk_aws-servicediscovery.PrivateDnsNamespace.html#static-from-wbr-private-wbr-dns-wbr-namespace-wbr-attributesscope-id-attrs
    //    cdk.Fn.importValue: https://docs.aws.amazon.com/cdk/api/latest/docs/@aws-cdk_core.Fn.html#static-import-wbr-valuesharedvaluetoimport
    //      because we export the values NSNAME, NSARN, NSID from the BaseStack we can import them here?
    //      looking up the output of cdk.CfnOutput from the ../../infrastructure/lib/infrastructure-stack.js.
    //      I wonder if I can just import from the file shown above?
    const cloudMapNamespace = servicediscovery.PrivateDnsNamespace.fromPrivateDnsNamespaceAttributes(
      this, 'SDNamespace', {
        namespaceName: cdk.Fn.importValue('NSNAME'),
        namespaceArn: cdk.Fn.importValue('NSARN'),
        namespaceId: cdk.Fn.importValue('NSID')
      }
    )

    // Lookup security group
    // const servicesSecurityGroup = ec2.SecurityGroup.fromSecurityGroupId(
    //   this, 'ServicesSecurityGroup', {
    //     securityGroupId: cdk.Fn.importValue('SecGrpId')
    //     // securityGroupId: 'sg-0dfa824f2840f2e01'
    //   }
    // )

    /* Create AWS resources */
    // Task image/container options(?)
    const taskImageOptions = {
      // An instance of Container Image: https://docs.aws.amazon.com/cdk/api/latest/docs/@aws-cdk_aws-ecs.ContainerImage.html
      // from DockerHub or other registry
      image: ecs.ContainerImage.fromRegistry('kissmygritts/fishnv-app'),
      containerPort: 3000,
      environment: {
        APIURL: 'http://api.fishnv-service:3000'
      }
    }

    // Create a container to run a Fargate task: https://docs.aws.amazon.com/cdk/api/latest/docs/@aws-cdk_aws-ecs-patterns.ApplicationLoadBalancedFargateService.html
    const fargateLoadBalancedService = new ecsPatterns.ApplicationLoadBalancedFargateService(
      this,
      'FrontendFargateLBService',
      {
        serviceName: 'fishnv-frontend',
        publicLoadBalancer: true,
        cpu: 512,
        memoryLimitMiB: 1024,
        desiredCount: 1,
        // An instance of an ECS Cluster from AWS
        cluster: cluster,
        // Attach to service discovery cloud map
        cloudMapOptions: cloudMapNamespace,
        // Properties to create task def: https://docs.aws.amazon.com/cdk/api/latest/docs/@aws-cdk_aws-ecs-patterns.ApplicationLoadBalancedTaskImageOptions.html
        taskImageOptions: taskImageOptions
      }
    )

    // Allow traffic from frontend to backend services(?)
    const portRules = new ec2.Port({
      protocol: ec2.Protocol.TCP,
      stringRepresentation: 'frontendtobackend',
      fromPort: 3000,
      toPort: 3000
    })

    // fargateLoadBalancedService.service.connections.allowTo(servicesSecurityGroup, {
    //   portRange: portRules
    // })

    // Enable Autoscaling
    const autoscale = fargateLoadBalancedService.service.autoScaleTaskCount({
      minCapacity: 1,
      maxCapacity: 10
    })

    // Set autoscale method and parameters
    autoscale.scaleOnCpuUtilization('CPUAutoscaling', {
      targetUtilizationPercent: 50,
      scaleInCooldown: cdk.Duration.seconds(30),
      scaleOutCooldown: cdk.Duration.seconds(30)
    })
  }
}

module.exports = { FrontendServiceStack }
