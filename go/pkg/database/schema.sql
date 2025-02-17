CREATE TABLE `apis` (
	`id` varchar(256) NOT NULL,
	`name` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`ip_whitelist` varchar(512),
	`auth_type` enum('key','jwt'),
	`key_auth_id` varchar(256),
	`created_at` datetime(3),
	`deleted_at` datetime(3),
	`delete_protection` boolean DEFAULT false,
	CONSTRAINT `apis_id` PRIMARY KEY(`id`),
	CONSTRAINT `apis_key_auth_id_unique` UNIQUE(`key_auth_id`)
);

CREATE TABLE `keys_permissions` (
	`temp_id` bigint AUTO_INCREMENT NOT NULL,
	`key_id` varchar(256) NOT NULL,
	`permission_id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `keys_permissions_key_id_permission_id_workspace_id` PRIMARY KEY(`key_id`,`permission_id`,`workspace_id`),
	CONSTRAINT `keys_permissions_temp_id_unique` UNIQUE(`temp_id`),
	CONSTRAINT `key_id_permission_id_idx` UNIQUE(`key_id`,`permission_id`)
);

CREATE TABLE `keys_roles` (
	`key_id` varchar(256) NOT NULL,
	`role_id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `keys_roles_role_id_key_id_workspace_id` PRIMARY KEY(`role_id`,`key_id`,`workspace_id`),
	CONSTRAINT `unique_key_id_role_id` UNIQUE(`key_id`,`role_id`)
);

CREATE TABLE `permissions` (
	`id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`name` varchar(512) NOT NULL,
	`description` varchar(512),
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `permissions_id` PRIMARY KEY(`id`),
	CONSTRAINT `unique_name_per_workspace_idx` UNIQUE(`name`,`workspace_id`)
);

CREATE TABLE `roles` (
	`id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`name` varchar(512) NOT NULL,
	`description` varchar(512),
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `roles_id` PRIMARY KEY(`id`),
	CONSTRAINT `unique_name_per_workspace_idx` UNIQUE(`name`,`workspace_id`)
);

CREATE TABLE `roles_permissions` (
	`role_id` varchar(256) NOT NULL,
	`permission_id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`updated_at` datetime(3),
	`created_at` datetime(3) NOT NULL,
	CONSTRAINT `roles_permissions_role_id_permission_id_workspace_id` PRIMARY KEY(`role_id`,`permission_id`,`workspace_id`),
	CONSTRAINT `unique_tuple_permission_id_role_id` UNIQUE(`permission_id`,`role_id`)
);

CREATE TABLE `key_auth` (
	`id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`created_at` datetime(3),
	`deleted_at` datetime(3),
	`created_at_m` bigint NOT NULL DEFAULT 0,
	`updated_at_m` bigint,
	`deleted_at_m` bigint,
	`store_encrypted_keys` boolean NOT NULL DEFAULT false,
	`default_prefix` varchar(8),
	`default_bytes` int DEFAULT 16,
	`size_approx` int NOT NULL DEFAULT 0,
	`size_last_updated_at` bigint NOT NULL DEFAULT 0,
	CONSTRAINT `key_auth_id` PRIMARY KEY(`id`)
);

CREATE TABLE `encrypted_keys` (
	`workspace_id` varchar(256) NOT NULL,
	`key_id` varchar(256) NOT NULL,
	`encrypted` varchar(1024) NOT NULL,
	`encryption_key_id` varchar(256) NOT NULL,
	CONSTRAINT `key_id_idx` UNIQUE(`key_id`)
);

CREATE TABLE `keys` (
	`id` varchar(256) NOT NULL,
	`key_auth_id` varchar(256) NOT NULL,
	`hash` varchar(256) NOT NULL,
	`start` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`for_workspace_id` varchar(256),
	`name` varchar(256),
	`owner_id` varchar(256),
	`identity_id` varchar(256),
	`meta` text,
	`created_at` datetime(3) NOT NULL,
	`expires` datetime(3),
	`created_at_m` bigint NOT NULL DEFAULT 0,
	`updated_at_m` bigint,
	`deleted_at_m` bigint,
	`deleted_at` datetime(3),
	`refill_day` tinyint,
	`refill_amount` int,
	`last_refill_at` datetime(3),
	`enabled` boolean NOT NULL DEFAULT true,
	`remaining_requests` int,
	`ratelimit_async` boolean,
	`ratelimit_limit` int,
	`ratelimit_duration` bigint,
	`environment` varchar(256),
	CONSTRAINT `keys_id` PRIMARY KEY(`id`),
	CONSTRAINT `hash_idx` UNIQUE(`hash`)
);

