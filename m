Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A737221DAE
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jul 2026 02:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783132464; cv=none; b=sL5FeqeqSzeggV76j5PBKygw1shaha/J6K3uaKMbf3x+5AvvFD60XqH9t7Zf7NnMGz3HYfBNjtqnkPWRLrZH+nxlll7lZCyRYB46KGdPjEoJl7aWS0uvF5ut7f03EW30gs4C06DOnqVaW5rDznnK6LGvqNNb49NSxajj1JnsI/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783132464; c=relaxed/simple;
	bh=pGsoEyAm3bZoDe6VREwnlPvdgL3+EACVmm0N6rqdyTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m9orffUsVqXDDlHYL7TLL7dgOwo7YN+7fQr7XR1QHpUHH2IKFp0NEfNlA2FrrlK63KjaG/tWUDJ9wBmELAMaOKsDfxTQ6tOO24SP7KMkandIh1oBsCGjTLgLSI3XrY7Z94KgUGXRDiyU51b5lBQ06tP0tKd8ksI4zyazj2IEa2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kY4UdbFU; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kY4UdbFU"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c6b67d5fa1so10944765ad.2
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jul 2026 19:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783132460; x=1783737260; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D5gdjEAhM6JnJ4nxg59m1hX+aKZvrIYJN+Eey2wy5DM=;
        b=kY4UdbFUIypbpfqJAB+JcvrY3g4hBcno+TfXGLUcuJaWqbKp8EDs7wQ8Ey8Vk5n+Q4
         uC4str+IUQAAUEnJGfltJDbeqjrWao2jSYALWRHIg+9p/FZSrlECH/iyQO4kYMxLT13S
         MsL/x7w6xmGHvhBuory7KATiEAMkC0/mC4bknm/U/vJkHZ/mGVZ1gIiu1ZWv9wiO/k7X
         zFH711XdP8vKZ1sLelYVDw4G4Fp/WKbSp8JiKK1F7dvLJmYks2GTg8Vm9kZYSDrO7KGd
         vrZ85g+at45RF0cq6CCG1uyv/lRfNznE94JHYe/cN+E7/9HOBNIfOXvFn03iEyDsaOsk
         7QQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783132460; x=1783737260;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D5gdjEAhM6JnJ4nxg59m1hX+aKZvrIYJN+Eey2wy5DM=;
        b=GUhJiD/ffCHa/SFvpkTJHKn2qjPe+UMsHaCgQ4dl2As45dhRDlka31+SsuDDrnZ6Rd
         67g+zzHua+ExLbwnFACHXc3KV0MsNGGyOfaTDfXLx23C43r8D4/+zcZqyyagxBb7AEFI
         HicBcVwOr9DipgFToJGnJaWOpK0ysocjTw5v0aHaTC41EjXUQVrMDjWSG2/GfIwd1z3Z
         eiASPQsjyfReNJro1Gnj8ryEbomsXSISFrbzwpjVaVGWolipT3bIoDhmAQWDx8Ipq8SZ
         zfj6m8mIGy81KePQvQH//0yNwYyTWuiKO5+R+Kww5VJ/45p/DMHP6onmS8LLEB76sPXm
         0l0Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqb/6XhB/V4oBhfdM7LB7RY7AyDeQwu89tNQyhht/JJtJj/kxc5+ZrUfbUn/72WhOipto4tXTbiEctu@vger.kernel.org
X-Gm-Message-State: AOJu0YynWkiaVENcKUjsNLjIqIvuUPAQDzKI2uRywNliQ8meYFvcZwL8
	zfbLa8GZrfhk1CrrBreMqhD6Qz0tbCz2WDvi2QEiHoVtt4ug/W7yk71w
