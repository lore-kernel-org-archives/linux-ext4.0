Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141C240D598;
	Tue, 30 Jun 2026 04:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782794493; cv=none; b=iT1K/1k8/YeMSkzXuC4T6GukyWa9tlGWKHZoJAgwMN1K3afK4rW+6QMIsp+gMOJ6MVQRbsUrI6FhafNarqqlzgIXHw5l1vaJZiI5QQDPFv8XGZZQduz5+R9P9himWYiC9ikNTMlEKGG3H/1GXOTEvWrJ+injG/NKsYfAn/Eyncs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782794493; c=relaxed/simple;
	bh=HIHJax/TekA/IPmSevuUnBs36qbQs5cMg8SoOYSvCq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K8YPd04qj8OnvR9pJgHiq+37oUIG0oEyV1bIGIOmvCx/K6RlDvyA9nupezlYQQLhdlvWRBllU5FqXD2DX8x9kcssrWv2dBeFezdR3QAzMjhDYUZl88/YCjcCI10R0LDVwMDXPce0A4A2+lfBahdtEQz1ZORhOG7i3saH46zUEtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gq9SL2rdRzYQtln;
	Tue, 30 Jun 2026 12:40:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 9563D4057D;
	Tue, 30 Jun 2026 12:41:26 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP2 (Coremail) with UTF8SMTPSA id Syh0CgCXBvT0SENqsk9MAQ--.14471S3;
	Tue, 30 Jun 2026 12:41:26 +0800 (CST)
Message-ID: <672a3768-6b13-4612-87eb-739097789b95@huaweicloud.com>
Date: Tue, 30 Jun 2026 12:41:24 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/23] ext4: implement writeback path using iomap
To: Jan Kara <jack@suse.cz>
Cc: Zhang Yi <yizhang089@gmail.com>, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-10-yi.zhang@huaweicloud.com>
 <jxlc26s4ez5mug27innhntsubeddyishy7wlz6nv6dfugvz7c3@ztgmhhe2333m>
 <b0781809-4759-4e12-be17-71555b764f48@gmail.com>
 <i536qqwj5eyulec3r2ki2ycnelqdd4bkpat2drn7t72t6p622k@ktueynysgo3j>
 <881a714b-12ad-4678-81d1-f92dcc126567@huaweicloud.com>
 <jv2yuguebafis6cahxuhnrcldqi7f7fnh4x2ibtn7tlqf3z2fi@kqbhc2ycz6mn>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <jv2yuguebafis6cahxuhnrcldqi7f7fnh4x2ibtn7tlqf3z2fi@kqbhc2ycz6mn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCXBvT0SENqsk9MAQ--.14471S3
X-Coremail-Antispam: 1UD129KBjvJXoW3CFy5trWxJFyrCrW7Zr1fWFg_yoWkGw4rpF
	WqkF1DGr4kJrySvwsFya1xtryFkw4UJF4UJrn3GrZxAF90vFyxKF4UKa4Y9Fyjkrs7Gw42
	qF4rt3yxX3WqyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/25/2026 8:58 PM, Jan Kara wrote:
