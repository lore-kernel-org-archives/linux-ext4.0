Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC3F3CF210;
	Fri,  4 Sep 2026 09:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512779; cv=none; b=UuRGCSQhqZvUkWBRVoTbM3XIUUtcKmyeCfYSD3pEKPgCriRqjYO+4gb5IVIo2nyQK9xiXvBCMmTpHmQ5oSSBuPAzN4aWnyN9/zC+M+hCnFwnmVsQvwn+VsnwbKMsMVjR/gpeGL8hbMN+KUgSuXUyizwzr61oa84ZtbjHTxGb4oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512779; c=relaxed/simple;
	bh=A8n1t92O52Zei/+D2Yv2OMQa5XY9nbyL8g0LM4boQGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cTl1cQLBTV5lC3l4L+vRUB1zrfQQz5vxlxYPyvgdiLeFEHDv43/HitzrjKKUmM8bm0e2q+/hclbpk0cC77nXJdnuXIfWiswdphARgdpSJX/4lIpQg6afaP0A1Ue+Ho3ASadMAr3hYxF3+tY8LfKDX3yjDr+Xk+srX0Ds2ZOdbr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbrCP6Qx6zYQv7b;
	Fri,  4 Sep 2026 17:05:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 3A35E40574;
	Fri,  4 Sep 2026 17:06:06 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3Hgn7iZpqJIHUAg--.46109S3;
	Fri, 04 Sep 2026 17:06:05 +0800 (CST)
Message-ID: <5e9a4d7f-7197-441b-9492-61c7b7e8943d@huaweicloud.com>
Date: Fri, 4 Sep 2026 17:06:03 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-ext4@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hughd@google.com,
 baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
 ziy@nvidia.com, bfoster@redhat.com, djwong@kernel.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com,
 wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgA3Hgn7iZpqJIHUAg--.46109S3
X-Coremail-Antispam: 1UD129KBjvAXoWfJFyUuw4fGFWxCr13KFWfXwb_yoW8JrW7Wo
	WfJws0vF1FqrWkta1UAF97JFykX3Z09ryfJF13ur4qvF42q34DAw4UJw1DGan5Zr1qkFn8
	G347J3WSyrZrJr13n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUY77kC6x804xWl14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/3/2026 7:50 PM, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
