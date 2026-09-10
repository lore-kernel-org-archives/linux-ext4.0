Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42914825CF
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789057631; cv=none; b=Kd9auqdTQZXMpXC+BLq31/kjduR/Sa0tmG50o6VpvKvPQgfzfBpgge34YdSfRH0LNp6xzXZfrpoXQ1SERncMUnbiCuldShi51gWtfXOLyZWgJBkQvFENjkxJF+2qNRTw9pQnuysxjFNvnWOUwAz2XqdBDQbSqtBTgiGho07dGts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789057631; c=relaxed/simple;
	bh=OR/0aL75NB6kFfjOqwZgJyYvWo9KOsGN/WkMJwy+cPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjfT+sjT0VvmYFirBycY/34/b9tZCjgs9kVeHSuXWBblegosRHCSLIoE0xo6RJX+zySvsf6/WuxcBjsaE/laXwWpyWcB9ZvOFTRf5OS/lKBfezWapNwI3UHUl+QnQB148VbxxmpoZP2PYp8lhSLjMaRrIyA/Ys4KiDKOwJN8qdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ECADnA+H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ECADnA+H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789057619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1puZjxs3lQ0OZGjrziHtT77SfFjdKoASATdow4jmCoE=;
	b=ECADnA+H4QVjfOKqlQnSO8crCZCqJQvg7A8XyLnpNjtracjWHcjWugFqqQ0TAPh3QDz/WU
	PBlxSU5nVSTxBiuw1p60Vx0f0eOAO287bTuTzkMUVXMPyu0q9b5HGI/GymMHnQphIBrHR6
	uXAHU/0y4jeXDARVsGhJbBaYj1WZ4xA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-212-KUPKdFIrNTa6Fvcwg-c9oA-1; Thu,
 10 Sep 2026 12:26:55 -0400
X-MC-Unique: KUPKdFIrNTa6Fvcwg-c9oA-1
X-Mimecast-MFC-AGG-ID: KUPKdFIrNTa6Fvcwg-c9oA_1789057610
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 433171955E7A;
	Thu, 10 Sep 2026 16:26:49 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1D101800351;
	Thu, 10 Sep 2026 16:26:43 +0000 (UTC)
Date: Thu, 10 Sep 2026 12:26:41 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, hughd@google.com,
	baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
	ziy@nvidia.com, joannelkoong@gmail.com, djwong@kernel.org,
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
	chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating straddling
 large folios
Message-ID: <aqLaQcZvaFIrAz0e@bfoster>
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Sep 09, 2026 at 02:23:39PM +0800, Zhang Yi wrote:
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
> In addition, even when both splits succeed, data can still be lost when
> the mapping's minimum folio order (min_order) is non-zero. folio_split()
> stops at min_order instead of order 0, so the sub-folio containing a
> split point stays aligned to 1 << min_order rather than to a page. The
> original success path left start at the page-aligned head of the range
> and set end to the exact page index of the end edge, neither of which is
> a folio boundary in general. Either one could land inside the large
> folio at its edge, and the truncate loop would drop that straddling
> folio together with its valid out-of-range tail.
> 
> For example, a 64K (order-4) folio with min_order = 2 punched from
> offset 0 to 36K:
> 
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()        # same_folio == true
>       1st split at p0 -> [p0-p3, p4-p7, p8-p15]  # non-uniform, min_order
>       folio2 = p8-p15 # straddles: p8 in range, p9-p15 tail valid
>       2nd split of folio2 -> [p8-p11, p12-p15]   # success
>       end = p9                           # BUG: p9 inside [p8-p11]
>     loop truncates ... p8-p11           # p9-p11's valid tail is lost
> 
> Rework the contract so the caller is told the page range to discard:
> 
>   - Return true only when a split occurred, false otherwise. This
>     clarifies the existing confusing return value semantics.
> 
>   - Add pgoff_t *pstart and *pend out-parameters that receive the page
>     range fully covered by [lstart, lend] after any split (or none),
>     i.e. the pages wholly within the range and safe to discard. They are
>     aligned up (pstart) and down (pend) to the mapping's minimum folio
>     order so they always fall on a folio boundary.
> 
>   - Rename the byte-range parameters start/end to lstart/lend to avoid
>     clashing with the new outputs and to separate byte offsets from
>     folio indices.
> 
> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
> &pstart for the folio at the start edge and &pend for the folio at the
> end edge, so the truncate loop drops exactly the fully covered pages and
> never touches a straddling folio that still holds valid out-of-range
> data.
> 
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
> v1->v2:
>  - Export pstart as a new parameter so that the generic and shmem
>    truncate paths don't need to recompute the start value from the
>    return value. (Brian)
>  - When min_order is nonzero, align [pstart, pend] to the inner
>    boundaries of the folio to ensure they do not point into the middle
>    of a large folio, which could otherwise cause valid data within the
>    folio to be incorrectly cleared. (Joanne)
> 
> v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/
> 

Hi Zhang,

Thanks for the tweaks. I still found some of the logic circuitous as I
read through it so I spent some time playing with this just to
experiment with cleaning it up a bit. I ended up removing a couple of
the labels, lifting the pstart/pend assignment to a default init/case,
and reshuffling the split case pstart/pend assignments in a way that I
think also elides the need for the boolean or using folio2. (I'm curious
if this happens to address the Sashiko feedback as well..?)

Note that this is completely untested and needs further review. Since
the current patch looked mostly Ok to me functionally (though I do agree
with the comment about possibly splitting up into smaller changes) and
has other reviews, I'm just posting this as an FYI. Here's a diff of the
changes I made on top of this patch (Assisted-by: LLM, fwiw). Feel free
to use some, all or none of it. Thanks!

Brian

--- 8< ---

diff --git a/mm/truncate.c b/mm/truncate.c
index d88a1b159084..8da16d7e6763 100644
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
@@ -266,29 +272,30 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
-		bool tail_isolated = true;
 
-		if (pend)
-			*pend = round_down(pos + offset + length,
+		if (pstart)
+			*pstart = round_up(pos + offset,
 					   min_nrbytes) >> PAGE_SHIFT;
 
-		if (offset + length == size)
-			goto split;
+		if (offset + length == size) {
+			if (pend)
+				*pend = round_down(pos + offset + length,
+						   min_nrbytes) >> PAGE_SHIFT;
+			return true;
+		}
 retry:
 		split_at2 = folio_page(folio,
 				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
 		folio2 = page_folio(split_at2);
 
 		if (!folio_try_get(folio2))
-			goto split;
+			return true;
 
 		if (!folio_test_large(folio2))
 			goto out;
 
-		if (!folio_trylock(folio2)) {
-			tail_isolated = false;
+		if (!folio_trylock(folio2))
 			goto out;
-		}
 
 		/*
 		 * split_at2 may no longer belong to folio2 due to concurrent
@@ -304,28 +311,18 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping &&
-		    folio_split_or_unmap(folio2, split_at2, min_order))
-			tail_isolated = false;
+		    !folio_split_or_unmap(folio2, split_at2, min_order) &&
+		    pend)
+			*pend = round_down(pos + offset + length,
+					   min_nrbytes) >> PAGE_SHIFT;
 
 		folio_unlock(folio2);
 out:
-		if (!tail_isolated && pend)
-			*pend = folio2->index;
 		folio_put(folio2);
-split:
-		if (pstart)
-			*pstart = round_up(pos + offset,
-					   min_nrbytes) >> PAGE_SHIFT;
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

