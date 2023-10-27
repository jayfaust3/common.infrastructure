import { CfnOutput, CfnResource, Stack, StackProps } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { Vpc } from 'aws-cdk-lib/aws-ec2';
import { Cluster } from 'aws-cdk-lib/aws-ecs';
import { HttpApi } from '@aws-cdk/aws-apigatewayv2-alpha';

export class NetworkStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpc = new Vpc(this, 'ApiVpc', {
      maxAzs: 3
    });

    const cluster = new Cluster(this, 'ApiVpcCluster', {
      vpc: vpc
    });

    const httpVpcLink = new CfnResource(this, 'HttpVpcLink', {
      type: 'AWS::ApiGatewayV2::VpcLink',
      properties: {
        Name: 'V2 VPC Link',
        SubnetIds: vpc.privateSubnets.map(m => m.subnetId)
      }
    });

    const api = new HttpApi(this, 'HttpApiGateway', {
      apiName: 'ApigwFargate',
      description: 'Integration between apigw and Application Load-Balanced Fargate Service',
    });

    new CfnOutput(this, 'APIGatewayUrl', {
      description: 'API Gateway URL to access the API endpoint',
      value: api.url!,
      exportName: 'APIGatewayUrlExport'
    })
  }
}