X-Gm-Gg: AfdE7ckHEKh3J/BlBbI89k97847j7V/Wj1flvw0o5KajOaKuPnlNrF1LsUE6N3cCfyY
	gNdAVJ5dsf940AQxxqYIA9k6OIe5KNim/7rQmezwBCXaUyqMvhGyDL/fQqidndTMJJf9+zRQDQH
	hJ91L3d4kxo7CWYkV7+oe0RW/tVGm1x6SdJw+WR0Sg4ZjyD4ztmZy/ULW16wsXRzoUEx9SKGZ6B
	+LrgmL/JaSYnzFJVo4ncjFteVXTz7vKe3/cdWjWVf6wK8e0UK5nl3hh+srFIiD7pHhTbh2aZDEX
	G9HEhy6h1zouV4rdmjuYpUWODpoBV0sDlxc58dRAtR/yTLdjA3Y+SlXFe9Xyy/320yz8Xu29cDa
	/yH7xtF2ZjmjcRVaZxGkeayET4NwCAAFylV30VkVqPrStR9Da9VLUYkcYBSem8yElc+2s9yuIPp
	bbU4NJabKUPimimiCC7bArr7CsfI86JYT5
X-Received: by 2002:a17:903:230b:b0:2c9:de53:f84f with SMTP id d9443c01a7336-2cbb9e4dd31mr15058825ad.19.1783132460069;
        Fri, 03 Jul 2026 19:34:20 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad712b12fsm16798695ad.25.2026.07.03.19.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 19:34:19 -0700 (PDT)
Message-ID: <d30ebe91-a5e4-4ee8-a3f7-c965e623535f@gmail.com>
Date: Sat, 4 Jul 2026 10:34:07 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap buffered
 I/O path
To: Jan Kara <jack@suse.cz>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <k3w5c3cyg2py4kums7nhdwjg6b6pm43qtweepuolk57xtmnotz@yxkm2k6sqfc6>
 <9ab9281d-c5dc-4183-8bc9-b53b5a4ac9c0@gmail.com>
 <3n6ge2tfe4bd65eicc7l2csxkzupcjtdtc4ojpl6bvtf7cwll6@sxmlt3uciw4c>
 <8999aa70-073c-47f9-ae6e-39af3cc1fe32@gmail.com>
 <c6zpjk3gml5lj72cagu7sncswqeea2e3h7gc2ie5qnwwe6qdft@6qoaz7zccmem>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <c6zpjk3gml5lj72cagu7sncswqeea2e3h7gc2ie5qnwwe6qdft@6qoaz7zccmem>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/2/2026 10:20 PM, Jan Kara wrote:
> On Tue 30-06-26 20:06:55, Zhang Yi wrote:
>> On 6/25/2026 5:42 PM, Jan Kara wrote:
>>> On Mon 22-06-26 11:32:16, Zhang Yi wrote:
>>>> On 6/18/2026 9:48 PM, Jan Kara wrote:
>>>>> On Mon 11-05-26 15:23:38, Zhang Yi wrote:
>>>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>>>
>>>>>> For append writes, wait for ordered I/O to complete before updating
>>>>>> i_disksize. This ensures that zeroed data is flushed to disk before the
>>>>>> metadata update, preventing stale data from being exposed during
>>>>>> unaligned post-EOF append writes.
>>>>>>
>>>>>> Suggested-by: Jan Kara <jack@suse.cz>
>>>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>>>
>>>>> Frankly, this all looks too complex to me. Plus your are adding 32-bytes to
>>>>> struct ext4_inode_info which isn't great either. Why don't you just do
>>>>> filemap_fdatawait() for the byte at old i_disksize and be done with it?
>>>>>
>>>>> I believe we have to simplify this. All this complexity (and thus
>>>>> maintenance burden) across several patches for the corner case of zeroing
>>>>> tail block on extention is in my opinion difficult to justify.
>>>>>
>>>>> 								Honza
>>>>
>>>> Hi, Jan!
>>>>
>>>> Thanks for the review. I understand the concern about complexity and the
>>>> 32-byte increase to ext4_inode_info. I tried using
>>>> filemap_fdatawait_range() as you suggested, but found two issues where
>>>> this solution doesn't work.
>>>>
>>>> 1. ioend worker deadlock
>>>>
>>>> Since worker concurrency resources are limited, we cannot wait for
>>>> another ioend worker to complete within one ioend worker with the same
>>>> work_struct. If the worker calls
>>>> filemap_fdatawait_range(byte_at_old_disksize) to wait for the zeroed
>>>> block's folio writeback to complete, it sleeps holding the only worker
>>>> slot. If the folio contains blocks requiring extent conversion, its
>>>> writeback bit is cleared by iomap_finish_ioends() running inside
>>>> another worker -- which can only run after the current worker finishes
>>>> its batch.
>>>>
>>>> Concretely:
>>>>     - Worker W1 processes ioend A, calls filemap_fdatawait_range() on
>>>>       the old EOF byte, sleeps.
>>>>     - The zeroed data is in ioend B. bio_endio defers it to
>>>>       i_iomap_ioend_list and calls queue_work().
>>>>     - queue_work() on i_iomap_ioend_work is idempotent: it returns false
>>>>       because the work is currently executing (even though sleeping).
>>>>     - ioend B sits in the list, never gets processed.
>>>>     - The folio writeback bit is only cleared by processing ioend B.
>>>>     - W1 sleeps forever -> deadlock.
>>>
>>> Yes, good point. We cannot wait for folio writeback completion from end_io
>>> processing for another folio.
>>>
>>>> Therefore, I think we have to put the wakeup logic in
>>>> ext4_iomap_end_bio() that runs in interrupt context without consuming
>>>> a worker thread. The ordered range tracking and wait queue are what
>>>> make that possible.
>>>>
>>>> 2. Truncate-up needs an accurate state query
>>>>
>>>> In the follow-up patch 19, ext4_set_inode_size() must make a precise
>>>> decision when updating i_disksize during truncate up.
>>>>
>>>> This needs a state query: "is there ordered zero I/O in flight right
>>>> now?" If yes, the i_disksize update is deferred to
>>>> ext4_iomap_wb_update_disksize(is_ordered=true), which advances
>>>> i_disksize to i_size when the ordered I/O completes. If no, we must
>>>> advance i_disksize immediately, otherwise we will lose the updating
>>>> forever.
>>>>
>>>> Therefore, we need to track the state of the ordered range. Simply
>>>> using filemap_fdatawait_range() doesn't work. i_ordered_len serves as
>>>> a maintained state flag that both the ioend completion path and the
>>>> setattr path can read atomically without sleeping.
>>>>
>>>> Suggestions?
>>>
>>> I see. Thanks for explanation. I went back to our discussion back from
>>> February to remind myself about the constraints on the tail block zeroing
>>> and the i_disksize update mechanism. And in the light of complexity of the
>>> current mechanism, I think we've discarded the following possibility too
>>> easily:
>>>
>>> * On file extend / truncate up just zero tail folio in the page cache, mark
>>>     it dirty, keep i_disksize at old value, update i_size to the new value,
>>>     add inode to orphan list.
>>>     If the i_disksize was block aligned (and so we skip zeroing), we just
>>>     update i_disksize rightaway.
>>>
>>> * In io end processing if the folio for which we end io has a block which
>>>     straddles i_disksize, we update i_disksize to current i_size. We defer
>>>     removing inode from orphan list e.g. to file close time (doing it from
>>>     end_io processing is problematic locking wise as we need i_rwsem for it).
>>>
>>> This is a very simple scheme with very good performace. It makes sure stale
>>> data in the tail block cannot be seen on disk after a crash.
>>
>> Hmm, I think this solution has a problem. Since i_disksize is advanced
>> to i_size only when the ioend covering the i_disksize block completes,
>> we must ensure that i_size is updated before the zeroed folio's
>> writeback completes. Otherwise the ioend worker reads the old i_size,
>> advances i_disksize to the old value (a no-op), and i_disksize stays
>> stale forever after i_size is updated.
>>
>> Currently, neither truncate-up nor file-extend paths guarantee this
>> ordering -- in both, ext4_block_zero_eof() runs before the i_size
>> update.
> 
> Good point, that needs to be handled.
> 
>> For truncate-up and fallocate, we might be able to split
>> ext4_update_inode_size() / ext4_set_inode_size() so that i_size is
>> updated before ext4_block_zero_eof(), and then decide whether to
>> update i_disksize based on whether i_disksize is block-aligned. I'm
>> not yet sure what side effects this reordering would have, but I feel
>> uneasy about this.
>>
>> The append-write case is hard to solve. We can't know the final i_size
>> before the write completes, so we can't update i_size ahead of
>> ext4_block_zero_eof(). When the zeroed folio is later written back, it's
>> treated as an ordinary overwriting write -- i_disksize is not advanced.
>> And when the subsequent buffered-write data is written back, i_disksize
>> still isn't advanced either. The size update is lost.
> 
> One thing we need to do is to perform i_size updates in append write,
> truncate, etc. under i_data_sem (similarly to i_disksize updates) so that
> we can properly synchronize i_size + i_disksize updates from IO completion
> and these paths.
> 
> How we could then handle the races between writeback of folio straddling
> i_disksize and the i_size updates from the i_size extending paths is that
> we'd set EXT4_STATE_DISKSIZE_GROW_PENDING bit when zeroing the folio
> straddling i_disksize and clear this (under i_data_sem) in IO completion
> when updating i_disksize to i_size. And when setting new i_size after
> append write, truncate up, etc. we will also update i_disksize when this
> state bit is not set (again all happening under i_data_sem). This should
> also automatically include the case where i_disksize was block aligned and
> thus no zeroing was needed and we need to update i_disksize together with
> i_size. Sounds good?
> 
> 								Honza

