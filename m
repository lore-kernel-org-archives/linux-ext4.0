Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C614DE715;
	Thu, 17 Sep 2026 12:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789646664; cv=none; b=SNVnHVP1p+Nf9rGLtFyIfAwdkz7BSXtbh+PmE0uj1T4g950oj7n0oxOPANAMUR6qn+opuqYJ9SDE8eE/hZNcr1AUjjruzRemKuUH3W/9DE9KPQOKbX69c3aj1eMrqnaneRzm93ID8nN73Kj934uuf51g6se/gnMu8ZuUcLrVGac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789646664; c=relaxed/simple;
	bh=5GLgoDbnmmPI1tOFYDp7omvJ9OrhE99PJ5vY2WcIHBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SoDum08V5r9UZcPagOVd5IeNMvt0vPLjHTrzmR1QlZimiEdpkF7RbVituU6xy9bKBlME2uxNBV0zPE/m1AZGTZNMnGHeeGe51UTYJGF3Id74zJ8XTYNU8YPJVyBLOaGCbzglsunIX6r9KRwCu+vUtLKXFeUTheiTEwvBVl3KaSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hlvYP5VSGzYQv4C;
	Thu, 17 Sep 2026 20:03:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5DC9540561;
	Thu, 17 Sep 2026 20:04:00 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgDntSgt16tqjrSRAg--.24695S3;
	Thu, 17 Sep 2026 20:03:59 +0800 (CST)
Message-ID: <453d0054-4f53-452a-9737-cd37d30a7d44@huaweicloud.com>
Date: Thu, 17 Sep 2026 20:03:57 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
To: Zhang Yi <yizhang089@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, bfoster@redhat.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com>
 <xl2rtnntlxoxoozkddgrlkcsgukcngvvcwazm7gb7q5g32yxir@ef5ltcwueboh>
 <DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com>
 <9d931f5e-cb34-4721-9def-7aeeda48700c@gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <9d931f5e-cb34-4721-9def-7aeeda48700c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDntSgt16tqjrSRAg--.24695S3
X-Coremail-Antispam: 1UD129KBjvAXoWfGFyDWr4UuFyfKry5JrW5ZFb_yoW8Gr1xXo
	WrK3y3tw1Fqr1UGa1UAw1DJr15X3Z8Jr9rJr13Cr47AF4Iq34jy3yxJr9rtayxJr18Gr1D
	GryUJr1ayFW7Jr1fn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUY77kC6x804xWl14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
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

