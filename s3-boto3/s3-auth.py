import botocore.auth
import botocore.awsrequest
import botocore.credentials


def main():
    credentials = botocore.credentials.Credentials(
        access_key="AKIAEXAMPLEACCESS",
        secret_key="exampleSecretKey1234567890",
        token=None,
        method=None,
        account_id=None,
    )

    request = botocore.awsrequest.AWSRequest(
        method="GET",
        url="https://s3.us-east-1.amazonaws.com/example-bucket/photos/cat.jpg?versionId=demo-version-id",
        headers={
            "Host": "s3.us-east-1.amazonaws.com",
            "x-amz-storage-class": "STANDARD",
            "x-amz-meta-demo": "signing-test",
        },
        data=None,
    )
    signer = botocore.auth.S3SigV4Auth(
        credentials=credentials,
        service_name="s3",
        region_name="us-east-1",
    )

    signer.add_auth(request)

    print("Signed headers:")
    for k, v in request.headers.items():
        print(f"{k}: {v}")


if __name__ == "__main__":
    main()
