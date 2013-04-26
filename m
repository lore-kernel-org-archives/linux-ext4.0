From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] [PATCH] xfstests: use -F when making scratch ext4 fs
Date: Fri, 26 Apr 2013 14:18:26 -0500
Message-ID: <517AD302.4000905@redhat.com>
References: <1367003813-17686-1-git-send-email-jbacik@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Josef Bacik <jbacik@fusionio.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab3DZTS3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Apr 2013 15:18:29 -0400
In-Reply-To: <1367003813-17686-1-git-send-email-jbacik@fusionio.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/26/13 2:16 PM, Josef Bacik wrote:
> mkfs.ext4 will ask you if you are sure if you try to mkfs an entire disk instead
> of just a partition, so any xfstest that uses a scratch device and you specify a
> full disk will appear to hang because it's waiting for you to say yes.  This
> fixes the problem by just forcing it to do its thing.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

The whole-disk test is pretty derpy anyway. Too bad -F overrides
much more than just that, but this is probably a decent
thing to do.

Thanks,
-Eric

> ---
>  common/rc |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index ff18cc2..9d1c3fc 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -485,7 +485,7 @@ _scratch_mkfs_ext4()
>  {
>  	local tmp_dir=/tmp/
>  
> -	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV \
> +	/sbin/mkfs -t $FSTYP -- -F $MKFS_OPTIONS $* $SCRATCH_DEV \
>  			2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
>  	local mkfs_status=$?
>  
> 

