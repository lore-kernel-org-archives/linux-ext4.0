Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6745320E702;
	Thu, 25 Jun 2026 03:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782358428; cv=none; b=sf0WkV0HZ6PC0IPKx/4NxTxeByGoNHfyNnzV458MIM4T9y2oyspsB1tm2I2gH1c+/sIgbst6fdCLguJGY5RAGWzsSqbNBA4+PjyLWjjgkSK2E4D8uXOEKzuU1ucBZ+nHQwPe5/rOUYQP5mXE0C7q76vpFHYsRDsrXDe0nOiHCho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782358428; c=relaxed/simple;
	bh=+Hjz9+r0GE/xG38QP8tfHPBOmns7ZRi/rZdYo9hraCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HUNHshZy/6/H4uXiAofj7jn50PGlkXuci7s0Wuhu+nxVUoO2H4T7PtLW0aYz9udWHzubgnKdMGelOwoSl73XQP5VWf8964epn/ldKGSzCLtuk7Hx4fNa06DitG7rqFpvyXHyzooGT5M1T0AtbLqvMEURx9wkdTUZiVkBfuV6NRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gm4Bc2JqszYQtvm;
	Thu, 25 Jun 2026 11:32:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id CFF514058D;
	Thu, 25 Jun 2026 11:33:39 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgB3eT6QoTxqQe0RDA--.29140S3;
	Thu, 25 Jun 2026 11:33:38 +0800 (CST)
Message-ID: <881a714b-12ad-4678-81d1-f92dcc126567@huaweicloud.com>
Date: Thu, 25 Jun 2026 11:33:36 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/23] ext4: implement writeback path using iomap
To: Jan Kara <jack@suse.cz>, Zhang Yi <yizhang089@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-10-yi.zhang@huaweicloud.com>
 <jxlc26s4ez5mug27innhntsubeddyishy7wlz6nv6dfugvz7c3@ztgmhhe2333m>
 <b0781809-4759-4e12-be17-71555b764f48@gmail.com>
 <i536qqwj5eyulec3r2ki2ycnelqdd4bkpat2drn7t72t6p622k@ktueynysgo3j>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <i536qqwj5eyulec3r2ki2ycnelqdd4bkpat2drn7t72t6p622k@ktueynysgo3j>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgB3eT6QoTxqQe0RDA--.29140S3
X-Coremail-Antispam: 1UD129KBjvAXoW3ury7uF4fZw1kZr17ZF13Arb_yoW8GF18Zo
	Wftw4aqr48Gr15Aa40yas3C345W3WkGr1xJrWY9r4SyF4aqay3Aw4fAw43Xay3Ja10krs5
	Aa48Gwn5ArZFq3Wrn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUY27kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
	GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	UAwIDUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/25/2026 1:16 AM, Jan Kara wrote:
> On Mon 22-06-26 20:36:02, Zhang Yi wrote:
>> On 6/16/2026 7:47 PM, Jan Kara wrote:
>>> On Mon 11-05-26 15:23:29, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> Add the iomap writeback path for ext4 buffered I/O. This introduces:
>>>>
>>>>   - ext4_iomap_writepages(): the main writeback entry point.
>>>>   - ext4_writeback_ops: a new iomap_writeback_ops instance to handle
>>>>     block mapping and I/O submission.
>>>>   - A new end I/O worker for converting unwritten extents, updating file
>>>>     size, and handling DATA_ERR_ABORT after I/O completion.
>>>>
>>>> Core implementation details:
>>>>
>>>>   - ->writeback_range() callback
>>>>     Calls ext4_iomap_map_writeback_range() to query the longest range of
>>>>     existing mapped extents. For performance, when a block range is not
>>>>     yet allocated, it allocates based on the writeback length and delalloc
>>>>     extent length, rather than allocating for a single folio at a time.
>>>>     The folio is then added to an iomap_ioend instance.
>>>>
>>>>   - ->writeback_submit() callback
>>>>     Registers ext4_iomap_end_bio() as the end bio callback. This callback
>>>>     schedules a worker to handle:
>>>>     - Unwritten extent conversion.
>>>>     - i_disksize update after data is written back.
>>>>     - Journal abort on writeback I/O failure.
>>>>
>>>> Key changes and considerations:
>>>>
>>>> - Append write and unwritten extents
>>>>    Since data=ordered mode is not used to prevent stale data exposure
>>>>    during append writebacks, new blocks are always allocated as unwritten
>>>>    extents (i.e. always enable dioread_nolock), and i_disksize update is
>>>>    postponed until I/O completion. Additionally, the deadlock that the
>>>>    reserve handle was expected to resolve does not occur anymore.
>>>>    Therefore, the end I/O worker can start a normal journal handle
>>>>    instead of a reserve handle when converting unwritten extents.
>>>>
>>>> - Lock ordering
>>>>    The ->writeback_range() callback runs under the folio lock, requiring
>>>>    the journal handle to be started under that same lock. This reverses
>>>>    the order compared to the buffer_head writeback path. The lock ordering
>>>>    documentation in super.c has been updated accordingly.
>>>>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>> ---
>>>>   fs/ext4/ext4.h        |   4 +
>>>>   fs/ext4/inode.c       | 208 +++++++++++++++++++++++++++++++++++++++++-
>>>>   fs/ext4/page-io.c     | 126 +++++++++++++++++++++++++
>>>>   fs/ext4/super.c       |   7 +-
>>>>   fs/iomap/ioend.c      |   3 +-
>>>>   include/linux/iomap.h |   1 +
>>>>   6 files changed, 346 insertions(+), 3 deletions(-)
>>>>

[...]

>> There are actually two reasons for this. First, we want to avoid
>> starting a journal handle in overwrite scenarios. Second, we want to
>> be able to query the extent locklessly without holding i_data_sem in
>> overwrite cases as well (note that ext4_es_lookup_extent() in
>> ext4_iomap_map_one_extent() is called with i_data_sem held).
>>
>> I ran a set of benchmark tests in my VM, performing the following FIO
>> overwrite test on a 500GB ramdisk:
>>
>> $fio -filename=/test_dir/foo -direct=0 -iodepth=8 -fsync=0 -rw=write \
>>            -numjobs=1 -bs=4k -ioengine=io_uring -size=20G -uncached=1 \
>>            -runtime=30 --ramp_time=5s -time_based -norandommap=0 \
>>            -fallocate=none -overwrite=1 \
>>            -group_reportin -name=test --output=/tmp/log
>>
>> The results are as follows:
>>
>> a: on a non-fragmented file
>> A: on a fragmented file [1]
>> b: no background metadata pressure
>> B: with background metadata pressure [2]
>>
>>      buffer_head | iomap pre-map w/o journal | iomap directly map
>> a+b:    680                 691                   690
>> a+B:    560                 568                   567
>> A+b:    637                 633                   579
>> A+B:    540                 571                   495
>>
>> [1] The file is pre-fragmented such that each block occupies a separate
>>     extent.
>> [2] A background fsstress process is running (only contains metadata
>>     ops):
>>     taskset -c 2 fsstress -c -d /test_dir -l 0 -n 1000 -f clonerange=0 \
>>             -f copyrange=0 -f awrite=0 -f aread=0 -f dread=0 \
>>             -f dwrite=0 -f mread=0 -f mwrite=0 -f readv=0 -f write=0 \
>>             -f writev=0 -f read=0 -f sync=0 -f afsync=0 -f fsync=0
>>
>> As can be seen, for large contiguous files, the performance impact is
>> minimal. However, in heavily fragmented scenarios or under other
>> metadata pressure, pre-querying the mapping brings noticeable gains.
>> However, this is testing the most extreme case — I'm not sure about
>> the real-world impact, so I don't have a strong preference either way.
>> But I suppose faster is better, at least not slower than the old
>> buffer_head path. :)
> 
> OK, thanks for the test! So for fragmented files the optimization of not
> starting a transaction seems indeed worth it. I still dislike the
> opencoding :) So given we have the reversed lock ordering now, why don't we
> teach ext4_map_blocks() to start a transaction (if not provided) just
> before it acquires i_data_sem for writing? This should be quite elegant. I
> know you have some concerns about possible races below so let's discuss
> that separately but at least in terms of performance and code complexity
> this would look ideal :).
> 