Ha, yeah. This overall looks good to me now. Your solution doesn't look
significantly different from mine currently implementation. My approach
uses i_ordered_len to precisely track the pending state of whether a
zeroed folio is awaiting submission, while you choose to use
EXT4_STATE_DISKSIZE_GROW_PENDING to represent this, which completely
eliminates the 32-byte bloat in ext4_inode_info.

However, I'd prefer we should still be able to keep the IO-completion
waiting logic instead of adding the orphan list. We can precisely
determine whether an IO is a "cross-i_disksize IO" by checking whether
its position straddles i_disksize, and when it completes, wake up the
worker waiting for it in interrupt context -- this won't deadlock (bio
end_io doesn't consume a worker thread). Besides, Since we plan to use
the EXT4_STATE_DISKSIZE_GROW_PENDING bit, the waiting doesn't require a
dedicated wait queue; wait_on_bit / wake_up_bit(&ei->i_state_flags,
EXT4_STATE_DISKSIZE_GROW_PENDING) should suffice.

Moreover, if we use the orphan list approach, it seems difficult to
decide when to release the orphan list entries. I'm concerned that
there may be concurrency issues that would need careful consideration
(For example, if the orphan list is deleted when the file is closed,
then after the last opener closes the file, is it necessary to wait for
synchronous writeback? If there is concurrent file expansion during the
writeback process, are there concurrency issues?) The original waiting
scheme is more straightforward to me.

In short, For v5, I think we should:
1) Track state via EXT4_STATE_DISKSIZE_GROW_PENDING instead of checking
    whether i_ordered_len is 0;
2) Determine the I/O type during writeback by checking i_disksize
    instead of the i_ordered_lblk parameter;
3) No longer use a dedicated wait queue; instead wait on
    EXT4_STATE_DISKSIZE_GROW_PENDING.

Thereforer, I think this solution won't simplify the logic much compared
to my current one; it will likely still require changes in quite a few
patches. The benefit is saving memory. I can't think of any other
potential issues for now, So I'm glad to have a try.

In addition, I'll need to address a few more details in v5:

1. Following earlier discussions with Ojaswin, I plan to drop the
    patch 07 "ext4: submit zeroed post-EOF data immediately in the iomap
    buffered I/O path" in the next version -- no longer submitting I/O
    immediately after zeroing the EOF block, to improve concurrency.
    Then, in ext4_iomap_writepages() we check the writeback range:
    if it behind the zeroed folio, we explicitly submit the zeroed folio
    to prevent the appending I/O from being wait too long.

2. We also need to handle the case where the zeroed folio is
    truncated before being written back. In that case, i_disksize must
    be updated directly since the folio no longer has a chance to be
    written back.

3. In the SYNC mode of fallocate and zero range, the zeroed folio
    needs to be submitted synchronously as well; otherwise i_disksize
    won't be updated immediately (which would violate SYNC semantics).


What do you think?


