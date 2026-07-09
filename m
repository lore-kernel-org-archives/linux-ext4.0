Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354FC36EA82;
	Thu,  9 Jul 2026 07:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783580776; cv=none; b=qrNOS+g+62XVhxnGPjUDkMgdSa6TPdJRd5f/B8p5btXpSXUtaZBTHMI96mr8igYcXZuE8U9gtCnQJCEVZsU0FD/PqsdU+NsKtt5EZzi7LYKioZQ4V/F0jvJOMsY627m2aoizNxhgvV1TBwUa/PLH4QhEjF6nQ4w7BXDIR44yHIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783580776; c=relaxed/simple;
	bh=EwclMNWK+ITBhRCBjMFSNsLCzhRWogxuVLxWZ1kiOHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jitd4nyV5f4QR0M+bKwQDdsGqXZRQvuXidoruprysCz9eb4MwkRFPY39s60lp7D2SFQLx11OIpdigLlPxs2HUr36qkbIrKBHn64P/wnvN45Bo3ezq2IOBopLXM34gNuEUqraEh8ifqiceZY6nZZGStKax+dSHOzA01fZNI8uPn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gwmFk1H9BzKHMRY;
	Thu,  9 Jul 2026 15:05:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 5E8B040573;
	Thu,  9 Jul 2026 15:06:08 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgBHWHReSE9qe85ZAg--.35797S3;
	Thu, 09 Jul 2026 15:06:08 +0800 (CST)
Message-ID: <f4fada5d-4d36-48cf-8bf7-fd650e101edf@huaweicloud.com>
Date: Thu, 9 Jul 2026 15:06:05 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap buffered
 I/O path
To: Jan Kara <jack@suse.cz>, Zhang Yi <yizhang089@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <k3w5c3cyg2py4kums7nhdwjg6b6pm43qtweepuolk57xtmnotz@yxkm2k6sqfc6>
 <9ab9281d-c5dc-4183-8bc9-b53b5a4ac9c0@gmail.com>
 <3n6ge2tfe4bd65eicc7l2csxkzupcjtdtc4ojpl6bvtf7cwll6@sxmlt3uciw4c>
 <8999aa70-073c-47f9-ae6e-39af3cc1fe32@gmail.com>
 <c6zpjk3gml5lj72cagu7sncswqeea2e3h7gc2ie5qnwwe6qdft@6qoaz7zccmem>
 <d30ebe91-a5e4-4ee8-a3f7-c965e623535f@gmail.com>
 <upstctpx7ouy6hwo3tsrhagprldt63c55qazcenhiwh5zkgwpk@dh2yyv6dlxsz>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <upstctpx7ouy6hwo3tsrhagprldt63c55qazcenhiwh5zkgwpk@dh2yyv6dlxsz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBHWHReSE9qe85ZAg--.35797S3
X-Coremail-Antispam: 1UD129KBjvAXoWfGr45CryxXryDGr43WF45Jrb_yoW8JF47uo
	WrXwsrtw4xKwn8X3WjkasrC34UW3Z5Wr1kAr45Xw4Fyasaqa9Fk3yfCw15XayftF4q9r1k
	A348J34FkFy3KF93n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYc7kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
	kF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02
	F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4I
	kC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
	xUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/8/2026 7:28 PM, Jan Kara wrote:
