import { CfnOutput, CfnResource, Stack, StackProps } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { Vpc } from 'aws-cdk-lib/aws-ec2';
import { Cluster } from 'aws-cdk-lib/aws-ecs';
import { HttpApi } from '@aws-cdk/aws-apigatewayv2-alpha';

export class NetworkStack extends Stack {
  readonly vpcClusterArn: string
  readonly httpVpcLinkRef: string
  readonly httpApiId: string

  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpc = new Vpc(this, 'ApiVpc', {
      maxAzs: 3
    });

    const cluster = new Cluster(this, 'ApiVpcCluster', {
      vpc: vpc
    });
    this.vpcClusterArn = cluster.clusterArn;

    const httpVpcLink = new CfnResource(this, 'HttpVpcLink', {
      type: 'AWS::ApiGatewayV2::VpcLink',
      properties: {
        Name: 'V2 VPC Link',
        SubnetIds: vpc.privateSubnets.map(m => m.subnetId)
      }
    });
    this.httpVpcLinkRef = httpVpcLink.ref;

    const api = new HttpApi(this, 'HttpApiGateway', {
      apiName: 'ServiceApi',
      description: 'Integration between api gateway and Application Load-Balanced services',
    });
    this.httpApiId = api.apiId;

    new CfnOutput(this, 'APIGatewayUrl', {
      description: 'API Gateway URL to access the API endpoint',
      value: api.url!,
      exportName: 'APIGatewayUrlExport'
    })
  }
}
