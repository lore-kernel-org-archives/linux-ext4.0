Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCC2C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 11:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0120721841
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 11:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfCULTC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:19:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfCULTC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Mar 2019 07:19:02 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D65130FE5D8;
        Thu, 21 Mar 2019 11:19:02 +0000 (UTC)
Received: from work (ovpn-204-90.brq.redhat.com [10.40.204.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DE245D70A;
        Thu, 21 Mar 2019 11:19:00 +0000 (UTC)
Date:   Thu, 21 Mar 2019 12:18:56 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 7/9] e2scrub_all: make sure there's enough free space for
 a snapshot
Message-ID: <20190321111856.gsbdc6gv3bfehion@work>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-7-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321020218.5154-7-tytso@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 21 Mar 2019 11:19:02 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 10:02:16PM -0400, Theodore Ts'o wrote:
> If there isn't, skip the volume so we don't spam the system
> administrator with error messages.  It's quite commkon that there is
> is zero free space in the volume group.
> 
> Addresses-Debian-Bug: #924301
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  scrub/e2scrub_all.in | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
> index 8bc868aa0..4cb90a0de 100644
> --- a/scrub/e2scrub_all.in
> +++ b/scrub/e2scrub_all.in
> @@ -21,6 +21,7 @@
>  PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
>  
>  scrub_all=0
> +snap_size_mb=256
>  conffile="@root_sysconfdir@/e2scrub.conf"
>  
>  test -f "${conffile}" && . "${conffile}"
> @@ -108,6 +109,9 @@ ls_scrub_targets() {
>  		eval "${lvm_vars}"
>  		echo "${LVM2_LV_ROLE}" | grep -q "snapshot" && continue
>  
> +		free_space="$(vgs -o vg_free --units m --noheadings --no-suffix "${LVM2_VG_NAME}" 2> /dev/null | sed -e 's/\..*//')"
> +		test "${snap_size_mb}" -gt "${free_space}" && continue

So you're going to be calling vgs for every lvs even though you can have
a whole bunch of them in the same vg. That's not very efficient.

You can just filter it out with the lvs at the start of the loop by
adding the proper select string.

-S vg_free\>${snap_size_mb}

-Lukas


> +
>  		if [ -n "${MOUNTPOINT}" ]; then
>  			echo "${MOUNTPOINT}"
>  		else
> -- 
> 2.19.1
> 
