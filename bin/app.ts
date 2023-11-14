import { App } from 'aws-cdk-lib';
import { NetworkStack } from '../stacks';

const app = new App();

new NetworkStack(app, 'NetworkStack');
