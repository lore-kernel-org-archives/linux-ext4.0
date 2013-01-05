From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] ext4: report error if things go wrong when do
 checksum
Date: Sat, 5 Jan 2013 11:50:54 -0800
Message-ID: <20130105195054.GL20106@blackbox.djwong.org>
References: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46461 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3AETvB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2013 14:51:01 -0500
Content-Disposition: inline
In-Reply-To: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 05, 2013 at 03:42:59PM +0800, Guo Chao wrote:
> In ext4_dx_csum_verify(), if we detect corrupted data,
> we do not compare checksum because checksum itself may
> be wrong, but we should report error in this case.
> 
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> ---
>  fs/ext4/namei.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index cac4482..843e29f 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -370,14 +370,14 @@ static int ext4_dx_csum_verify(struct inode *inode,
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

In both of these cases we cannot figure out where the dx block checksum lives,
and therefore we have no stored checksum to compare against.  This can result
from enabling checksums on a existing filesystem and ignoring tune2fs' request
to run fsck -D to rebuild dx blocks that are completely full.  However, since
we haven't a checksum that we could use to decide if there's real corruption,
there's no cause to return -EIO to the user.  Therefore, we print a warning and
trust the sanity checks to catch totally bogus blocks, which is the best we can
hope for.

Sorry, but this doesn't seem necessary.

--D
>  	}
>  	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
>  
> -- 
> 1.7.9.5
> 