On 9/17/2026 7:38 PM, Zhang Yi wrote:
> On 9/17/2026 2:03 AM, Zi Yan wrote:
>> On Wed Sep 16, 2026 at 8:02 AM EDT, Jan Kara wrote:
>>> On Wed 16-09-26 17:24:48, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> truncate_inode_partial_folio() splits a large folio so that the caller's
>>>> truncate loop can drop the in-range sub-folios while keeping the
>>>> out-of-range tail. The first split at the punch start edge is
>>>> non-uniform, which leaves the sub-folio at the truncation end edge as
>>>> large as possible, this means it may still straddle the range, holding
>>>> both zeroed in-range and valid out-of-range data. The function then
>>>> attempts a second split at offset + length to isolate that tail.
>>>>
>>>> If the second split fails the straddling sub-folio stays merged. The
>>>> function returned true unconditionally on all exit paths of the success
>>>> block, telling the caller it was fully handled. The caller kept its
>>>> default end and the truncate loop truncated every sub-folio below it,
>>>> including the merged straddler, discarding the valid out-of-range tail.
>>>>
>>>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>>>> of the last page:
>>>>
>>>>    truncate_inode_pages_range()
>>>>      truncate_inode_partial_folio()      # same_folio == true
>>>>        1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>>>        folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>>>        2nd split of folio2 fails / cannot lock
>>>>        return true                       # BUG: caller keeps default end
>>>>      end = 3
>>>>      loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>>>
>>>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>>>> folio_split() in truncate operation") replaced the atomic split_folio()
>>>> with folio_split(), whose non-uniform split can partially split a folio
>>>> and leave the end edge merged.
>>>>
>>>> It has gone unnoticed because a dirty large folio normally carries the
>>>> filesystem's private data, for example buffer_head, so
>>>> filemap_release_folio() -> iomap_release_folio() returns false on a
>>>> dirty folio and folio_split() aborts with -EBUSY before any split,
>>>> leaving the straddler safely unsplit. The bug is only reachable on paths
>>>> that produce dirty large folios without filesystem private data, and it
>>>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>>>> attached.
>>>>
>>>> Rework the contract so the caller is told the page range to discard:
>>>>
>>>>    - Add pgoff_t *pstart and *pend out-parameters that receive the page
>>>>      range fully covered by [lstart, lend] after any split (or none),
>>>>      i.e. the pages wholly within the range and safe to discard.
>>>>
>>>>    - Adjust the ordering of the validate check when splitting folio2.
>>>>      folio2->index is only reliable after the reference count and lock
>>>>      have been successfully acquired, since it may have been split
>>>>      concurrently, or freed and recycled to an unrelated mapping. On any
>>>>      failure to obtain a reliable end position, fall back to
>>>>      folio->index, which is safe but leaves the sub-folios split off at
>>>>      the offset edge in the page cache.
>>>>
>>>>    - Rename the byte-range parameters start/end to lstart/lend to better
>>>>      express their semantics.
>>>>
>>>> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
>>>> &pstart for the folio at the start edge and &pend for the folio at the
>>>> end edge, so the truncate loop drops exactly the fully covered pages and
>>>> never touches a straddling folio that still holds valid out-of-range
>>>> data.
>>>>
>>>> Suggested-by: Brian Foster <bfoster@redhat.com>
>>>> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
>>>> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>
>>> The changes mostly look good to me but I have some confusion around the
>>> folio2 splitting below.
>>>
>>>> @@ -259,32 +271,62 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>>>            * for shmem truncate
>>>>            */
>>>>           struct folio *folio2;
>>>> +        pgoff_t end, aligned_end = (pos + offset + length) >>
>>>> +                       PAGE_SHIFT;
>>>>   -        if (offset + length == size)
>>>> -            goto no_split;
>>>> +        if (pstart)
>>>> +            *pstart = round_up(pos + offset, PAGE_SIZE) >>
>>>> +                  PAGE_SHIFT;
>>>> +
>>>> +        if (offset + length == size) {
>>>> +            end = aligned_end;
>>>> +            goto out;
>>>> +        }
>>>>             split_at2 = folio_page(folio,
>>>>                   PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>>>>           folio2 = page_folio(split_at2);
>>>>   +        /*
>>>> +         * folio2 may become stale due to a concurrent split or
>>>> +         * freeing, so validate it before and after taking its lock.
>>>> +         * If it fails, we can't get an accurate end position and fall
>>>> +         * back to folio->index, which may leave sub-folios split off
>>>> +         * at the offset edge in the page cache this round.
>>>> +         */
>>>> +        end = folio->index;
>>>>           if (!folio_try_get(folio2))
>>>> -            goto no_split;
>>>> -
>>>> -        if (!folio_test_large(folio2))
>>>>               goto out;
>>>>   +        if (folio2->mapping != folio->mapping ||
>>>> +            !folio_test_large(folio2))
>>>> +            goto out_put;
>>>> +
>>>>           if (!folio_trylock(folio2))
>>>> -            goto out;
>>>> +            goto out_put;
>>>>   -        /* make sure folio2 is large and does not change its mapping */
>>>> -        if (folio_test_large(folio2) &&
>>>> -            folio2->mapping == folio->mapping)
>>>> -            folio_split_or_unmap(folio2, split_at2, min_order);
>>>> +        if (page_folio(split_at2) != folio2) {
>>>> +            folio_unlock(folio2);
>>>> +            goto out_put;
>>>> +        }
>>>> +        if (!folio_test_large(folio2)) {
>>>> +            end = aligned_end;
>>>> +            folio_unlock(folio2);
>>>> +            goto out_put;
>>>> +        }
>>>
>>> So I always found this folio2 lookup and revalidation somewhat suspicious
>>> and now that we're digging into it I'll ask: As you note in the changelog,
>>> by the time we compute split_at2 the page can be already freed and reused
>>> because it was split off from the original 'folio'. It can be for example a
>>> slab page or anything else. So is it guaranteed that page_folio() actually
>>
>> For a slab or unrelated page, folio->mapping check rejects them.
>>
>>> returns something sensible? What guarantees we properly detect the "reuse
>>
>> No, but folio_try_get() prevents non ref'd folios.
>>
>>> for something else" case in all possible cases for which the page can be
>>> reused? I understand this is mostly a preexisting issue so maybe these
>>> questions are more for MM guys than you...
>>
>> I agree with you that trying to split a unlocked and not ref'd folio2 is
>> flaky. And it almost does a __filemap_get_folio() like you proposed
>> below.
>>
> 
> I think this is indeed a pre-existing issue, as Sashiko pointed out:
> 
>> [Severity: Critical]
>> Does this speculative lookup handle the reallocation race correctly if the
>> folio is reallocated to a different file offset?
>>
>> After the first split, the tail pages are added to the page cache and
>> unlocked. During speculative lookup, the tail page could be concurrently
>> reclaimed, freed, and reallocated as a new large folio in the same mapping
>> but at a completely different file offset.
>>
>> The validation checks earlier and the page_folio check here will all pass
>> because the physical page split_at2 is part of the new allocation.
>>
>> However, the file index of the folio is not verified. If this unrelated large
>> folio fails to split, the fallback path assigns its index to end here:
>>
>>     if (folio_split_or_unmap(folio2, split_at2, min_order))
>>         end = folio2->index;
>>
>> This unrelated file offset is then returned to the caller via pend, which
>> can cause the hole punch loop to truncate an unrelated segment of the file.
>>
>> Should we verify that the file index of folio2 matches the expected index
>> (e.g. folio2->index + folio_page_idx(folio2, split_at2) == expected_index)
>> before using it?
> 
> the current mapping check on the folio2 and the folio !=
> page_folio(split_at) check in __folio_split() are not able to catch this
> problem, which could then cause folio2 to be split at the wrong
> position. Does that sound right?
> 
>>>
>>> So for me as an filesystem guy I'd appreciate some comment in this code
>>> explaining why grabbing folio2 this way is actually safe. The really safe
>>> way of getting to folio2 would be to use
>>>    __filemap_get_folio(mapping, (offset+length) >> PAGE_SHIFT, FGP_LOCK, 0)
>>> but I suppose we don't use the mapping lookup as it is more expensive?
>>
>> __filemap_get_folio() is a better version of the existing folio2 finding
>> code. When I wrote the code, I never thought about using
>> __filemap_get_folio(), but I probably should have done it.
>>
>> BTW,
>> __filemap_get_folio(mapping, folio->index + (offset+length) >> PAGE_SHIFT,
>>         FGP_LOCK | FGP_NOWAIT, 0)
>> might be better:
>> 1. folio->index is needed to get the right folio2,
>> 2. nowait can us nonblocking.
>>
>>
> 
> Following your suggestion, I reworked my existing patch to use
> __filemap_get_folio(), and it ends up looking roughly like the
> following(not tested yet). What do you think?
> 
> Besides, if the issue Sashiko pointed out does indeed exist, I can
> extract the __filemap_get_folio() change into a separate patch to fix it
> on its own.
> 
> Thanks,
> Yi.
> 

Sorry, the previous diff format was incorrect, reposting it.

diff --git a/mm/truncate.c b/mm/truncate.c
index 23c90f00b530..b5e5bdf5f9ef 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -279,51 +279,46 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 			*pstart = round_up(pos + offset,
 					   min_nrbytes) >> PAGE_SHIFT;

-		if (offset + length == size) {
-			end = aligned_end;
+		end = aligned_end;
+		if (offset + length == size)
 			goto out;
-		}
-
-		split_at2 = folio_page(folio,
-				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
-		folio2 = page_folio(split_at2);

 		/*
-		 * folio2 may become stale due to a concurrent split or
-		 * freeing, so validate it before and after taking its lock.
-		 * If it fails, we can't get an accurate end position and fall
-		 * back to folio->index, which may leave sub-folios split off
-		 * at the offset edge in the page cache this round.
+		 * After the first split at the start edge, the folio at the
+		 * end edge may be freed and reused concurrently.
+		 * __filemap_get_folio() looks up the straddler at
+		 * aligned_end and returns it locked and ref'd with the
+		 * mapping validated.
 		 */
-		end = folio->index;
-		if (!folio_try_get(folio2))
+		folio2 = __filemap_get_folio(folio->mapping, aligned_end,
+					     FGP_LOCK | FGP_NOWAIT, 0);
+		if (IS_ERR(folio2)) {
+			/*
+			 * No sub-folio straddles the boundary when aligned_end
+			 * is empty so discarding up to it is safe.  Otherwise
+			 * the straddler is locked by someone else and we
+			 * cannot obtain a reliable end position, so we fall
+			 * back to folio->index.  This is safe but may leave
+			 * pages split off at the offset edge lingering in the
+			 * page cache this round.
+			 */
+			if (PTR_ERR(folio2) != -ENOENT)
+				end = folio->index;
 			goto out;
-
-		if (folio2->mapping != folio->mapping ||
-		    !folio_test_large(folio2))
-			goto out_put;
-
-		if (!folio_trylock(folio2))
-			goto out_put;
-
-		if (page_folio(split_at2) != folio2) {
-			folio_unlock(folio2);
-			goto out_put;
-		}
-		if (!folio_test_large(folio2)) {
-			end = aligned_end;
-			folio_unlock(folio2);
-			goto out_put;
 		}

-		/* Split failed: back off to the head of the straddler */
+		/* Already at the minimum order, nothing to split */
+		if (folio_order(folio2) == min_order)
+			goto out_put;
+
+		split_at2 = folio_page(folio2, (aligned_end - folio2->index));
+
+		/* Split failed, keep the straddler intact */
 		if (folio_split_or_unmap(folio2, split_at2, min_order))
 			end = folio2->index;
-		else
-			end = aligned_end;

-		folio_unlock(folio2);
 out_put:
+		folio_unlock(folio2);
 		folio_put(folio2);
 out:
 		if (pend)


