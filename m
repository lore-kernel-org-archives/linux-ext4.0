Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5793E5577
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 09:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781776165; cv=none; b=NhZ/z8NA61JzWF6vqGyexAFbLH90de78AXkq0lFgc/OmCJJfEJcvdo/XhAtcpxzL7Rq4Fcg9mKEMBWFW+uxb4OeD0J9PmqhqKahKyii6aDdwmCSn7HxjoHCqaoh+ytWsemM09uqz8vOg0q+L2NiIG4qa/VokXTuKnojQUiEvcSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781776165; c=relaxed/simple;
	bh=joXGFqPukUUTGbI3DqbSJFHl2RLHgtCqaSh2CrO/aLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DCNp/zxEbCuuDNr7IuR12sRV63zoKSEARFSCOBLCm9BNhFc7aQ+/HsxYSFc8+29pvGoAPIIv5C0s1/frE1SiRQGfkfEQIC211XM0BEpqmtYsPuqYrMnjbX4PXf2FcmhG6bDd61dy+kaieWDHPh7e5AL1dGI1oAv7mYviBdH6mEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ghzsM9gF; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ghzsM9gF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781776155; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3Rcgb96eBo95eOi4w1vZQbn15Z5vilP5CAkVORS5Ojc=;
	b=ghzsM9gFWWXakXwv8ru8jSQY6R5UdJxwNFb5ibpDrPRKoGJRsL2q9uvYUtwUJ/uL60K1K8YQ1je4UJtZMTDW83vpXj9dxdz4YS/Dnbrt8/jckYrb81mOr8qbzDVId08wdWR0tM4XU4LU8utUCycKb5LifVXRSURKYRFVsd9SE94=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X56WpvC_1781776154;
