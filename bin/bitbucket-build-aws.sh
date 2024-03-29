#!/bin/bash

# variables/ labels
# nl_sep=" <br> "
nl_sep="  \\n "
prefix="tb-TRAM build was executed $nl_sep"
github_api_url="https://api.github.com/repos"
api_url="https://api.bitbucket.org/2.0/repositories"
pr_id=`sed -e 's#.*/\(\)#\1#' <<< "$CODEBUILD_WEBHOOK_TRIGGER"` #get PR id
repo_path=$(basename "$(dirname "$CODEBUILD_SRC_DIR")")/$(basename "$CODEBUILD_SRC_DIR")
more_details="$nl_sep $nl_sep BUILD Log is available at: $nl_sep $CODEBUILD_BUILD_URL"
build_failed="BUILD FAILED. Review the below log: $nl_sep "

isPlanEvent() {
    events=(PULL_REQUEST_CREATED PULL_REQUEST_UPDATED PULL_REQUEST_REOPENED)
    elementIn "$CODEBUILD_WEBHOOK_EVENT" "${events[@]}"
    return
}

isDeployEvent() {
    [[ "$CODEBUILD_INITIATOR" == "codepipeline/"* ]]
    return
}

get_snowflake_key(){
    echo "Getting snowflake private key"
    aws ssm get-parameters --name $TRAM_PRIVATE_KEY_PEM --with-decryption --query "Parameters[*].{Value:Value}" --region us-east-1 --output text > snowflake_rsa_key.p8
}

process_plan() {
    get_snowflake_key
    bin/tram-fetch || exit 1
    echo "=====================================================START - TRAM DRYRUN OUTPUT====================================================="
    bin/tram-dry-run || exit 1
    cat tram-statements.sql
    echo "Below tram statements will be executed when this PR is merged" >> output
    cat tram-statements.sql >> output
    echo "=====================================================END - TRAM DRYRUN OUTPUT====================================================="
    format_change_output output
    post_pr_comment "$prefix$comment_content$more_details"
}

process_deploy() {
    get_snowflake_key
    bin/tram-fetch || exit 1
    echo "=====================================================START - TRAM PROVISION OUTPUT====================================================="
    bin/tram-provision || exit 1
    echo "=====================================================END - TRAM PROVISION OUTPUT====================================================="
    comment_content="$nl_sep All jobs completed normally. Please review the build log to view the status of TRAM provisioning."
    post_pr_comment "$prefix$comment_content$more_details"
}

get_pr_details() {
    pr_id=`curl --silent -u $bb_app_user:$bb_app_pwd $api_url/$repo_path/commit/$CODEBUILD_RESOLVED_SOURCE_VERSION/pullrequests \
        | jq -r '.values[0].id'`
    pr_status=`curl --silent -u $bb_app_user:$bb_app_pwd $api_url/$repo_path/pullrequests/$pr_id \
        | jq -r '.state'`
    head_branch=`git name-rev --name-only $CODEBUILD_RESOLVED_SOURCE_VERSION`
    echo "pr_id :: $pr_id && pr_status :: $pr_status"
}

post_pr_comment() {
  if [[ $pr_comments == "enable" ]]; then
    curl --silent -u $bb_app_user:$bb_app_pwd $api_url/$repo_path/pullrequests/$pr_id/comments \
          --request POST \
          --header 'Content-Type: application/json' \
          --data "{\"content\": { \"raw\": \"$1\" }}" > /dev/null
  fi
}

format_change_output () {
    comment_content=""
    set +x
    while read -r LINE
    do
        LINE=$(sed -E 's/\\/\\\\/g' <<<"${LINE}") #escape \ 
        comment_content="${comment_content} $nl_sep ${LINE}"
    done < $1
    set -x
    echo $comment_content
}

elementIn() {
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
}


# main
if [ "$stage" = "build" ]; then
    if isPlanEvent; then
        process_plan
    elif isDeployEvent; then
        process_deploy
    else
        echo "No action performed by BUILD"
    fi
elif [ "$stage" == "post_build" ] && [ "$CODEBUILD_BUILD_SUCCEEDING" -eq 0 ] ; then
    post_pr_comment "$prefix$build_failed$more_details"
fi