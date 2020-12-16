#!/bin/bash
export AWS_DEFAULT_PROFILE="$1"
export AWS_DEFAULT_REGION="$2"
export DATETODAY=$(date +%d-%m-%Y-%H-%M)
#export instance_id="i-02828f20803cf1762"
export instance_id="i-02828f20803cf1762"
export AMI_ID="$(aws ec2 create-image --instance-id $instance_id --name "ASG_NAME"-"$DATETODAY" --no-reboot)"
export LT_ID="lt-00d545c4e3da190eb"
export LT_descp="$(echo "lau-sk"-"$DATETODAY")"

if [ ! -z "$AMI_ID" ]; then
      while true; do
        export AMI_STATE="$(aws ec2 describe-images --filters Name=image-id,Values="$AMI_ID" --query 'Images[*].State')"
        if [ "$AMI_STATE" == "available" ]; then
              export desc_LT="$(aws ec2 describe-launch-template-versions --launch-template-id lt-00d545c4e3da190eb --output json --query LaunchTemplateVersions[0] > /tmp/test.json)"
              cat /tmp/test.json | jq 'del(.CreatedBy, .DefaultVersion, .VersionNumber, .CreateTime, .LaunchTemplateName)' | jq ".LaunchTemplateData.ImageId = \"$AMI_ID\" | .VersionDescription = \"$LT_descp\"" > /tmp/test1.json
              export LT_update="$(aws ec2 create-launch-template-version --cli-input-json file:///tmp/test1.json --output json --query 'LaunchTemplateVersion.VersionNumber')"
              aws ec2 modify-launch-template --launch-template-id "$LT_ID" --default-version "$LT_update"
              break
        fi
          echo "AMI creation still under progress. Retrying in 15 seconds..."
          sleep 15
      done
fi
