import datetime
import logging
import pprint
import sys

import boto3
import botocore.config
import botocore.endpoint

s3_config = {'bucket_name': 'haha', }

# 配置参考: https://docs.aws.amazon.com/botocore/latest/reference/config.html
client = boto3.client(
    service_name='s3',
    region_name=None,
    api_version=None,
    use_ssl=True,
    verify=None,
    endpoint_url='https://192.168.3.10:12538',
    aws_access_key_id='abcdefg',
    aws_secret_access_key='hjklmn',
    aws_session_token=None,
    config=botocore.config.Config(
        region_name=None,
        signature_version=None,
        user_agent=None,
        user_agent_extra=None,
        user_agent_appid=None,
        connect_timeout=botocore.endpoint.DEFAULT_TIMEOUT,
        read_timeout=botocore.endpoint.DEFAULT_TIMEOUT,
        parameter_validation=True,
        max_pool_connections=botocore.endpoint.MAX_POOL_CONNECTIONS,
        proxies=None,
        proxies_config=None,
        s3={
            'use_accelerate_endpoint': True,
            'payload_signing_enabled': True,
            'addressing_style': 'auto',
            'us_east_1_regional_endpoint': 'legacy',
            's3_disable_express_session_auth': None,
        },
        s3_disable_express_session_auth=None,
        retries={
            'total_max_attempts': 1,
            'max_attempts': 0,
            'mode': 'adaptive',
        },
        client_cert=None,
        inject_host_prefix=None,
        endpoint_discovery_enabled=None,
        use_dualstack_endpoint=None,
        use_fips_endpoint=None,
        ignore_configured_endpoint_urls=None,
        defaults_mode='legacy', tcp_keepalive=None,
        request_min_compression_size_bytes=None,
        disable_request_compression=None,
        client_context_params=None,
        sigv4a_signing_region_set=None,
        request_checksum_calculation=None,
        response_checksum_validation=None,
        account_id_endpoint_mode=None,
        auth_scheme_preference=None,
    ),
    aws_account_id=None,
)

logging.basicConfig(
    level=logging.INFO,
    format="[%(asctime)s.%(msecs)03d] [%(levelname)s] [%(process)d] [%(threadName)s] [%(filename)s:%(funcName)s:%(lineno)d] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    handlers=[logging.StreamHandler(sys.stdout)],
    force=True,
)

logger = logging.getLogger(__name__)


def upload_file():
    file_path = "/s3-auth.py"
    key = "key-aws-sdk-cpp.tar.gz"
    client.upload_file(file_path, s3_config["bucket_name"], key)


def list_objects():
    resp = client.list_objects(Bucket=s3_config["bucket_name"], Delimiter='/', EncodingType='url', Marker='abcd',
                               MaxKeys=123, Prefix='8!@#$%^&*()/98', )
    pprint.pprint(resp)


def put_object():
    logger.info(''.center(100, '-'))
    resp = client.put_object(Bucket=s3_config["bucket_name"], Key='a/b/c.txt', Body=b"Hello World")
    pprint.pprint(resp)


def abort_multipart_upload():
    logger.info(''.center(100, '-'))
    resp = client.abort_multipart_upload(
        Bucket='string',
        Key='string',
        UploadId='string',
        RequestPayer='requester',
        ExpectedBucketOwner='string',
        IfMatchInitiatedTime=datetime.datetime(2015, 1, 1)
    )
    pprint.pprint(resp)


def complete_multipart_upload():
    logger.info(''.center(100, '-'))
    resp = client.complete_multipart_upload(
        Bucket='string',
        Key='string',
        MultipartUpload={
            'Parts': [
                {
                    'ETag': 'string',
                    'ChecksumCRC32': 'string',
                    'ChecksumCRC32C': 'string',
                    'ChecksumCRC64NVME': 'string',
                    'ChecksumSHA1': 'string',
                    'ChecksumSHA256': 'string',
                    'ChecksumSHA512': 'string',
                    'ChecksumMD5': 'string',
                    'ChecksumXXHASH64': 'string',
                    'ChecksumXXHASH3': 'string',
                    'ChecksumXXHASH128': 'string',
                    'PartNumber': 123
                },
            ]
        },
        UploadId='string',
        ChecksumCRC32='string',
        ChecksumCRC32C='string',
        ChecksumCRC64NVME='string',
        ChecksumSHA1='string',
        ChecksumSHA256='string',
        ChecksumSHA512='string',
        ChecksumMD5='string',
        ChecksumXXHASH64='string',
        ChecksumXXHASH3='string',
        ChecksumXXHASH128='string',
        ChecksumType='COMPOSITE',
        MpuObjectSize=123,
        RequestPayer='requester',
        ExpectedBucketOwner='string',
        IfMatch='string',
        IfNoneMatch='string',
        SSECustomerAlgorithm='string',
        SSECustomerKey='string',
    )
    pprint.pprint(resp)


