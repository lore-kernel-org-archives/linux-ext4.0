Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B746E34A3DB
	for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2026 12:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782821230; cv=none; b=NdDpd9EASl2Ba6Ui0W3YoBVkP2gLE3aSj5zlQZ2Bv9uyb8CwcWEcAi3T1P9Zld7gHgIka1l6ns8DMuRDAMNKPrygZIr/IUSqw8ESV1swhKjtDcDIBU8jI7EpnUFQ6IyWUFZJtT37hd9ko1i2BJkCxfnDA+SPSSan1UKoSgN7KZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782821230; c=relaxed/simple;
	bh=itAlsaST6j0kxNgKTm7bL9oYDa4zsO9/SWJNPboIP6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CzhNfLf5J677wKyp1NBwADweZJYFFSbGswYhDt3V+qzOw98bCku8/jZ65bmxsjJow2KPPzPI3tsDAC3dqEoTgB/mczgKxep63iO6x8hZu9eGHXWH2wr5f84UYShV7Nl5ojobOBWhlNaroLjBou/gVb0vJFCBn0zmLGl906mcWqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bQi7pGOY; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bQi7pGOY"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c88973b6965so254299a12.1
        for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2026 05:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782821227; x=1783426027; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GRsif6n23PSbdnHewtfXyh6tsaYmvVnWO2OghT4M8iw=;
        b=bQi7pGOY+8eQMuWvIyFd3o5pFpvTrsO1NQsl+ysdfjY3bVp/3iaS0U1j67xzHIjzl7
         deeuYpjDg5eYig7ATE1NU2iN/o0XHEL+EFjG6nIrguXGcfVyZKIIdVvmcfycPSp4oNlN
         UUyRgZmssQvUd59y8daKGTTpHOm5BI/9wfdhIC96fe3z0M08a4gLIqNc3YydYh9mtoJo
         bTK2OtQIIi05zxZ/703pT+6lNdyhOkQxfSX8cGo/1LkFrN4r6mrQWFF622M3Wjri+fps
         vTob7qasnZq8W3PKl+a4Rj/xmloBAjZAai+CNJu+vLQ+7EQIf7ErWRQEmZGyO0QfiBYb
         96Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782821227; x=1783426027;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GRsif6n23PSbdnHewtfXyh6tsaYmvVnWO2OghT4M8iw=;
        b=ohZ2xfSAOtHUfIeOr9tXvluFWhdOAp5sD/Clu+qfeV7crn4Jy1icG5Sr1j4MGE4SrR
         iFNIe62loJaUkLC0yYVphLS2AOW1z80VtUdD9NvcxfpS/dc1hHDsZw9s0hUdEA0ktdrP
         XvrRJYtmPkjW+XJhB0phSrORnvL/1ZmGsh3LdjNN5i0UzZ2CSZ7Ui3IPUdhqlBDnbfQu
         cCt25B6QmONo2jVj5fm4IGjprZCIb45vC+mHz/nSIK0fOqhNc1saXYbkBl/dOidiFz1f
         wpOWBuDYSFjQYDvu3ZyvhgY9bTqFvo2p3MYHd+z6nDVxWk09/58FcQuIwGPBptrktCEj
         SNsw==
X-Forwarded-Encrypted: i=1; AFNElJ9SDUko2HZRnzOlv18Isyg2zUoBLKBPdae2a8JdboE5RwGy3tUBgdKfA9g70GZ81WzxD02L7YmoT+4R@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3XnO4SHg9vw9/THU5tNPjm7Ab93TA6SDZN6zmIl536/xIKUXP
	BOZYCVqBj+FrtiDE1EIDA6w14d8V6jxmuKF4WrZ2mfBvHG9WqkwN7UZvdeztvsNbRLs=
