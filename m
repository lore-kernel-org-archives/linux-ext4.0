Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397DF2E738B;
	Thu,  8 Oct 2026 12:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791462066; cv=none; b=ZSkOmKsZslSI5e2tiFRqbTKTWahxzNF80wBibL72oznGQwDnbB4MAMQTq9bVKCaxmobA/AqY+52dhw9OV2jWJWwG5qXFeNqoBeelc5yfBOesTzk8VgRnJ7j06vKN1F4LNBXo6MPfy8eL4nDwD3CnXfc7Y3FqEew+jTXVYP2RQtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791462066; c=relaxed/simple;
	bh=lMSRThv56yqi2c1Kr6mK4q4tinGZFq3KIyA9Qp/k5GU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FcrEV8ATolB32pmWmTrGOIL4QM5gDEzULp+Y/strL3ijo0Zwoib+5Xa+jVRwD6xv0vPMFlB0a7jzyqeFyKeys51XCvYhnpxSa152sbUwewbDzhpdfVKkLOn8ai+BK2gayjkzvLSYDUvwBwDP0h5UE9ZnV+ZWYHWv5K3FhKIDcaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j0pwc4cVNzYQvW9;
	Thu,  8 Oct 2026 20:20:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4213140599;
	Thu,  8 Oct 2026 20:20:59 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBHFyqgisdqshvpDA--.27979S3;
	Thu, 08 Oct 2026 20:20:58 +0800 (CST)
Message-ID: <d1a2d713-e329-41a4-aae0-3f315a8be06c@huaweicloud.com>
Date: Thu, 8 Oct 2026 20:20:48 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing
 unaligned EOF block
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
 wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-28-yi.zhang@huaweicloud.com>
 <asNl-SOu1im5mJhc@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <asNl-SOu1im5mJhc@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBHFyqgisdqshvpDA--.27979S3
X-Coremail-Antispam: 1UD129KBjvJXoW3AFyxXw1xGF13Xw4rCF45ZFb_yoW3tryUp3
	yUK3Z5Ar4DKr9F9r1IqF1Sqr129395Jw4UGFZxGrW2vF98ur1IgFyIg34rWFy8A39xGa12
	qF4UGrZ7u3W0yrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUIa
	0PDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/5/2026 4:55 PM, Ojaswin Mujoo wrote:
> On Thu, Sep 03, 2026 at 08:35:39PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> In the iomap buffered I/O path, data=ordered mode is not used, so the
>> zeroed EOF block has no implicit ordering with later i_disksize updates.
>> Without the pending state being set, i_disksize can be advanced past the
>> zeroed block before writeback completes, exposing stale data after a
>> crash.
>>
>> Previous patches added the consumer side of the
>> disksize-grow-pending mechanism: the state bit, clear and wait helpers,
>> and ioend tagging. Now add ext4_iomap_mark_disksize_pending() and call
>> it from ext4_block_zero_eof() after zeroing the tail of the block that
>> straddles i_disksize.
>>
>> The helper locks the folio, waits for any in-flight writeback on it to
>> complete, then sets EXT4_STATE_DISKSIZE_GROW_PENDING only if the folio
>> is still dirty. Waiting for writeback prevents folio_test_dirty() from
>> returning false mid-writeback, which would cause us to skip the pending
>> state while zeroed data is still in flight. The dirty check then avoids
>> setting the bit when the data has already been written back.
>>
>> Suggested-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Hey Zhang, so I've been looking at the last few patches
> (DISKSIZE_GROW_PENDING) handling as a whole, and I have a race that I
> think might hit. (This is assuming we will revert 3/31 patch here as its
> buggy). Imagine the following set of operations:

Thank you for the review! Though I don't think this race can actually
happen. See below.

> 
>     Initial state: i_size = i_disksize = 2k
>     pwrite(4k,6k)
>     pwrite(8k,10k)
> 
>     The following order might cause an issue:
> 
>     1. pwrite(4k,6k)
>        - ext4_block_zero_eof(2k,4k)
>          set inode state DISK_SIZE_GROW_PENDING
>        - i_size=6k, i_disksize=2k
>     2. writeback(2k,4k)
>        - submits a GROW_IO ioend for 0,4k
>        - i_size=6k, i_disksize=2k (unchanged)
>     3. writeback(4k,6k)
>        - Imainge here a parallel mmap has written beyond 6k so we have
>          data past EOF
>        - submits IO for 4k,8k
>        - i_size=6k, i_disksize=2k (unchanged)
>     4. IO for 3. completes (disk has data past 6kb now)
>        - completion not called yet.
>     5. pwrite(8k,10k)
>        - ext4_block_zero_eof(6k,8k)

Please note that ext4_iomap_mark_disksize_pending() will call
folio_wait_writeback() before setting bit, so this will wait for I/O for
3 to complete. Once it's done, we can obtain a fresh, stable i_disksize
and re-set the DISK_SIZE_GROW_PENDING flag. So the 6k - 8K data shouldn't
be exposed below.

Thanks,
Yi.

