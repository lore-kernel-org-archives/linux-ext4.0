Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E687286419
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2026 03:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782099152; cv=none; b=YtavIQpmJb9Q/OCp9ZMllH1yA2AT1XH/gkePw8hzXk2zDLBPqBCDCgRpogvMrrVWDP2edAhFG1rDG/nwy+q6QDh4baqxXcV1jqy2Y1riOMhr/wpXYP8scTTZzip25/x+3IbgxvEfSpSVlRtdv4R9TGnq8IpammQBVH/IQYuAtMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782099152; c=relaxed/simple;
	bh=IQCNczz362BJKOTuSK/2fHb7kUxzCXLixSu1ys/HKSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TNxubLr7+nD0VSARC0QBgNK0GgJasXU7OUzDUarxBZ/mkQzsNO6yB2q1IUzS9S6/Kw0K02hsVbDuuoyLuP5ZpEY3+CEgUr8E4sJ8fe6bSJJ1/puFrlCx5iZEXcEETsCjZ+6T8MR1n0xRU8fzg3QVzIX9delNN86HwMG+UyYW6K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RclQVVNN; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RclQVVNN"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c6ec0af575so23874435ad.1
        for <linux-ext4@vger.kernel.org>; Sun, 21 Jun 2026 20:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782099150; x=1782703950; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yIlz1K6aIT1CuYjgAcvLI6q8d0Jll7bCZwaf+v0UXG0=;
        b=RclQVVNNA8Di+AXI283DCd0grDGss/UXk80+pvxPtts00HLgVCin3g0cORwrmKdN1b
         PYvP7Cv68hWwH9FDeArrbPkJJhMKUMM9BxlZt4lRzS4JT+RED6VPu5P6fIDNDzEzVRGS
         QhxkbnyYvjn/gyWsskANUH2EHHfjblfO0+MoCzSNkdzFvHDzNTtRyjvs4pXlTABIQ34A
         RSdJw/ntJE1BHJeQREkYEYRJeMhw1RTMpa/yo7gN2Edmxz9ocWJrs+ZGY2o2aZH/x/zS
         otvwrHWpwaQhmq75dvqJ1EfmOsqecm/uKpGFj//5IXvWyvAE+3mOkG3x+nx/WFhQZt52
         Nuhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782099150; x=1782703950;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yIlz1K6aIT1CuYjgAcvLI6q8d0Jll7bCZwaf+v0UXG0=;
        b=SW00deZRqlYcDSnOfPEs/gEbwPRMAXhVXF+azh86p/ROEScx08ZRuEx38wL/XYxdNY
         OAZFCjxJxi0XddxkX+fkYd/2feBHWedASRCaIdDDq4qnHJV70nIJpJOlkoDcxjJOBcQc
         NWQUrZZUwLwIH27xywte9uVinC5I/BBCzNzx7MqTqKDBF7t5CScf9QxQ5iRgchNaF0Wg
         ayLRW3hLc5kntMKmElkgXqqsSnRAFEMpsfCmja1evjZmIOMepnQh7Plxkon9fkkKDh1M
         dAgHgi4Z3zkAeYNFB/PIaSFQ7yYA1y58kzy/23liE2nsQFmMaRq9YVfte2IosTU3bWux
         0jbg==
X-Gm-Message-State: AOJu0Yxyc7Z9JhZa0Qc59mUim1HLbeh6eAs3XnI3c+kvX/2YgCp9mNsk
	ntThy+0K+E6drWkCKxuWt6bDN9CFwH8v7w2bwZhXQi85StGUYUzfdqfi
X-Gm-Gg: AfdE7cmsjNxg0S2TXdMZdM7nbagpPZ1xlvv0MJHoaBVCtLopqw/eGnQCMpsg79t30jL
	+JL9BuGUdNGAiF7Ck15keP+KA93vM3UEXdWyVu7ElBG7N9VbwmxmMcS3orBW5qMViAkEKtyqJrM
	Mb2kesiJ/oBGBVK4deO8Zsq2ydVkzaTZch6fO/LIrAaY7hSSnsgVdWEgP23toclYR7L+/TCaQLA
	OMYBjXLRlo/0hO4nc1++y+IXrJq4P5qiFR7UMNs3QWxaE48JE60Q4X9NQivXJlfR4uXq7K5J8Kq
	pxmVfkZfZ3WyWx8TpP6ZCi21zSMXrRpUdgvCymfDHnPhe3Tm8OTKt6J8bfVznNZaJ1TIHgzq34E
	K3ThvS1DGsIFb7Linz+WIoFWakgbIDTot0xDTmjZMBFEgb2QmcuRsszVL6i2AzuAxG39mZQkgcv
	3+EG9xlgGK+ZIUMA3uIKKIZBRILAR9h4Lq