CREATE TABLE `vercel_bindings` (
	`id` varchar(256) NOT NULL,
	`integration_id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`project_id` varchar(256) NOT NULL,
	`environment` enum('development','preview','production') NOT NULL,
	`resource_id` varchar(256) NOT NULL,
	`resource_type` enum('rootKey','apiId') NOT NULL,
	`vercel_env_id` varchar(256) NOT NULL,
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3) NOT NULL,
	`deleted_at` datetime(3),
	`last_edited_by` varchar(256) NOT NULL,
	CONSTRAINT `vercel_bindings_id` PRIMARY KEY(`id`),
	CONSTRAINT `project_environment_resource_type_idx` UNIQUE(`project_id`,`environment`,`resource_type`)
);

CREATE TABLE `vercel_integrations` (
	`id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`team_id` varchar(256),
	`access_token` varchar(256) NOT NULL,
	`created_at` datetime(3),
	`deleted_at` datetime(3),
	CONSTRAINT `vercel_integrations_id` PRIMARY KEY(`id`)
);

CREATE TABLE `ratelimit_namespaces` (
	`id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`name` varchar(512) NOT NULL,
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	`deleted_at` datetime,
	CONSTRAINT `ratelimit_namespaces_id` PRIMARY KEY(`id`),
	CONSTRAINT `unique_name_per_workspace_idx` UNIQUE(`name`,`workspace_id`)
);

CREATE TABLE `ratelimit_overrides` (
	`id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`namespace_id` varchar(256) NOT NULL,
	`identifier` varchar(512) NOT NULL,
	`limit` int NOT NULL,
	`duration` int NOT NULL,
	`async` boolean,
	`sharding` enum('edge'),
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	`deleted_at` datetime(3),
	CONSTRAINT `ratelimit_overrides_id` PRIMARY KEY(`id`),
	CONSTRAINT `unique_identifier_per_namespace_idx` UNIQUE(`identifier`,`namespace_id`)
);

CREATE TABLE `workspaces` (
	`id` varchar(256) NOT NULL,
	`tenant_id` varchar(256) NOT NULL,
	`name` varchar(256) NOT NULL,
	`created_at` datetime(3),
	`deleted_at` datetime(3),
	`plan` enum('free','pro','enterprise') DEFAULT 'free',
	`stripe_customer_id` varchar(256),
	`stripe_subscription_id` varchar(256),
	`trial_ends` datetime(3),
	`beta_features` json NOT NULL,
	`features` json NOT NULL,
	`plan_locked_until` datetime(3),
	`plan_downgrade_request` enum('free'),
	`plan_changed` datetime(3),
	`subscriptions` json,
	`enabled` boolean NOT NULL DEFAULT true,
	`delete_protection` boolean DEFAULT false,
	CONSTRAINT `workspaces_id` PRIMARY KEY(`id`),
	CONSTRAINT `tenant_id_idx` UNIQUE(`tenant_id`)
);

CREATE TABLE `secrets` (
	`id` varchar(256) NOT NULL,
	`name` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`encrypted` varchar(1024) NOT NULL,
	`encryption_key_id` varchar(256) NOT NULL,
	`created_at` bigint NOT NULL,
	`updated_at` bigint,
	`comment` varchar(256),
	CONSTRAINT `secrets_id` PRIMARY KEY(`id`),
	CONSTRAINT `unique_workspace_id_name_idx` UNIQUE(`workspace_id`,`name`)
);

CREATE TABLE `gateway_header_rewrites` (
	`id` varchar(256) NOT NULL,
	`name` varchar(256) NOT NULL,
	`secret_id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`gateways_id` varchar(256) NOT NULL,
	`created_at` datetime(3),
	`deleted_at` datetime(3),
	CONSTRAINT `gateway_header_rewrites_id` PRIMARY KEY(`id`)
);

CREATE TABLE `gateways` (
	`id` varchar(256) NOT NULL,
	`name` varchar(128) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`origin` varchar(256) NOT NULL,
	`created_at` datetime(3),
	`deleted_at` datetime(3),
	CONSTRAINT `gateways_id` PRIMARY KEY(`id`),
	CONSTRAINT `gateways_name_unique` UNIQUE(`name`)
);

CREATE TABLE `webhook_delivery_attempts` (
	`id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`webhook_id` varchar(256) NOT NULL,
	`event_id` varchar(256) NOT NULL,
	`time` bigint NOT NULL,
	`attempt` int NOT NULL,
	`next_attempt_at` bigint,
	`success` boolean NOT NULL,
	`internal_error` varchar(512),
	`response_status` int,
	`response_body` varchar(1000),
	CONSTRAINT `webhook_delivery_attempts_id` PRIMARY KEY(`id`)
);

