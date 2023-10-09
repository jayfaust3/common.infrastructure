import { App } from 'aws-cdk-lib';
import { AnalyticsStack } from './stacks/analytics-stack';

const app = new App();

new AnalyticsStack(app, 'analytics-stack');
