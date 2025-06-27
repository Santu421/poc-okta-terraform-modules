# Okta Terraform Modules

This repository contains reusable Terraform modules for creating and managing Okta applications and resources using a metadata-driven approach. The modules support various OAuth application types including 2-leg API services and 3-leg applications (SPA, Web App, Native) with conditional resource creation.

## 🚀 Features

- **Metadata-Driven Configuration**: Centralized metadata management using YAML files
- **Object-Based Variables**: Clean variable structure using `oauth2`, `spa`, `web`, and `na` objects
- **Conditional Resources**: Optional bookmark apps and other resources based on configuration
- **Multi-Environment Support**: Environment-specific configurations with shared metadata
- **Comprehensive OAuth Support**: 2-leg API services and 3-leg applications (SPA, Web, Native)
- **Automatic Resource Management**: Groups, trusted origins, and app assignments created automatically

## 📁 Structure

```
poc-okta-terraform-modules/
├── main.tf                 # Root configuration with provider setup
├── variables.tf            # Root variables (object-based)
├── outputs.tf              # Root outputs
├── versions.tf             # Terraform and provider versions
├── main/                   # Main orchestration module
│   ├── main.tf            # Metadata parsing and application creation logic
│   ├── variables.tf       # Module variables
│   └── outputs.tf         # Module outputs
├── modules/                # Reusable Terraform modules
│   ├── oauth_2leg/        # 2-leg OAuth API service
│   ├── spa_oidc/          # Single Page Application OIDC
│   ├── web_oidc/          # Web Application OIDC
│   ├── na_oidc/           # Native Application OIDC
│   ├── okta_app_group_assignment/ # App-group assignments
│   ├── okta_group/        # Okta groups
│   └── okta_trusted_origin/ # Trusted origins
├── vars/                   # Environment-specific variables
│   ├── dev.tfvars         # Development environment (provider config)
│   ├── uat.tfvars         # UAT environment
│   └── prod.tfvars        # Production environment
└── scripts/                # Utility scripts
```

## 🔧 Provider Configuration

The Okta provider is configured at the root level with version 4.20.0. Required variables:

