Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61589C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 16:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B07F2175B
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 16:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfCUQLD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 12:11:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbfCUQLD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Mar 2019 12:11:03 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 36E2481F01;
        Thu, 21 Mar 2019 16:11:03 +0000 (UTC)
Received: from work (ovpn-204-90.brq.redhat.com [10.40.204.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BA4560857;
        Thu, 21 Mar 2019 16:11:02 +0000 (UTC)
Date:   Thu, 21 Mar 2019 17:10:58 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321161058.no7hfljldmoaz7z3@work>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190321020218.5154-8-tytso@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 21 Mar 2019 16:11:03 +0000 (UTC)
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

Btw, I know that you're going to change and resend this, but there is
another problem. You're missing NAME field and so the check that we have
later

 93 →       →       if [ -n "${MOUNTPOINT}" ]; then
 94 →       →       →       echo "${MOUNTPOINT}"
 95 →       →       else
 96 →       →       →       echo "${NAME}"
 97 →       →       fi

will never print the device name.

It almost feels like we need some regression testing for this ;) However
I agree that it's going to be PITA to create since historically our test
suite did not require elevated privledges, nor did it change the system
in any way.

I could bring some knowledge over from ssm and try to avoid system
changes by using loop devices and DM_DEV_DIR, but it will still require
a root privledges and will be significantly different from what we do in
tests/ today. Any ideas on how you want to do this ?

-Lukas


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