> On Thu 25-06-26 11:33:36, Zhang Yi wrote:
>> On 6/25/2026 1:16 AM, Jan Kara wrote:
>>> On Mon 22-06-26 20:36:02, Zhang Yi wrote:
>>>>> then I'd
>>>>> probably prefer coming up with an ext4_get_blocks flag which tells it to
>>>>> start a transaction on its own if we need to allocate blocks... That would
>>>>> be much simpler than opencoding all this.
>>>>
>>>> Additionally, there is a key point here. The reason I open-coded
>>>> ext4_iomap_map_writeback_range() is that we must ensure extent query
>>>> and allocation are performed atomically under i_data_sem. Otherwise,
>>>> concurrent truncate could lead to quota leaks.
>>>>
>>>> Specifically, consider the following scenario: we call
>>>> ext4_map_blocks() to allocate blocks. Suppose there is a delalloc
>>>> extent covering blocks [0,3). While writeback is submitting block 0, a
>>>> concurrent truncate(block 1) occurs:
>>>>
>>>> wb                         truncate
>>>> ext4_es_lookup_extent()    ext4_truncate_down()
>>>>   //get [0,3)
>>>>                             truncate_inode_pages_range()
>>>>                                //clear page 1&2
>>>>                             ext4_truncate()
>>>>                              down_write(i_data_sem)
>>>>                               ext4_es_remove_extent()
>>>>                                //drop extent [1,3)
>>>>                                //i_reserved_data_blocks: 3->1
>>>>                               up_write(i_data_sem)
>>>> down_write(i_data_sem)
>>>> ext4_map_create_blocks()
>>>>   //alloc 3 blocks
>>>>  ext4_es_insert_extent()
>>>>   //only reclaim 1 block，stale 2 blocks
>>>> up_write(i_data_sem)
>>>>
>>>> Therefore, If we don't open-coding this part, we would need to
>>>> significantly rework ext4_map_blocks(), which might have a larger
>>>> impact at this point. What do you think?
>>>
>>> Hum, is something like this really possible? I mean iomap_writepages() will
>>> lookup and lock folio. Only then it calls ->iomap_begin to map it to
>>> underlying blocks. And folio lock synchronizes against
>>> truncate_inode_pages_range() so how would writeback end up trying to
>>> allocate something underlying pages 1 or 2?
>>
>> I believe this scenario can indeed occur, and folio lock alone is
>> insufficient to protect against this concurrency issue. The main reason
>> is that the iomap writeback framework processes folios one by one. For
>> each folio, it follows the "lock -> map -> unlock" sequence. If each
>> iteration only mapped blocks covering no more than one folio in length,
>> performance would be severely degraded. Therefore, both XFS and the
>> current ext4 iomap implementation choose to map up to the minimum of the
>> writeback length and the delalloc extent length. This means that when
>> processing folio 0, if an extent of length 3 is found, the ranges
>> corresponding to the subsequent folios are also mapped and cached. As a
>> result, holding only the folio lock of folio 0 is insufficient to
>> protect against truncation concurrency with the latter two folios.
> 
> Yes, I know about the behavior that iomap_writepages() can cache extent
> longer than what folio_lock covers. But after truncate_inode_pages_range()
> completes in the truncate path, writeback_iter will never attempt to map
> anything for folios beyond i_size. If we had anything cached from before
> truncate, iomap_valid() check takes care it isn't used.
> 
> But I think you might be concerned about the following race:
> In the writeback path iomap_writeback_folio() is called for folio 0.
> iomap_writeback_handle_eof() still sees old i_size so end_pos is kept
> large, we go down to ext4_map_blocks() which runs ext4_map_query_blocks()
                                                   and ext4_es_lookup_extent()

> and still sees larger delalloc extent. Then truncate to folio 1 comes. It
> can fully run and complete because folio 0 is not affected by it. Then
> ext4_map_blocks() resumes and calls ext4_map_create_blocks() with the (now
> stale) long delalloc extent and allocates blocks under already truncated
> area.

Yes.

> 
> Frankly what I think needs to happen is to fix ext4_map_blocks() so that
> after reacquiring i_data_sem, we recheck m_seq still matches i_seq and if
> not, redo the extent status tree lookup which will as a side effect also
> trim the length to map to appropriate size. What do you think?

Ha, I think this is a good idea. I tried making the following 4 changes
in ext4_map_blocks():

1. Before calling ext4_map_create_blocks(), check i_es_seq against
   the m_seq of the mapping info obtained from the extent status cache
   or query block. If they don't match, retry by jumping back to before
   the ext4_es_lookup_extent() call.

2. Before taking down_write(i_data_sem), check whether the caller
   passed in a handle. If not, start a handle internally and stop it
   before the function exits.

3. Avoid starting a transaction for unwritten extents. Since the
   writeback path needs to allocate unwritten extents before issuing
   I/O, we can check before calling ext4_map_create_blocks(): if an
   existing unwritten extent is found, there's no need to start a
   handle or call ext4_map_create_blocks() — we can just return
   directly.

4. Avoid allocating blocks for holes during writeback. I originally
   thought that dirty+hole wouldn't appear during writeback, but I was
   wrong, the debugging showed it does happen.

   For example, in scenarios where folio size > block size, if a mmap
   write is performed at the file's EOF, the entire folio gets dirtied.
   Later, if the file is truncated up (expanding i_size) and the folio
   is written back, a sub-folio dirty range without a pre-mapped extent
   can occur.

   I currently handle this case in ext4_iomap_map_one_extent(). In the
   original buffer_head writeback path, mpage_add_bh_to_extent() avoids
   allocating blocks for holes via !buffer_delay(bh) &&
   !buffer_unwritten(bh).

   Therefore, we need to preserve this logic. I added a check in
   ext4_map_blocks(): if the extent status cache or query finds a hole
   and the caller has set EXT4_GET_BLOCKS_IO_SUBMIT, we return directly
   without block allocation.

With the above changes, we can completely remove the initial
ext4_map_blocks() lookup step in both ext4_iomap_map_one_extent() and
ext4_iomap_map_writeback_range(), and simply call
ext4_map_blocks(EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT | ...) directly.

