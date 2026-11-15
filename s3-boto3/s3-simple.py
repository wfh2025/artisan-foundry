import pprint

import boto3
import botocore.config
import botocore.endpoint

s3_config = {
    'bucket_name': 'haha',
}

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
        # proxies=None,
        # proxies_config=None,
        s3={
            # 'use_accelerate_endpoint': True,
            'payload_signing_enabled': True,
            'addressing_style': 'auto',
            # 'us_east_1_regional_endpoint': 'legacy',
            # 's3_disable_express_session_auth': None,
        },
        # s3_disable_express_session_auth=None,
        retries={
            'total_max_attempts': 1,
            'max_attempts': 0,
            'mode': 'adaptive',
        },
        # client_cert=None,
        # inject_host_prefix=None,
        # endpoint_discovery_enabled=None,
        # use_dualstack_endpoint=None,
        # use_fips_endpoint=None,
        # ignore_configured_endpoint_urls=None,
        # defaults_mode='legacy',
        tcp_keepalive=None,
        # request_min_compression_size_bytes=None,
        # disable_request_compression=None,
        # client_context_params=None,
        # sigv4a_signing_region_set=None,
        # request_checksum_calculation=None,
        # response_checksum_validation=None,
        # account_id_endpoint_mode=None,
        # auth_scheme_preference=None,
    ),
    aws_account_id=None,
)


def upload_file():
    file_path = "/s3-auth.py"
    key = "key-aws-sdk-cpp.tar.gz"
    client.upload_file(file_path, s3_config["bucket_name"], key)


def list_objects():
    resp = client.list_objects(
        Bucket=s3_config["bucket_name"],
        Delimiter='/',
        EncodingType='url',
        Marker='abcd',
        MaxKeys=123,
        Prefix='8!@#$%^&*()/98',
    )
    pprint.pprint(resp)


def put_object():
    resp = client.put_object(
        Bucket=s3_config["bucket_name"],
        Key='a/b/c.txt',
        Body=b"Hello World"
    )
    pprint.pprint(resp)


if __name__ == "__main__":
    put_object()
