import { App, Stack, StackProps } from 'aws-cdk-lib';
import { Cluster, ClusterType, Table as RedshiftTable } from '@aws-cdk/aws-redshift-alpha';
import { Vpc } from 'aws-cdk-lib/aws-ec2';

export class AnalyticsStack extends Stack {
    constructor(scope: App, id: string, props?: StackProps) {
        super(scope, id, props);

        const analyticsVpc = new Vpc(this, 'analytics-vpc');

        const analyticsCluster = new Cluster(this, 'analytics-cluster', {
            masterUser: {
                masterUsername: 'adminuser',
                // masterPassword: SecretValue.unsafePlainText('Password%1'),
            },
            clusterType: ClusterType.SINGLE_NODE,
            defaultDatabaseName: 'analytics',
            vpc: analyticsVpc,
        });

        analyticsCluster.connections.allowDefaultPortFromAnyIpv4();

        new RedshiftTable(this, 'saint_lake', {
            cluster: analyticsCluster,
            databaseName: 'analytics',
            tableName: 'saint_lake',
            tableColumns: [
                {
                    name: 'system_id',
                    dataType: 'BIGINT IDENTITY(1,1)',
                    sortKey: true,
                },
                {
                    name: 'id',
                    dataType: 'VARCHAR(24) NOT NULL',
                    distKey: true,
                },
                {
                    name: 'created_date',
                    dataType: 'TIMESTAMP NOT NULL',
                },
                {
                    name: 'modified_date',
                    dataType: 'TIMESTAMP NOT NULL',
                },
                {
                    name: 'active',
                    dataType: 'BOOL NOT NULL',
                },
                {
                    name: 'name',
                    dataType: 'VARCHAR(100) NOT NULL',
                },
                {
                    name: 'year_of_birth',
                    dataType: 'INT NOT NULL',
                },
                {
                    name: 'year_of_death',
                    dataType: 'INT NOT NULL',
                },
                {
                    name: 'region',
                    dataType: 'VARCHAR(100) NOT NULL',
                },
                {
                    name: 'martyred',
                    dataType: 'BOOL NOT NULL',
                },
                {
                    name: 'notes',
                    dataType: 'TEXT NULL',
                },
                {
                    name: 'has_avatar',
                    dataType: 'BOOL NOT NULL',
                },
            ],
        });
    }
}