After some testing, it passes the kvm-xfstest auto suite, and
performance is on par with the open-coded approach. This would greatly
simplify the code.  :)

> 
>>>>> For now, I'd prefer to do what XFS does and offload everything. Then you
>>>>> don't have to export iomap_finish_ioend() (which would need to be in a
>>>>> separate patch and acked by iomap maintainers) and the code is more
>>>>> standard. There's a patchset in the works which adds general ioend offloading
>>>>> infrastructure into iomap [1] and when that lands we should get all these
>>>>                       ^^^^^ block layer?
>>>>
>>>>> bells and whistles (even better ones with percpu work queues, batching,
>>>>> etc.) for free.
>>>>>
>>>>> [1] https://lore.kernel.org/all/20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu/
>>>>>
>>>>> 								Honza
>>>>
>>>> Ha, I've noticed this patchset, so I haven't implemented
>>>> uncached I/O handling for now. As a side note, I have a question:
>>>> if we convert all endio processing to worker threads, IIRC, my
>>>> recollection from previous performance tests is that pure overwrite
>>>> scenarios would see at least a 20% degradation. Is that acceptable?
>>>
>>> No, but the latest version of the patches exactly does IO completion in the
>>> interrupt unless the bio is flagged as needing IO completion from process
>>> context or unless end_io handler returns a particular error - which means
>>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> Please let me confirm whether my understanding is correct. The latest(v6)
>> modification to bio_endio() is as follows:
>>
>> @@ -1791,7 +1865,9 @@ void bio_endio(struct bio *bio)
>>  	}
>>  #endif
>>
>> -	if (bio->bi_end_io)
>> +	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK) && bio_in_atomic())
>> +		__bio_complete_in_task(bio);
>> +	else if (bio->bi_end_io)
>>  		bio->bi_end_io(bio);
>>  }
>>
>> Currently, __bio_complete_in_task() is only called in bio_endio() when
>> BIO_COMPLETE_IN_TASK is explicitly set on the bio. It is not called
>> again based on a specific error return from bio->bi_end_io(). So I
>> believe what you meant is that each filesystem's own ->bi_end_io()
>> should call it to convert the endio processing to process context.
>> Is my understanding correct?
> 
> Right yes. I remembered wrong what we ended up with. But I was certain
> the usecase of offloading from ->bi_end_io is handled. :)
> 
>>>> The reason I kept ext4_iomap_end_bio() handling I/O completion in
>>>> interrupt context is for overwrite performance. XFS also handles
>>>> overwrites in interrupt context (via ioend_writeback_end_bio()).
>>>> However, ext4 has the data_error=abort mount option — when this mode
>>>> is set and an I/O error occurs, we must abort the journal in a
>>>> worker. Since we cannot predict I/O errors at submission time, we
>>>> can't directly use ioend_writeback_end_bio() and must instead bind
>>>> our own ext4_iomap_end_bio(). At the same time, I want to avoid
>>>> spawning a worker for pure overwrites when no I/O error occurs, so I
>>>> exported iomap_finish_ioend(). What do you think?
>>>
>>> So data_error=abort handling can exactly use the new generic framework - if
>>> we detect during processing IO completion we cannot actually do it in the
>>> interrupt (like in case of error), we just return appropriately from the
>>> handler and the generic code will handle offloading and call the ->end_io
>>> callback again.
>>
>> If my understanding above is correct, what you are suggesting here is
>> that in ext4_iomap_end_bio(), we should call __bio_complete_in_task()
>> to switch to process context when data_error=abort is set and the I/O
>> returns an error. This way, we could drop ext4's own
>> i_iomap_ioend_work / i_rsv_conversion_work handling. Is that right?
> 
> Exactly.
> 
>> But even with that, it seems we would still need to export
>> iomap_finish_ioend(). Because if the I/O does not fail,
>> ext4_iomap_end_bio() would need to complete the IO processing in
>> interrupt context for pure overwrite and would not switch to tasks
>> context. Because only iomap_finish_ioend() is safe to call in interrupt
>> context. Am I misunderstanding something?
> 
> Hmm, yes, something like that. Basically iomap ioend processing will need
> to be updated to play well with the generic IO completion offloading
> infrastructure. But that's a separate topic. Just keep things simple
> (possibly not perfect in terms of performance) since we should transition
> to the generic infrastructure sooner rather than later.
> 
> 								Honza

Yeah, I see.

OK, I get it. So for now, to keep things simple, let's not export
iomap_finish_ioend() and stay consistent with XFS by having
ext4_iomap_end_bio() always kick off a worker to handle the IO
completion logic. We can revisit and adjust the ioend handling flow
later after the new generic framework is completed.

Thanks,
Yi.

