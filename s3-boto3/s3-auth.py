"""演示 botocore SigV4 手工签名 S3 请求."""

import logging
import sys

import botocore.auth
import botocore.awsrequest
import botocore.credentials

logging.basicConfig(
    level=logging.INFO,
    format=(
        '[%(asctime)s.%(msecs)03d] [%(levelname)s] [%(process)d] '
        '[%(threadName)s] [%(filename)s:%(funcName)s:%(lineno)d] %(message)s'
    ),
    datefmt='%Y-%m-%d %H:%M:%S',
    handlers=[logging.StreamHandler(sys.stdout)],
    force=True,
)

logger = logging.getLogger(__name__)


def main() -> None:
    """对示例请求做 S3SigV4Auth 签名并打印结果头."""
    credentials = botocore.credentials.Credentials(
        access_key='AKIAEXAMPLEACCESS',
        secret_key='exampleSecretKey1234567890',  # noqa: S106 演示用假密钥
        token=None,
        method=None,
        account_id=None,
    )

    request = botocore.awsrequest.AWSRequest(
        method='GET',
        url='https://s3.us-east-1.amazonaws.com/example-bucket/photos/cat.jpg?versionId=demo-version-id',
        headers={
            'Host': 's3.us-east-1.amazonaws.com',
            'x-amz-storage-class': 'STANDARD',
            'x-amz-meta-demo': 'signing-test',
        },
        data=None,
    )
    signer = botocore.auth.S3SigV4Auth(
        credentials=credentials,
        service_name='s3',
        region_name='us-east-1',
    )

    signer.add_auth(request)

    logger.info('Signed headers:')
    for k, v in request.headers.items():
        logger.info('%s: %s', k, v)


if __name__ == '__main__':
    main()