X-Gm-Gg: AfdE7cnn2cdcZog87IhW+sWR+71ukdmD2ZK7jdACOnOYsLNQzVA+/vjwyQMacIy8ZUU
	UxpRAG0MPuHUAfsi4AIZR4trZoXx7BcOQskS1Lf323izpltysWURM8/pKxu2fyI7x5K0dksR4PV
	yvfAoPPP/VG3XRIIJsxkLWWbazZQIbvytVn0HJWhQBTOrg7j8vJwsEZ1jLeURok9+OBI/JcuKZH
	6V8PcUC6Mto8+5p3mSQKGPH7zz2Ub4j0MRCPFZVkBYNCt/JnwC9fkEL7nYAolJQnqUF9yAJe8A1
	mSFViBaosg29deO8pLu3ULYHA+kL8xPPj6Q0fXnZ36zh0EUvK8J7/gt8B1gYhOZBlVcPqkMEKXR
	Hh5MtH6X0M9U3RK2WheEh4zXL2yUP89j4uNtfhlCqoRxgNGta4AF37axgrRGdoDiE72GEI+iv4x
	zRE7Iji0sBrsSQrsomFAEddlSZpfbDACfn
X-Received: by 2002:a05:6a21:4596:b0:3bf:990d:3fc7 with SMTP id adf61e73a8af0-3bfd2849358mr1111547637.20.1782821226742;
        Tue, 30 Jun 2026 05:07:06 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9bc02082ebsm1471182a12.26.2026.06.30.05.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 05:07:06 -0700 (PDT)
Message-ID: <8999aa70-073c-47f9-ae6e-39af3cc1fe32@gmail.com>
Date: Tue, 30 Jun 2026 20:06:55 +0800
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
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <3n6ge2tfe4bd65eicc7l2csxkzupcjtdtc4ojpl6bvtf7cwll6@sxmlt3uciw4c>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/2026 5:42 PM, Jan Kara wrote:
> On Mon 22-06-26 11:32:16, Zhang Yi wrote:
>> On 6/18/2026 9:48 PM, Jan Kara wrote:
>>> On Mon 11-05-26 15:23:38, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> For append writes, wait for ordered I/O to complete before updating
>>>> i_disksize. This ensures that zeroed data is flushed to disk before the
>>>> metadata update, preventing stale data from being exposed during
>>>> unaligned post-EOF append writes.
>>>>
>>>> Suggested-by: Jan Kara <jack@suse.cz>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>
>>> Frankly, this all looks too complex to me. Plus your are adding 32-bytes to
>>> struct ext4_inode_info which isn't great either. Why don't you just do
>>> filemap_fdatawait() for the byte at old i_disksize and be done with it?
>>>
>>> I believe we have to simplify this. All this complexity (and thus
>>> maintenance burden) across several patches for the corner case of zeroing
>>> tail block on extention is in my opinion difficult to justify.
>>>
>>> 								Honza
>>
>> Hi, Jan!
>>
>> Thanks for the review. I understand the concern about complexity and the
>> 32-byte increase to ext4_inode_info. I tried using
>> filemap_fdatawait_range() as you suggested, but found two issues where
>> this solution doesn't work.
>>
>> 1. ioend worker deadlock
>>
>> Since worker concurrency resources are limited, we cannot wait for
>> another ioend worker to complete within one ioend worker with the same
>> work_struct. If the worker calls
>> filemap_fdatawait_range(byte_at_old_disksize) to wait for the zeroed
>> block's folio writeback to complete, it sleeps holding the only worker
>> slot. If the folio contains blocks requiring extent conversion, its
>> writeback bit is cleared by iomap_finish_ioends() running inside
>> another worker -- which can only run after the current worker finishes
>> its batch.
>>
>> Concretely:
>>    - Worker W1 processes ioend A, calls filemap_fdatawait_range() on
>>      the old EOF byte, sleeps.
>>    - The zeroed data is in ioend B. bio_endio defers it to
>>      i_iomap_ioend_list and calls queue_work().
>>    - queue_work() on i_iomap_ioend_work is idempotent: it returns false
>>      because the work is currently executing (even though sleeping).
>>    - ioend B sits in the list, never gets processed.
>>    - The folio writeback bit is only cleared by processing ioend B.
>>    - W1 sleeps forever -> deadlock.
> 
> Yes, good point. We cannot wait for folio writeback completion from end_io
> processing for another folio.
> 
>> Therefore, I think we have to put the wakeup logic in
>> ext4_iomap_end_bio() that runs in interrupt context without consuming
>> a worker thread. The ordered range tracking and wait queue are what
>> make that possible.
>>
>> 2. Truncate-up needs an accurate state query
>>
>> In the follow-up patch 19, ext4_set_inode_size() must make a precise
>> decision when updating i_disksize during truncate up.
>>
>> This needs a state query: "is there ordered zero I/O in flight right
>> now?" If yes, the i_disksize update is deferred to
>> ext4_iomap_wb_update_disksize(is_ordered=true), which advances
>> i_disksize to i_size when the ordered I/O completes. If no, we must
>> advance i_disksize immediately, otherwise we will lose the updating
>> forever.
>>
>> Therefore, we need to track the state of the ordered range. Simply
>> using filemap_fdatawait_range() doesn't work. i_ordered_len serves as
>> a maintained state flag that both the ioend completion path and the
>> setattr path can read atomically without sleeping.
>>
>> Suggestions?
> 
> I see. Thanks for explanation. I went back to our discussion back from
> February to remind myself about the constraints on the tail block zeroing
> and the i_disksize update mechanism. And in the light of complexity of the
> current mechanism, I think we've discarded the following possibility too
> easily:
> 
> * On file extend / truncate up just zero tail folio in the page cache, mark
>    it dirty, keep i_disksize at old value, update i_size to the new value,
>    add inode to orphan list.
>    If the i_disksize was block aligned (and so we skip zeroing), we just
>    update i_disksize rightaway.
> 
> * In io end processing if the folio for which we end io has a block which
>    straddles i_disksize, we update i_disksize to current i_size. We defer
>    removing inode from orphan list e.g. to file close time (doing it from
>    end_io processing is problematic locking wise as we need i_rwsem for it).
> 
> This is a very simple scheme with very good performace. It makes sure stale
> data in the tail block cannot be seen on disk after a crash.

