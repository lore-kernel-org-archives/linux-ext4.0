From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH, RFC] ext4: remove ext4_new_blocks() and call ext4_mb_new_blocks()
 directly
Date: Mon, 08 Dec 2008 16:23:28 +0800
Message-ID: <493CD980.1070803@cn.fujitsu.com>
References: <1228678434-14707-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbYLHIWi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Dec 2008 03:22:38 -0500
In-Reply-To: <1228678434-14707-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I think we can merge balloc.c and mballoc.c since ext4 now uses mballoc only.

on 12/08/2008 03:33 AM, Theodore Ts'o wrote:
> There was only one caller of the compatibility function
> ext4_new_blocks(), in balloc.c's ext4_alloc_blocks().  Change it to
> call ext4_mb_new_blocks() directly, and remove ext4_new_blocks()
> altogether.  This cleans up the code, by removing two extra functions
> from the call chain, and hopefully saving some stack usage.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/balloc.c |   20 --------------------
>  fs/ext4/ext4.h   |    3 ---
>  fs/ext4/inode.c  |   16 +++++++++++-----
>  3 files changed, 11 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 9ce2fcd..02e8ce4 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -741,26 +741,6 @@ ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
>  	return ext4_new_meta_blocks(handle, inode, goal, &count, errp);
>  }
>  
> -/*
> - * ext4_new_blocks() -- allocate data blocks
> - *
> - * @handle:             handle to this transaction
> - * @inode:              file inode
> - * @goal:               given target block(filesystem wide)
> - * @count:		total number of blocks need
> - * @errp:               error code
> - *
> - * Return 1st allocated block numberon success, *count stores total account
> - * error stores in errp pointer
> - */
> -
> -ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
> -				ext4_lblk_t iblock, ext4_fsblk_t goal,
> -				unsigned long *count, int *errp)
> -{
> -	return do_blk_alloc(handle, inode, iblock, goal, count, errp, 0);
> -}
> -
>  /**
>   * ext4_count_free_blocks() -- count filesystem free blocks
>   * @sb:		superblock
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8370ffd..74cb395 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1002,9 +1002,6 @@ extern ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
>  			ext4_fsblk_t goal, int *errp);
>  extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>  			ext4_fsblk_t goal, unsigned long *count, int *errp);
> -extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
> -					ext4_lblk_t iblock, ext4_fsblk_t goal,
> -					unsigned long *count, int *errp);
>  extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi, s64 nblocks);
>  extern int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks);
>  extern void ext4_free_blocks(handle_t *handle, struct inode *inode,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2a3804e..d972b4c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -546,6 +546,7 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
>  				int indirect_blks, int blks,
>  				ext4_fsblk_t new_blocks[4], int *err)
>  {
> +	struct ext4_allocation_request ar;
>  	int target, i;
>  	unsigned long count = 0, blk_allocated = 0;
>  	int index = 0;
> @@ -594,10 +595,15 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
>  	if (!target)
>  		goto allocated;
>  	/* Now allocate data blocks */
> -	count = target;
> -	/* allocating blocks for data blocks */
> -	current_block = ext4_new_blocks(handle, inode, iblock,
> -						goal, &count, err);
> +	memset(&ar, 0, sizeof(ar));
> +	ar.inode = inode;
> +	ar.goal = goal;
> +	ar.len = target;
> +	ar.logical = iblock;
> +	ar.flags = EXT4_MB_HINT_DATA;
> +
> +	current_block = ext4_mb_new_blocks(handle, &ar, err);
> +
>  	if (*err && (target == blks)) {
>  		/*
>  		 * if the allocation failed and we didn't allocate
> @@ -613,7 +619,7 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
>  		 */
>  			new_blocks[index] = current_block;
>  		}
> -		blk_allocated += count;
> +		blk_allocated += ar.len;
>  	}
>  allocated:
>  	/* total number of blocks allocated for direct blocks */

-- 
Best Regards,
--------------------------------------------------
Shen Feng
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
8/F., Civil Defense Building, No.189 Guangzhou Road,
Nanjing, 210029, China
PHONE: +86-25-86630566-950
COINS: 79955-950
FAX: +86-25-83317685
MAIL: shen@cn.fujitsu.com
-------------------------------------------------
This communication is for use by the intended recipient(s) only and may contain information that is privileged, confidential and exempt from disclosure under applicable law. If you are not an intended recipient of this communication, you are hereby notified that any dissemination, distribution or copying hereof is strictly prohibited.  If you have received this communication in error, please notify me by reply e-mail, permanently delete this communication from your system, and destroy any hard copies you may have printed.
