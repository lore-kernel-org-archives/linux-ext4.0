Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DE7C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00676218A5
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfCUUzn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 16:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfCUUzn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Mar 2019 16:55:43 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D7673082A51;
        Thu, 21 Mar 2019 20:55:43 +0000 (UTC)
Received: from work (ovpn-204-90.brq.redhat.com [10.40.204.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26D3A19C59;
        Thu, 21 Mar 2019 20:55:41 +0000 (UTC)
Date:   Thu, 21 Mar 2019 21:55:38 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321205538.sdhvixwexbwzqdcc@work>
References: <20190321202513.1969-1-tytso@mit.edu>
 <20190321202513.1969-9-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321202513.1969-9-tytso@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 21 Mar 2019 20:55:43 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 04:25:12PM -0400, Theodore Ts'o wrote:
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
> 
> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  scrub/e2scrub_all.in | 49 ++++++++++++++++++++++----------------------
>  1 file changed, 24 insertions(+), 25 deletions(-)
> 
> diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
> index 4cb90a0de..81340b76f 100644
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
> @@ -88,36 +89,34 @@ if ! type lvcreate >& /dev/null ; then
>  fi
>  
>  # Find scrub targets, make sure we only do this once.
> -ls_scrub_targets() {
> -	lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n | while read vars; do
> -		eval "${vars}"
> -
> +ls_scan_targets() {
> +	for NAME in $(lvs -o lv_path --noheadings \
> +		   -S "lv_active=active,lv_role=public,lv_role!=snapshot,vg_free>${snap_size_mb}") ; do
>  		# Skip non-ext[234]
> -		case "${FSTYPE}" in
> +		case "$(blkid -o value -s TYPE ${NAME})" in

as I said in previous email for some reason blkid makes it terribly slow
for me.

	lsblk -o FSTYPE -n ${NAME}

lsblk makes is almost 9 times faster on my system. Not really sure what's
going on with blkid in my setup.

>  		ext[234])	;;
>  		*)		continue;;
>  		esac
>  
> -		# Skip unmounted filesystems unless -A
> -		if [ "${scrub_all}" -eq 0 ] && [ -z "${MOUNTPOINT}" ]; then
> -			continue;
> +		if [ "${scrub_all}" -eq 1 ] ||
> +		   [ -n "$(lsblk -o MOUNTPOINT --noheadings ${NAME})" ]; then
> +		    echo ${NAME}
>  		fi
> +	done | sort | uniq

It's already sorted and unique from lvs.

-Lukas

> +}
>  
> -		# Skip non-lvm devices and lvm snapshots
> -		lvm_vars="$(lvs --nameprefixes -o vg_name,lv_name,lv_role --noheadings "${NAME}" 2> /dev/null)"
> -		test $? -ne 0 && continue
> -		eval "${lvm_vars}"
> -		echo "${LVM2_LV_ROLE}" | grep -q "snapshot" && continue
> -
> -		free_space="$(vgs -o vg_free --units m --noheadings --no-suffix "${LVM2_VG_NAME}" 2> /dev/null | sed -e 's/\..*//')"
> -		test "${snap_size_mb}" -gt "${free_space}" && continue
> +# Find leftover scrub snapshots
> +ls_reap_targets() {
> +	lvs -o lv_path -S lv_role=snapshot -S lv_name=~\(e2scrub$\) --noheadings
> +}
>  
> -		if [ -n "${MOUNTPOINT}" ]; then
> -			echo "${MOUNTPOINT}"
> -		else
> -			echo "${NAME}"
> -		fi
> -	done | sort | uniq
> +# Figure out what we're targeting
> +ls_targets() {
> +	if [ "${reap}" -eq 1 ]; then
> +		ls_reap_targets
> +	else
> +		ls_scan_targets
> +	fi
>  }
>  
>  # systemd doesn't know to do path escaping on the instance variable we pass
> @@ -140,10 +139,10 @@ escape_path_for_systemd() {
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
