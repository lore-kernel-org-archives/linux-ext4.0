Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6942F387369;
	Sat, 30 May 2026 07:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780125739; cv=none; b=Pv9pbdP5nN07gRR8jCdTHNLTAeMEUWDoJgvGgacnr8b9BDQTqQ3L0dLoe2ay0t6ncCDuSaF7AqZKryA8xHSz2odUTH+dGbGl3dRruJdpawG/iCmMyQPdBtYuJMaV7rUevfyXWY8NlIELz5Ev+5phDCVGcfX47Hz/1HsgizyNgkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780125739; c=relaxed/simple;
	bh=g9yam3A0+B+g4L53d8D0sbjoDE8OHcuChwBeT2TOx5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d2XExXtdlwdK7pGeNFAW6Um3qlSm3lnvuDSBQpl1LQLmYkS8QjubBtMVPgBcOnja4GYPxH0yLR/Sm7PFMegvjsYROv+TSg5rDRxywZ52oYVH2pyGhE11D6BVpWFAihFWNAsVXdd0RyozuNMB0yVSOiQAENSubldcLgYN/6DfKrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gSBVh04q1zKHLyR;
	Sat, 30 May 2026 15:21:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1D06340576;
	Sat, 30 May 2026 15:22:07 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgA3_1odkBpqfS2jEA--.61536S3;
	Sat, 30 May 2026 15:22:06 +0800 (CST)
Message-ID: <5d2b13b9-d5a0-47ce-876c-ab01070cbe49@huaweicloud.com>
Date: Sat, 30 May 2026 15:22:04 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap buffered
 I/O path
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <ahcUeq_IA_X988Ca@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <ahcUeq_IA_X988Ca@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgA3_1odkBpqfS2jEA--.61536S3
X-Coremail-Antispam: 1UD129KBjvAXoW3uw4kCrW8urW7ZFWkWrW3KFg_yoW8Gr1DJo
	WFgr47Xr4xGryYkay0k34kGFyUuayDCw4rGw15urZ2yF9aqF13Ca17Ww17WFW3J3WFyr1r
	G34xGr10yFW7tr1rn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUY77kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

Hi, Ojaswin!