- `okta_org_name`: Your Okta organization name
- `okta_base_url`: Okta base URL (e.g., https://your-org.okta.com)
- `okta_api_token`: Okta API token (should be passed securely)

## 📋 Usage

### 1. Environment Setup

Use the environment-specific tfvars files in the `vars/` directory for provider configuration:

```bash
# For development
terraform plan -var-file="vars/dev.tfvars" -var="environment=dev" -var="app_config_path=./path/to/app/config"

# For UAT
terraform plan -var-file="vars/uat.tfvars" -var="environment=uat" -var="app_config_path=./path/to/app/config"

# For production
terraform plan -var-file="vars/prod.tfvars" -var="environment=prod" -var="app_config_path=./path/to/app/config"
```

### 2. Application Configuration

Applications are configured using a metadata-driven approach:

#### Metadata File (`{app-name}-metadata.yaml`)
Located at the app level (e.g., `apps/DIV1/TEST/TEST-metadata.yaml`):

```yaml
parent_cmdb_name: "Complify Application"
division: "DIV1"
cmdb_app_short_name: "TEST"
team_dl: "div4-team@company.com"
requested_by: "aadyasri@company.com"
```

#### Environment Configuration (`{app-name}-{environment}.yaml`)
Located in the environment folder (e.g., `apps/DIV1/TEST/dev/TEST-dev.yaml`):

```yaml
app_config:
  create_2leg: true
  create_3leg_frontend: true
  create_3leg_backend: true
  create_3leg_native: true
```

### 3. Application Variables (.tfvars)

Each application type has its own `.tfvars` file with object-based configuration:

#### 2-Leg API (`2leg-api.tfvars`)
```hcl
oauth2 = {
  label = "DIV1_TEST_API_SVCS"
  client_id = "DIV1_TEST_API_SVCS"
  token_endpoint_auth_method = "client_secret_basic"
  omit_secret = true
  login_mode = "DISABLED"
  hide_ios = true
  hide_web = true
  # ... other OAuth settings
}
```

#### 3-Leg SPA (`3leg-spa.tfvars`)
```hcl
spa = {
  label = "DIV1_TEST_SPA"
  client_id = "DIV1_TEST_SPA"
  token_endpoint_auth_method = "none"
  pkce_required = true
  redirect_uris = [
    "http://localhost:3000/callback",
    "http://localhost:3000/logout"
  ]
  group_name = "DIV1_TEST_SPA_ACCESS_V3"
  trusted_origin_name = "DIV1_TEST_SPA_ORIGIN_V3"
  trusted_origin_url = "http://localhost:3002"
  # Bookmark section commented out for 5-app limit
  # bookmark_label = "DIV1_TEST_SPA"
  # bookmark_url = "http://localhost:3002"
}
```

#### 3-Leg Web (`3leg-web.tfvars`)
```hcl
web = {
  label = "DIV1_TEST_WEB"
  client_id = "DIV1_TEST_WEB"
  token_endpoint_auth_method = "client_secret_basic"
  pkce_required = true
  redirect_uris = [
    "https://test-web-app.company.com/callback",
    "https://test-web-app.company.com/logout"
  ]
  group_name = "DIV1_TEST_WEB_ACCESS_V1"
  trusted_origin_name = "DIV1_TEST_WEB_ORIGIN_V1"
  trusted_origin_url = "https://test-web-app.company.com"
  # Bookmark section commented out for 5-app limit
}
```

#### 3-Leg Native (`3leg-native.tfvars`)
```hcl
na = {
  label = "DIV1_TEST_NATIVE"
  client_id = "DIV1_TEST_NATIVE"
  token_endpoint_auth_method = "client_secret_basic"
  pkce_required = true
  redirect_uris = [
    "com.test.app://callback",
    "com.test.app://logout"
  ]
  group_name = "DIV1_TEST_NATIVE_ACCESS_V1"
  trusted_origin_name = "DIV1_TEST_NATIVE_ORIGIN_V1"
  trusted_origin_url = "http://localhost:3003"
  # Bookmark section commented out for 5-app limit
}
```

### 4. Complete Deployment Example

```bash
# Deploy all application types
terraform apply \
  -var-file="../poc-okta-terraform-configs/apps/DIV1/TEST/dev/2leg-api.tfvars" \
  -var-file="../poc-okta-terraform-configs/apps/DIV1/TEST/dev/3leg-spa.tfvars" \
  -var-file="../poc-okta-terraform-configs/apps/DIV1/TEST/dev/3leg-web.tfvars" \
  -var-file="../poc-okta-terraform-configs/apps/DIV1/TEST/dev/3leg-native.tfvars" \
  -var-file="vars/dev.tfvars" \
  -var="app_config_path=../poc-okta-terraform-configs/apps/DIV1/TEST" \
  -var="environment=dev" \
  -auto-approve
```

## 🏗️ Supported Application Types

### 2-leg OAuth (API Services)
- **Purpose**: Service-to-service communication
- **Flow**: Client credentials flow
- **Features**: No user interaction, automatic client secret rotation
- **Use Case**: Backend APIs, microservices

### 3-leg OAuth Applications
- **SPA (Single Page Application)**: Frontend applications
  - PKCE required
  - No client secret (public client)
  - Browser-based redirects
- **Web App**: Backend applications with server-side rendering
  - Client secret authentication
  - Server-side redirects
  - Refresh token support
- **Native App**: Mobile or desktop applications
  - PKCE required
  - Custom URI schemes
  - Password grant support

## 🔄 Conditional Resources

The modules support conditional resource creation:

- **Bookmark Apps**: Optional admin access apps (can be disabled for app limits)
- **Groups**: Automatically created for access control
- **Trusted Origins**: Required for CORS and redirects
- **App Assignments**: Automatic group-to-app assignments

## 📤 Outputs

The modules provide comprehensive outputs:

```hcl
# Application outputs
output "oauth2_app_id" { value = module.main.module.oauth_2leg[0].okta_app_oauth.oauth_2leg.id }
output "spa_app_id" { value = module.main.module.oauth_3leg_frontend[0].okta_app_oauth.spa_oidc.id }
output "web_app_id" { value = module.main.module.oauth_3leg_backend[0].okta_app_oauth.web_oidc.id }
output "native_app_id" { value = module.main.module.oauth_3leg_native[0].okta_app_oauth.na_oidc.id }

# Client IDs (sensitive)
output "oauth2_client_id" { value = module.main.module.oauth_2leg[0].okta_app_oauth.oauth_2leg.client_id }
output "spa_client_id" { value = module.main.module.oauth_3leg_frontend[0].okta_app_oauth.spa_oidc.client_id }

# Group outputs
output "spa_group_id" { value = module.main.module.oauth_3leg_frontend[0].okta_group.spa_oidc_group.id }
output "web_group_id" { value = module.main.module.oauth_3leg_backend[0].okta_group.web_oidc_group.id }
output "native_group_id" { value = module.main.module.oauth_3leg_native[0].okta_group.na_oidc_group.id }

# Trusted origin outputs
output "spa_origin_id" { value = module.main.module.oauth_3leg_frontend[0].okta_trusted_origin.spa_oidc_origin.id }
output "web_origin_id" { value = module.main.module.oauth_3leg_backend[0].okta_trusted_origin.web_oidc_origin.id }
output "native_origin_id" { value = module.main.module.oauth_3leg_native[0].okta_trusted_origin.na_oidc_origin.id }
```

## 🔒 Security Features

- **Sensitive Outputs**: Client secrets and API tokens marked as sensitive
- **Conditional Secrets**: `omit_secret` option for public clients
- **Environment Isolation**: Separate configurations per environment
- **Metadata Validation**: Centralized metadata with validation
- **Access Control**: Automatic group creation and assignments

## 🛠️ Dependencies

- **Terraform**: >= 1.0
- **Okta Provider**: 4.20.0
- **YAML Configuration**: From the configs repository
- **Metadata Files**: App-level metadata with environment-specific configs

## 🚀 Pipeline Integration

For CI/CD pipelines, use environment variables for sensitive data:

```bash
export TF_VAR_okta_api_token="your-api-token"
terraform apply \
  -var-file="vars/prod.tfvars" \
  -var="environment=prod" \
  -var="app_config_path=./app-config" \
  -auto-approve
```

## 📚 Examples

See the `poc-okta-terraform-configs` repository for complete examples:
- `apps/DIV1/TEST/` - Complete TEST application with all app types
- `templates/` - Template files for different application types
- `scripts/` - Validation and deployment scripts

## 🔧 Development

### Branch Strategy
- `main` - Production-ready code
- `develop` - Integration branch
- `develop_2x` - Feature development branch

### Validation Scripts
```bash
# Validate all apps
./scripts/validate-all-apps.sh

# Validate specific app
./scripts/validate-app-config.sh apps/DIV1/TEST/dev/TEST-dev.yaml

# Generate Terraform from YAML
./scripts/generate-terraform.sh apps/DIV1/TEST/dev/TEST-dev.yaml
```

## 🤝 Contributing

1. Create a feature branch from `develop`
2. Make your changes with proper validation
3. Update documentation
4. Test with validation scripts
5. Submit a pull request

## 📝 Notes

- **App Limits**: Some Okta tenants have app limits (e.g., 5 apps for dev)
- **Bookmark Apps**: Can be disabled by commenting out bookmark sections
- **Metadata Path**: Must point to app directory, not environment directory
- **State Management**: Use separate state files per environment
- **Cleanup**: Always destroy resources before recreating to avoid conflicts

## 🔗 Related Repositories

- [poc-okta-terraform-configs](https://github.com/Santu421/poc-okta-terraform-configs) - Application configurations and metadata 