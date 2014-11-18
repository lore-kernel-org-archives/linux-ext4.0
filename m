From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/11] quota: Switch ->get_dqblk() and ->set_dqblk() to
 use bytes as space units
Date: Wed, 19 Nov 2014 09:29:52 +1100
Message-ID: <20141118222952.GQ23575@dastard>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
 <1415739865-2438-11-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:10952 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbaKRWaD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Nov 2014 17:30:03 -0500
Content-Disposition: inline
In-Reply-To: <1415739865-2438-11-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 11, 2014 at 10:04:24PM +0100, Jan Kara wrote:
> Currently ->get_dqblk() and ->set_dqblk() use struct fs_disk_quota which
> tracks space limits and usage in 512-byte blocks. However VFS quotas
> track usage in bytes (as some filesystems require that) and we need to
> somehow pass this information. Upto now it wasn't a problem because we
> didn't do any unit conversion (thus VFS quota routines happily stuck
> number of bytes into d_bcount field of struct fd_disk_quota). Only if
> you tried to use Q_XGETQUOTA or Q_XSETQLIM for VFS quotas (or Q_GETQUOTA
> / Q_SETQUOTA for XFS quotas), you got bogus results but noone really
> tried that. But when we want interfaces compatible we need to fix this.
> 
> So we bite the bullet and define another quota structure used for
> passing information from/to ->get_dqblk()/->set_dqblk. It's somewhat
> sad we have to have more conversion routines in fs/quota/quota.c but
> it seems cleaner than overloading e.g. units of d_bcount to bytes.

I don't really like the idea of having to copy the dquot information
an extra time. We now:

	- copy from internal dquot to the new qc_dqblk
	- copy from the new qc_dqblk to if_dqblk/xfs_dqblk
	- copy if_dqblk/xfs_dqblk to the user buffer.

That's now three copies, and when we are having to deal with quota
reports containing hundreds of thousands of dquots that's going to
hrut performance.

We could probably get away with just one copy by passing a
filldir()-like context down into the filesystems to format their
internal dquot information directly into the user buffer in the
appropriate format. That way fs/quota/quota.c doesn't need
conversion routines, filesystems can optimise the formating to
minimise copying, and we can still provide generic routines for
filesystems using the generic quota infrastructure....

[...]

> @@ -277,10 +287,73 @@ static int quota_getxstatev(struct super_block *sb, void __user *addr)
>  	return ret;
>  }
>  
> +/* XFS blocks to space conversion */
> +static u64 xfs_btos(u64 blocks)
> +{
> +	return blocks << 9;
> +}
> +
> +/* Space to XFS blocks conversion */
> +static u64 xfs_stob(u64 space)
> +{
> +	return (space + 511) >> 9;
> +}

Which is just redefining BBTOB() [Basic Blocks to Bytes] and BTOBB()
with magic numbers and no explanation of what a "block" actually is.
We already export those macros to userspace, and they are used by
xfs_quota to convert the block counts to bytes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