X-Received: by 2002:a17:902:f54e:b0:2bf:7b62:a038 with SMTP id d9443c01a7336-2c718ca5fcbmr145682415ad.9.1782099149762;
        Sun, 21 Jun 2026 20:32:29 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7439f85fesm61146885ad.46.2026.06.21.20.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2026 20:32:29 -0700 (PDT)
Message-ID: <9ab9281d-c5dc-4183-8bc9-b53b5a4ac9c0@gmail.com>
Date: Mon, 22 Jun 2026 11:32:16 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap buffered
 I/O path
To: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <k3w5c3cyg2py4kums7nhdwjg6b6pm43qtweepuolk57xtmnotz@yxkm2k6sqfc6>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <k3w5c3cyg2py4kums7nhdwjg6b6pm43qtweepuolk57xtmnotz@yxkm2k6sqfc6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/2026 9:48 PM, Jan Kara wrote:
> On Mon 11-05-26 15:23:38, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> For append writes, wait for ordered I/O to complete before updating
>> i_disksize. This ensures that zeroed data is flushed to disk before the
>> metadata update, preventing stale data from being exposed during
>> unaligned post-EOF append writes.
>>
>> Suggested-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Frankly, this all looks too complex to me. Plus your are adding 32-bytes to
> struct ext4_inode_info which isn't great either. Why don't you just do
> filemap_fdatawait() for the byte at old i_disksize and be done with it?
> 
> I believe we have to simplify this. All this complexity (and thus
> maintenance burden) across several patches for the corner case of zeroing
> tail block on extention is in my opinion difficult to justify.
> 
> 								Honza

Hi, Jan!

Thanks for the review. I understand the concern about complexity and the
32-byte increase to ext4_inode_info. I tried using
filemap_fdatawait_range() as you suggested, but found two issues where
this solution doesn't work.

1. ioend worker deadlock

Since worker concurrency resources are limited, we cannot wait for
another ioend worker to complete within one ioend worker with the same
work_struct. If the worker calls
filemap_fdatawait_range(byte_at_old_disksize) to wait for the zeroed
block's folio writeback to complete, it sleeps holding the only worker
slot. If the folio contains blocks requiring extent conversion, its
writeback bit is cleared by iomap_finish_ioends() running inside
another worker -- which can only run after the current worker finishes
its batch.

Concretely:
   - Worker W1 processes ioend A, calls filemap_fdatawait_range() on
     the old EOF byte, sleeps.
   - The zeroed data is in ioend B. bio_endio defers it to
     i_iomap_ioend_list and calls queue_work().
   - queue_work() on i_iomap_ioend_work is idempotent: it returns false
     because the work is currently executing (even though sleeping).
   - ioend B sits in the list, never gets processed.
   - The folio writeback bit is only cleared by processing ioend B.
   - W1 sleeps forever -> deadlock.

Therefore, I think we have to put the wakeup logic in
ext4_iomap_end_bio() that runs in interrupt context without consuming
a worker thread. The ordered range tracking and wait queue are what
make that possible.

2. Truncate-up needs an accurate state query

In the follow-up patch 19, ext4_set_inode_size() must make a precise
decision when updating i_disksize during truncate up.

This needs a state query: "is there ordered zero I/O in flight right
now?" If yes, the i_disksize update is deferred to
ext4_iomap_wb_update_disksize(is_ordered=true), which advances
i_disksize to i_size when the ordered I/O completes. If no, we must
advance i_disksize immediately, otherwise we will lose the updating
forever.

Therefore, we need to track the state of the ordered range. Simply
using filemap_fdatawait_range() doesn't work. i_ordered_len serves as
a maintained state flag that both the ioend completion path and the
setattr path can read atomically without sleeping.

Suggestions?

Regarding the bloat of ext4_inode_info, perhaps we can drop the
wait_queue_head_t (24 bytes) and use wait_var_event()/ wake_up_var()
instead. Would this be acceptable?

Thanks,
Yi

