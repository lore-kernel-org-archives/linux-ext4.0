From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Attempt to sync the fsstress writes to a frozen F.S
Date: Thu, 12 May 2011 09:22:54 -0500
Message-ID: <4DCBED3E.4020302@redhat.com>
References: <4DCA3583.7010904@canonical.com> <1305097841-2308-1-git-send-email-surbhi.palande@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, marco.stornelli@gmail.com, adilger.kernel@dilger.ca,
	toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab1ELOXJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 May 2011 10:23:09 -0400
In-Reply-To: <1305097841-2308-1-git-send-email-surbhi.palande@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/11/11 2:10 AM, Surbhi Palande wrote:
> While the fsstress background writes are busy dirtying the page cache, if a
> fsfreeze happens then the background writes should stall. A sync should then
> not have any data to sync to the FS. If it does have any data to sync then
> sync will cause a deadlock by holding the s_umount write semaphore and waiting
> in the wait queue for the FS to thaw, whereas the F.S can never thaw without
> getting the s_umount write semaphore.
> 
> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>

Seems ok to me.  In the future, when sending xfstests patches,
if you can add "xfstests" to the subject, and cc: the xfs list,
it'd be great.

I presume that this test does fail for you without your fixes?

I'll see if anyone on the xfs list has comments and if not, I can check this in.

Thanks,
-Eric

> ---
>  068 |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/068 b/068
> index 82c1a4e..b9ac58d 100755
> --- a/068
> +++ b/068
> @@ -101,6 +101,11 @@ do
>  	    tee -a $seq.full
>  	sleep 2
>  
> +	# there should be nothing to sync at this point. This may hang in case
> +	# of fsstress background writes dirtying the page cache while the F.S is frozen
> +	sync &
> +	sleep 2
> +
>  	echo "*** thawing  \$SCRATCH_MNT" | tee -a $seq.full
>  	xfs_freeze -u "$SCRATCH_MNT" | tee -a $seq.full
>  	[ $? != 0 ] && echo xfs_freeze -u "$SCRATCH_MNT" failed | \