On 5/27/2026 11:58 PM, Ojaswin Mujoo wrote:
> On Mon, May 11, 2026 at 03:23:38PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> For append writes, wait for ordered I/O to complete before updating
>> i_disksize. This ensures that zeroed data is flushed to disk before the
>> metadata update, preventing stale data from being exposed during
>> unaligned post-EOF append writes.
>>
>> Suggested-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>  fs/ext4/ext4.h    | 11 +++++++
>>  fs/ext4/inode.c   | 80 ++++++++++++++++++++++++++++++++++++++++++-----
>>  fs/ext4/page-io.c | 60 +++++++++++++++++++++++++++++++++++
>>  fs/ext4/super.c   | 23 ++++++++++----
>>  4 files changed, 161 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 078feda47e36..9ce2128eea3e 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1195,6 +1195,15 @@ struct ext4_inode_info {
>>  #ifdef CONFIG_FS_ENCRYPTION
>>  	struct fscrypt_inode_info *i_crypt_info;
>>  #endif
>> +
>> +	/*
>> +	 * Track ordered zeroed data during post-EOF append writes, fallocate,
>> +	 * and truncate-up operations. These parameters are used only in the
>> +	 * iomap buffered I/O path.
>> +	 */
>> +	ext4_lblk_t i_ordered_lblk;
>> +	ext4_lblk_t i_ordered_len;
>> +	wait_queue_head_t i_ordered_wq;
>>  };
>>  
>>  /*
>> @@ -3858,6 +3867,8 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>>  			     __u64 len, __u64 *moved_len);
>>  
>>  /* page-io.c */
>> +#define EXT4_IOMAP_IOEND_ORDER_IO	1UL	/* This I/O is an ordered one */
>> +
>>  extern int __init ext4_init_pageio(void);
>>  extern void ext4_exit_pageio(void);
>>  extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index e013aeb03d7b..11fb369efeb1 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4345,6 +4345,7 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>  {
>>  	struct iomap_ioend *ioend = wpc->wb_ctx;
>>  	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
>> +	ext4_lblk_t start, end, order_lblk, order_len;
>>  
>>  	/*
>>  	 * After I/O completion, a worker needs to be scheduled when:
>> @@ -4357,6 +4358,30 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>  	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
>>  		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>>  
>> +	/*
>> +	 * Mark the I/O as ordered. Ordered I/O requires separate endio
>> +	 * handling and must not be merged with regular I/O operations.
>> +	 */
>> +	order_len = READ_ONCE(ei->i_ordered_len);
>> +	if (order_len) {
>> +		/*
>> +		 * Pair with smp_store_release() in ext4_block_zero_eof().
>> +		 * Ensure we see the updated i_ordered_lblk that was written
>> +		 * before the release store to i_ordered_len.
>> +		 */
>> +		smp_rmb();
>> +		order_lblk = READ_ONCE(ei->i_ordered_lblk);
>> +		start = ioend->io_offset >> ioend->io_inode->i_blkbits;
>> +		end = EXT4_B_TO_LBLK(ioend->io_inode,
>> +				     ioend->io_offset + ioend->io_size);
>> +
>> +		if (start <= order_lblk && end >= order_lblk + order_len) {
> 
> Hi Zhang,
> 
> I guess this check is enough cause ordered_lblk and ordered_len will
> always be  contained in a single block.

Yeah.

> 
>> +			ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>> +			ioend->io_private = (void *)EXT4_IOMAP_IOEND_ORDER_IO;
>> +			ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
> 
> FWIU, we are wanting the ordered IO to not be merged and submitted asap
> since we want to wake up the waiters. Is there any other reason?

My original intention was to prevent the loss of the
EXT4_IOMAP_IOEND_ORDER_IO flag during worker processing triggered by I/O
completion, which could be caused by merging an ordered ioend with a
normal ioend.  In patch 19, we need to determine the flag to update
i_disksize to the correct position.

> 
> Adding the boundary in ->writeback_submit() only affects
> iomap_ioend_can_merge() which happens after we have woken up the waiters
> and deferred the IO to the wq. We ideally want it affect
> iomap_can_add_to_ioend() ie we need to add IOMAP_F_BOUNDARY in
> ->writeback_range().

IIUC, merging into the same ioend during the submission stage doesn't
seem to cause any problems.

> 
> Secondly, I don't think boundary is the right flag here. It ensures
> that everything before the ordered iomap gets submitted and the ordered
> iomap starts a new ioend. This can still keep getting merged with the
> newer ioends untils we decide to submit the IO, which can delay waking
> up the waiters. If we really want the "no merge" behavior, we'll have to
> do something like [1] (Check the 2 NOMERGE flag patches).

Yeah, IOMAP_IOEND_BOUNDARY appears to be just a one-way barrier and
still cannot prevent merging. I missed this, thank you for pointing this
out. However, I think perhaps we should change iomap_ioend_can_merge()
to check the iomap_ioend->io_private. Something like:

	if (ioend->io_private || next->io_private)
		return false;

What do you think?

Thanks,
Yi.

> 
>> +		}
>> +	}
>> +
>>  	return iomap_ioend_writeback_submit(wpc, error);
>>  }
>>  
>> @@ -4746,8 +4771,10 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
>>  					loff_t from, loff_t end)
>>  {
>>  	struct address_space *mapping = inode->i_mapping;
>> +	struct ext4_inode_info *ei = EXT4_I(inode);
>>  	struct folio *folio;
>>  	bool do_submit = false;
>> +	int ret;
>>  
>>  	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
>>  	if (IS_ERR(folio))
>> @@ -4757,14 +4784,50 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
>>  	folio_wait_writeback(folio);
>>  	WARN_ON_ONCE(folio_test_writeback(folio));
>>  
>> -	if (likely(folio_test_dirty(folio)))
>> +	/*
>> +	 * Mark the ordered range. It will be cleared upon I/O completion
>> +	 * in ext4_iomap_end_bio(). Any operation that extends i_disksize
>> +	 * (including append write end io past the zeroed boundary,
>> +	 * truncate up and append fallocate) must wait for this I/O to
>> +	 * complete before updating i_disksize.
>> +	 *
>> +	 * When multiple overlapping unaligned EOF writes are in flight, we
>> +	 * only need to track and wait for the first one. Subsequent writes
>> +	 * will zero the gap in memory and ensure that the zeroed data is
>> +	 * written out along with the valid data in the same block before
>> +	 * i_disksize is updated.
>> +	 */
>> +	if (likely(folio_test_dirty(folio) &&
>> +		   READ_ONCE(ei->i_ordered_len) == 0)) {
>> +		WRITE_ONCE(ei->i_ordered_lblk,
>> +			   from >> inode->i_blkbits);
>> +		/*
>> +		 * Pairs with smp_rmb() in ext4_iomap_writeback_submit()
>> +		 * and ext4_iomap_wb_ordered_wait(). Ensure the updated
>> +		 * i_ordered_lblk is visible when i_ordered_len becomes
>> +		 * non-zero.
>> +		 */
>> +		smp_store_release(&ei->i_ordered_len, 1);
>>  		do_submit = true;
>> +	}
>>  	folio_unlock(folio);
>>  	folio_put(folio);
>>  
>>  	/* Submit zeroed block. */
>> -	if (do_submit)
>> -		return filemap_fdatawrite_range(mapping, from, end - 1);
>> +	if (do_submit) {
>> +		ret = filemap_fdatawrite_range(mapping, from, end - 1);
>> +		if (ret) {
>> +			/*
>> +			 * Pairs with wait_event() in
>> +			 * ext4_iomap_wb_ordered_wait(). Ensure
>> +			 * i_ordered_len = 0 is visible before waking up
>> +			 * waiters.
>> +			 */
>> +			smp_store_release(&ei->i_ordered_len, 0);
>> +			wake_up_all(&ei->i_ordered_wq);
>> +			return ret;
>> +		}
>> +	}
>>  	return 0;
>>  }
>>  
>> @@ -4827,10 +4890,13 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>  		 * data=ordered mode. We submit zeroed range directly here.
>>  		 * Do not wait for I/O completion for performance.
>>  		 *
>> -		 * TODO: Any operation that extends i_disksize (including
>> -		 * append write end io past the zeroed boundary, truncate up,
>> -		 * and append fallocate) must wait for the relevant I/O to
>> -		 * complete before updating i_disksize.
>> +		 * The end_io handler ext4_iomap_wb_ordered_wait() will wait
>> +		 * for I/O completion before updating i_disksize if the write
>> +		 * extends beyond the zeroed boundary.
>> +		 *
>> +		 * TODO: Any other operation that extends i_disksize
>> +		 * (including truncate up and append fallocate) must wait for
>> +		 * the relevant I/O to complete before updating i_disksize.
>>  		 */
>>  		} else if (ext4_inode_buffered_iomap(inode)) {
>>  			err = ext4_iomap_submit_zero_block(inode, from, end);
>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
>> index 3050c887329f..ad05ebb49bf6 100644
>> --- a/fs/ext4/page-io.c
>> +++ b/fs/ext4/page-io.c
>> @@ -613,6 +613,46 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
>>  	return 0;
>>  }
>>  
>> +/*
>> + * If the old disk size is not block size aligned and the current
>> + * writeback range is entirely beyond the old EOF block, we should
>> + * wait for the zeroed data written in ext4_block_zero_eof() to be
>> + * written out, otherwise, it may expose stale data in that block.
>> + */
>> +static void ext4_iomap_wb_ordered_wait(struct inode *inode,
>> +				       loff_t pos, loff_t end)
>> +{
>> +	struct ext4_inode_info *ei = EXT4_I(inode);
>> +	unsigned int blocksize = i_blocksize(inode);
>> +	loff_t disksize = READ_ONCE(ei->i_disksize);
>> +	ext4_lblk_t order_lblk, order_len;
>> +
>> +	/*
>> +	 * Waiting for ordered I/O is unnecessary when:
>> +	 * - The on-disk size is block-aligned (no stale data exists).
>> +	 * - The write start is within the block of the old EOF
>> +	 *   (overwriting, or appending to a block that already contains
>> +	 *   valid data).
>> +	 */
>> +	if (!(disksize & (blocksize - 1)) ||
>> +	    pos < round_up(disksize, blocksize))
>> +		return;
>> +
>> +	order_len = READ_ONCE(ei->i_ordered_len);
>> +	if (!order_len)
>> +		return;
>> +
>> +	/*
>> +	 * Pair with smp_store_release() in ext4_iomap_end_bio() and
>> +	 * ext4_block_zero_eof(). Ensure we see the updated i_ordered_lblk
>> +	 * that was written before the release store to i_ordered_len.
>> +	 */
>> +	smp_rmb();
>> +	order_lblk = READ_ONCE(ei->i_ordered_lblk);
>> +	if ((pos >> inode->i_blkbits) >= order_lblk + order_len)
>> +		wait_event(ei->i_ordered_wq, READ_ONCE(ei->i_ordered_len) == 0);
>> +}
>> +
>>  static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
>>  					 loff_t end)
>>  {
>> @@ -656,6 +696,9 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>>  		goto out;
>>  	}
>>  
>> +	/* Wait ordered zero data to be written out. */
>> +	ext4_iomap_wb_ordered_wait(inode, pos, pos + size);
>> +
>>  	/* We may need to convert one extent and dirty the inode. */
>>  	credits = ext4_chunk_trans_blocks(inode,
>>  			EXT4_MAX_BLOCKS(size, pos, inode->i_blkbits));
>> @@ -717,8 +760,25 @@ void ext4_iomap_end_bio(struct bio *bio)
>>  	struct inode *inode = ioend->io_inode;
>>  	struct ext4_inode_info *ei = EXT4_I(inode);
>>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>> +	unsigned long io_mode = (unsigned long)ioend->io_private;
>>  	unsigned long flags;
>>  
>> +	/*
>> +	 * This is an ordered I/O, clear the ordered range set in
>> +	 * ext4_block_zero_eof() and wake up all waiters that will update
>> +	 * the inode i_disksize.
>> +	 */
>> +	if (io_mode == EXT4_IOMAP_IOEND_ORDER_IO) {
>> +		/*
>> +		 * Pairs with wait_event() in ext4_iomap_wb_ordered_wait().
>> +		 * Ensure i_ordered_len = 0 is visible before waking up
>> +		 * waiters.
>> +		 */
>> +		smp_store_release(&ei->i_ordered_len, 0);
>> +		wake_up_all(&ei->i_ordered_wq);
>> +		goto defer;
>> +	}
>> +
>>  	/* Needs to convert unwritten extents or update the i_disksize. */
>>  	if ((ioend->io_flags & IOMAP_IOEND_UNWRITTEN) ||
>>  	    ioend->io_offset + ioend->io_size > READ_ONCE(ei->i_disksize))
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 62bfe05a64bc..9c0a00e716f3 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -1444,6 +1444,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>>  	ext4_fc_init_inode(&ei->vfs_inode);
>>  	spin_lock_init(&ei->i_fc_lock);
>>  	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
>> +	ei->i_ordered_lblk = 0;
>> +	ei->i_ordered_len = 0;
>> +	init_waitqueue_head(&ei->i_ordered_wq);
>>  	return &ei->vfs_inode;
>>  }
>>  
>> @@ -1480,12 +1483,20 @@ static void ext4_destroy_inode(struct inode *inode)
>>  		dump_stack();
>>  	}
>>  
>> -	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS) &&
>> -	    WARN_ON_ONCE(EXT4_I(inode)->i_reserved_data_blocks))
>> -		ext4_msg(inode->i_sb, KERN_ERR,
>> -			 "Inode %llu (%p): i_reserved_data_blocks (%u) not cleared!",
>> -			 inode->i_ino, EXT4_I(inode),
>> -			 EXT4_I(inode)->i_reserved_data_blocks);
>> +	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS)) {
>> +		if (WARN_ON_ONCE(EXT4_I(inode)->i_reserved_data_blocks))
>> +			ext4_msg(inode->i_sb, KERN_ERR,
>> +				 "Inode %llu (%p): i_reserved_data_blocks (%u) not cleared!",
>> +				 inode->i_ino, EXT4_I(inode),
>> +				 EXT4_I(inode)->i_reserved_data_blocks);
>> +
>> +		if (WARN_ON_ONCE(EXT4_I(inode)->i_ordered_len))
>> +			ext4_msg(inode->i_sb, KERN_ERR,
>> +				 "Inode %llu (%p): i_ordered_lblk (%u) and i_ordered_len (%u) not cleared!",
>> +				 inode->i_ino, EXT4_I(inode),
>> +				 EXT4_I(inode)->i_ordered_lblk,
>> +				 EXT4_I(inode)->i_ordered_len);
>> +	}
>>  }
>>  
>>  static void ext4_shutdown(struct super_block *sb)
>> -- 
>> 2.52.0
>>