Yeah, I agree with you on this point. But let's discuss the below race
issue first.  :)

>>> then I'd
>>> probably prefer coming up with an ext4_get_blocks flag which tells it to
>>> start a transaction on its own if we need to allocate blocks... That would
>>> be much simpler than opencoding all this.
>>
>> Additionally, there is a key point here. The reason I open-coded
>> ext4_iomap_map_writeback_range() is that we must ensure extent query
>> and allocation are performed atomically under i_data_sem. Otherwise,
>> concurrent truncate could lead to quota leaks.
>>
>> Specifically, consider the following scenario: we call
>> ext4_map_blocks() to allocate blocks. Suppose there is a delalloc
>> extent covering blocks [0,3). While writeback is submitting block 0, a
>> concurrent truncate(block 1) occurs:
>>
>> wb                         truncate
>> ext4_es_lookup_extent()    ext4_truncate_down()
>>   //get [0,3)
>>                             truncate_inode_pages_range()
>>                                //clear page 1&2
>>                             ext4_truncate()
>>                              down_write(i_data_sem)
>>                               ext4_es_remove_extent()
>>                                //drop extent [1,3)
>>                                //i_reserved_data_blocks: 3->1
>>                               up_write(i_data_sem)
>> down_write(i_data_sem)
>> ext4_map_create_blocks()
>>   //alloc 3 blocks
>>  ext4_es_insert_extent()
>>   //only reclaim 1 block，stale 2 blocks
>> up_write(i_data_sem)
>>
>> Therefore, If we don't open-coding this part, we would need to
>> significantly rework ext4_map_blocks(), which might have a larger
>> impact at this point. What do you think?
> 
> Hum, is something like this really possible? I mean iomap_writepages() will
> lookup and lock folio. Only then it calls ->iomap_begin to map it to
> underlying blocks. And folio lock synchronizes against
> truncate_inode_pages_range() so how would writeback end up trying to
> allocate something underlying pages 1 or 2?

I believe this scenario can indeed occur, and folio lock alone is
insufficient to protect against this concurrency issue. The main reason
is that the iomap writeback framework processes folios one by one. For
each folio, it follows the "lock -> map -> unlock" sequence. If each
iteration only mapped blocks covering no more than one folio in length,
performance would be severely degraded. Therefore, both XFS and the
current ext4 iomap implementation choose to map up to the minimum of the
writeback length and the delalloc extent length. This means that when
processing folio 0, if an extent of length 3 is found, the ranges
corresponding to the subsequent folios are also mapped and cached. As a
result, holding only the folio lock of folio 0 is insufficient to
protect against truncation concurrency with the latter two folios.

This issue does not occur in the original buffer_head writeback path,
ext4_do_writepages(). In that path, a batch of consecutive folios to be
mapped are locked upfront before the mapping operation. Therefore, the
blocks within the corresponding range are protected by folio locks
during mapping, making it impossible for truncation to race with
writeback.

[...]