> On Sat 04-07-26 10:34:07, Zhang Yi wrote:
>> On 7/2/2026 10:20 PM, Jan Kara wrote:
>>> On Tue 30-06-26 20:06:55, Zhang Yi wrote:
>>>> On 6/25/2026 5:42 PM, Jan Kara wrote:
>>>>> I see. Thanks for explanation. I went back to our discussion back from
>>>>> February to remind myself about the constraints on the tail block zeroing
>>>>> and the i_disksize update mechanism. And in the light of complexity of the
>>>>> current mechanism, I think we've discarded the following possibility too
>>>>> easily:
>>>>>
>>>>> * On file extend / truncate up just zero tail folio in the page cache, mark
>>>>>     it dirty, keep i_disksize at old value, update i_size to the new value,
>>>>>     add inode to orphan list.
>>>>>     If the i_disksize was block aligned (and so we skip zeroing), we just
>>>>>     update i_disksize rightaway.
>>>>>
>>>>> * In io end processing if the folio for which we end io has a block which
>>>>>     straddles i_disksize, we update i_disksize to current i_size. We defer
>>>>>     removing inode from orphan list e.g. to file close time (doing it from
>>>>>     end_io processing is problematic locking wise as we need i_rwsem for it).
>>>>>
>>>>> This is a very simple scheme with very good performace. It makes sure stale
>>>>> data in the tail block cannot be seen on disk after a crash.
>>>>
>>>> Hmm, I think this solution has a problem. Since i_disksize is advanced
>>>> to i_size only when the ioend covering the i_disksize block completes,
>>>> we must ensure that i_size is updated before the zeroed folio's
>>>> writeback completes. Otherwise the ioend worker reads the old i_size,
>>>> advances i_disksize to the old value (a no-op), and i_disksize stays
>>>> stale forever after i_size is updated.
>>>>
>>>> Currently, neither truncate-up nor file-extend paths guarantee this
>>>> ordering -- in both, ext4_block_zero_eof() runs before the i_size
>>>> update.
>>>
>>> Good point, that needs to be handled.
>>>
>>>> For truncate-up and fallocate, we might be able to split
>>>> ext4_update_inode_size() / ext4_set_inode_size() so that i_size is
>>>> updated before ext4_block_zero_eof(), and then decide whether to
>>>> update i_disksize based on whether i_disksize is block-aligned. I'm
>>>> not yet sure what side effects this reordering would have, but I feel
>>>> uneasy about this.
>>>>
>>>> The append-write case is hard to solve. We can't know the final i_size
>>>> before the write completes, so we can't update i_size ahead of
>>>> ext4_block_zero_eof(). When the zeroed folio is later written back, it's
>>>> treated as an ordinary overwriting write -- i_disksize is not advanced.
>>>> And when the subsequent buffered-write data is written back, i_disksize
>>>> still isn't advanced either. The size update is lost.
>>>
>>> One thing we need to do is to perform i_size updates in append write,
>>> truncate, etc. under i_data_sem (similarly to i_disksize updates) so that
>>> we can properly synchronize i_size + i_disksize updates from IO completion
>>> and these paths.
>>>
>>> How we could then handle the races between writeback of folio straddling
>>> i_disksize and the i_size updates from the i_size extending paths is that
>>> we'd set EXT4_STATE_DISKSIZE_GROW_PENDING bit when zeroing the folio
>>> straddling i_disksize and clear this (under i_data_sem) in IO completion
>>> when updating i_disksize to i_size. And when setting new i_size after
>>> append write, truncate up, etc. we will also update i_disksize when this
>>> state bit is not set (again all happening under i_data_sem). This should
>>> also automatically include the case where i_disksize was block aligned and
>>> thus no zeroing was needed and we need to update i_disksize together with
>>> i_size. Sounds good?
>>>
>>> 								Honza
>>
>> Ha, yeah. This overall looks good to me now. Your solution doesn't look
>> significantly different from mine currently implementation. My approach
>> uses i_ordered_len to precisely track the pending state of whether a
>> zeroed folio is awaiting submission, while you choose to use
>> EXT4_STATE_DISKSIZE_GROW_PENDING to represent this, which completely
>> eliminates the 32-byte bloat in ext4_inode_info.
> 
> Good :)
> 
>> However, I'd prefer we should still be able to keep the IO-completion
>> waiting logic instead of adding the orphan list. We can precisely
>> determine whether an IO is a "cross-i_disksize IO" by checking whether
>> its position straddles i_disksize, and when it completes, wake up the
>> worker waiting for it in interrupt context -- this won't deadlock (bio
>> end_io doesn't consume a worker thread). Besides, Since we plan to use
>> the EXT4_STATE_DISKSIZE_GROW_PENDING bit, the waiting doesn't require a
>> dedicated wait queue; wait_on_bit / wake_up_bit(&ei->i_state_flags,
>> EXT4_STATE_DISKSIZE_GROW_PENDING) should suffice.
> 
> OK, but if you want to avoid adding to orphan list, then where exactly you
> want to wait for the writeback of the folio straddling i_disksize? Because
> as we have discussed i_disksize needs to be updated in the same transaction
> in which we convert unwritten extents beyond current i_disksize to written
> ones (otherwise you could get inconsistent fs after crash with written
> extents beyond i_disksize). And you cannot update i_disksize until the
> writeback of the folio straddling current i_disksize is completed. We
> discussed you cannot wait in the end_io handler doing the extent conversion
> and i_disksize update because that blocks the conversion worker thread. So
> you want to wait earlier on IO submission?

