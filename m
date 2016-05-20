From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: correct error value of function verifying dx
 checksum
Date: Thu, 19 May 2016 18:51:00 -0700
Message-ID: <20160520015100.GA4586@birch.djwong.org>
References: <1463702096-11386-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39541 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbcETBvJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 May 2016 21:51:09 -0400
Content-Disposition: inline
In-Reply-To: <1463702096-11386-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 20, 2016 at 08:54:56AM +0900, Daeho Jeong wrote:
> ext4_dx_csum_verify() returns the success return value in two checksum
> verification failure cases. We need to set the return values to zero
> as failure like ext4_dirent_csum_verify() returning zero when failing
> to find a checksum dirent at the tail.

ISTR deciding back in 2011 that "can't find the checksums" wasn't a hard enough
error to warrant shutting down the FS.  Though, being unable to find the limit
and count fields of a dx node /is/ bad enough, I think.

2016 me is more paranoid about soft errors, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> ---
>  fs/ext4/namei.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 48e4b89..ec811bb 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -446,14 +446,14 @@ static int ext4_dx_csum_verify(struct inode *inode,
>  	c = get_dx_countlimit(inode, dirent, &count_offset);
>  	if (!c) {
>  		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
> -		return 1;
> +		return 0;
>  	}
>  	limit = le16_to_cpu(c->limit);
>  	count = le16_to_cpu(c->count);
>  	if (count_offset + (limit * sizeof(struct dx_entry)) >
>  	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
>  		warn_no_space_for_csum(inode);
> -		return 1;
> +		return 0;
>  	}
>  	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
