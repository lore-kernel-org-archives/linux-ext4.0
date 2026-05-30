Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D5A61FFE;
	Sat, 30 May 2026 09:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780133586; cv=none; b=CoAeD7ldU2EJsU0zS83LAJ6ESLvdbUnhatEw5ZlipWAu8fLYSO1Bw5YYCxKiCTrzrKQuOjFiAnVFfAjdlaI7FxSkmZjLF+0nx58wHdRGrVp5iCmF6mN2DkVaixoryC5LpVfpCkHoqiu4+NRVpl3hy45Yt+AUyGWNZi554RD9RK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780133586; c=relaxed/simple;
	bh=qU07iCSOdJv6nZV8Ta19AIiCHaspps/03yGBRxsPeQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D3jNv8LBAKmDyX/e0YnnkNjKUaPAXQyCNpDdasp7V5fgOeb0ZwBRFbTz0a0IoVbi7CqOEszjFUK5BwkssS3EMq3xaDrBX4VnIkfxHXsOOoCUVvd35dhkP3J4akrOllc7CSGlxFnI63jPSwV5PkSDPHAfsYFLGQwaFZc/ZhArMy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gSFPd4x5YzKHMZ6;
	Sat, 30 May 2026 17:32:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E856A40573;
	Sat, 30 May 2026 17:32:56 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgAX31rGrhpqnFCuEA--.60558S3;
	Sat, 30 May 2026 17:32:56 +0800 (CST)
Message-ID: <b22baeed-3a20-47a4-8e7c-22f61a6eb49b@huaweicloud.com>
Date: Sat, 30 May 2026 17:32:54 +0800
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
 <ahhEV3STaaVI4dTs@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <ahhEV3STaaVI4dTs@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAX31rGrhpqnFCuEA--.60558S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtF4DAw1DuFW7XFykAryfXrb_yoW3CF47pr
	WrKF1rJF48Xry3uwsaq3W0qr1S93yrGr1xXFy3WrsFv398CryIkFn7tr15uFy0yrs7J3W0
	qF4UJrZxuF98A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
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

