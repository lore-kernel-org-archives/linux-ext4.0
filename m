Return-Path: <SRS0=iy/Z=RW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108D9C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 10:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8A0F20828
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 10:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfCSK6b (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:58:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726782AbfCSK6b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Mar 2019 06:58:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D0DC33082B0F;
        Tue, 19 Mar 2019 10:58:30 +0000 (UTC)
Received: from work (ovpn-204-238.brq.redhat.com [10.40.204.238])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 321815D70D;
        Tue, 19 Mar 2019 10:58:28 +0000 (UTC)
Date:   Tue, 19 Mar 2019 11:58:24 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH] e2scrub_all: refactor device probe loop
Message-ID: <20190319105824.apzsygxgl5dt3fq6@work>
References: <20190319001732.GB4916@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319001732.GB4916@magnolia>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 19 Mar 2019 10:58:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 18, 2019 at 05:17:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Paul Menzel reported that the e2scrub_all reaper service that runs at
> startup takes a long time to run, and Ted T'so pointed out that we could
> do a lot less work by using lvs as the outer loop in the ext4 filesystem
> probe function so that we only have to lsblk the lvm devices containing
> ext4 filesystems.
> 
> Therefore, refactor the loops to put lvs first, which should boost speed
> a bit.
> 
> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/e2scrub_all.in |   51 ++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 37 insertions(+), 14 deletions(-)
> 
> diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
> index 23d122d25..41420d03d 100644
> --- a/scrub/e2scrub_all.in
> +++ b/scrub/e2scrub_all.in
> @@ -19,6 +19,7 @@
>  #  Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>  
>  scrub_all=0
> +reap=0
>  conffile="@root_sysconfdir@/e2scrub.conf"
>  
>  test -f "${conffile}" && . "${conffile}"
> @@ -61,7 +62,7 @@ exitcode() {
>  while getopts "ArV" opt; do
>  	case "${opt}" in
>  	"A") scrub_all=1;;
> -	"r") scrub_args="${scrub_args} -r";;
> +	"r") scrub_args="${scrub_args} -r"; reap=1;;
>  	"V") print_version; exitcode 0;;
>  	*) print_help; exitcode 2;;
>  	esac
> @@ -69,27 +70,27 @@ done
>  shift "$((OPTIND - 1))"
>  
>  # Find scrub targets, make sure we only do this once.
> -ls_scrub_targets() {
> -	lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n | while read vars; do
> +ls_scan_targets() {
> +	lvs --name-prefixes -o vg_name,lv_name,lv_path \
> +			-S lv_active=active,lv_role=public --noheadings | \

You're not using vg_name, nor lv_name so you can drop it maybe ? Also
you're missing lv_role since you're checking it later, however you can
do this instead

	-S lv_active=active,lv_role=public -S lv_role!=snapshot

so you only need to ask for lv_path

> +	while read vars; do
>  		eval "${vars}"
> +		eval "$(lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n "${LVM2_LV_PATH}")"

Now that you only have one lv filed you can maybe pass this directly to
the lsblk ?


This looks funny but works fine for me :)

lsblk -o MOUNTPOINT,NAME,FSTYPE -p -n `lvs -o lv_path -S lv_active=active,lv_role=public -S lv_role!=snapshot --noheadings` | grep 'ext[234]' | awk '{print $1}'

if you only want mounted file systems than you just add

	| grep -v -E '^/dev/'

>  
> -		# Skip non-ext[234]
> +		# Skip unless ext*
>  		case "${FSTYPE}" in
> -		ext[234])	;;
> -		*)		continue;;
> +		ext*) ;;
> +		*) continue;;
>  		esac
>  
> +		# Don't run against a snapshot ever
> +		echo "${LVM2_LV_ROLE}" | grep -q "snapshot" && continue
> +
>  		# Skip unmounted filesystems unless -A
>  		if [ "${scrub_all}" -eq 0 ] && [ -z "${MOUNTPOINT}" ]; then
>  			continue;
>  		fi
>  
> -		# Skip non-lvm devices and lvm snapshots
> -		lvm_vars="$(lvs --nameprefixes -o vg_name,lv_name,lv_role --noheadings "${NAME}" 2> /dev/null)"
> -		test $? -ne 0 && continue
> -		eval "${lvm_vars}"
> -		echo "${LVM2_LV_ROLE}" | grep -q "snapshot" && continue
> -
>  		if [ -n "${MOUNTPOINT}" ]; then
>  			echo "${MOUNTPOINT}"
>  		else
> @@ -98,6 +99,28 @@ ls_scrub_targets() {
>  	done | sort | uniq
>  }
>  
> +# Find leftover scrub snapshots
> +ls_reap_targets() {
> +	lvs --name-prefixes -o vg_name,lv_name,lv_path,origin \

You only seem to be using lv_name and lv_path ?

also I think you can do this:

lvs -o lv_path -S lv_role=snapshot -S lv_name=~\(e2scrub$\) --noheadings

Also since you only ask for one field I tihnk it's already sorted so no
need to sort, or add -O

-Lukas

> +		-S lv_role=snapshot --noheadings | while read vars; do
> +		eval "${vars}"
> +
> +		# Filter out anything except our snapshots
> +		case "${LVM2_LV_NAME}" in
> +		*.e2scrub) echo "${LVM2_LV_PATH}";;
> +		esac
> +	done | sort | uniq
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
> @@ -118,10 +141,10 @@ escape_path_for_systemd() {
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
