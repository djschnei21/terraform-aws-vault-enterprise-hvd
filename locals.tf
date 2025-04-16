# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  vault_seal_attributes = {
    region     = var.vault_seal_awskms_region == null ? data.aws_region.current.name : var.vault_seal_awskms_region
    kms_key_id = var.vault_seal_awskms_key_arn
  }

  # Check if vm_instance_type is a Graviton instance using regex
  is_graviton_instance = can(regex("^(t4g|c6g|c7g|m6g|m7g|r6g|r7g|g5g|im4gn|is4gen)\\.", var.vm_instance_type))

  # Select AMI based on instance type, overridden by vm_image_id if provided
  launch_template_image_id = var.vm_image_id == null ? (
    local.is_graviton_instance ? data.aws_ami.ubuntu_noble_24_04_arm.id : data.aws_ami.ubuntu_noble_24_04.id
  ) : var.vm_image_id
}