>          DISK_SIZE_GROW_PENDING already set
>        - i_size=10k, i_disksize=2k (updated)
>     6. endio handler for 2.
>        - Sees GROW_IO ioend, clears DISK_SIZE_GROW_PENDING
>        - i_size=10k i_disksize=10k (updated)
>     7. writeback (8k, 10k) for 5.
>        - submits IO for 8k,12k
>        - i_size=10k i_disksize=10k (unchanged)
>     8. endio handler for 7.
>        - Sees DISK_SIZE_GROW_PENDING cleared.
>        - converts 8k,12k written.
>        - i_size=10k i_disksize=10k (unchanged)
>     9. end handler for 3.
>        - Sees DISK_SIZE_GROW_PENDING cleared.
>        - converts 4k,8k to written. This exposes 6k to 8k data
>          which is zeroed in folio but not on disk yet.
>        - i_size=10k i_disksize=10k (unchanged)
>     10. **crash**
>     11. We now have i_disksize of 10k with 6k to 8k written data that was
>         supposed to be zeroed but is not
> 
> In this case, ideally 6. should not clear the DISKSIZE_GROW_PENDING
> state and update the i_disksize. That should happen once the zero doen
> in 5. is complete. I think, just having an inode state might not be
> enough to handle such cases, we either might need an atomic counter or a
> linked list of ranges.
> 
> But I'd first like to to hear your opinion on it to see if the race is
> possible or did I miss something in the logic.
> 
> Regards,
> ojaswin
> 
>> ---
>>  fs/ext4/inode.c | 85 ++++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 73 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 8e8859c8f5b0..4cb0ea82f58c 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4838,6 +4838,68 @@ static int ext4_block_zero_range(struct inode *inode,
>>  					zero_written);
>>  }
>>  
>> +/*
>> + * Inodes using the iomap buffered I/O path do not use data=ordered mode.
>> + * Therefore, we mark the inode as disksize-grow-pending after zeroing the
>> + * EOF block. The zeroed block will be submitted before any subsequent
>> + * data.
>> + *
>> + * In the I/O completion path, ext4_iomap_wb_disksize_pending_wait() will
>> + * wait for I/O completion before advancing i_disksize if the write
>> + * extends beyond the zeroed boundary.
>> + *
>> + * When zeroed I/O is in progress, operations that extend i_disksize are
>> + * handled as follows:
>> + *
>> + *  - Truncate up, append fallocate and zero_range:
>> + *    Defer the update. The file size will be updated to i_size by the
>> + *    end_io handler once the ongoing pending I/O completes.
>> + *
>> + *  - Insert range and collapse range operations:
>> + *    Wait synchronously for the relevant I/O to complete before updating
>> + *    i_disksize.
>> + */
>> +static int ext4_iomap_mark_disksize_pending(struct inode *inode, loff_t from)
>> +{
>> +	struct folio *folio;
>> +
>> +	folio = filemap_lock_folio(inode->i_mapping, from >> PAGE_SHIFT);
>> +	if (IS_ERR(folio))
>> +		/* Already in writeback and cleared? */
>> +		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
>> +
>> +	/*
>> +	 * Ensure that in-flight writeback, possibly started after
>> +	 * iomap_zero_range() unlocked the folio, has completed. Without
>> +	 * this wait folio_test_dirty() below may miss the zeroed data
>> +	 * (writeback clears PG_dirty), causing us to skip the
>> +	 * disksize-grow-pending tracking and potentially expose stale
>> +	 * on-disk data.
>> +	 */
>> +	folio_wait_writeback(folio);
>> +	WARN_ON_ONCE(folio_test_writeback(folio));
>> +
>> +	/*
>> +	 * Mark the inode as disksize-grow-pending. The zeroed block will
>> +	 * be written out by the generic writepages cycle or any other
>> +	 * syncing operation.
>> +	 *
>> +	 * Multiple overlapping unaligned EOF writes should not happen,
>> +	 * because we only mark the pending state after zeroing the on-disk
>> +	 * EOF block, and i_disksize can only be updated after the previous
>> +	 * zeroed pending block has been written back or the dirty folio
>> +	 * has been discared.
>> +	 */
>> +	if (likely(folio_test_dirty(folio) &&
>> +		   !ext4_test_inode_state(inode,
>> +					  EXT4_STATE_DISKSIZE_GROW_PENDING)))
>> +		ext4_set_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING);
>> +
>> +	folio_unlock(folio);
>> +	folio_put(folio);
>> +	return 0;
>> +}
>> +
>>  /*
>>   * Submit and wait for the pending zeroed EOF block range to complete
>>   * if the given range [@offset, @end) fully covers it.  Must be called
>> @@ -4926,22 +4988,21 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>  	 * concurrent writeback that updates i_disksize. And if such a race
>>  	 * occurs, it means the previous unaligned EOF block has already been
>>  	 * zeroed (if needed) and persisted to disk.
>> -	 *
>> -	 * TODO: In the iomap path, handle this by tracking the ordered range
>> -	 * and updating i_disksize to i_size after the zeroed data has been
>> -	 * written back.
>>  	 */
>> -	if (ext4_should_order_data(inode) &&
>> -	    did_zero && zero_written && !IS_DAX(inode) &&
>> +	if (did_zero && zero_written && !IS_DAX(inode) &&
>>  	    from < round_up(READ_ONCE(EXT4_I(inode)->i_disksize), blocksize)) {
>> -		handle_t *handle;
>> +		if (ext4_should_order_data(inode)) {
>> +			handle_t *handle;
>>  
>> -		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>> -		if (IS_ERR(handle))
>> -			return PTR_ERR(handle);
>> +			handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>> +			if (IS_ERR(handle))
>> +				return PTR_ERR(handle);
>>  
>> -		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
>> -		ext4_journal_stop(handle);
>> +			err = ext4_jbd2_inode_add_write(handle, inode, from,
>> +							length);
>> +			ext4_journal_stop(handle);
>> +		} else if (ext4_inode_buffered_iomap(inode))
>> +			err = ext4_iomap_mark_disksize_pending(inode, from);
>>  		if (err)
>>  			return err;
>>  	}
>> -- 
>> 2.52.0
>>

