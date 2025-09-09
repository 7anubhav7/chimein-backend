#!/usr/bin/env bash
set -euo pipefail

# Ensure ENV_TYPE is set
if [[ -z "${ENV_TYPE:-}" ]]; then
  echo "❌ ENV_TYPE not set. Exiting."
  exit 1
fi

# Get all ASGs with Type=$ENV_TYPE
ASGS=$(aws autoscaling describe-auto-scaling-groups \
  --no-paginate \
  --query "AutoScalingGroups[?Tags[?Key=='Type' && Value=='${ENV_TYPE}']].AutoScalingGroupName" \
  --output text)

if [[ -z "$ASGS" ]]; then
  echo "⚠️  No Auto Scaling Groups found with tag Type=$ENV_TYPE"
  exit 0
fi

for ASG in $ASGS; do
  echo "🗑 Deleting Auto Scaling Group: $ASG"
  aws autoscaling delete-auto-scaling-group \
    --auto-scaling-group-name "$ASG" \
    --force-delete
done