def create_multipart_upload():
    logger.info(''.center(100, '-'))
    resp = client.create_multipart_upload(
        ACL='public-read-write',
        Bucket='string',
        CacheControl='string',
        ContentDisposition='string',
        ContentEncoding='string',
        ContentLanguage='string',
        ContentType='string',
        Expires=datetime.datetime(2015, 1, 1),
        GrantFullControl='string',
        GrantRead='string',
        GrantReadACP='string',
        GrantWriteACP='string',
        Key='string',
        Metadata={
            'string': 'string'
        },
        ServerSideEncryption='AES256',
        StorageClass='STANDARD',
        WebsiteRedirectLocation='string',
        SSECustomerAlgorithm='string',
        SSECustomerKey='string',
        SSEKMSKeyId='string',
        SSEKMSEncryptionContext='string',
        BucketKeyEnabled=True,
        RequestPayer='requester',
        Tagging='string',
        ObjectLockMode='GOVERNANCE',
        ObjectLockRetainUntilDate=datetime.datetime(2015, 1, 1),
        ObjectLockLegalHoldStatus='ON',
        ExpectedBucketOwner='string',
        ChecksumAlgorithm='CRC32',
        ChecksumType='COMPOSITE',
    )
    pprint.pprint(resp)


def delete_object():
    logger.info(''.center(100, '-'))
    resp = client.delete_object(
        Bucket='string',
        Key='string',
        MFA='string',
        VersionId='string',
        RequestPayer='requester',
        BypassGovernanceRetention=True,
        ExpectedBucketOwner='string',
        IfMatch='string',
        IfMatchLastModifiedTime=datetime.datetime(2015, 1, 1),
        IfMatchSize=123
    )
    pprint.pprint(resp)


def delete_objects():
    logger.info(''.center(100, '-'))
    resp = client.delete_objects(
        Bucket='string',
        Delete={
            'Objects': [
                {
                    'Key': 'string',
                    'VersionId': 'string',
                    'ETag': 'string',
                    'LastModifiedTime': datetime.datetime(2015, 1, 1),
                    'Size': 123
                },
            ],
            'Quiet': True,
        },
        MFA='string',
        RequestPayer='requester',
        BypassGovernanceRetention=True,
        ExpectedBucketOwner='string',
        ChecksumAlgorithm='CRC32',
    )
    pprint.pprint(resp)


def delete_object_tagging():
    logger.info(''.center(100, '-'))
    resp = client.delete_object_tagging(
        Bucket='string',
        Key='string',
        VersionId='string',
        ExpectedBucketOwner='string'
    )
    pprint.pprint(resp)


def get_object():
    logger.info(''.center(100, '-'))
    resp = client.get_object(
        Bucket='string',
        IfMatch='string',
        IfModifiedSince=datetime.datetime(2015, 1, 1),
        IfNoneMatch='string',
        IfUnmodifiedSince=datetime.datetime(2015, 1, 1),
        Key='string',
        Range='string',
        ResponseCacheControl='string',
        ResponseContentDisposition='string',
        ResponseContentEncoding='string',
        ResponseContentLanguage='string',
        ResponseContentType='string',
        ResponseExpires=datetime.datetime(2015, 1, 1),
        VersionId='string',
        SSECustomerAlgorithm='string',
        SSECustomerKey='string',
        RequestPayer='requester',
        PartNumber=123,
        ExpectedBucketOwner='string',
        ChecksumMode='ENABLED'
    )
    pprint.pprint(resp)


