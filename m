Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C79495AF8
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 17:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789580344; cv=none; b=CoQDYl7sqOCOSdcS89tqHqdjgrNT2VSvPhTjpamqHKXjqMGA7qNX1cb04I+NmpW/hL0AluRXX+9J7/eaMWtPauiuZLYZWh2LKffth9aH4rKFPCiZXD5VUDwG2MTT+e/eR5lQH/PLLk9Z9tj/xCdHib7M/s3xksq3vZl2tcBsSi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789580344; c=relaxed/simple;
	bh=t6HIyMUbz0E+eEqvpBo6BTSjlXKQbldSOqUj/2OSVU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1zYLlta09NJm9S9sCWq5lB1afH19C42gbd0s1Tf1mnl811N4NifsW/uyBVofAmfKkAs6TdCWK8GvXdFndHRf0SfPJ8zGgARcmqrBmNRRCEYx2gOylLbUlLPeVjHzy/w//pacEveiPN7HAm402yhn9cyh0P0NI8XkX/Dd0EH2mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X4BufaVm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4BufaVm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789580328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cmdjUNL1XY7zBDucnHHtvP/PymRScu1lUWAizmkODYI=;
	b=X4BufaVmFqhZw567ZHFqDRNk/0ruOj+1BrfVSSpe1+TmeOygt6tcfJtM8IZDhTVRsPlXOl
	B+4yybX/sFXhuXswLADA5CIRmnYWh+FL0l7vtSIhtimQ5k8Y0qNJjJJdUqdjcSQdCfWV1l
	N5K4lZstDhAQ2m9J8zklqGtdECX/5YM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-AEY05fytPNudNZBo7klhJg-1; Wed,
 16 Sep 2026 13:38:44 -0400
X-MC-Unique: AEY05fytPNudNZBo7klhJg-1
X-Mimecast-MFC-AGG-ID: AEY05fytPNudNZBo7klhJg_1789580321
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 817AA195422C;
	Wed, 16 Sep 2026 17:38:40 +0000 (UTC)
Received: from bfoster (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83CE21956087;
	Wed, 16 Sep 2026 17:38:35 +0000 (UTC)
Date: Wed, 16 Sep 2026 13:38:33 -0400
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
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
Message-ID: <aqrUGRd0JClEZNzN@bfoster>
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916092450.654408-2-yi.zhang@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Sep 16, 2026 at 05:24:48PM +0800, Zhang Yi wrote:
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
> Rework the contract so the caller is told the page range to discard:
> 
>   - Add pgoff_t *pstart and *pend out-parameters that receive the page
>     range fully covered by [lstart, lend] after any split (or none),
>     i.e. the pages wholly within the range and safe to discard.
> 
>   - Adjust the ordering of the validate check when splitting folio2.
>     folio2->index is only reliable after the reference count and lock
>     have been successfully acquired, since it may have been split
>     concurrently, or freed and recycled to an unrelated mapping. On any
>     failure to obtain a reliable end position, fall back to
>     folio->index, which is safe but leaves the sub-folios split off at
>     the offset edge in the page cache.
> 
>   - Rename the byte-range parameters start/end to lstart/lend to better
>     express their semantics.
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
>  mm/internal.h |  4 +--
>  mm/shmem.c    | 13 +++-----
>  mm/truncate.c | 89 ++++++++++++++++++++++++++++++++++++---------------
>  3 files changed, 71 insertions(+), 35 deletions(-)
> 
...
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..bec6d881d022 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
...
> @@ -259,32 +271,62 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> +		pgoff_t end, aligned_end = (pos + offset + length) >>
> +					   PAGE_SHIFT;
>  
> -		if (offset + length == size)
> -			goto no_split;
> +		if (pstart)
> +			*pstart = round_up(pos + offset, PAGE_SIZE) >>
> +				  PAGE_SHIFT;
> +
> +		if (offset + length == size) {
> +			end = aligned_end;
> +			goto out;
> +		}
>  
>  		split_at2 = folio_page(folio,
>  				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>  		folio2 = page_folio(split_at2);
>  
> +		/*
> +		 * folio2 may become stale due to a concurrent split or
> +		 * freeing, so validate it before and after taking its lock.
> +		 * If it fails, we can't get an accurate end position and fall
> +		 * back to folio->index, which may leave sub-folios split off
> +		 * at the offset edge in the page cache this round.
> +		 */
> +		end = folio->index;
>  		if (!folio_try_get(folio2))
> -			goto no_split;
> -
> -		if (!folio_test_large(folio2))
>  			goto out;
>  
> +		if (folio2->mapping != folio->mapping ||
> +		    !folio_test_large(folio2))
> +			goto out_put;
> +

Hi Zhang,

The only thing that sticks out to me in this version is the
!folio_test_large() check above. If we split (or something happens) such
that folio2 is no longer large, wouldn't it be more likely to catch it
here and fail to update end like we do in the same check a bit further
down after the folio lock? Maybe I'm missing something here, but it
seems a little odd for the same condition to return two possible states
like this. Otherwise I like the changes you've made and the rest of the
patch LGTM.

Brian

>  		if (!folio_trylock(folio2))
> -			goto out;
> +			goto out_put;
>  
> -		/* make sure folio2 is large and does not change its mapping */
> -		if (folio_test_large(folio2) &&
> -		    folio2->mapping == folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> +		if (page_folio(split_at2) != folio2) {
> +			folio_unlock(folio2);
> +			goto out_put;
> +		}
> +		if (!folio_test_large(folio2)) {
> +			end = aligned_end;
> +			folio_unlock(folio2);
> +			goto out_put;
> +		}
> +
> +		/* Split failed: back off to the head of the straddler */
> +		if (folio_split_or_unmap(folio2, split_at2, min_order))
> +			end = folio2->index;
> +		else
> +			end = aligned_end;
>  
>  		folio_unlock(folio2);
> -out:
> +out_put:
>  		folio_put(folio2);
> -no_split:
> +out:
> +		if (pend)
> +			*pend = end;
>  		return true;
>  	}
>  	if (folio_test_dirty(folio))
> @@ -413,11 +455,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
>  	if (!IS_ERR(folio)) {
>  		same_folio = lend < folio_next_pos(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
> -			start = folio_next_index(folio);
> -			if (same_folio)
> -				end = folio->index;
> -		}
> +		truncate_inode_partial_folio(folio, lstart, lend, &start,
> +					     same_folio ? &end : NULL);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		folio = NULL;
> @@ -427,8 +466,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
>  						FGP_LOCK, 0);
>  		if (!IS_ERR(folio)) {
> -			if (!truncate_inode_partial_folio(folio, lstart, lend))
> -				end = folio->index;
> +			truncate_inode_partial_folio(folio, lstart, lend,
> +						     NULL, &end);
>  			folio_unlock(folio);
>  			folio_put(folio);
>  		}
> -- 
> 2.52.0
> 

