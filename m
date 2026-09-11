Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B899D4334C9;
	Fri, 11 Sep 2026 07:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789112099; cv=none; b=dSVXI+oRVnL1bSzsfZF7W4njR/4a/4dm0ThL7pmMjw+byTGFYc2WgV8eaC/jOUYX9C6YeKYyJiG1hv5mg0YL6Gu9YfxUTbvkHNAhAOht2UJbq6yqzRjNutj6j52ESbFCaaWucJnQV7+ngJ6X9fLYX9motBDNOLeVh2wDIfcyYy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789112099; c=relaxed/simple;
	bh=coPsXuKmtF487IufcVpCcYEMGSNreq9HmUgcQLT34ZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fE+I667f98x3glzWax9OYZCUYGgOeEJCDTdk6gUfUr4ui7yHDASYB3y8ca6YiANazpnmSJ+s3WQjKO79b2pN2gEJAqRhHmNaMGT95xubMPOFu16dICbK/zqdaBi+QMV3HGM59tXcT1NAg47RhgVpO0Ut4DLOd9y+DLXIGwBQ4s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hh5sd22BWzKHMP2;
	Fri, 11 Sep 2026 15:34:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 1732B4058D;
	Fri, 11 Sep 2026 15:34:51 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgAH7ggYr6Nq45QyBg--.39022S3;
	Fri, 11 Sep 2026 15:34:50 +0800 (CST)
Message-ID: <5796c4ea-fd8f-48aa-8c9b-f1cc8ec1dde1@huaweicloud.com>
Date: Fri, 11 Sep 2026 15:34:48 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating straddling
 large folios
To: Brian Foster <bfoster@redhat.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
 <aqLaQcZvaFIrAz0e@bfoster>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <aqLaQcZvaFIrAz0e@bfoster>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAH7ggYr6Nq45QyBg--.39022S3
X-Coremail-Antispam: 1UD129KBjvAXoWfJF1DGF4xXw45WFy8ZrWrXwb_yoW8GrWDWo
	WrJ3yYv3WF9r1kAa10kas7JryDW3Z8ZryxJF13urs0vFnFq34qyw4fJ39rGFZ7Aw1jkF15
	Ga47Ja4SyrZrtF1fn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYc7kC6x804xWl14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
	kF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02
	F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4I
	kC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a
	6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
	xUIF4iUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/11/2026 12:26 AM, Brian Foster wrote:
> On Wed, Sep 09, 2026 at 02:23:39PM +0800, Zhang Yi wrote:
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
> 
> Hi Zhang,
> 
> Thanks for the tweaks. I still found some of the logic circuitous as I
> read through it so I spent some time playing with this just to
> experiment with cleaning it up a bit. I ended up removing a couple of
> the labels, lifting the pstart/pend assignment to a default init/case,
> and reshuffling the split case pstart/pend assignments in a way that I
> think also elides the need for the boolean or using folio2. (I'm curious
> if this happens to address the Sashiko feedback as well..?)
> 
> Note that this is completely untested and needs further review. Since
> the current patch looked mostly Ok to me functionally (though I do agree
> with the comment about possibly splitting up into smaller changes) and
> has other reviews, I'm just posting this as an FYI. Here's a diff of the
> changes I made on top of this patch (Assisted-by: LLM, fwiw). Feel free
> to use some, all or none of it. Thanks!
> 
> Brian

Hi Brian,

Thanks a lot for spending time on this, and for posting the diff. I
agree with most of it.

Lifting the default pstart/pend assignment to the top and turning the
early exits into plain returns removed the need for the no_split: /
split: labels and the tail_isolated boolean, which does make the
function easier to follow.

One thing I was wondering about: in your diff, when setting pend while
trying to split folio2, you completely dropped the use of folio2->index.
With folio2->index gone, an unaligned end means any failed split falls
back to folio->index. I assume that is mainly because its value is not
reliable under concurrency, which is exactly what sashiko pointed out.
However, it does mean we lose a bit of precision though, I mean the
sub-folios that were successfully split off at the pstart edge end up
left behind in the page cache. Please see a small example below.

> 
> --- 8< ---
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index d88a1b159084..8da16d7e6763 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -237,10 +237,16 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>  	else
>  		length = lend + 1 - pos - offset;
>  
> +	if (pstart)
> +		*pstart = offset ? folio_next_index(folio) : folio->index;
> +	if (pend)
> +		*pend = (pos + size > (u64)lend) ? folio->index :
> +						   folio_next_index(folio);
> +
>  	folio_wait_writeback(folio);
>  	if (length == size) {
>  		truncate_inode_folio(folio->mapping, folio);
> -		goto no_split;
> +		return false;
>  	}
>  
>  	/*
> @@ -254,7 +260,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>  	if (folio_needs_release(folio))
>  		folio_invalidate(folio, offset, length);
>  	if (!folio_test_large(folio))
> -		goto no_split;
> +		return false;
>  
>  	min_order = mapping_min_folio_order(folio->mapping);
>  	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
> @@ -266,29 +272,30 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> -		bool tail_isolated = true;
>  
> -		if (pend)
> -			*pend = round_down(pos + offset + length,
> +		if (pstart)
> +			*pstart = round_up(pos + offset,
>  					   min_nrbytes) >> PAGE_SHIFT;
>  
> -		if (offset + length == size)
> -			goto split;
> +		if (offset + length == size) {
> +			if (pend)
> +				*pend = round_down(pos + offset + length,
> +						   min_nrbytes) >> PAGE_SHIFT;
> +			return true;
> +		}
>  retry:
>  		split_at2 = folio_page(folio,
>  				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>  		folio2 = page_folio(split_at2);
>  
>  		if (!folio_try_get(folio2))
> -			goto split;
> +			return true;
>  
>  		if (!folio_test_large(folio2))
>  			goto out;
>  
> -		if (!folio_trylock(folio2)) {
> -			tail_isolated = false;
> +		if (!folio_trylock(folio2))
>  			goto out;
> -		}
>  
>  		/*
>  		 * split_at2 may no longer belong to folio2 due to concurrent
> @@ -304,28 +311,18 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>  		/* make sure folio2 is large and does not change its mapping */
>  		if (folio_test_large(folio2) &&
>  		    folio2->mapping == folio->mapping &&
> -		    folio_split_or_unmap(folio2, split_at2, min_order))
> -			tail_isolated = false;
> +		    !folio_split_or_unmap(folio2, split_at2, min_order) &&
> +		    pend)
> +			*pend = round_down(pos + offset + length,
> +					   min_nrbytes) >> PAGE_SHIFT;