def get_object_tagging():
    logger.info(''.center(100, '-'))
    resp = client.get_object_tagging(
        Bucket='string',
        Key='string',
        VersionId='string',
        ExpectedBucketOwner='string',
        RequestPayer='requester'
    )
    pprint.pprint(resp)


def head_object():
    logger.info(''.center(100, '-'))
    resp = client.head_object(
        Bucket='string',
        IfMatch='string',
        IfModifiedSince=datetime.datetime(2015, 1, 1),
        IfNoneMatch='string',
        IfUnmodifiedSince=datetime.datetime(2015, 1, 1),
        Key='string',
        Range='string',
        ResponseCacheControl='string',
        ResponseContentDisposition='string',
        ResponseContentEncoding='string',
        ResponseContentLanguage='string',
        ResponseContentType='string',
        ResponseExpires=datetime.datetime(2015, 1, 1),
        VersionId='string',
        SSECustomerAlgorithm='string',
        SSECustomerKey='string',
        RequestPayer='requester',
        PartNumber=123,
        ExpectedBucketOwner='string',
        ChecksumMode='ENABLED'
    )
    pprint.pprint(resp)


def list_multipart_uploads():
    logger.info(''.center(100, '-'))
    resp = client.list_multipart_uploads(
        Bucket='string',
        Delimiter='string',
        EncodingType='url',
        KeyMarker='string',
        MaxUploads=123,
        Prefix='string',
        UploadIdMarker='string',
        ExpectedBucketOwner='string',
        RequestPayer='requester'
    )
    pprint.pprint(resp)


def list_object_versions():
    logger.info(''.center(100, '-'))
    resp = client.list_object_versions(
        Bucket='string',
        Delimiter='string',
        EncodingType='url',
        KeyMarker='string',
        MaxKeys=123,
        Prefix='string',
        VersionIdMarker='string',
        ExpectedBucketOwner='string',
        RequestPayer='requester',
        OptionalObjectAttributes=[
            'RestoreStatus',
        ]
    )
    pprint.pprint(resp)


def list_objects_v2():
    logger.info(''.center(100, '-'))
    resp = client.list_objects_v2(
        Bucket='string',
        Delimiter='string',
        EncodingType='url',
        MaxKeys=123,
        Prefix='string',
        ContinuationToken='string',
        FetchOwner=True,
        StartAfter='string',
        RequestPayer='requester',
        ExpectedBucketOwner='string',
        OptionalObjectAttributes=[
            'RestoreStatus',
        ]
    )
    pprint.pprint(resp)


def list_parts():
    logger.info(''.center(100, '-'))
    resp = client.list_parts(
        Bucket='string',
        Key='string',
        MaxParts=123,
        PartNumberMarker=123,
        UploadId='string',
        RequestPayer='requester',
        ExpectedBucketOwner='string',
        SSECustomerAlgorithm='string',
        SSECustomerKey='string',
    )
    pprint.pprint(resp)


def put_object_tagging():
    logger.info(''.center(100, '-'))
    resp = client.put_object_tagging(
        Bucket='string',
        Key='string',
        VersionId='string',
        ContentMD5='string',
        ChecksumAlgorithm='CRC32',
        Tagging={
            'TagSet': [
                {
                    'Key': 'string',
                    'Value': 'string'
                },
            ]
        },
        ExpectedBucketOwner='string',
        RequestPayer='requester'
    )
    pprint.pprint(resp)


def upload_part():
    logger.info(''.center(100, '-'))
    response = client.upload_part(
        Body=b'bytes',
        Bucket='string',
        ContentLength=123,
        ContentMD5='string',
        ChecksumAlgorithm='CRC32',
        ChecksumCRC32='string',
        ChecksumCRC32C='string',
        ChecksumCRC64NVME='string',
        ChecksumSHA1='string',
        ChecksumSHA256='string',
        ChecksumSHA512='string',
        ChecksumMD5='string',
        ChecksumXXHASH64='string',
        ChecksumXXHASH3='string',
        ChecksumXXHASH128='string',
        Key='string',
        PartNumber=123,
        UploadId='string',
        SSECustomerAlgorithm='string',
        SSECustomerKey='string',
        RequestPayer='requester',
        ExpectedBucketOwner='string'
    )
    pprint.pprint(response)


def main():
    put_object()


if __name__ == '__main__':
    main()