Hmm, I think this solution has a problem. Since i_disksize is advanced
to i_size only when the ioend covering the i_disksize block completes,
we must ensure that i_size is updated before the zeroed folio's
writeback completes. Otherwise the ioend worker reads the old i_size,
advances i_disksize to the old value (a no-op), and i_disksize stays
stale forever after i_size is updated.

Currently, neither truncate-up nor file-extend paths guarantee this
ordering -- in both, ext4_block_zero_eof() runs before the i_size
update.

For truncate-up and fallocate, we might be able to split
ext4_update_inode_size() / ext4_set_inode_size() so that i_size is
updated before ext4_block_zero_eof(), and then decide whether to
update i_disksize based on whether i_disksize is block-aligned. I'm
not yet sure what side effects this reordering would have, but I feel
uneasy about this.

The append-write case is hard to solve. We can't know the final i_size
before the write completes, so we can't update i_size ahead of
ext4_block_zero_eof(). When the zeroed folio is later written back, it's
treated as an ordinary overwriting write -- i_disksize is not advanced.
And when the subsequent buffered-write data is written back, i_disksize
still isn't advanced either. The size update is lost.

> 
> Potential problems with this:
> 
> * We need to do i_disksize update from io end processing which means starting a
>    transaction. So this mechanism has to be restricted to buffered IO iomap
>    path due to locking constraints. If the inode uses old ordered mode, it
>    has to keep using it also for handling of the tail block zeroing.
>    I think that's acceptable as we want to transition everything to iomap
>    anyway so this duplicity will eventually go away.
> 
> * After a crash we can see i_disksize already updated but file content will
>    show zeros. This is not breaking any guarantees, it just changes how ext4
>    behaves after a crash. Again, I think this is acceptable tradeoff for the
>    simplicity.

These two points are fine with me. My current implementation also has
these same tradeoffs.

> 
> What do you think? Any problems I have missed? I'm sorry for poking into
> this mechanism again and again but I want to keep the code as simple as
> possible to make our life easier in the future...

That's fine. Although it's a corner case, it's quite subtle, and
handling it properly takes some careful thought. I would very much
like to solve it in a simple and elegant way. Any good suggestions
are welcome.

Thanks,
Yi.

> 
>> Regarding the bloat of ext4_inode_info, perhaps we can drop the
>> wait_queue_head_t (24 bytes) and use wait_var_event()/ wake_up_var()
>> instead. Would this be acceptable?
> 
> Yes, that would be a good way to reduce the bloat if we still need this.
> 
> 								Honza