> 
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 078feda47e36..9ce2128eea3e 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1195,6 +1195,15 @@ struct ext4_inode_info {
>>   #ifdef CONFIG_FS_ENCRYPTION
>>   	struct fscrypt_inode_info *i_crypt_info;
>>   #endif
>> +
>> +	/*
>> +	 * Track ordered zeroed data during post-EOF append writes, fallocate,
>> +	 * and truncate-up operations. These parameters are used only in the
>> +	 * iomap buffered I/O path.
>> +	 */
>> +	ext4_lblk_t i_ordered_lblk;
>> +	ext4_lblk_t i_ordered_len;
>> +	wait_queue_head_t i_ordered_wq;
>>   };
>>   
>>   /*
>> @@ -3858,6 +3867,8 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>>   			     __u64 len, __u64 *moved_len);
>>   
>>   /* page-io.c */
>> +#define EXT4_IOMAP_IOEND_ORDER_IO	1UL	/* This I/O is an ordered one */
>> +
>>   extern int __init ext4_init_pageio(void);
>>   extern void ext4_exit_pageio(void);
>>   extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index e013aeb03d7b..11fb369efeb1 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4345,6 +4345,7 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>   {
>>   	struct iomap_ioend *ioend = wpc->wb_ctx;
>>   	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
>> +	ext4_lblk_t start, end, order_lblk, order_len;
>>   
>>   	/*
>>   	 * After I/O completion, a worker needs to be scheduled when:
>> @@ -4357,6 +4358,30 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>   	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
>>   		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
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
>> +			ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>> +			ioend->io_private = (void *)EXT4_IOMAP_IOEND_ORDER_IO;
>> +			ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
>> +		}
>> +	}
>> +
>>   	return iomap_ioend_writeback_submit(wpc, error);
>>   }
>>   
>> @@ -4746,8 +4771,10 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
>>   					loff_t from, loff_t end)
>>   {
>>   	struct address_space *mapping = inode->i_mapping;
>> +	struct ext4_inode_info *ei = EXT4_I(inode);
>>   	struct folio *folio;
>>   	bool do_submit = false;
>> +	int ret;
>>   
>>   	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
>>   	if (IS_ERR(folio))
>> @@ -4757,14 +4784,50 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
>>   	folio_wait_writeback(folio);
>>   	WARN_ON_ONCE(folio_test_writeback(folio));
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
>>   		do_submit = true;
>> +	}
>>   	folio_unlock(folio);
>>   	folio_put(folio);
>>   
>>   	/* Submit zeroed block. */
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
>>   	return 0;
>>   }
>>   
>> @@ -4827,10 +4890,13 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>   		 * data=ordered mode. We submit zeroed range directly here.
>>   		 * Do not wait for I/O completion for performance.
>>   		 *
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
>>   		 */
>>   		} else if (ext4_inode_buffered_iomap(inode)) {
>>   			err = ext4_iomap_submit_zero_block(inode, from, end);
>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
>> index 3050c887329f..ad05ebb49bf6 100644
>> --- a/fs/ext4/page-io.c
>> +++ b/fs/ext4/page-io.c
>> @@ -613,6 +613,46 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
>>   	return 0;
>>   }
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
>>   static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
>>   					 loff_t end)
>>   {
>> @@ -656,6 +696,9 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>>   		goto out;
>>   	}
>>   
>> +	/* Wait ordered zero data to be written out. */
>> +	ext4_iomap_wb_ordered_wait(inode, pos, pos + size);
>> +
>>   	/* We may need to convert one extent and dirty the inode. */
>>   	credits = ext4_chunk_trans_blocks(inode,
>>   			EXT4_MAX_BLOCKS(size, pos, inode->i_blkbits));
>> @@ -717,8 +760,25 @@ void ext4_iomap_end_bio(struct bio *bio)
>>   	struct inode *inode = ioend->io_inode;
>>   	struct ext4_inode_info *ei = EXT4_I(inode);
>>   	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>> +	unsigned long io_mode = (unsigned long)ioend->io_private;
>>   	unsigned long flags;
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
>>   	/* Needs to convert unwritten extents or update the i_disksize. */
>>   	if ((ioend->io_flags & IOMAP_IOEND_UNWRITTEN) ||
>>   	    ioend->io_offset + ioend->io_size > READ_ONCE(ei->i_disksize))
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 62bfe05a64bc..9c0a00e716f3 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -1444,6 +1444,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>>   	ext4_fc_init_inode(&ei->vfs_inode);
>>   	spin_lock_init(&ei->i_fc_lock);
>>   	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
>> +	ei->i_ordered_lblk = 0;
>> +	ei->i_ordered_len = 0;
>> +	init_waitqueue_head(&ei->i_ordered_wq);
>>   	return &ei->vfs_inode;
>>   }
>>   
>> @@ -1480,12 +1483,20 @@ static void ext4_destroy_inode(struct inode *inode)
>>   		dump_stack();
>>   	}
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
>>   }
>>   
>>   static void ext4_shutdown(struct super_block *sb)
>> -- 
>> 2.52.0
>>

