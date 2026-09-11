Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB326411FA7;
	Fri, 11 Sep 2026 08:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789115135; cv=none; b=FC0NRai6LzaJyF6MpZPKr6TPYxd7OUgOLbkS6U7og13cBv/xzeRl8eRv9T7on86Q6I9PmCcHmGbZfpG6GMrn+p7GhfpzciRYYXcPn2SZPPjh7McTlhqzqGZhGHwt689HPeTDVsQuj/Hurjd8Fo/Bfb0XDOXHxB396XzACorvf0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789115135; c=relaxed/simple;
	bh=kvwK/D6Ch0u9q2sGlCGhyPjlqEOZvaGo0yb6o9YB3NQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QsRN7+UoRqpFENxk/5GPZSubVE37JkJ2j73hhawtzOVZUZpnxNRBu/fHYLSz11+OeTkNt0DY4eC8eqqjYP8CAynqdAl0imYWYhQ/S/ytNN0ppot8XZl2FzLJTjeP9qg/Um/kTjsC6/w8LzkA1hCJktzbezlKvljr4bWzqRY72CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hh6zv2RhmzKHMQQ;
	Fri, 11 Sep 2026 16:25:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 363D240590;
	Fri, 11 Sep 2026 16:25:21 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH_AfuuqNqJOk2Bg--.2181S3;
	Fri, 11 Sep 2026 16:25:20 +0800 (CST)
Message-ID: <aa0f94c8-b959-4aec-b8f5-69365d1a02fa@huaweicloud.com>
Date: Fri, 11 Sep 2026 16:25:18 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating straddling
 large folios
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com, bfoster@redhat.com,
 djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
 <CAJnrk1b8fWpp-yBRxFaBbFzA8852N53SB6j3Zi9Qnp+JBFuNbA@mail.gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <CAJnrk1b8fWpp-yBRxFaBbFzA8852N53SB6j3Zi9Qnp+JBFuNbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDH_AfuuqNqJOk2Bg--.2181S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XFy8tF1DXF47KF18AFWUurg_yoWxKr4fpr
	W2ga9Iyrs7G392krn2va1DXw1rJ3yfXr4UAF93J3s2kan0vr12kF1Utw1rCFWUGr97G3W0
	v3WjvanrW3WDAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
	WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jxCztUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/10/2026 2:29 AM, Joanne Koong wrote:
> On Tue, Sep 8, 2026 at 11:31 PM Zhang Yi <yi.zhang@huaweicloud.com> wrote:
>>
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> truncate_inode_partial_folio() splits a large folio so that the caller's
>> truncate loop can drop the in-range sub-folios while keeping the
>> out-of-range tail. The first split at the punch start edge is
>> non-uniform, which leaves the sub-folio at the truncation end edge as
>> large as possible, this means it may still straddle the range, holding
>> both zeroed in-range and valid out-of-range data. The function then
>> attempts a second split at offset + length to isolate that tail.
>>
>> If the second split fails the straddling sub-folio stays merged. The
>> function returned true unconditionally on all exit paths of the success
>> block, telling the caller it was fully handled. The caller kept its
>> default end and the truncate loop truncated every sub-folio below it,
>> including the merged straddler, discarding the valid out-of-range tail.
>>
>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>> of the last page:
>>
>>   truncate_inode_pages_range()
>>     truncate_inode_partial_folio()      # same_folio == true
>>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>       2nd split of folio2 fails / cannot lock
>>       return true                       # BUG: caller keeps default end
>>     end = 3
>>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>
>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>> folio_split() in truncate operation") replaced the atomic split_folio()
>> with folio_split(), whose non-uniform split can partially split a folio
>> and leave the end edge merged.
>>
>> It has gone unnoticed because a dirty large folio normally carries the
>> filesystem's private data, for example buffer_head, so
>> filemap_release_folio() -> iomap_release_folio() returns false on a
>> dirty folio and folio_split() aborts with -EBUSY before any split,
>> leaving the straddler safely unsplit. The bug is only reachable on paths
>> that produce dirty large folios without filesystem private data, and it
>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>> attached.
>>
>> In addition, even when both splits succeed, data can still be lost when
>> the mapping's minimum folio order (min_order) is non-zero. folio_split()
>> stops at min_order instead of order 0, so the sub-folio containing a
>> split point stays aligned to 1 << min_order rather than to a page. The
>> original success path left start at the page-aligned head of the range
>> and set end to the exact page index of the end edge, neither of which is
>> a folio boundary in general. Either one could land inside the large
>> folio at its edge, and the truncate loop would drop that straddling
>> folio together with its valid out-of-range tail.
>>
>> For example, a 64K (order-4) folio with min_order = 2 punched from
>> offset 0 to 36K:
>>
>>   truncate_inode_pages_range()
>>     truncate_inode_partial_folio()        # same_folio == true
>>       1st split at p0 -> [p0-p3, p4-p7, p8-p15]  # non-uniform, min_order
>>       folio2 = p8-p15 # straddles: p8 in range, p9-p15 tail valid
>>       2nd split of folio2 -> [p8-p11, p12-p15]   # success
>>       end = p9                           # BUG: p9 inside [p8-p11]
>>     loop truncates ... p8-p11           # p9-p11's valid tail is lost
>>
>> Rework the contract so the caller is told the page range to discard:
>>
>>   - Return true only when a split occurred, false otherwise. This
>>     clarifies the existing confusing return value semantics.
>>
>>   - Add pgoff_t *pstart and *pend out-parameters that receive the page
>>     range fully covered by [lstart, lend] after any split (or none),
>>     i.e. the pages wholly within the range and safe to discard. They are
>>     aligned up (pstart) and down (pend) to the mapping's minimum folio
>>     order so they always fall on a folio boundary.
>>
>>   - Rename the byte-range parameters start/end to lstart/lend to avoid
>>     clashing with the new outputs and to separate byte offsets from
>>     folio indices.
>>
>> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
>> &pstart for the folio at the start edge and &pend for the folio at the
>> end edge, so the truncate loop drops exactly the fully covered pages and
>> never touches a straddling folio that still holds valid out-of-range
>> data.
>>
>> Suggested-by: Brian Foster <bfoster@redhat.com>
>> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
>> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> 
>> ---
>> v1->v2:
>>  - Export pstart as a new parameter so that the generic and shmem
>>    truncate paths don't need to recompute the start value from the
>>    return value. (Brian)
>>  - When min_order is nonzero, align [pstart, pend] to the inner
>>    boundaries of the folio to ensure they do not point into the middle
>>    of a large folio, which could otherwise cause valid data within the
>>    folio to be incorrectly cleared. (Joanne)
>>
>> v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/
>>
>>  mm/internal.h |  4 +--
>>  mm/shmem.c    | 13 +++-----
>>  mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
>>  3 files changed, 67 insertions(+), 38 deletions(-)
>>

[...]

>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index b58ba940be47..d88a1b159084 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -206,35 +206,41 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
>>  /*
>>   * Handle partial folios.  The folio may be entirely within the
>>   * range if a split has raced with us.  If not, we zero the part of the
>> - * folio that's within the [start, end] range, and then split the folio if
>> + * folio that's within the [lstart, lend] range, and then split the folio if
>>   * it's large.  split_page_range() will discard pages which now lie beyond
>>   * i_size, and we rely on the caller to discard pages which lie within a
>>   * newly created hole.
>>   *
>> - * Returns false if splitting failed so the caller can avoid
>> - * discarding the entire folio which is stubbornly unsplit.
>> + * When @pstart and/or @pend are non-NULL they receive the indexes of the
>> + * page range fully covered by [lstart, lend] after any split (or none),
>> + * i.e. the range of pages that are wholly within [lstart, lend] and so safe
>> + * to discard.
> 
> I think with themin_order > 0 case, pages wholly within [lstart, lend]
> can still be excluded, so maybe worth editing this to reflect that.
> 
> Thanks,
> Joanne

Good point, I will fix this in next iteration.

Thanks,
Yi.

> 
>> + *
>> + * Return %true if the folio was split, %false otherwise.
>>   */
>> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>> +                                 loff_t lend, pgoff_t *pstart, pgoff_t *pend)
>>  {
>>         loff_t pos = folio_pos(folio);
>>         size_t size = folio_size(folio);