>>>> +void ext4_iomap_end_bio(struct bio *bio)
>>>> +{
>>>> +	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
>>>> +	struct inode *inode = ioend->io_inode;
>>>> +	struct ext4_inode_info *ei = EXT4_I(inode);
>>>> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>>>> +	unsigned long flags;
>>>> +
>>>> +	/* Needs to convert unwritten extents or update the i_disksize. */
>>>> +	if ((ioend->io_flags & IOMAP_IOEND_UNWRITTEN) ||
>>>> +	    ioend->io_offset + ioend->io_size > READ_ONCE(ei->i_disksize))
>>>> +		goto defer;
>>>> +
>>>> +	/* Needs to abort the journal on data_err=abort.  */
>>>> +	if (unlikely(ioend->io_bio.bi_status))
>>>> +		goto defer;
>>>> +
>>>> +	iomap_finish_ioend(ioend, 0);
>>>> +	return;
>>>> +defer:
>>>> +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>>>> +	if (list_empty(&ei->i_iomap_ioend_list))
>>>> +		queue_work(sbi->rsv_conversion_wq, &ei->i_iomap_ioend_work);
>>>> +	list_add_tail(&ioend->io_list, &ei->i_iomap_ioend_list);
>>>> +	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>>>> +}
>>>
>>> For now, I'd prefer to do what XFS does and offload everything. Then you
>>> don't have to export iomap_finish_ioend() (which would need to be in a
>>> separate patch and acked by iomap maintainers) and the code is more
>>> standard. There's a patchset in the works which adds general ioend offloading
>>> infrastructure into iomap [1] and when that lands we should get all these
>>                       ^^^^^ block layer?
>>
>>> bells and whistles (even better ones with percpu work queues, batching,
>>> etc.) for free.
>>>
>>> [1] https://lore.kernel.org/all/20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu/
>>>
>>> 								Honza
>>
>> Ha, I've noticed this patchset, so I haven't implemented
>> uncached I/O handling for now. As a side note, I have a question:
>> if we convert all endio processing to worker threads, IIRC, my
>> recollection from previous performance tests is that pure overwrite
>> scenarios would see at least a 20% degradation. Is that acceptable?
> 
> No, but the latest version of the patches exactly does IO completion in the
> interrupt unless the bio is flagged as needing IO completion from process
> context or unless end_io handler returns a particular error - which means
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Please let me confirm whether my understanding is correct. The latest(v6)
modification to bio_endio() is as follows:

@@ -1791,7 +1865,9 @@ void bio_endio(struct bio *bio)
 	}
 #endif

-	if (bio->bi_end_io)
+	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK) && bio_in_atomic())
+		__bio_complete_in_task(bio);
+	else if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }

Currently, __bio_complete_in_task() is only called in bio_endio() when
BIO_COMPLETE_IN_TASK is explicitly set on the bio. It is not called
again based on a specific error return from bio->bi_end_io(). So I
believe what you meant is that each filesystem's own ->bi_end_io()
should call it to convert the endio processing to process context.
Is my understanding correct?

> IO completion wasn't actually done and needs offloading into process
> context instead.
> 
>> I understand why uncached I/O might need the entire completion path
>> in a worker, but can we complete the I/O in interrupt context for
>> pure overwrite and then release the page cache in a worker? Must
>> page cache invalidation and I/O completion be synchronous?
> 
> Strictly speaking no, we can first complete the IO and evict page cache
> independently later. But it would be quite tricky locking wise (folios and
> the mapping containing them can get evicted once folio writeback bit gets
> cleared) so the whole uncached writes handling would have to be reworked. I
> don't think it's worth it at this point.

Ah, I see. Thanks for the clarification. :)

>  
>> The reason I kept ext4_iomap_end_bio() handling I/O completion in
>> interrupt context is for overwrite performance. XFS also handles
>> overwrites in interrupt context (via ioend_writeback_end_bio()).
>> However, ext4 has the data_error=abort mount option — when this mode
>> is set and an I/O error occurs, we must abort the journal in a
>> worker. Since we cannot predict I/O errors at submission time, we
>> can't directly use ioend_writeback_end_bio() and must instead bind
>> our own ext4_iomap_end_bio(). At the same time, I want to avoid
>> spawning a worker for pure overwrites when no I/O error occurs, so I
>> exported iomap_finish_ioend(). What do you think?
> 
> So data_error=abort handling can exactly use the new generic framework - if
> we detect during processing IO completion we cannot actually do it in the
> interrupt (like in case of error), we just return appropriately from the
> handler and the generic code will handle offloading and call the ->end_io
> callback again.
> 
> 								Honza

If my understanding above is correct, what you are suggesting here is
that in ext4_iomap_end_bio(), we should call __bio_complete_in_task()
to switch to process context when data_error=abort is set and the I/O
returns an error. This way, we could drop ext4's own
i_iomap_ioend_work / i_rsv_conversion_work handling. Is that right?

But even with that, it seems we would still need to export
iomap_finish_ioend(). Because if the I/O does not fail,
ext4_iomap_end_bio() would need to complete the IO processing in
interrupt context for pure overwrite and would not switch to tasks
context. Because only iomap_finish_ioend() is safe to call in interrupt
context. Am I misunderstanding something?

Thanks,
Yi.