Besides, I've been revisiting why the iomap buffered I/O series disables
data=ordered mode these days. If we can directly solve the deadlock
problem in data=ordered mode, things would be much simpler. However,
IIRC, I recall that Ted previously mentioned planning to deprecate the
data=ordered mode in the future, so I'm not sure whether exploring this
direction is worthwhile. In any case, let me share my thoughts:

The root cause of this deadlock is that, during writeback, we cannot
start a new handle/transaction without stalling on the currently
committing transaction (T_N) to finish. Please see the Patch 07 with the
deadlock call graph:

  
https://github.com/zhangyi089/linux/commit/c1a0e32ebf134411edb600b9b602b4af9420d25d

When writeback tries to start T_{N+1}, it has two stalls involved:

   [ T_0 | T_1 | ... | T_N-1 |  T_N  ]

1. Waiting for the T_N to enter T_FLUSH if it has start committing, so a
    new running transaction can be created. This is one-directional
    waiting, not part of the deadlock cycle.
2. Waiting for log space, which is where the deadlock cycle below
    closes.

    T_{N+1} start  ->  waits for  ->  T_0/1/... checkpoint completion
    T_0 checkpoint ->  waits for  ->  T_N commit completion if it
                                      contians the same bh
    T_N commit     ->  waits for  ->  ordered data writeback
    ordered writeback = T_{N+1} start path  ->  (cycle)

Only case 2 is the actual deadlock. So what I'm thinking is could we try
to break the cycle at the T_0 checkpoint -> T_N commit edge? That is
when checkpoint hits a bh that T_N has adopted, write the pre-T_N
contents to the original on-disk location instead of waiting for T_N to
commit. To avoid excessive copying, this requires:

- Identifying T_N as the last transaction that can start without
   blocking on log space reclamation — once T_N starts, the remaining
   log space is enough to fit T_N's own handle credits, but not enough to
   fit another full j_max_transaction_buffers after that.
- When T_N adopts a bh still on an older checkpoint list, snapshot the
   bh contents at adoption time, so the older checkpoint can write that
   snapshot to disk independently of T_N's commit progress.

   [ T_0 | T_1 | ... | T_N-1 |    T_N    ]
                             |<--     -->|  -> T_N
                              (j_max_transaction_buffers)

1. Mark T_N as the last TX that started without obstruction. When a new
    handle joins a running transaction, evaluate whether the remaining
    log space, after subtracting this handle's credits, can still fit a
    full j_max_transaction_buffers. If not, the current transaction is
    committed immediately and the handle joins the next one, which
    becomes T_N — the last transaction that can start without log-space
    reclamation, T_N is then marked.
2. Snapshotting on adoption. In do_get_write_access(), when the current
    handle's transaction is T_N and the bh is still on an older
    checkpoint list, copy the bh contents into a new
    jh->b_checkpoint_data pointer(like b_frozen_data does);
3. Consuming the snapshot at checkpoint. In jbd2_log_do_checkpoint(),
    the current branch that handles an adopted bh by starting and waiting
    for T_N's commit is extended: if b_checkpoint_data is present, write
    it to the original block location and remove the bh from the
    checkpoint list — without waiting for T_N to commit.
4. Releasing b_checkpoint_data. Freed when the bh is unlinked from its
    checkpoint list or T_N is finished to commit.

This keeps the snapshot granularity at a minimum, only T_N's adopted
buffers get the extra copy. When metadata changes are light, T_N rarely
adopts such buffers, and the cost is unnoticeable; when metadata changes
are heavy , the dominant cost is the metadata writeback itself, and the
extra in-memory copy is unlikely to be the bottleneck. However, the
downside is that there may be some memory overhead, especially in the
metadata-intensive cases.

Another possible optimization: at T_N start, opportunistically try to
push the checkpoint tail. If enough space is reclaimed that another full
j_max_transaction_buffers fits after T_N's handle credits, T_N is no
longer "last" and the snapshotting can be skipped entirely.

If this scheme works, I think we should be able to completely remove the
limitation that writeback cannot start a handle in data=ordered mode.
This would also benefit the buffer_head path — perhaps we could
deprecate the reserved handle mechanism.

This is just a preliminary idea. What do you think of this approach?

Thanks,
Yl.

