## Intro

## Usage

## Improvements
    - To keep API integrations private for services in AWS/on-prem/over-direct-connect
        - private + performant
        - public API backed by private services (VPC, EC2, lambda, ECS)
            REF: - https://aws.amazon.com/blogs/compute/introducing-amazon-api-gateway-private-endpoints/
            
## Tricks:
    - "Removing a hop"  - Integration Flow:
        Method requests can be validated, modeled, or transformed (static values, add new headers)
        Integration request is done next (s3, dynamo, etc)
            - Instead of having event data go from api -> lambda -> dynamoDB, why not just api -> dynamoDB, skip a hop
            - You can also validate, model or transform requests going out (Method response)
                - Ensure good data return for client
            - Validate event data coming in using API
        Example: 
            - 10m requests come in, we pay for 9m, if we validate at the lambda, we incur additional invocations
            - INSTEAD: have the API gateway do the validating, etc, if possible (reduce a hop)
    - $-Note: 400,000 GB memory for free per account?
    - auth + auth
        - open (wide-open), IAM permissions, cognito authorizer
        - lambda; can validate bearer token, OAuth or SAML
    - VPC links
    - api gateway management
        - multi-staged: dev/beta/prod all aliases to different versions of same code
        - mono-staged layered: dev/beta/prod all split into individual accounts, which have multiple versions v1,v2,v3
    - canary releases
    - WAF
    - custom domains
        - supports wildcard domains towards a layered approach dev -> api-gw1, beta -> api-gw2, etc
        
    