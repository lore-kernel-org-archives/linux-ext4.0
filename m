From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -v2] ext4: delalloc  block reservation fix
Date: Tue, 03 Jun 2008 19:13:41 -0700
Message-ID: <1212545622.5372.12.camel@localhost.localdomain>
References: <1212524286-20477-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:44359 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYFDCNt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 22:13:49 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m542DlDW026127
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 22:13:47 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m542DlM2130902
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 20:13:47 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m542DlNq026469
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 20:13:47 -0600
In-Reply-To: <1212524286-20477-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-06-04 at 01:48 +0530, Aneesh Kumar K.V wrote: 
> a) We need to decrement the meta data blocks that got allocated
> from percpu s_freeblocks_counter
> 
With the original patch, reserved metadata but unused meta data blocks
are got released when block allocation is done, isn't it? comments below
in the code ...

> b) We need to protect the reservation block counter so that
> reserve and release space doesn't race each other.
> 

Yeah I was aware of this, just still trying to decide whether it worth a
lock for these two counters or use atmoc_t . I guess using a lock to
protect is more accurate.

> c) don't check for free space in ext4_mb_new_blocks with delalloc
> We already reserved the space.
> 

Yep, that's a bug. The fix looks right, thanks.

> e) Don't release space for block allocation from fallocate space.
> We don't  reserve space for them
> 

That a bug too, but the fix is not quit right, comments below..

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/balloc.c  |    9 +++++++++
>  fs/ext4/ext4_i.h  |    2 ++
>  fs/ext4/inode.c   |   39 +++++++++++++++++++++++++--------------
>  fs/ext4/mballoc.c |    7 ++++++-
>  fs/ext4/super.c   |    2 ++
>  5 files changed, 44 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 71b184c..bd18ceb 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1959,6 +1959,15 @@ ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
>  	ar.goal = goal;
>  	ar.len = 1;
>  	ret = ext4_mb_new_blocks(handle, &ar, errp);
> +	/*
> +	 * Account for the allocated meta blocks
> +	 */
> +	if (!(*errp)) {
> +		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> +		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
> +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +	}
> +
>  	return ret;
>  }
>  ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
> diff --git a/fs/ext4/ext4_i.h b/fs/ext4/ext4_i.h
> index 425518e..3d08e5b 100644
> --- a/fs/ext4/ext4_i.h
> +++ b/fs/ext4/ext4_i.h
> @@ -166,7 +166,9 @@ struct ext4_inode_info {
>  	/* allocation reservation info for delalloc */
>  	unsigned long i_reserved_data_blocks;
>  	unsigned long i_reserved_meta_blocks;
> +	unsigned long i_allocated_meta_blocks;
>  	unsigned short i_delalloc_reserved_flag;
> +	spinlock_t i_block_reservation_lock;
>  };
> 
>  #endif	/* _EXT4_I */
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1695ecc..787ce99 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1426,11 +1426,12 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
>         struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>         unsigned long md_needed, mdblocks, total = 0;
> 
> -       /*
> -        * calculate the amount of metadata blocks to reserve
> -	* in order to allocate nrblocks
> -	* worse case is one extent per block
> -	*/
> +	/*
> +	 * recalculate the amount of metadata blocks to reserve
> +	 * in order to allocate nrblocks
> +	 * worse case is one extent per block
> +	 */
> +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
>  	mdblocks = ext4_ext_calc_metadata_amount(inode, total);
>  	BUG_ON(mdblocks < EXT4_I(inode)->i_reserved_meta_blocks);
> @@ -1438,42 +1439,51 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
>  	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
>  	total = md_needed + nrblocks;
> 
> -	if (ext4_has_free_blocks(sbi, total) < total)
> +	if (ext4_has_free_blocks(sbi, total) < total) {
> +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		return -ENOSPC;
> +	}
> 
>  	/* reduce fs free blocks counter */
>  	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
> 
>  	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
> -	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
> +	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
> 
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  	return 0;       /* success */
>  }
> 
>  void ext4_da_release_space(struct inode *inode, int used, int to_free)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> -	int total, mdb, release;
> +	int total, mdb, mdb_free, release;
> 
> -	/* calculate the number of metablocks still need to be reserved */
> +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> +	/* recalculate the number of metablocks still need to be reserved */
>  	total = EXT4_I(inode)->i_reserved_data_blocks - used - to_free;

