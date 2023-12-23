#! /bin/bash
# entrypoint.sh
SSM_ACTIVATION_CODE=$(cat /run/secrets/ssm_activation_code)
SSM_ACTIVATION_ID=$(cat /run/secrets/ssm_activation_id)
REGION=${REGION:-ap-northeast-1}
if [ ! -f /var/lib/amazon/ssm/registration ]; then
    /usr/bin/amazon-ssm-agent -register -code "${SSM_ACTIVATION_CODE}" \
        -id "${SSM_ACTIVATION_ID}" -region "${REGION}" || exit 1
fi
/usr/bin/amazon-ssm-agent &
exec "$@"
