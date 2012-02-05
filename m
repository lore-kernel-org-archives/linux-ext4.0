From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: Protect xfs_file_aio_write() &
 xfs_setattr_size() with sb_start_write - sb_end_write
Date: Mon, 6 Feb 2012 10:11:27 +1100
Message-ID: <20120205231127.GH6922@dastard>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
 <1327091686-23177-6-git-send-email-jack@suse.cz>
 <4F2CB44D.4060006@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Alex Elder <elder@kernel.org>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>,
	Dave Chinner <dchinner@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:5957 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003Ab2BEXLb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Feb 2012 18:11:31 -0500
Content-Disposition: inline
In-Reply-To: <4F2CB44D.4060006@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 03, 2012 at 10:30:05PM -0600, Eric Sandeen wrote:
> On 1/20/12 2:34 PM, Jan Kara wrote:
> > Replace racy xfs_wait_for_freeze() check in xfs_file_aio_write() with
> > a reliable sb_start_write() - sb_end_write() locking.
> 
> Here's what I'm running with now.  With this and my modified
> patch6, I can pass xfstests 068 on xfs.

Just a quick question this raises - is .splice_write() protected?

Cheers,

Dave.
> 
> -Eric
> 
> 
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7e5bc87..f1cacdc 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -874,11 +874,11 @@ xfs_file_aio_write(
>  	if (ocount == 0)
>  		return 0;
>  
> -	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
> -
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> +	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
> +

This check really should go before the shutdown check - if the
filesystem shuts down while we are freezing or attempting to freeze,
we want to abort the write after we are woken....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