[...]

Assume a 4-page order-2 folio [p0 p1 p2 p3], punched from offset 0 into
the middle of p3, with min_order == 0.:

   [p0 p1 p2 p3]  --1st split @p0-->  [p0] [p1] [p2-p3]
   folio now points to [p0]
   folio2 = [p2-p3]            # p2 zeroed, p3 tail valid
   2nd split of [p2-p3] fails  # folio_split_or_unmap() returns failure.
		
As a result, both pstart and pend are p0, so the sub-folios p0 and p1
are left behind.

I agree that under concurrency we really can't get a valid end position
since folio2 is not trustworthy(e,g., failed to get the folio2 or failed
to lock the folio2...). But once we have successfully got a reference to
and locked folio2, its index should be valid. So I've ended up with
something like the below (This hasn't been tested yet, just wanted to see
everyone's opinions), let me know what you and the other reviewers think.


diff --git a/mm/truncate.c b/mm/truncate.c
index d88a1b159084..b551e8253de7 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -237,10 +237,16 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 	else
 		length = lend + 1 - pos - offset;

+	if (pstart)
+		*pstart = offset ? folio_next_index(folio) : folio->index;
+	if (pend)
+		*pend = (pos + size > (u64)lend) ? folio->index :
+						   folio_next_index(folio);
+
 	folio_wait_writeback(folio);
 	if (length == size) {
 		truncate_inode_folio(folio->mapping, folio);
-		goto no_split;
+		return false;
 	}

 	/*
@@ -254,7 +260,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 	if (folio_needs_release(folio))
 		folio_invalidate(folio, offset, length);
 	if (!folio_test_large(folio))
-		goto no_split;
+		return false;

 	min_order = mapping_min_folio_order(folio->mapping);
 	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
@@ -266,66 +272,65 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
-		bool tail_isolated = true;
+		pgoff_t end, aligned_end = round_down(pos + offset + length,
+						min_nrbytes) >> PAGE_SHIFT;

-		if (pend)
-			*pend = round_down(pos + offset + length,
+		if (pstart)
+			*pstart = round_up(pos + offset,
 					   min_nrbytes) >> PAGE_SHIFT;

-		if (offset + length == size)
-			goto split;
-retry:
+		if (offset + length == size) {
+			end = aligned_end;
+			goto out;
+		}
+
 		split_at2 = folio_page(folio,
 				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
 		folio2 = page_folio(split_at2);

-		if (!folio_try_get(folio2))
-			goto split;
-
-		if (!folio_test_large(folio2))
-			goto out;
-
-		if (!folio_trylock(folio2)) {
-			tail_isolated = false;
-			goto out;
-		}
-
 		/*
-		 * split_at2 may no longer belong to folio2 due to concurrent
-		 * split. Retry to find the correct folio in case it's still
-		 * large.
+		 * folio2 may become stale due to a concurrent split or
+		 * freeing, so validate it before and after taking its lock.
+		 * If it fails, we can't get an accurate end position and fall
+		 * back to folio->index, which may leave sub-folios split off
+		 * at the offset edge in the page cache this round.
 		 */
+		end = folio->index;
+		if (!folio_try_get(folio2))
+			goto out;
+		if (folio2->mapping != folio->mapping ||
+		    !folio_test_large(folio2))
+			goto out_put;
+
+		if (!folio_trylock(folio2))
+			goto out_put;
+
 		if (page_folio(split_at2) != folio2) {
 			folio_unlock(folio2);
-			folio_put(folio2);
-			goto retry;
+			goto out_put;
+		}
+		if (!folio_test_large(folio2)) {
+			end = aligned_end;
+			folio_unlock(folio2);
+			goto out_put;
 		}

-		/* make sure folio2 is large and does not change its mapping */
-		if (folio_test_large(folio2) &&
-		    folio2->mapping == folio->mapping &&
-		    folio_split_or_unmap(folio2, split_at2, min_order))
-			tail_isolated = false;
+		/* Split failed: back off to the head of the straddler */
+		if (folio_split_or_unmap(folio2, split_at2, min_order))
+			end = folio2->index;
+		else
+			end = aligned_end;

 		folio_unlock(folio2);
-out:
-		if (!tail_isolated && pend)
-			*pend = folio2->index;
+out_put:
 		folio_put(folio2);
-split:
-		if (pstart)
-			*pstart = round_up(pos + offset,
-					   min_nrbytes) >> PAGE_SHIFT;
+out:
+		if (pend)
+			*pend = end;
 		return true;
 	}
 	if (!folio_test_dirty(folio))
 		truncate_inode_folio(folio->mapping, folio);
-no_split:
-	if (pstart)
-		*pstart = offset ? folio_next_index(folio) : folio->index;
-	if (pend)
-		*pend = (pos + size > (u64)lend) ? folio->index :
-						   folio_next_index(folio);
 	return false;
 }


