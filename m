Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCD63939AE
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 10:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781693663; cv=none; b=UX4G9h7C4kc2pBqTP6HKymTVWh44FvJRMBTvCY3Vuuw0rTEEznoQJZ/QmWMNsamwAXlHVMJ+YE7Vc5L0ylKK2ususJtYQvtJKSPGHIcJG5ryTzwUIsRUeVM8CIwdaFmuCaTnE5ahR3CocY+Z8lSffbk0prZC7gtF786S40EacA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781693663; c=relaxed/simple;
	bh=mTCYehxELbv5eHQ2U+LtFuDMwe0gLbkW+NlwH0NBdpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CwaVLp195HlusQvyP2l5rOpn7gS4Ym8k2XjFGJ3A12SegkmNAL4CW2rpHhUAWWioAHIlwWdu0+WXr2igkHUrHLEvtb7b9QDcbFlfZUBOdRNWPdejnJxJRmg3Th+mm4q8LARwmficgvV2L/avouHSmQ5XvFFi7Mrq8MJh6vbEG7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ggLLP6fsNzKHMQR
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 18:53:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 350F84056E
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 18:54:06 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgAnKT7MfDJqBHV0CA--.17386S3;
	Wed, 17 Jun 2026 18:54:06 +0800 (CST)
Message-ID: <8dd17689-b596-40ab-a32f-551aadc7bbe8@huaweicloud.com>
Date: Wed, 17 Jun 2026 18:54:04 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ext4: base unaligned DIO lock decision on partial
 block zeroing
To: Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yizhang089@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 peng_wang@linux.alibaba.com
References: <20260611163441.2431805-1-libaokun@linux.alibaba.com>
 <20260611163441.2431805-3-libaokun@linux.alibaba.com>
 <060f63e0-d64f-40df-99a7-af53862049ee@linux.alibaba.com>
 <d1adcf7c-c276-458d-9cac-68a4410f7626@gmail.com>
 <4f4800dc-0a2c-48e2-9535-f32b21628bdb@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <4f4800dc-0a2c-48e2-9535-f32b21628bdb@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAnKT7MfDJqBHV0CA--.17386S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Ar4DJry5tF45uFykAryxKrg_yoW7Kr15pF
	93KFy7J348GrWkJr47tF1Uury8Kr1UJw4UXryrJF18X34DAr4jqrsrXr10gryDJrW8Cr17
	Jr4UAr9rZr1UJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/17/2026 3:52 PM, Baokun Li wrote:
> On 2026/6/17 10:45, Zhang Yi wrote:
>> Hi, Baokun!
>>
>> On 6/16/2026 9:10 PM, Baokun Li wrote:
>>> Hi all,
>>>
>>> Thank you for your review!
>>>
>>> After extensive testing, I found that after merging this patch,
>>> generic/746
>>> started failing intermittently on ext3 (mkfs.ext4 -O ^extents).  The
>>> test
>>> triggers a "Page cache invalidation failure on direct I/O" warning, and
>>> subsequent fsync returns -EIO.
>>>
>>> The underlying race existed before this patch, but this patch appears to
>>> have widened the reproduction window considerably, so I thought it worth
>>> trying to address.  Here is my analysis:
>>>
>>> On no-extent inodes, DIO writes that hit holes cannot use unwritten
>>> extents.  ext4_iomap_alloc() leaves m_flags=0, so ext4_map_blocks()
>>> returns 0 for a hole, and:
>>>
>>>          if (!m_flags && !ret)
>>>                  ret = -ENOTBLK;
>>>
>>> The iomap layer returns -ENOTBLK to ext4, which falls back to buffered
>>> I/O.  The fallback path dirties pages in the page cache, then flushes
>>> and invalidates them.  However, concurrent async DIO completions to
>>> other blocks on the same inode can run
>>> kiocb_invalidate_post_direct_write()
>>> without holding the inode lock.
>>>
>>> Consider a file with two 4k extents: [hole][written].  Thread A does DIO
>>> to the written extent, while thread B does DIO spanning both extents:
>>>
>>>    kworker A (4k DIO, allocated block)    kworker B (8k DIO,
>>> hole->fallback)
>>>    -----------------------------------   
>>> -----------------------------------
>>>    inode_lock_shared()                    inode_lock_shared()
>>>    iomap_dio_rw():                        iomap_dio_rw():
>>>      kiocb_invalidate_pages -> clean        iomap_begin -> -ENOTBLK
>>>      submit_bio (async)                     dio->size = 0
>>>    inode_unlock_shared()                  inode_unlock_shared()
>>>
>>>    [bio pending in block layer]           /* fallback: inode lock
>>> released */
>>>                                           ext4_buffered_write_iter()
>>>                                             inode_lock(exclusive)
>>>                                             generic_perform_write()
>>>                                               -> dirty pages [0, 8k]
>>>                                             inode_unlock(exclusive)
>>>
>>>                                           /* pages still dirty here */
>>>    [bio completes]                        filemap_write_and_wait_range()
>>>    iomap_dio_complete()                     -> flush dirty pages
>>>      kiocb_invalidate_post_direct_write() invalidate_mapping_pages()
>>>        invalidate_inode_pages2_range()
>>>        -> finds dirty page!               /* window closed */
>>>        -> dio_warn_stale_pagecache()
>>>        -> errseq_set(-EIO)
>>>
>>
>> It looks like this issue occurs when invalidate_inode_pages2_range()
>> checks beyond the DIO write range, which may only happen when folio size
>> is larger than block size. Is that correct?
> Thanks for looking at this!
> 
> Not quite — the scenario involves an 8k file with layout
> 
>  [hole at 0-4k] [written extent at 4k-8k]
> 
> and two DIO threads. Thread A does a 4k DIO write at offset 4k; since
> the target block is a written extent, no fallback occurs. Thread B
> does an 8k DIO write at offset 0; since blocks 0-4k are a hole on an
> indirect-block inode and ext3 does not support unwritten extents,
> iomap returns -ENOTBLK and the entire 8k write falls back to buffered
> I/O.
> 
> Normally the kernel would prevent concurrent BIO and DIO to
> overlapping ranges on the same file. But because Thread A holds only
> a shared inode lock (pure overwrite on a written extent), and
> Thread B's DIO has already returned -ENOTBLK before its buffered
> fallback begins, both paths can proceed concurrently:
> 
> 
> Thread A: 4k DIO at offset 4k     Thread B: 8k DIO at offset 0
> ─────────────────────────────     ─────────────────────────────
> kiocb_invalidate_pages            iomap_begin → -ENOTBLK
>   → page index 1 already clean      (indirect inode hole, m_flags=0)
> submit_bio (async)                dio->size = 0
> inode_unlock_shared()             inode_unlock_shared()
> 
>                                   ext4_buffered_write_iter()
> [bio pending]                       → dirty page 0 [0, 4k]
>                                     → dirty page 1 [4k, 8k]
>                                   inode_unlock()
>                                   // pages dirty, no lock
> 
> [bio completes]
> iomap_dio_complete():
>   kiocb_invalidate_post_direct_write()
>     start = 4096 >> 12 = 1
>     end = (8191) >> 12 = 1
>     invalidate_inode_pages2_range(1, 1)
>       → page 1 [4k,8k] is DIRTY
>       → -EBUSY → errseq_set(-EIO)
> 
> Page index 1 corresponds to file offset [4k, 8k], which is exactly
> Thread A's DIO range. The invalidation is not going beyond the DIO
> range — the dirty page was placed there by Thread B's buffered
> fallback, which wrote to [0, 8k] and dirtied the same page.
> 
> No large folio is needed; 4k pages and 4k blocks are sufficient.
> 
> From the user's perspective, when performing concurrent DIO on a
> holed ext3 file, the file contents can become corrupted with some
> probability. If the file is used as a loop device's backing file,
> this manifests as filesystem corruption inside the loop device.

Ha, fair enough. Thanks for the details.

Cheers,
Yi.

