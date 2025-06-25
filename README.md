# Okta Terraform Modules

This repository contains reusable Terraform modules for creating and managing Okta applications and resources. The modules support various OAuth application types including 2-leg API services and 3-leg applications (SPA, Web App, Native).

## Structure

```
poc-okta-terraform-modules/
├── main.tf                 # Root configuration with provider setup
├── variables.tf            # Root variables
├── outputs.tf              # Root outputs
├── versions.tf             # Terraform and provider versions
├── main/                   # Main orchestration module
│   ├── main.tf            # Application creation logic
│   └── outputs.tf         # Module outputs
├── modules/                # Reusable Terraform modules
│   ├── oauth_2leg/        # 2-leg OAuth API service
│   ├── spa_oidc/          # Single Page Application OIDC
│   ├── web_oidc/          # Web Application OIDC
│   ├── na_oidc/           # Native Application OIDC
│   ├── okta_group/        # Okta groups
│   ├── okta_trusted_origin/ # Trusted origins
│   └── okta_app_bookmark/ # Bookmark applications
├── vars/                   # Environment-specific variables
│   ├── dev.tfvars         # Development environment
│   ├── uat.tfvars         # UAT environment
│   └── prod.tfvars        # Production environment
└── scripts/                # Utility scripts
```

## Provider Configuration

The Okta provider is configured at the root level with version 4.20.0. Required variables:

- `okta_org_name`: Your Okta organization name
- `okta_base_url`: Okta base URL (e.g., https://your-org.okta.com)
- `okta_api_token`: Okta API token (should be passed securely)

## Usage

### 1. Environment Setup

Use the environment-specific tfvars files in the `vars/` directory:

```bash
# For development
terraform plan -var-file="vars/dev.tfvars" -var="environment=dev" -var="app_config_path=./path/to/app/config"

# For UAT
terraform plan -var-file="vars/uat.tfvars" -var="environment=uat" -var="app_config_path=./path/to/app/config"

# For production
terraform plan -var-file="vars/prod.tfvars" -var="environment=prod" -var="app_config_path=./path/to/app/config"
```

### 2. Application Configuration

Applications are configured using YAML files with the following structure:

- `metadata.yaml`: Shared application metadata
- `{environment}.yaml`: Environment-specific configuration

Example metadata.yaml:
```yaml
parent_cmdb_name: "My Application"
division_name: "DIV1"
cmdb_app_short_name: "MYAPP"
team_dl: "myapp-team@company.com"
requested_by: "john.doe@company.com"
```

Example dev.yaml:
```yaml
environment: dev
app_config:
  create_2leg: true
  create_3leg_frontend: true
  create_3leg_backend: false
  create_3leg_native: false
oauth_config:
  redirect_uris:
    - "https://myapp-dev.example.com/callback"
trusted_origins:
  - name: "MyApp Dev Origin"
    url: "https://myapp-dev.example.com"
    scopes: ["CORS", "REDIRECT"]
```

### 3. Pipeline Integration

For CI/CD pipelines, pass the API token as an environment variable:

```bash
export TF_VAR_okta_api_token="your-api-token"
terraform apply -var-file="vars/prod.tfvars" -var="environment=prod" -var="app_config_path=./app-config"
```

## Supported Application Types

### 2-leg OAuth (API Services)
- Client credentials flow
- No user interaction required
- Suitable for service-to-service communication

### 3-leg OAuth Applications
- **SPA (Single Page Application)**: Frontend applications
- **Web App**: Backend applications with server-side rendering
- **Native App**: Mobile or desktop applications

## Outputs

The modules provide outputs for:
- Application IDs
- Client IDs (sensitive)
- Client secrets (sensitive, where applicable)
- Group IDs
- Trusted origin IDs
- Bookmark application IDs

## Security Notes

- API tokens should never be committed to version control
- Use environment variables or pipeline secrets for sensitive values
- Client secrets are marked as sensitive in outputs
- Review and validate all configurations before applying

## Dependencies

- Terraform >= 1.0
- Okta Provider 4.20.0
- YAML configuration files from the configs repository

## Modules

### Application Modules
- `okta_app_oauth` - OAuth/OIDC applications
- `okta_app_saml` - SAML applications  
- `okta_app_bookmark` - Bookmark applications

### Group & Assignment Modules
- `okta_group` - Okta groups
- `okta_app_group_assignment` - Assign groups to applications
- `okta_app_user_assignment` - Assign users to applications

### Policy Modules
- `okta_policy_signon` - Sign-on policies
- `okta_policy_rule_signon` - Sign-on policy rules

### Security Modules
- `okta_trusted_origin` - Trusted origins for CORS and redirects
- `okta_network_zone` - Network zones
- `okta_auth_server` - Authorization servers

## Usage

```hcl
module "okta_oauth_app" {
  source = "git::https://github.com/your-org/poc-okta-terraform-modules.git//modules/okta_app_oauth?ref=v1.0.0"
  
  app = {
    name         = "my-app"
    label        = "My OAuth App"
    grant_types  = ["authorization_code"]
    redirect_uris = ["https://my-app.example.com/callback"]
    response_types = ["code"]
  }
}
```

## Requirements

- Terraform >= 1.0
- Okta Provider >= 4.0

## Examples

See the `examples/` directory for usage examples.

## Contributing

1. Create a feature branch
2. Make your changes
3. Update documentation
4. Submit a pull request 