My idea is to still wait in the ioend worker and keep it in the same
transaction as converting unwritten extents, but do the wakeup in
interrupt context rather than in another ioend worker, which can avoid
deadlock.

Specifically, since we can determine at I/O submission time that an I/O
crosses i_disksize based on i_disksize, the write offset and the
EXT4_STATE_DISKSIZE_GROW_PENDING bit, we can mark it accordingly(e.g.,
mark it EXT4_IOMAP_DISKSIZE_GROW_IO). Then in the interrupt handler
ext4_iomap_end_bio() when the I/O completes, we can wake up the waiter
immediately. This avoids the problem of workers waiting on each other
due to insufficient worker concurrency we discussed. What do you think?

> 
>> Moreover, if we use the orphan list approach, it seems difficult to
>> decide when to release the orphan list entries. I'm concerned that
>> there may be concurrency issues that would need careful consideration
>> (For example, if the orphan list is deleted when the file is closed,
>> then after the last opener closes the file, is it necessary to wait for
>> synchronous writeback? If there is concurrent file expansion during the
>> writeback process, are there concurrency issues?) The original waiting
>> scheme is more straightforward to me.
> 
> I think the concurrently should be dealt with the synchronization on
> i_data_sem. At least in my mind that is relatively straightforward :). But
> I agree that the deletion of the inode from orphan is subtle and needs some
> careful thought.

I agree. I can take a closer look at both options during development and
pick the simpler one. :)

> 
>> In short, For v5, I think we should:
>> 1) Track state via EXT4_STATE_DISKSIZE_GROW_PENDING instead of checking
>>    whether i_ordered_len is 0;
>> 2) Determine the I/O type during writeback by checking i_disksize
>>    instead of the i_ordered_lblk parameter;
>> 3) No longer use a dedicated wait queue; instead wait on
>>    EXT4_STATE_DISKSIZE_GROW_PENDING.
>>
>> Thereforer, I think this solution won't simplify the logic much compared
>> to my current one; it will likely still require changes in quite a few
>> patches. The benefit is saving memory. I can't think of any other
>> potential issues for now, So I'm glad to have a try.
> 
> I'm OK with waiting on completion of the writeback of the folio straddling
> i_disksize if we have a place where we can safely wait and it will not hurt
> small append cases badly.
> 
>> In addition, I'll need to address a few more details in v5:
>>
>> 1. Following earlier discussions with Ojaswin, I plan to drop the
>>    patch 07 "ext4: submit zeroed post-EOF data immediately in the iomap
>>    buffered I/O path" in the next version -- no longer submitting I/O
>>    immediately after zeroing the EOF block, to improve concurrency.
>>    Then, in ext4_iomap_writepages() we check the writeback range:
>>    if it behind the zeroed folio, we explicitly submit the zeroed folio
>>    to prevent the appending I/O from being wait too long.
> 
> Sounds good although we have to be careful about deadlocks. The lock
> ordering of folio locks is in the ascending order of folio indices. Now you
> potentially need to lock previous folio to submit it for writeback. So this
> will have to be handled relatively early in our ->writepages implementation
> before we start locking any other folios.

