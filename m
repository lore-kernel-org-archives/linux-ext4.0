From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: ext4: fix reference counting bug on block allocation error
Date: Sun, 14 Aug 2016 20:32:06 +0200
Message-ID: <20160814183206.GA11040@kroah.com>
References: <20160727052921.5B41C35574@git2.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbcHNSb5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Aug 2016 14:31:57 -0400
Content-Disposition: inline
In-Reply-To: <20160727052921.5B41C35574@git2.kroah.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Vegard and ext4 developers,

The patch below, in Linus's tree, references a patch in the Fixes: line
that is not in Linus's tree (neither the git commit id, nor the subject
line.)

That's a bit confusing, what is this patch supposed to be fixing up?
What stable tree(s) should it go to if the original patch it fixes isn't
even in any tree?

confused,

greg k-h


On Wed, Jul 27, 2016 at 05:29:21AM +0000, Gregs git-bot wrote:
> commit: 554a5ccc4e4a20c5f3ec859de0842db4b4b9c77e
> From: Vegard Nossum <vegard.nossum@oracle.com>
> Date: Thu, 14 Jul 2016 23:02:47 -0400
> Subject: ext4: fix reference counting bug on block allocation error
> 
> If we hit this error when mounted with errors=continue or
> errors=remount-ro:
> 
>     EXT4-fs error (device loop0): ext4_mb_mark_diskspace_used:2940: comm ext4.exe: Allocating blocks 5090-6081 which overlap fs metadata
> 
> then ext4_mb_new_blocks() will call ext4_mb_release_context() and try to
> continue. However, ext4_mb_release_context() is the wrong thing to call
> here since we are still actually using the allocation context.
> 
> Instead, just error out. We could retry the allocation, but there is a
> possibility of getting stuck in an infinite loop instead, so this seems
> safer.
> 
> [ Fixed up so we don't return EAGAIN to userspace. --tytso ]
> 
> Fixes: 8556e8f3b6 ("ext4: Don't allow new groups to be added during block allocation")
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/ext4/mballoc.c | 17 +++--------------
>  1 file changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 77249e1..1156216 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2943,7 +2943,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
>  		ext4_error(sb, "Allocating blocks %llu-%llu which overlap "
>  			   "fs metadata", block, block+len);
>  		/* File system mounted not to panic on error
> -		 * Fix the bitmap and repeat the block allocation
> +		 * Fix the bitmap and return EFSCORRUPTED
>  		 * We leak some of the blocks here.
>  		 */
>  		ext4_lock_group(sb, ac->ac_b_ex.fe_group);
> @@ -2952,7 +2952,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
>  		ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
>  		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
>  		if (!err)
> -			err = -EAGAIN;
> +			err = -EFSCORRUPTED;
>  		goto out_err;
>  	}
>  
> @@ -4517,18 +4517,7 @@ repeat:
>  	}
>  	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
>  		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_clstrs);
> -		if (*errp == -EAGAIN) {
> -			/*
> -			 * drop the reference that we took
> -			 * in ext4_mb_use_best_found
> -			 */
> -			ext4_mb_release_context(ac);
> -			ac->ac_b_ex.fe_group = 0;
> -			ac->ac_b_ex.fe_start = 0;
> -			ac->ac_b_ex.fe_len = 0;
> -			ac->ac_status = AC_STATUS_CONTINUE;
> -			goto repeat;
> -		} else if (*errp) {
> +		if (*errp) {
>  			ext4_discard_allocated_blocks(ac);
>  			goto errout;
>  		} else {
> -- 
> 2.9.0