Okay, here is the part I guess you got confused (due to confused
variable name I agree, will fix that next) 

>  	mdb = ext4_ext_calc_metadata_amount(inode, total);
> 
This calculate the number of metadata need to reserve in order to
allocate "total" number of blocks. total is the the number of data
blocks that are reserved but remains unallocated by now.

>  	/* figure out how many metablocks to release */
>  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> -	mdb = EXT4_I(inode)->i_reserved_meta_blocks - mdb;

Okay, above trying to figure out how many extra metadata this inode have
reserved that need to be free(due to some allocation finished), by
calculate the delta of how many we have reserved for metadata before the
allocation, and  how many we still need for future allocation (that
already have reserved blocks) after the just finished allocation from
ext4_da_get_block_write().

> +	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
> +

actually with your change, mdb_free becomes the number of blocks that
need to be reserved incorrectly, right?

I hope this helps clarify things..

> +	/* Account for allocated meta_blocks */
> +	mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
> 
> -	release = to_free + mdb;
> +	release = to_free + mdb_free;
> 
>  	/* update fs free blocks counter for truncate case */
>  	percpu_counter_add(&sbi->s_freeblocks_counter, release);
> 
>  	/* update per-inode reservations */
>  	BUG_ON(used + to_free > EXT4_I(inode)->i_reserved_data_blocks);
> -	EXT4_I(inode)->i_reserved_data_blocks -= used + to_free;
> +	EXT4_I(inode)->i_reserved_data_blocks -= (used + to_free);
> 
>  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> -	EXT4_I(inode)->i_reserved_meta_blocks -= mdb;
> +	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
> +	EXT4_I(inode)->i_allocated_meta_blocks = 0;
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  }
> 
>  static void ext4_da_page_release_reservation(struct page *page,
> @@ -1555,7 +1565,8 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
>  		bh_result->b_size = (ret << inode->i_blkbits);
> 
>  		/* release reserved-but-unused meta blocks */
> -		ext4_da_release_space(inode, ret, 0);
> +		if (buffer_delay(bh_result))
> +			ext4_da_release_space(inode, ret, 0);
> 



The bh_result passed to ext4_da_get_block() (calling from
mpage_da_map_blocks())could be a dummy one that doesn't have
buffer_delay set. So I assume you want to set this dummy bh_result as
buffer_delay before calling ext4_da_write_page().

with above assumption, this fixed the issue with fallocate, but still
issue for rewrite after sync (i.e. blocks are already allocated), the
reservation updating is not needed. 

ext4_da_get_block_write() could not do allocation at all and just
simplely return the number of blocks that are already allocated. I think
the ext4_da_release_space() should be called inside
ext4_get_blocks_wrap() when we know there is block allocation ( not
block lookup/map or fallocate split extents).

>  		/*
>  		 * Update on-disk size along with block allocation
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index a7bdacb..09922ae 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4052,7 +4052,12 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>  					    &(ar->len), errp);
>  		return block;
>  	}
> -	ar->len = ext4_has_free_blocks(sbi, ar->len);
> +	if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag) {
> +		/*
> +		 * With delalloc we already reserved the blocks
> +		 */
> +		ar->len = ext4_has_free_blocks(sbi, ar->len);
> +	}
> 
> 
agree.

>  	if (ar->len == 0) {
>  		*errp = -ENOSPC;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 073bb2c..ee036af 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -574,7 +574,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  	spin_lock_init(&ei->i_prealloc_lock);
>  	ei->i_reserved_data_blocks = 0;
>  	ei->i_reserved_meta_blocks = 0;
> +	ei->i_allocated_meta_blocks = 0;
>  	ei->i_delalloc_reserved_flag = 0;
> +	spin_lock_init(&(ei->i_block_reservation_lock));
>  	return &ei->vfs_inode;
>  }
> 

