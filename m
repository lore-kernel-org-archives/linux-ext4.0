From: Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 04/12 v2] xfs: pass LLONG_MAX to
 truncate_inode_pages_range
Date: Mon, 16 Jul 2012 09:11:17 +1000
Message-ID: <20120715231117.GD30524@devil.redhat.com>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
 <1342185555-21146-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, achender@linux.vnet.ibm.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab2GOXLb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Jul 2012 19:11:31 -0400
Content-Disposition: inline
In-Reply-To: <1342185555-21146-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 13, 2012 at 03:19:07PM +0200, Lukas Czerner wrote:
> Currently we're passing -1 to truncate_inode_pages_range() which is
> actually really confusing since the argument is signed so we do not get
> "huge" number as one would expect, but rather just -1. To make things
> clearer and easier for truncate_inode_pages_range() just pass LLONG_MAX
> since it is actually what was intended anyway.
> 
> It also makes thing easier for allowing truncate_inode_pages_range() to
> handle non page aligned regions. Moreover letting the lend argument to
> be negative might actually hide some bugs.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_fs_subr.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs_subr.c b/fs/xfs/xfs_fs_subr.c
> index 652b875..6e9b052 100644
> --- a/fs/xfs/xfs_fs_subr.c
> +++ b/fs/xfs/xfs_fs_subr.c
> @@ -34,7 +34,8 @@ xfs_tosspages(
>  {
>  	/* can't toss partial tail pages, so mask them out */
>  	last &= ~(PAGE_SIZE - 1);
> -	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last - 1);
> +	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first,
> +				   last == -1 ? LLONG_MAX : last);

The last paramter changed from (last -1) to last. so if we pass in
last = 16384, we now truncate to 16384 (first byte of page index 5)
instead of 16383 (last byte of page index 4). That's a change of
behaviour and a potential off-by one error, right?

> @@ -53,7 +54,8 @@ xfs_flushinval_pages(
>  	ret = filemap_write_and_wait_range(mapping, first,
>  				last == -1 ? LLONG_MAX : last);
>  	if (!ret)
> -		truncate_inode_pages_range(mapping, first, last);
> +		truncate_inode_pages_range(mapping, first,
> +					   last == -1 ? LLONG_MAX : last);

Given this is also done immediately above in the function, perhaps
this should be done before anything:

	if (last == -1)
		last = LLONG_MAX;

and the parameter simply passed to the two functions without the
conditional logic?

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com