CREATE TABLE `events` (
	`id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`webhook_id` varchar(256) NOT NULL,
	`event` enum('verifications.usage.record','xx') NOT NULL,
	`time` bigint NOT NULL,
	`payload` json NOT NULL,
	`state` enum('created','retrying','delivered','failed') NOT NULL DEFAULT 'created',
	`created_at` bigint NOT NULL,
	`updated_at` bigint,
	CONSTRAINT `events_id` PRIMARY KEY(`id`)
);

CREATE TABLE `webhooks` (
	`id` varchar(256) NOT NULL,
	`destination` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`enabled` boolean NOT NULL DEFAULT true,
	`created_at` bigint NOT NULL,
	`updated_at` bigint,
	`encrypted` varchar(1024) NOT NULL,
	`encryption_key_id` varchar(256) NOT NULL,
	CONSTRAINT `webhooks_id` PRIMARY KEY(`id`)
);

CREATE TABLE `usage_reporters` (
	`id` varchar(256) NOT NULL,
	`webhook_id` varchar(256) NOT NULL,
	`key_space_id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`interval` bigint NOT NULL,
	`high_water_mark` bigint NOT NULL DEFAULT 0,
	`next_execution` bigint NOT NULL,
	`created_at` bigint NOT NULL,
	`updated_at` bigint,
	CONSTRAINT `usage_reporters_id` PRIMARY KEY(`id`)
);

CREATE TABLE `llm_gateways` (
	`id` varchar(256) NOT NULL,
	`name` varchar(128) NOT NULL,
	`subdomain` varchar(128) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`created_at` bigint NOT NULL,
	`updated_at` bigint,
	CONSTRAINT `llm_gateways_id` PRIMARY KEY(`id`),
	CONSTRAINT `llm_gateways_subdomain_unique` UNIQUE(`subdomain`)
);

CREATE TABLE `key_migration_errors` (
	`id` varchar(256) NOT NULL,
	`migration_id` varchar(256) NOT NULL,
	`created_at` bigint NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`message` json NOT NULL,
	CONSTRAINT `key_migration_errors_id` PRIMARY KEY(`id`)
);

CREATE TABLE `identities` (
	`id` varchar(256) NOT NULL,
	`external_id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`environment` varchar(256) NOT NULL DEFAULT 'default',
	`created_at` bigint NOT NULL,
	`updated_at` bigint,
	`meta` json,
	CONSTRAINT `identities_id` PRIMARY KEY(`id`),
	CONSTRAINT `external_id_workspace_id_idx` UNIQUE(`external_id`,`workspace_id`)
);

CREATE TABLE `ratelimits` (
	`id` varchar(256) NOT NULL,
	`name` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`created_at` bigint NOT NULL,
	`updated_at` bigint,
	`key_id` varchar(256),
	`identity_id` varchar(256),
	`limit` int NOT NULL,
	`duration` bigint NOT NULL,
	CONSTRAINT `ratelimits_id` PRIMARY KEY(`id`),
	CONSTRAINT `unique_name_idx` UNIQUE(`name`,`key_id`,`identity_id`)
);

CREATE TABLE `audit_log` (
	`id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`bucket_id` varchar(256) NOT NULL,
	`event` varchar(256) NOT NULL,
	`time` bigint NOT NULL,
	`display` varchar(256) NOT NULL,
	`remote_ip` varchar(256),
	`user_agent` varchar(256),
	`actor_type` varchar(256) NOT NULL,
	`actor_id` varchar(256) NOT NULL,
	`actor_name` varchar(256),
	`actor_meta` json,
	`created_at` bigint NOT NULL,
	`updated_at` bigint,
	CONSTRAINT `audit_log_id` PRIMARY KEY(`id`)
);

CREATE TABLE `audit_log_bucket` (
	`id` varchar(256) NOT NULL,
	`workspace_id` varchar(256) NOT NULL,
	`name` varchar(256) NOT NULL,
	`retention_days` int,
	`created_at` bigint NOT NULL,
	`updated_at` bigint,
	`delete_protection` boolean DEFAULT false,
	CONSTRAINT `audit_log_bucket_id` PRIMARY KEY(`id`),
	CONSTRAINT `unique_name_per_workspace_idx` UNIQUE(`workspace_id`,`name`)
);

CREATE TABLE `audit_log_target` (
	`workspace_id` varchar(256) NOT NULL,
	`bucket_id` varchar(256) NOT NULL,
	`audit_log_id` varchar(256) NOT NULL,
	`display_name` varchar(256) NOT NULL,
	`type` varchar(256) NOT NULL,
	`id` varchar(256) NOT NULL,
	`name` varchar(256),
	`meta` json,
	`created_at` bigint NOT NULL,
	`updated_at` bigint,
	CONSTRAINT `audit_log_target_audit_log_id_id_pk` PRIMARY KEY(`audit_log_id`,`id`)
);