Received: from 30.221.149.201(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X56WpvC_1781776154 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:49:15 +0800
Message-ID: <063f1230-4014-4686-8308-f35736fd691e@linux.alibaba.com>
Date: Thu, 18 Jun 2026 17:49:14 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ext4: base unaligned DIO lock decision on partial
 block zeroing
To: Jan Kara <jack@suse.cz>
Cc: Zhang Yi <yizhang089@gmail.com>, linux-ext4@vger.kernel.org,
 tytso@mit.edu, adilger.kernel@dilger.ca, yi.zhang@huawei.com,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, peng_wang@linux.alibaba.com
References: <20260611163441.2431805-1-libaokun@linux.alibaba.com>
 <20260611163441.2431805-3-libaokun@linux.alibaba.com>
 <060f63e0-d64f-40df-99a7-af53862049ee@linux.alibaba.com>
 <d1adcf7c-c276-458d-9cac-68a4410f7626@gmail.com>
 <4f4800dc-0a2c-48e2-9535-f32b21628bdb@linux.alibaba.com>
 <wbgohsiks4355iejpa2xhvjdgyd4hfpg2gjcpgrv2wcbnevwao@mhik7uhkzzhx>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <wbgohsiks4355iejpa2xhvjdgyd4hfpg2gjcpgrv2wcbnevwao@mhik7uhkzzhx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/6/17 19:08, Jan Kara wrote:
> On Wed 17-06-26 15:52:24, Baokun Li wrote:
>> On 2026/6/17 10:45, Zhang Yi wrote:
>>> On 6/16/2026 9:10 PM, Baokun Li wrote:
>>>> Thank you for your review!
>>>>
>>>> After extensive testing, I found that after merging this patch,
>>>> generic/746
>>>> started failing intermittently on ext3 (mkfs.ext4 -O ^extents).  The
>>>> test
>>>> triggers a "Page cache invalidation failure on direct I/O" warning, and
>>>> subsequent fsync returns -EIO.
>>>>
>>>> The underlying race existed before this patch, but this patch appears to
>>>> have widened the reproduction window considerably, so I thought it worth
>>>> trying to address.  Here is my analysis:
>>>>
>>>> On no-extent inodes, DIO writes that hit holes cannot use unwritten
>>>> extents.  ext4_iomap_alloc() leaves m_flags=0, so ext4_map_blocks()
>>>> returns 0 for a hole, and:
>>>>
>>>>          if (!m_flags && !ret)
>>>>                  ret = -ENOTBLK;
>>>>
>>>> The iomap layer returns -ENOTBLK to ext4, which falls back to buffered
>>>> I/O.  The fallback path dirties pages in the page cache, then flushes
>>>> and invalidates them.  However, concurrent async DIO completions to
>>>> other blocks on the same inode can run
>>>> kiocb_invalidate_post_direct_write()
>>>> without holding the inode lock.
>>>>
>>>> Consider a file with two 4k extents: [hole][written].  Thread A does DIO
>>>> to the written extent, while thread B does DIO spanning both extents:
>>>>
>>>>    kworker A (4k DIO, allocated block)    kworker B (8k DIO,
>>>> hole->fallback)
>>>>    -----------------------------------   
>>>> -----------------------------------
>>>>    inode_lock_shared()                    inode_lock_shared()
>>>>    iomap_dio_rw():                        iomap_dio_rw():
>>>>      kiocb_invalidate_pages -> clean        iomap_begin -> -ENOTBLK
>>>>      submit_bio (async)                     dio->size = 0
>>>>    inode_unlock_shared()                  inode_unlock_shared()
>>>>
>>>>    [bio pending in block layer]           /* fallback: inode lock
>>>> released */
>>>>                                           ext4_buffered_write_iter()
>>>>                                             inode_lock(exclusive)
>>>>                                             generic_perform_write()
>>>>                                               -> dirty pages [0, 8k]
>>>>                                             inode_unlock(exclusive)
>>>>
>>>>                                           /* pages still dirty here */
>>>>    [bio completes]                        filemap_write_and_wait_range()
>>>>    iomap_dio_complete()                     -> flush dirty pages
>>>>      kiocb_invalidate_post_direct_write() invalidate_mapping_pages()
>>>>        invalidate_inode_pages2_range()
>>>>        -> finds dirty page!               /* window closed */
>>>>        -> dio_warn_stale_pagecache()
>>>>        -> errseq_set(-EIO)
>>>>
>>> It looks like this issue occurs when invalidate_inode_pages2_range()
>>> checks beyond the DIO write range, which may only happen when folio size
>>> is larger than block size. Is that correct?
>> Thanks for looking at this!
>>
>> Not quite — the scenario involves an 8k file with layout
>>
>>  [hole at 0-4k] [written extent at 4k-8k]
>>
>> and two DIO threads. Thread A does a 4k DIO write at offset 4k; since
>> the target block is a written extent, no fallback occurs. Thread B
>> does an 8k DIO write at offset 0; since blocks 0-4k are a hole on an
>> indirect-block inode and ext3 does not support unwritten extents,
>> iomap returns -ENOTBLK and the entire 8k write falls back to buffered
>> I/O.
> Right, but for this to happen userspace had to submit two overlapping
> direct IO writes. This always had undefined behavior so some inconsistent
> content in the file is more or less acceptable. But as Zhang pointed out,
> the same failure can also appear when block_size < folio_size and there we
> should really strive to provide consistent data.
Agreed, overlapping DIO is UB from userspace's perspective. However,
neither the loop device usage in generic/746 nor the BS < PS scenario
that Yi mentioned involves userspace intentionally submitting
overlapping DIO writes. Both are triggered through normal I/O paths,
so the issue still needs to be addressed.
>
>>>> The critical window is the gap between ext4_buffered_write_iter()
>>>> dirtying
>>>> pages and filemap_write_and_wait_range() flushing them.  In this
>>>> window the
>>>> inode lock is not held, so another thread's async DIO completion is
>>>> free to
>>>> invalidate the still-dirty pages in the page cache.
>>>>
>>>> This race has always existed on ext3 because indirect-block inodes lack
>>>> unwritten-extent support.  However, the window was extremely narrow in
>>>> practice, because the old ext4_overwrite_io() checked every block and
>>>> would conservatively take an exclusive lock.  This patch replaced it
>>>> with ext4_dio_needs_zeroing(), which only checks head and tail blocks,
>>>> making unaligned DIO more likely to take a shared lock and
>>>> proportionally increasing the chance of hitting the race.
>>>>
>>>> I tried a couple of alternatives before settling on the patch below:
>>>>
>>>> 1. Force exclusive lock + IOMAP_DIO_FORCE_WAIT for all no-extent DIO.
>>>>     This closes the window for new DIO submissions, but does not protect
>>>>     against bio completions from previously submitted async DIO, which
>>>>     run independently of the inode lock.
>>>>
>>>> 2. Wrap the fallback dirty+flush+invalidate sequence in
>>>>     filemap_invalidate_lock().  However, the ext4 DIO and iomap layers
>>>>     do not use this lock, so it would not serialise against DIO
>>>>     completions.
>>>>
>>> Could we add a call to inode_dio_wait() before falling back to buffered
>>> I/O? That is, in thread B, when falling back to buffered I/O, could we
>>> acquire the exclusive inode lock and then call inode_dio_wait() to wait
>>> for in-flight DIO to complete? This should close the race window. Since
>>> scenarios where DIO writes to holes on ext3 are relatively rare, the
>>> performance impact should be minimal (I suppose).
>>>
>> That's a great idea, thank you!
>>
>> I had been trying to fix this on the DIO side and didn't consider
>> waiting from the buffered fallback path.
>>
>> I've tested the approach locally and it closes the race; I'll add a
>> patch using it in the next version.
> Yes, this looks like the best solution so far. The fallback doesn't have to
> be fast. It was always - you are doing something stupid and we try to fixup
> for you - kind of thing and bad performance is acceptable in that case.
Agreed.
>>>> One straightforward approach that seems correct is to skip direct I/O
>>>> for no-extent inodes entirely, by returning 0 from ext4_dio_alignment():
>>>>
>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>> --- a/fs/ext4/inode.c
>>>> +++ b/fs/ext4/inode.c
>>>> @@ -6131,6 +6131,8 @@ u32 ext4_dio_alignment(struct inode *inode)
>>>>   {
>>>>          if (fsverity_active(inode))
>>>>                  return 0;
>>>> +       if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>>>> +               return 0;
>>>>          if (ext4_should_journal_data(inode))
>>>>                  return 0;
>>>>          if (ext4_has_inline_data(inode))
>>>>
>>>> With this, ext4_should_use_dio() returns false for no-extent inodes, and
>>>> all I/O goes through ext4_buffered_write_iter() directly, bypassing the
>>>> DIO path entirely.  On ext3, DIO to a hole already falls back to
>>>> buffered
>>>> I/O, so there is essentially no performance benefit to using DIO in the
>>>> first place.
>>>>
>>>> Note that with this change, the fallback branch in
>>>> ext4_dio_write_iter():
>>>>
>>>>          if (ret >= 0 && iov_iter_count(from)) {
>>>>                  /* buffered fallback */
>>>>          }
>>>>
>>>> would also become dead code for extent-based inodes (since unwritten
>>>> extents guarantee iomap_dio_rw() never returns zero with unconsumed
>>>> data), and could be removed in a follow-up cleanup.
>>>>
>>>> Thoughts?  Is there a reason to preserve DIO on no-extent inodes that
>>>> I'm missing?
>>>>
>>> Hmm, this would also cause DIO to fall back to buffered I/O in common
>>> extending write cases, which I think would be unacceptable.
>> Fair point, the regression on extending writes is hard to justify.  That
>> said, until we had a better fix, I'd argue a behavioural change was
>> still preferable to potential data corruption. With the inode_dio_wait()
>> approach above, this trade-off goes away. 
> But heavily regressing performance for overwrites or extending DIO writes
> even on indirect block based files is not really acceptable. There are
> still users who for whatever reasons stay with old filesystems having
> indirect block based files and they'd likely notice the regression.
>
> 								Honza

Agreed. Significantly degrading performance for common workloads
(overwrites, extending writes) to handle a rare race condition is
unacceptable for production systems. The current fix with
inode_dio_wait() only impacts the fallback path (DIO → buffered I/O),
which is already an exceptional and slow path, so the performance
impact there is acceptable.


Thanks,
Baokun

