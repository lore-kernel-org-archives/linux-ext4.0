Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DA9419FD2;
	Fri,  4 Sep 2026 06:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503265; cv=none; b=XTOrFGSMQAPtB02X82ocaD82HXn3NTvXV5xmZ95HR0ilvGpWwlztbAa52NCQK23Iv8Azs+S8g/DphVMaWbwmWeVK1vmTldt4l+/rPr8QXmTAhPW9LXqci6cQAP7+XniYwe49cb4n3yzYcZDk6FewDQ6q/x8fNB8I1d2FFNSi6K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503265; c=relaxed/simple;
	bh=6gioUt+B5CAQgBnBviclbaI3D/JX/pcUgW62TiOM1B8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+Qh+rYdaVHXXMeK5zdJ+Jbx+OIUoqT9yTPwUATuPXlxqvFHXBP6N27mlrPYLHbqFtl9SqufCtSoxzdAovg6JwPFU/tsaSCJ5dFbp+3oPa2KiqYwN29xamzgVL0dbLAVLI1WqbRrZNCnuNyQ8HpZdLuxAl/siVDDWRP5tZQneHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbmhH38tszKHMZK;
	Fri,  4 Sep 2026 14:26:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 4DB474056D;
	Fri,  4 Sep 2026 14:27:34 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH_AfTZJpqP+rGAg--.7342S3;
	Fri, 04 Sep 2026 14:27:33 +0800 (CST)
Message-ID: <4e498938-f21b-4d75-b789-8a615aba877a@huaweicloud.com>
Date: Fri, 4 Sep 2026 14:27:31 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
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
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
 <CAJnrk1ZLzNQxrSLQx7TsLK89QC_=9cDfoDcyKNBNde0CiDGoNg@mail.gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <CAJnrk1ZLzNQxrSLQx7TsLK89QC_=9cDfoDcyKNBNde0CiDGoNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDH_AfTZJpqP+rGAg--.7342S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XFy8tF1DXF47KF18AFWUurg_yoWfWw1kpr
	W3Ka9Iyr4DG3y2krsrZan8Xw1Yy3s3XrWUJFyfGFy3CFs09r1xKF1UK3WF93y7Grn7AFy0
	qF1UZa9xW3WDAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	4xRDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/4/2026 3:01 AM, Joanne Koong wrote:
> On Thu, Sep 3, 2026 at 5:01 AM Zhang Yi <yi.zhang@huaweicloud.com> wrote:
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
>> Rework the contract so the caller is told where to stop instead of
>> silently truncating the straddler:
>>
>>   - Return true only when a split occurred, false otherwise. This
>>     clarifies the existing confusing return value semantics.
>>
>>   - Add an optional out-parameter pgoff_t *end, set to the index of the
>>     folio that contains @lend and must be kept by the caller's loop. It
>>     is only written when the folio actually straddles @lend. On the
>>     success path it defaults to the page index of the end edge and is
>>     refined to folio2->index when the second split fails to isolate the
>>     tail.
>>
>>   - Rename the byte-range parameters start/end to lstart/lend to avoid
>>     clashing with the new @end output and to separate byte offsets from
>>     folio indices.
>>
>> Callers in truncate_inode_pages_range() and shmem_undo_range() pass &end
>> only when the folio straddles lend. After all, no caller discards a
>> straddling folio anymore, the in-range cleanly-split sub-folios below it
>> are still dropped.
>>
>> Suggested-by: Brian Foster <bfoster@redhat.com>
>> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
>> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>  mm/internal.h |  4 ++--
>>  mm/shmem.c    | 12 +++++------
>>  mm/truncate.c | 57 ++++++++++++++++++++++++++++++---------------------
>>  3 files changed, 41 insertions(+), 32 deletions(-)
>>
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index b58ba940be47..2ebb00f6c379 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -206,15 +206,18 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
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
>> + * When @end non-NULL, set to the index of the folio that contains @lend
>> + * and must be kept by the caller's truncate loop.  Return %true if the
>> + * folio was split, %false otherwise, in which case the folio is dropped or
>> + * may still straddle the range, so the caller must not discard it.
>>   */
>> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>> +                                 loff_t lend, pgoff_t *end)
>>  {
>>         loff_t pos = folio_pos(folio);
>>         size_t size = folio_size(folio);
>> @@ -222,19 +225,22 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>         struct page *split_at, *split_at2;
>>         unsigned int min_order;
>>
>> -       if (pos < start)
>> -               offset = start - pos;
>> +       if (end && pos + size > (u64)lend)
>> +               *end = folio->index;
>> +
>> +       if (pos < lstart)
>> +               offset = lstart - pos;
>>         else
>>                 offset = 0;
>> -       if (pos + size <= (u64)end)
>> +       if (pos + size <= (u64)lend)
>>                 length = size - offset;
>>         else
>> -               length = end + 1 - pos - offset;
>> +               length = lend + 1 - pos - offset;
>>
>>         folio_wait_writeback(folio);
>>         if (length == size) {
>>                 truncate_inode_folio(folio->mapping, folio);
>> -               return true;
>> +               return false;
>>         }
>>
>>         /*
>> @@ -248,7 +254,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>         if (folio_needs_release(folio))
>>                 folio_invalidate(folio, offset, length);
>>         if (!folio_test_large(folio))
>> -               return true;
>> +               return false;
>>
>>         min_order = mapping_min_folio_order(folio->mapping);
>>         split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
>> @@ -259,6 +265,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>                  * for shmem truncate
>>                  */
>>                 struct folio *folio2;
>> +               bool tail_isolated = true;
>> +
>> +               if (end)
>> +                       *end = (pos + offset + length) >> PAGE_SHIFT;
> 
> If I'm understanding it correctly, based on how
> truncate_inode_pages_range() uses the end value (eg the "while (index
> < end)" loop condition and the find_get_entries(..., end - 1, ...)),
> end needs to point to the start of the folio if the tail folio from
> the split is a large folio, in order to exclude that folio from then
> being truncated. But with the (pos + offset + length) >> PAGE_SHIFT
> calculation here, does that result in some cases in it pointing to the
> middle of a large folio? Maybe some logic is needed to make sure that
> it points to the start?
> 

Hi Joanne,

Thanks for your careful review! I don't think that case can actually
occur. Let me walk through the scenarios where the
(pos + offset + length) >> PAGE_SHIFT calculation is kept as the final
end value:

1) offset + length == size:
   The truncate range aligns exactly with the folio boundary, so
   (pos + offset + length) >> PAGE_SHIFT points to the start of the next
   folio, not the middle of one.

2) !folio_try_get(folio2):
   The folio at that position has already been freed or is being freed,
   so there is no folio in the page cache at that location. The
   subsequent find_get_entries() won't find anything there.

3) !folio_test_large(folio2):
   folio2 is no longer large, likely split to order-0 by a concurrent
   operation. For an order-0 folio, the page index and folio index are
   the same, so the calculation is correct.

4) folio2 becomes stale:
   The same to case 2), folio2 is removed from the address space, so
   there is no large folio straddling the boundary that needs
   protection. The caller won't get folio from here through
   find_get_entries(). Using the page index is safe here.

If a large folio straddles the boundary at (offset + length), we will
successfully get a reference via folio_try_get(folio2) and
folio_test_large(folio2) will be true. In that case, if the split fails
(cannot lock or split operation fails), we set tail_isolated to false
and set *end = folio2->index to point to the start of that large folio
since tail_isolated.

The page index from this setting is only kept when no large folio exists
at the boundary, which makes it safe to use. What is particularly
noteworthy is that for cases 2 and 4 above, aside from setting it to
(pos + offset + length) >> PAGE_SHIFT, there does not seem to be any
better alternative.

Does this make sense or am I missing something?

Thanks,
Yi.