> 
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
> 
> For example, a 4-page order-2 folio punched from offset 0 to the middle
> of the last page:
> 
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()      # same_folio == true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end = 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
> 
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
> 
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.
> 
> Rework the contract so the caller is told where to stop instead of
> silently truncating the straddler:
> 
>   - Return true only when a split occurred, false otherwise. This
>     clarifies the existing confusing return value semantics.
> 
>   - Add an optional out-parameter pgoff_t *end, set to the index of the
>     folio that contains @lend and must be kept by the caller's loop. It
>     is only written when the folio actually straddles @lend. On the
>     success path it defaults to the page index of the end edge and is
>     refined to folio2->index when the second split fails to isolate the
>     tail.
> 
>   - Rename the byte-range parameters start/end to lstart/lend to avoid
>     clashing with the new @end output and to separate byte offsets from
>     folio indices.
> 
> Callers in truncate_inode_pages_range() and shmem_undo_range() pass &end
> only when the folio straddles lend. After all, no caller discards a
> straddling folio anymore, the in-range cleanly-split sub-folios below it
> are still dropped.
> 
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/internal.h |  4 ++--
>  mm/shmem.c    | 12 +++++------
>  mm/truncate.c | 57 ++++++++++++++++++++++++++++++---------------------
>  3 files changed, 41 insertions(+), 32 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 68db5abd0a4c..db7d9d9fb5c9 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -627,8 +627,8 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
>  unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
>  		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
>  int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
> -		loff_t end);
> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
> +		loff_t lend, pgoff_t *end);
>  long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
>  unsigned long mapping_try_invalidate(struct address_space *mapping,
>  		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 89a1495e55f7..cc1548ff509a 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1175,11 +1175,9 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  	if (folio) {
>  		same_folio = lend < folio_next_pos(folio);
>  		folio_mark_dirty(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
> +		if (!truncate_inode_partial_folio(folio, lstart, lend,
> +						  same_folio ? &end : NULL))
>  			start = folio_next_index(folio);
> -			if (same_folio)
> -				end = folio->index;
> -		}
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		folio = NULL;
> @@ -1189,8 +1187,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
>  	if (folio) {
>  		folio_mark_dirty(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend))
> -			end = folio->index;
> +		truncate_inode_partial_folio(folio, lstart, lend, &end);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  	}
> @@ -1258,7 +1255,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  
>  				if (!folio_test_large(folio)) {
>  					truncate_inode_folio(mapping, folio);
> -				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
> +				} else if (truncate_inode_partial_folio(folio,
> +							lstart, lend, NULL)) {
>  					/*
>  					 * If we split a page, reset the loop so
>  					 * that we pick up the new sub pages.
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..2ebb00f6c379 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -206,15 +206,18 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
>  /*
>   * Handle partial folios.  The folio may be entirely within the
>   * range if a split has raced with us.  If not, we zero the part of the
> - * folio that's within the [start, end] range, and then split the folio if
> + * folio that's within the [lstart, lend] range, and then split the folio if
>   * it's large.  split_page_range() will discard pages which now lie beyond
>   * i_size, and we rely on the caller to discard pages which lie within a
>   * newly created hole.
>   *
> - * Returns false if splitting failed so the caller can avoid
> - * discarding the entire folio which is stubbornly unsplit.
> + * When @end non-NULL, set to the index of the folio that contains @lend
> + * and must be kept by the caller's truncate loop.  Return %true if the
> + * folio was split, %false otherwise, in which case the folio is dropped or
> + * may still straddle the range, so the caller must not discard it.
>   */
> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
> +				  loff_t lend, pgoff_t *end)
>  {
>  	loff_t pos = folio_pos(folio);
>  	size_t size = folio_size(folio);
> @@ -222,19 +225,22 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  	struct page *split_at, *split_at2;
>  	unsigned int min_order;
>  
> -	if (pos < start)
> -		offset = start - pos;
> +	if (end && pos + size > (u64)lend)
> +		*end = folio->index;
> +
> +	if (pos < lstart)
> +		offset = lstart - pos;
>  	else
>  		offset = 0;
> -	if (pos + size <= (u64)end)
> +	if (pos + size <= (u64)lend)
>  		length = size - offset;
>  	else
> -		length = end + 1 - pos - offset;
> +		length = lend + 1 - pos - offset;
>  
>  	folio_wait_writeback(folio);
>  	if (length == size) {
>  		truncate_inode_folio(folio->mapping, folio);
> -		return true;
> +		return false;
>  	}
>  
>  	/*
> @@ -248,7 +254,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  	if (folio_needs_release(folio))
>  		folio_invalidate(folio, offset, length);
>  	if (!folio_test_large(folio))
> -		return true;
> +		return false;
>  
>  	min_order = mapping_min_folio_order(folio->mapping);
>  	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
> @@ -259,6 +265,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> +		bool tail_isolated = true;
> +
> +		if (end)
> +			*end = (pos + offset + length) >> PAGE_SHIFT;
>  
>  		if (offset + length == size)
>  			goto no_split;
> @@ -273,24 +283,28 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		if (!folio_test_large(folio2))
>  			goto out;
>  
> -		if (!folio_trylock(folio2))
> +		if (!folio_trylock(folio2)) {
> +			tail_isolated = false;
>  			goto out;
> +		}
>  
>  		/* make sure folio2 is large and does not change its mapping */
>  		if (folio_test_large(folio2) &&
> -		    folio2->mapping == folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> +		    folio2->mapping == folio->mapping &&
> +		    folio_split_or_unmap(folio2, split_at2, min_order))
> +			tail_isolated = false;

Sashiko pointed out:

> [Severity: High]
> Does this code have a TOCTOU race that could lead to an out-of-bounds page
> split?
>
> In truncate_inode_partial_folio() in mm/truncate.c, a speculative folio
> lookup occurs just prior to this block:
>
> 	split_at2 = folio_page(folio,
> 			PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
> 	folio2 = page_folio(split_at2);
>
> 	if (!folio_try_get(folio2))
> 		goto no_split;
>
> Without a re-validation check after folio_try_get(), couldn't a concurrent
> operation (like memory reclaim or shmem readahead reallocation) change the
> compound structure of folio2?
>
> If the compound structure changes, a thread could successfully take a
> reference on the new, smaller folio2. However, split_at2 would now be
> outside the bounds of this new folio2.
>
> When folio2 is later passed into folio_split_or_unmap() in the modified
> code above, would this out-of-bounds split_at2 cause a kernel panic via
> VM_BUG_ON_FOLIO() inside folio_split(), or corrupt adjacent page structures
> if debug is disabled?
>
> Should there be a check like if (unlikely(page_folio(split_at2) != folio2))
> added after folio_try_get() to stabilize the reference?

I think this is right. This is a pre-existing issue in the current code.
There is a TOCTOU window between page_folio() and folio_try_get(). A
concurrent split could change folio2's compound structure, making
split_at2 point outside the new folio2's bounds. This would cause an
out-of-bounds split when we later call folio_split_or_unmap().

However, folio_try_get() alone isn't sufficient to close this window. We
need to re-validate after acquiring folio2's lock, since I think the
folio could still be split between folio_try_get() and folio_trylock().

I can send a separate fix patch to address this issue prior to this one.

Thanks,
Yi.

>  
>  		folio_unlock(folio2);
>  out:
> +		if (!tail_isolated && end)
> +			*end = folio2->index;
>  		folio_put(folio2);
>  no_split:
>  		return true;
>  	}
> -	if (folio_test_dirty(folio))
> -		return false;
> -	truncate_inode_folio(folio->mapping, folio);
> -	return true;
> +	if (!folio_test_dirty(folio))
> +		truncate_inode_folio(folio->mapping, folio);
> +	return false;
>  }
>  
>  /*
> @@ -413,11 +427,9 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
>  	if (!IS_ERR(folio)) {
>  		same_folio = lend < folio_next_pos(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
> +		if (!truncate_inode_partial_folio(folio, lstart, lend,
> +						  same_folio ? &end : NULL))
>  			start = folio_next_index(folio);
> -			if (same_folio)
> -				end = folio->index;
> -		}
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		folio = NULL;
> @@ -427,8 +439,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
>  						FGP_LOCK, 0);
>  		if (!IS_ERR(folio)) {
> -			if (!truncate_inode_partial_folio(folio, lstart, lend))
> -				end = folio->index;
> +			truncate_inode_partial_folio(folio, lstart, lend, &end);
>  			folio_unlock(folio);
>  			folio_put(folio);
>  		}