Yes, I plan to do it early in ext4_iomap_writepages().

> 
>> 2. We also need to handle the case where the zeroed folio is
>>    truncated before being written back. In that case, i_disksize must
>>    be updated directly since the folio no longer has a chance to be
>>    written back.
> 
> If we truncate the zeroed folio (i.e., truncate down), we will set i_size
> and i_disksize to a value before this zeroed folio and then remove it from
> the page cache. So I don't see why we'd want to still update i_disksize to
> some larger value due to writeback of the zeroed folio?

For example, with zero_range and punch_hole, if we discard a pending
writeback folio that is straddling the old i_disksize, then we would
need to update i_disksize.

> 
>> 3. In the SYNC mode of fallocate and zero range, the zeroed folio
>>    needs to be submitted synchronously as well; otherwise i_disksize
>>    won't be updated immediately (which would violate SYNC semantics).
> 
> I agree.
> 
>> Besides, I've been revisiting why the iomap buffered I/O series disables
>> data=ordered mode these days. If we can directly solve the deadlock
>> problem in data=ordered mode, things would be much simpler. However,
>> IIRC, I recall that Ted previously mentioned planning to deprecate the
>> data=ordered mode in the future, so I'm not sure whether exploring this
>> direction is worthwhile.
> 
> Yes, eventually we'd like to transition to this mode where we allocate
> blocks before IO submission in memory only, write data to them, and on IO
> completion we allocate these blocks on disk and attach them to the inode.
> This will remove the need of data=ordered mode as well.

Ha, right. So since we're planning to sunset the data=ordered mode,
this direction is probably not worth exploring further. Let's go back
to the solution we are discussing above.

> 
>> In any case, let me share my thoughts:
>>
>> The root cause of this deadlock is that, during writeback, we cannot
>> start a new handle/transaction without stalling on the currently
>> committing transaction (T_N) to finish. Please see the Patch 07 with the
>> deadlock call graph:
>>
>> https://github.com/zhangyi089/linux/commit/c1a0e32ebf134411edb600b9b602b4af9420d25d
>>
>> When writeback tries to start T_{N+1}, it has two stalls involved:
>>
>>   [ T_0 | T_1 | ... | T_N-1 |  T_N  ]
>>
>> 1. Waiting for the T_N to enter T_FLUSH if it has start committing, so a
>>    new running transaction can be created. This is one-directional
>>    waiting, not part of the deadlock cycle.
> 
> I agree.
> 
>> 2. Waiting for log space, which is where the deadlock cycle below
>>    closes.
>>
>>    T_{N+1} start  ->  waits for  ->  T_0/1/... checkpoint completion
>>    T_0 checkpoint ->  waits for  ->  T_N commit completion if it
>>                                      contians the same bh
>>    T_N commit     ->  waits for  ->  ordered data writeback
>>    ordered writeback = T_{N+1} start path  ->  (cycle)
>>
>> Only case 2 is the actual deadlock. So what I'm thinking is could we try
>> to break the cycle at the T_0 checkpoint -> T_N commit edge? That is
>> when checkpoint hits a bh that T_N has adopted, write the pre-T_N
>> contents to the original on-disk location instead of waiting for T_N to
>> commit.
> 
> I think I get the idea but I'm not sure it works. You have a transaction
> T_N that is doing a commit. To do that it needs to writeout and thus lock
> some folio F_N. The lock on F_N is held by writeback that wants to start a
> new transaction handle. Now you cannot guarantee that handle can be added
> to the transaction T_{N+1} that is currently running - other operations may
> have already filled that transaction as well. So without some kind of
> reservation scheme (like we currently have for conversion of unwritten
> extents on IO completion) that is impossible to resolve.
> 

Yes, indeed. With that in mind, my approach probably isn't that viable.

Thank you for the guide!
Yi.


