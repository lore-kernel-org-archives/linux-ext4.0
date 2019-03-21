Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93881C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 04:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60639218A5
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 04:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CJ1LjFzE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfCUEF6 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 00:05:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47292 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfCUEF6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 00:05:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2L3wu4C081742;
        Thu, 21 Mar 2019 04:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=KaienRJaYj5PTmn+kA5XGqEZ7z3fN+ZeflkXt9dC1Ko=;
 b=CJ1LjFzELU/ulkpY5L7GmfokzMG6zC0Qz/NDP68paFTb4EdK1E4zhhJ7hLQNb+ebwGzd
 gX16qYfyu+tGYgfSUbGNPSDpbt0min2mDyFqFPhNN8sIKIz9pwlCtFZiKi/I/uVY/0rF
 0bbPcpfVUKI2vBBsdU3GerimEV2AUATIj8gsTxx7eq9q77bb5uj4kRCqcL19xyNMNT9M
 3trRJdRsLEMlEUw+6PmKIciwj3fV+XQO8VGP3KrViIvaC0PXYI9I/Gf/lo4zWUnIhg5G
 hFH1obOjsbkEF4tLPI+kvZsC7ekfm67NmIXyqchN4lSQrix1SIVH4S+lQSbDB/TgSOY8 ng== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2r8rjuxbca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 04:05:55 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2L45ogf007851
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 04:05:50 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2L45oXI000807;
        Thu, 21 Mar 2019 04:05:50 GMT
Received: from localhost (/10.159.247.212)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Mar 2019 21:05:49 -0700
Date:   Wed, 20 Mar 2019 21:05:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321040551.GG1173@magnolia>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321020218.5154-8-tytso@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9201 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=29 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903210026
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 10:02:17PM -0400, Theodore Ts'o wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> Paul Menzel reported that the e2scrub_all reaper service that runs at
> startup takes a long time to run, and Ted Ts'o pointed out that we could
> do a lot less work by using lvs as the outer loop in the ext4 filesystem
> probe function so that we only have to lsblk the lvm devices containing
> ext4 filesystems.
> 
> Therefore, refactor the loops to put lvs first, which should boost speed
> a bit.
> 
> [ Made some of the further optimizations suggested by Lukas Czerner.  -- TYT ]

Those chnages LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  scrub/e2scrub_all.in | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
> index 4cb90a0de..cad232987 100644
> --- a/scrub/e2scrub_all.in
> +++ b/scrub/e2scrub_all.in
> @@ -22,6 +22,7 @@ PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
>  
>  scrub_all=0
>  snap_size_mb=256
> +reap=0
>  conffile="@root_sysconfdir@/e2scrub.conf"
>  
>  test -f "${conffile}" && . "${conffile}"
> @@ -65,7 +66,7 @@ exitcode() {
>  while getopts "nrAV" opt; do
>  	case "${opt}" in
>  	"n") DBG="echo Would execute: " ;;
> -	"r") scrub_args="${scrub_args} -r";;
> +	"r") scrub_args="${scrub_args} -r"; reap=1;;
>  	"A") scrub_all=1;;
>  	"V") print_version; exitcode 0;;
>  	*) print_help; exitcode 2;;
> @@ -88,9 +89,12 @@ if ! type lvcreate >& /dev/null ; then
>  fi
>  
>  # Find scrub targets, make sure we only do this once.
> -ls_scrub_targets() {
> -	lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n | while read vars; do
> +ls_scan_targets() {
> +	lvs --name-prefixes -o vg_name,lv_path \
> +			-S lv_active=active,lv_role=public --noheadings | \
> +	while read vars; do
>  		eval "${vars}"
> +		eval "$(lsblk -o FSTYPE,MOUNTPOINT -p -P -n "${LVM2_LV_PATH}")"
>  
>  		# Skip non-ext[234]
>  		case "${FSTYPE}" in
> @@ -103,12 +107,6 @@ ls_scrub_targets() {
>  			continue;
>  		fi
>  
> -		# Skip non-lvm devices and lvm snapshots
> -		lvm_vars="$(lvs --nameprefixes -o vg_name,lv_name,lv_role --noheadings "${NAME}" 2> /dev/null)"
> -		test $? -ne 0 && continue
> -		eval "${lvm_vars}"
> -		echo "${LVM2_LV_ROLE}" | grep -q "snapshot" && continue
> -
>  		free_space="$(vgs -o vg_free --units m --noheadings --no-suffix "${LVM2_VG_NAME}" 2> /dev/null | sed -e 's/\..*//')"
>  		test "${snap_size_mb}" -gt "${free_space}" && continue
>  
> @@ -120,6 +118,20 @@ ls_scrub_targets() {
>  	done | sort | uniq
>  }
>  
> +# Find leftover scrub snapshots
> +ls_reap_targets() {
> +	lvs -o lv_path -S lv_role=snapshot -S lv_name=~\(e2scrub$\) --noheadings
> +}
> +
> +# Figure out what we're targeting
> +ls_targets() {
> +	if [ "${reap}" -eq 1 ]; then
> +		ls_reap_targets
> +	else
> +		ls_scan_targets
> +	fi
> +}
> +
>  # systemd doesn't know to do path escaping on the instance variable we pass
>  # to the e2scrub service, which breaks things if there is a dash in the path
>  # name.  Therefore, do the path escaping ourselves if needed.
> @@ -140,10 +152,10 @@ escape_path_for_systemd() {
>  
>  # Scrub any mounted fs on lvm by creating a snapshot and fscking that.
>  stdin="$(realpath /dev/stdin)"
> -ls_scrub_targets | while read tgt; do
> +ls_targets | while read tgt; do
>  	# If we're not reaping and systemd is present, try invoking the
>  	# systemd service.
> -	if [ -z "${scrub_args}" ] && type systemctl > /dev/null 2>&1; then
> +	if [ "${reap}" -ne 1 ] && type systemctl > /dev/null 2>&1; then
>  		tgt_esc="$(escape_path_for_systemd "${tgt}")"
>  		${DBG} systemctl start "e2scrub@${tgt_esc}" 2> /dev/null < "${stdin}"
>  		res=$?
> -- 
> 2.19.1
> 