On 5/28/2026 9:34 PM, Ojaswin Mujoo wrote:
> On Wed, May 27, 2026 at 09:28:28PM +0530, Ojaswin Mujoo wrote:
>> On Mon, May 11, 2026 at 03:23:38PM +0800, Zhang Yi wrote:
>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>
>>> For append writes, wait for ordered I/O to complete before updating
>>> i_disksize. This ensures that zeroed data is flushed to disk before the
>>> metadata update, preventing stale data from being exposed during
>>> unaligned post-EOF append writes.
>>>
>>> Suggested-by: Jan Kara <jack@suse.cz>
>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>> ---
>>>  fs/ext4/ext4.h    | 11 +++++++
>>>  fs/ext4/inode.c   | 80 ++++++++++++++++++++++++++++++++++++++++++-----
>>>  fs/ext4/page-io.c | 60 +++++++++++++++++++++++++++++++++++
>>>  fs/ext4/super.c   | 23 ++++++++++----
>>>  4 files changed, 161 insertions(+), 13 deletions(-)
>>>
[...]
>>> @@ -4746,8 +4771,10 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
>>>  					loff_t from, loff_t end)
>>>  {
>>>  	struct address_space *mapping = inode->i_mapping;
>>> +	struct ext4_inode_info *ei = EXT4_I(inode);
>>>  	struct folio *folio;
>>>  	bool do_submit = false;
>>> +	int ret;
>>>  
>>>  	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
>>>  	if (IS_ERR(folio))
>>> @@ -4757,14 +4784,50 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
>>>  	folio_wait_writeback(folio);
>>>  	WARN_ON_ONCE(folio_test_writeback(folio));
>>>  
>>> -	if (likely(folio_test_dirty(folio)))
>>> +	/*
>>> +	 * Mark the ordered range. It will be cleared upon I/O completion
>>> +	 * in ext4_iomap_end_bio(). Any operation that extends i_disksize
>>> +	 * (including append write end io past the zeroed boundary,
>>> +	 * truncate up and append fallocate) must wait for this I/O to
>>> +	 * complete before updating i_disksize.
>>> +	 *
>>> +	 * When multiple overlapping unaligned EOF writes are in flight, we
>>> +	 * only need to track and wait for the first one. Subsequent writes
>>> +	 * will zero the gap in memory and ensure that the zeroed data is
>>> +	 * written out along with the valid data in the same block before
>>> +	 * i_disksize is updated.
>>> +	 */
>>> +	if (likely(folio_test_dirty(folio) &&
>>> +		   READ_ONCE(ei->i_ordered_len) == 0)) {
>>> +		WRITE_ONCE(ei->i_ordered_lblk,
>>> +			   from >> inode->i_blkbits);
>>> +		/*
>>> +		 * Pairs with smp_rmb() in ext4_iomap_writeback_submit()
>>> +		 * and ext4_iomap_wb_ordered_wait(). Ensure the updated
>>> +		 * i_ordered_lblk is visible when i_ordered_len becomes
>>> +		 * non-zero.
>>> +		 */
>>> +		smp_store_release(&ei->i_ordered_len, 1);
>>>  		do_submit = true;
>>> +	}
>>>  	folio_unlock(folio);
>>>  	folio_put(folio);
>>>  
>>>  	/* Submit zeroed block. */
>>> -	if (do_submit)
>>> -		return filemap_fdatawrite_range(mapping, from, end - 1);
>>> +	if (do_submit) {
>>> +		ret = filemap_fdatawrite_range(mapping, from, end - 1);
>>> +		if (ret) {
>>> +			/*
>>> +			 * Pairs with wait_event() in
>>> +			 * ext4_iomap_wb_ordered_wait(). Ensure
>>> +			 * i_ordered_len = 0 is visible before waking up
>>> +			 * waiters.
>>> +			 */
>>> +			smp_store_release(&ei->i_ordered_len, 0);
>>> +			wake_up_all(&ei->i_ordered_wq);
>>> +			return ret;
> 
> Okay so even if the ordered IO fails we still let the i_disksize updates
> go ahead? 

Yes when data_err=ignore, no when data_err=abort.

> I think this is a deviation from the current behavior where we
> abort the journal. If this is acceptable we should atleast add a comment
> on why its okay.
> 

I think this behavior is consistent with the current data=ordered mode.
In the data_err=ignore mode, if an I/O write fails, ext4_end_io_end()
does not abort the journal, so i_disksize is still updated normally.
Conversely, in the data_err=abort mode, the journal is aborted, and
since i_disksize is not updated, it cannot be updated afterwards. Am I
missing something?

>>> +		}
>>> +	}
>>>  	return 0;
>>>  }
>>>  
>>> @@ -4827,10 +4890,13 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>>  		 * data=ordered mode. We submit zeroed range directly here.
>>>  		 * Do not wait for I/O completion for performance.
>>>  		 *
>>> -		 * TODO: Any operation that extends i_disksize (including
>>> -		 * append write end io past the zeroed boundary, truncate up,
>>> -		 * and append fallocate) must wait for the relevant I/O to
>>> -		 * complete before updating i_disksize.
>>> +		 * The end_io handler ext4_iomap_wb_ordered_wait() will wait
>>> +		 * for I/O completion before updating i_disksize if the write
>>> +		 * extends beyond the zeroed boundary.
>>> +		 *
>>> +		 * TODO: Any other operation that extends i_disksize
>>> +		 * (including truncate up and append fallocate) must wait for
>>> +		 * the relevant I/O to complete before updating i_disksize.
>>>  		 */
>>>  		} else if (ext4_inode_buffered_iomap(inode)) {
>>>  			err = ext4_iomap_submit_zero_block(inode, from, end);
>>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
>>> index 3050c887329f..ad05ebb49bf6 100644
>>> --- a/fs/ext4/page-io.c
>>> +++ b/fs/ext4/page-io.c
>>> @@ -613,6 +613,46 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
>>>  	return 0;
>>>  }
>>>  
>>> +/*
>>> + * If the old disk size is not block size aligned and the current
>>> + * writeback range is entirely beyond the old EOF block, we should
>>> + * wait for the zeroed data written in ext4_block_zero_eof() to be
>>> + * written out, otherwise, it may expose stale data in that block.
>>> + */
>>> +static void ext4_iomap_wb_ordered_wait(struct inode *inode,
>>> +				       loff_t pos, loff_t end)
>>> +{
>>> +	struct ext4_inode_info *ei = EXT4_I(inode);
>>> +	unsigned int blocksize = i_blocksize(inode);
>>> +	loff_t disksize = READ_ONCE(ei->i_disksize);
>>> +	ext4_lblk_t order_lblk, order_len;
>>> +
>>> +	/*
>>> +	 * Waiting for ordered I/O is unnecessary when:
>>> +	 * - The on-disk size is block-aligned (no stale data exists).
>>> +	 * - The write start is within the block of the old EOF
>>> +	 *   (overwriting, or appending to a block that already contains
>>> +	 *   valid data).
>>> +	 */
>>> +	if (!(disksize & (blocksize - 1)) ||
>>> +	    pos < round_up(disksize, blocksize))
>>> +		return;
> 
> Okay these checks are pretty confusing. I was intially thinking that
> i_disksize's block would always be equal to i_ordered_lblk but seems
> like that is not true because ext4_block_zero_eof() uses from=i_size.

Yeah, this is the key point that I was a bit confused about as
well.

> 
> So we could have a sequence where
> 
> 1. truncate 4k (i_disksize = i_size = 4k)
> 2. write 8k,10k (i_disksize = 4k i_size = 10k, i_ordered_len = 0 (old isisze  is block aligned)) 
> 3. write 16k,18k (i_disksize = 4k i_size = 10k, i_ordered_len = 1, lblk=4)
                                             18k                     lblk=2, (10k >> 12)
> 
> Here we issue ordered IO even though it' probably not needed.  Now if
> write 3 finishes first we see disksize as 4k so we don't wait for
> ordered write. Which seems okay since we don't risk any stale data
> exposure. However, this flow is pretty confuing.

Indeed!

> 
> Can't we somehow avoid having to issue/set ordered len/lblk in case it
> is not really needed, like only issue it if i_disksize (and not i_size) 
> is unaligned. That can simplify some of our check and avoid extra IO
> overhead.
> 

I was also planning to explore optimizations on this point next.
However, since the original logic in buffer_head already works this way,
keeping the same logic in the iomap path will not introduce any
additional side effects. To avoid unnecessary waiting, I simply added
the disksize alignment check in ext4_iomap_wb_ordered_wait().

Therefore, I do not plan to implement this optimization in this series.
I can open a separate series later to address this optimization — perhaps
by checking i_disksize in ext4_block_zero_eof() before issuing or adding
ordered I/O, and the buffer_head path might also benefit from optimization.
Meanwhile, to avoid confusion, I can add a TODO comment in this patch.

What do you think?

Cheers,
Yi.

