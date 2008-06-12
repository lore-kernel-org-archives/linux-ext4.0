From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: PATCH] ext4: Change error handling in ext4_defrag_alloc_blocks
Date: Thu, 12 Jun 2008 15:49:43 -0700
Message-ID: <1213310983.3698.27.camel@localhost.localdomain>
References: <48507F43.8080602@rs.jp.nec.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	shen@cn.fujitsu.com
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53812 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbYFLWtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 18:49:45 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5CMniMq023797
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:49:44 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5CMniK3129692
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:49:44 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5CMnijZ006698
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:49:44 -0400
In-Reply-To: <48507F43.8080602@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-06-12 at 10:43 +0900, Akira Fujita wrote:
> Change error handling in ext4_defrag_alloc_blocks,
> since ext4_ext_journal_restart returns the error value.
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> ---
>  fs/ext4/defrag.c  |    6 ++----
>  fs/ext4/ext4.h    |    2 +-
>  fs/ext4/extents.c |    2 +-
>  3 files changed, 4 insertions(+), 6 deletions(-)
> diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
> index cd8b151..5187681 100644
> --- a/fs/ext4/defrag.c
> +++ b/fs/ext4/defrag.c
> @@ -1386,12 +1386,10 @@ ext4_defrag_alloc_blocks(handle_t *handle, struct inode *org_inode,
>  	int err, i, credits = 0;
> 
>  	credits = ext4_ext_calc_credits_for_insert(dest_inode, dest_path);
> -	handle = ext4_ext_journal_restart(handle,
> +	err = ext4_ext_journal_restart(handle,
>  				credits + EXT4_TRANS_META_BLOCKS);
> -	if (IS_ERR(handle)) {
> -		err = PTR_ERR(handle);
> +	if (err)
>  		return err;
> -	}
> 
>  	*newblock = ext4_mb_new_blocks(handle, ar, &err);
>  	if (err)
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index eec99be..202514e 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1198,7 +1198,7 @@ extern void ext4_inode_bitmap_set(struct super_block *sb,
>  extern void ext4_inode_table_set(struct super_block *sb,
>  				 struct ext4_group_desc *bg, ext4_fsblk_t blk);
>  /* extents.c */
> -extern handle_t *ext4_ext_journal_restart(handle_t *handle, int needed);
> +extern int ext4_ext_journal_restart(handle_t *handle, int needed);
>  /* defrag.c */
>  extern int ext4_defrag(struct file *filp, ext4_lblk_t block_start,
>  			ext4_lblk_t defrag_size, ext4_fsblk_t goal,
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 8d47490..30e011b 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -93,7 +93,7 @@ static void ext4_idx_store_pblock(struct ext4_extent_idx *ix, ext4_fsblk_t pb)
>  	ix->ei_leaf_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
>  }
> 
> -handle_t *ext4_ext_journal_restart(handle_t *handle, int needed)
> +int ext4_ext_journal_restart(handle_t *handle, int needed)
>  {
>  	int err;
> 

Thanks, I fold this patch to the parent patch
ext4-online-defrag-alloc-contiguous-blks.patch with slightly
modification to make it apply.

Mingming


