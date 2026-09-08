Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1092353B5ED;
	Tue,  8 Sep 2026 12:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870063; cv=none; b=kU0n5ygmOXR9J1V8Yy3K4Lw1/CEYU2Il8RJ4kfmtUH4XYs60bcJrNfmMvbqt6KD/mYHRRdDZyiGjAQcZoWL9ZE56GStarKir2k/VZCufnFui347P8JgOAnNQ8XbRNgwPHRnPPv04ODoGBP+eYQQ7Clt3qjjNBVJxoO+rAsdTGbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870063; c=relaxed/simple;
	bh=azzrluQA/5waPz9IoQumAIpbXimFSCK1M4cko3tfls0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Thvn9lxMiv+yT3JibJyBMwHGYhz58jWjEqexf2IUkWxaQkyTNbBmmO7LCWorSHZ2LvmAeFyY2rfBsngz8zl86ODpjc1YLIAIJNqT2SoG8/+H4kjpJC7Wv7VrXbQSKKbRKMtY+P7bR87iziq05RJuqLTs5gIZKXdAIQHQi47vEeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hfNL340ykzYQvFk;
	Tue,  8 Sep 2026 20:19:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 047AB40573;
	Tue,  8 Sep 2026 20:20:47 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCXzAec_Z9qZzPVBA--.39877S3;
	Tue, 08 Sep 2026 20:20:46 +0800 (CST)
Message-ID: <30a70622-1812-46aa-bfc7-b9821148197d@huaweicloud.com>
Date: Tue, 8 Sep 2026 20:20:44 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
To: Zhang Yi <yizhang089@gmail.com>, Brian Foster <bfoster@redhat.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com, djwong@kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com,
 wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
 <apsH60jXMc5Y6Imh@bfoster> <06252b2e-532f-4359-ad8b-f8bc1f48e73f@gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <06252b2e-532f-4359-ad8b-f8bc1f48e73f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXzAec_Z9qZzPVBA--.39877S3
X-Coremail-Antispam: 1UD129KBjvAXoW3KF1DKr45Kr4DAw4kZr1fJFb_yoW8GFWDKo
	W5Kw4aqr1FqrWUKF4UAry7Jry5Xw15Arn7tr13Cr13CF1IvryUA3yUJryDt3yUJr18Gr1U
	GryUJFyjvFW7Jr1Un29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYz7kC6x804xWl14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
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

On 9/5/2026 5:58 PM, Zhang Yi wrote:
> On 9/5/2026 2:03 AM, Brian Foster wrote:
>> On Thu, Sep 03, 2026 at 07:50:18PM +0800, Zhang Yi wrote:
>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>
>>> truncate_inode_partial_folio() splits a large folio so that the caller's
>>> truncate loop can drop the in-range sub-folios while keeping the
>>> out-of-range tail. The first split at the punch start edge is
>>> non-uniform, which leaves the sub-folio at the truncation end edge as
>>> large as possible, this means it may still straddle the range, holding
>>> both zeroed in-range and valid out-of-range data. The function then
>>> attempts a second split at offset + length to isolate that tail.
>>>
>>> If the second split fails the straddling sub-folio stays merged. The
>>> function returned true unconditionally on all exit paths of the success
>>> block, telling the caller it was fully handled. The caller kept its
>>> default end and the truncate loop truncated every sub-folio below it,
>>> including the merged straddler, discarding the valid out-of-range tail.
>>>
>>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>>> of the last page:
>>>
>>>    truncate_inode_pages_range()
>>>      truncate_inode_partial_folio()      # same_folio == true
>>>        1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>>        folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>>        2nd split of folio2 fails / cannot lock
>>>        return true                       # BUG: caller keeps default end
>>>      end = 3
>>>      loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>>
>>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>>> folio_split() in truncate operation") replaced the atomic split_folio()
>>> with folio_split(), whose non-uniform split can partially split a folio
>>> and leave the end edge merged.
>>>
>>> It has gone unnoticed because a dirty large folio normally carries the
>>> filesystem's private data, for example buffer_head, so
>>> filemap_release_folio() -> iomap_release_folio() returns false on a
>>> dirty folio and folio_split() aborts with -EBUSY before any split,
>>> leaving the straddler safely unsplit. The bug is only reachable on paths
>>> that produce dirty large folios without filesystem private data, and it
>>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>>> attached.
>>>
>>> Rework the contract so the caller is told where to stop instead of
>>> silently truncating the straddler:
>>>
>>>    - Return true only when a split occurred, false otherwise. This
>>>      clarifies the existing confusing return value semantics.
>>>
>>>    - Add an optional out-parameter pgoff_t *end, set to the index of the
>>>      folio that contains @lend and must be kept by the caller's loop. It
>>>      is only written when the folio actually straddles @lend. On the
>>>      success path it defaults to the page index of the end edge and is
>>>      refined to folio2->index when the second split fails to isolate the
>>>      tail.
>>>
>>>    - Rename the byte-range parameters start/end to lstart/lend to avoid
>>>      clashing with the new @end output and to separate byte offsets from
>>>      folio indices.
>>>
>>> Callers in truncate_inode_pages_range() and shmem_undo_range() pass &end
>>> only when the folio straddles lend. After all, no caller discards a
>>> straddling folio anymore, the in-range cleanly-split sub-folios below it
>>> are still dropped.
>>>
>>> Suggested-by: Brian Foster <bfoster@redhat.com>
>>> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
>>> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>> ---
>>
>> Thanks for the patch and description. AFAICT this looks good in terms of
>> I think it fixes the issue and generally otherwise preserves existing
>> behavior (modulo the thing Joanne is poking at that I haven't grok'd).
>> That said...
>>
>>>   mm/internal.h |  4 ++--
>>>   mm/shmem.c    | 12 +++++------
>>>   mm/truncate.c | 57 ++++++++++++++++++++++++++++++---------------------
>>>   3 files changed, 41 insertions(+), 32 deletions(-)
>>>
>> ...
>>> diff --git a/mm/truncate.c b/mm/truncate.c
>>> index b58ba940be47..2ebb00f6c379 100644
>>> --- a/mm/truncate.c
>>> +++ b/mm/truncate.c
>>> @@ -206,15 +206,18 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
>>>   /*
>>>    * Handle partial folios.  The folio may be entirely within the
>>>    * range if a split has raced with us.  If not, we zero the part of the
>>> - * folio that's within the [start, end] range, and then split the folio if
>>> + * folio that's within the [lstart, lend] range, and then split the folio if
>>>    * it's large.  split_page_range() will discard pages which now lie beyond
>>>    * i_size, and we rely on the caller to discard pages which lie within a
>>>    * newly created hole.
>>>    *
>>> - * Returns false if splitting failed so the caller can avoid
>>> - * discarding the entire folio which is stubbornly unsplit.
>>> + * When @end non-NULL, set to the index of the folio that contains @lend
>>> + * and must be kept by the caller's truncate loop.  Return %true if the
>>> + * folio was split, %false otherwise, in which case the folio is dropped or
>>> + * may still straddle the range, so the caller must not discard it.
>>>    */
>>> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>>> +                  loff_t lend, pgoff_t *end)
>>
>> ... I find the interface kind of confusing and I wonder if we can come
>> up with something cleaner. After some time rubber ducking with $LLM,
>> what do you think about something where we'd have this function take
>> lstart/lend and always return something like pstart/pend page offsets
>> (instead of just end)? Those page offsets would essentially refer to the
>> indexes for the page range fully covered by lstart/lend, after whatever
>> splitting occurred (or didn't).
>>
>> So in this particular example of a 4-page folio where we truncate from 0
>> to the middle of the last page, pstart would refer to p0 and pend to p3
>> in the successful case. This tells the caller that pages p0 thru p2 can
>> be punched out.
>>
>> If the second split fails as in the commit log example, then you have
>> pstart == p0 and pend == p2-3. The caller (truncate_inode_pages_range())
>> would reflect this into start/end such that we only punch out p0 thru p1
>> in that case.
>>
>> I think that means for the case where same_folio == false, the range to
>> walk in the caller would be defined by pstart of the first
>> partial_folio() call and pend of the second, so that code would have to
>> change a little bit. That said, I wonder if that means we could also
>> just get rid of the return value and let the pstart/pend values infer
>> whether splits occurred or not. I see you've already removed the need
>> for the return check in the second partial_folio() call. I haven't run
>> through the other users of this function though. Thoughts on something
>> like that?
>>
>> Brian
> 
> Thank you for your suggestion. I think I've roughly understood your
> idea, and it does sound promising at first glance.
> 
> Yes, I've already removed the tail-side check by using the return
> value from pend. Similarly, it seems that we should be able to
> eliminate the head-side checks in both truncate_inode_pages_range()
> and shmem_undo_range() by leveraging pstart.
> 
> But I'm still not entirely sure whether we can completely drop the
> return value, as I need to take a closer look at the third call site
> of shmem_undo_range(). I haven't fully figured that part out yet, so
> I'd like to analyze it more carefully.
> 

After a closer look at the third call site in shmem_undo_range(), I'd
prefer to keep the bool return, though. Because it relies on the return
value to decide whether the folio was split. If it was, it resets the
loop so the freshly split sub-folios are picked up and dropped. If not,
there are no newly split sub-folios to pick up, so the loop simply
continues. Dropping the return value would force reworking the current
logic instead of its reset-loop logic, which is a separate behavioral
change I don't want to bundle into this data-loss fix.

Besides, the min_order > 0 issue Joanne pointed out should also happen
on the start side, so the pstart changes you suggested become necessary.
Therefore, in the next iteration, I will pass pstart but keep the return
value.

Thanks,
Yi.

> 
>>
>>>   {
>>>       loff_t pos = folio_pos(folio);
>>>       size_t size = folio_size(folio);
>>> @@ -222,19 +225,22 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>>       struct page *split_at, *split_at2;
>>>       unsigned int min_order;
>>>   -    if (pos < start)
>>> -        offset = start - pos;
>>> +    if (end && pos + size > (u64)lend)
>>> +        *end = folio->index;
>>> +
>>> +    if (pos < lstart)
>>> +        offset = lstart - pos;
>>>       else
>>>           offset = 0;
>>> -    if (pos + size <= (u64)end)
>>> +    if (pos + size <= (u64)lend)
>>>           length = size - offset;
>>>       else
>>> -        length = end + 1 - pos - offset;
>>> +        length = lend + 1 - pos - offset;
>>>         folio_wait_writeback(folio);
>>>       if (length == size) {
>>>           truncate_inode_folio(folio->mapping, folio);
>>> -        return true;
>>> +        return false;
>>>       }
>>>         /*
>>> @@ -248,7 +254,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>>       if (folio_needs_release(folio))
>>>           folio_invalidate(folio, offset, length);
>>>       if (!folio_test_large(folio))
>>> -        return true;
>>> +        return false;
>>>         min_order = mapping_min_folio_order(folio->mapping);
>>>       split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
>>> @@ -259,6 +265,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>>            * for shmem truncate
>>>            */
>>>           struct folio *folio2;
>>> +        bool tail_isolated = true;
>>> +
>>> +        if (end)
>>> +            *end = (pos + offset + length) >> PAGE_SHIFT;
>>>             if (offset + length == size)
>>>               goto no_split;
>>> @@ -273,24 +283,28 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>>           if (!folio_test_large(folio2))
>>>               goto out;
>>>   -        if (!folio_trylock(folio2))
>>> +        if (!folio_trylock(folio2)) {
>>> +            tail_isolated = false;
>>>               goto out;
>>> +        }
>>>             /* make sure folio2 is large and does not change its mapping */
>>>           if (folio_test_large(folio2) &&
>>> -            folio2->mapping == folio->mapping)
>>> -            folio_split_or_unmap(folio2, split_at2, min_order);
>>> +            folio2->mapping == folio->mapping &&
>>> +            folio_split_or_unmap(folio2, split_at2, min_order))
>>> +            tail_isolated = false;
>>>             folio_unlock(folio2);
>>>   out:
>>> +        if (!tail_isolated && end)
>>> +            *end = folio2->index;
>>>           folio_put(folio2);
>>>   no_split:
>>>           return true;
>>>       }
>>> -    if (folio_test_dirty(folio))
>>> -        return false;
>>> -    truncate_inode_folio(folio->mapping, folio);
>>> -    return true;
>>> +    if (!folio_test_dirty(folio))
>>> +        truncate_inode_folio(folio->mapping, folio);
>>> +    return false;
>>>   }
>>>     /*
>>> @@ -413,11 +427,9 @@ void truncate_inode_pages_range(struct address_space *mapping,
>>>       folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
>>>       if (!IS_ERR(folio)) {
>>>           same_folio = lend < folio_next_pos(folio);
>>> -        if (!truncate_inode_partial_folio(folio, lstart, lend)) {
>>> +        if (!truncate_inode_partial_folio(folio, lstart, lend,
>>> +                          same_folio ? &end : NULL))
>>>               start = folio_next_index(folio);
>>> -            if (same_folio)
>>> -                end = folio->index;
>>> -        }
>>>           folio_unlock(folio);
>>>           folio_put(folio);
>>>           folio = NULL;
>>> @@ -427,8 +439,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
>>>           folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
>>>                           FGP_LOCK, 0);
>>>           if (!IS_ERR(folio)) {
>>> -            if (!truncate_inode_partial_folio(folio, lstart, lend))
>>> -                end = folio->index;
>>> +            truncate_inode_partial_folio(folio, lstart, lend, &end);
>>>               folio_unlock(folio);
>>>               folio_put(folio);
>>>           }
>>> -- 
>>> 2.52.0
>>>
>>

