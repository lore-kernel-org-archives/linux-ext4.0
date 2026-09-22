Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113224DDB5F;
	Tue, 22 Sep 2026 11:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077484; cv=none; b=HiGHxsD3937fS/7BA6AQ4rYshHZeXLwE2N9u/1pRAHmftX21TjrQrcxw+6ld/gFGadLOQxL2zAsO9Acm5B+G+mPBhA6MbojyHwftWjcwj2njmKD7tQ9nzCCmiz8WcDBcIAWv+/ePZPHTuMXWMw5jM0AFAwm77NbtHplb6ZwnO1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077484; c=relaxed/simple;
	bh=O/XSITxHoUbyjKlTa2/IUxWS7aOf+sWaUj/tADuRiQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xm7Vcrv39DHV3F6MHvRsFaJ4viSnihEZua6gqY+ci79cw0OS9Tavn/gJkh1iUmFRXAICNmshGWpEJtzWDgU/Qg9yqN/fW2CaosFQr322neMOxRxoffillVcTn2PpvSbAgQkGrNDiktWm2p8CLpblswf9y0xqbXsKLc2xyyKhkyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0KvwR/zJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rse08GEl; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=N+6wpHNp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wvSD5AkE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0KvwR/zJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rse08GEl";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="N+6wpHNp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wvSD5AkE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8360A1FA79;
	Tue, 22 Sep 2026 11:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790077475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K0R7PnUXEmLCmdT6soybArzdlBxzCLCA04LCMbneRVU=;
	b=0KvwR/zJAkVY2wLuya/6CuBx44T0B02iD/0E00u+UZydyHqb2erv2xZpTb1Oitzx+bp5Zz
	9b8WQSdsdlsCmG+ev0u/UX14wM7f5ZUqEpZdST/EAMhAG06yYshBfHM3yg14MmH+G8fLni
	5g8uqdi7IXEUmM5ubzHq2yyOMWXaeXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790077475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K0R7PnUXEmLCmdT6soybArzdlBxzCLCA04LCMbneRVU=;
	b=rse08GElL5BaXVAIowIfuwddQ9yBSqFutHNPr5skps+4fzxdPIBEo1oaFbjk180vjzpz0E
	KftmCweL/KYzXjBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790077471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K0R7PnUXEmLCmdT6soybArzdlBxzCLCA04LCMbneRVU=;
	b=N+6wpHNpOZvsAgExlPvxgZtE1wMCNZutPvCH09HF72pHcbb6oRWQith4MFS1QPEEQNp4LC
	zqYQNzAyGB7OYN48N/wnVCGqYpfqwwmHGf4uolB7eulQk1tbrF2778ISgjFzKMcau0puUY
	x3WQI0Lq8gdmLPf/UR4oIZ32dXNKt08=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790077471;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K0R7PnUXEmLCmdT6soybArzdlBxzCLCA04LCMbneRVU=;
	b=wvSD5AkEmeuwXIc4MZPGvw7WjS6xMginNNGOZSbWfv88TUqA478zxVZceaZ8k3ODKAjD78
	aI+Txp2kIDnZqBAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 58BA3132D3;
	Tue, 22 Sep 2026 11:44:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U9e+CR9qsmobfwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Sep 2026 11:44:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C5E28A13D4; Tue, 22 Sep 2026 13:44:30 +0200 (CEST)
Date: Tue, 22 Sep 2026 13:44:30 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hughd@google.com, 
	baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz, ziy@nvidia.com, 
	bfoster@redhat.com, joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com, 
	yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 3/4] mm/truncate: fix data loss when splitting
 straddling large folios fails
Message-ID: <drxn6o73fsd63tgfdisdgcshc4bixwycfqiztfkhfb3yuu5imx@7mqkn7opeyxc>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-4-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922110703.468389-4-yi.zhang@huaweicloud.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kvack.org,vger.kernel.org,linux-foundation.org,kernel.org,infradead.org,google.com,suse.com,linux.alibaba.com,suse.cz,nvidia.com,redhat.com,gmail.com,huawei.com,fnnas.com];
	R_RATELIMIT(0.00)[to_ip_from(RLh65wkrmjx1yjc7agkshaaime)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,huawei.com:email]
X-Spam-Flag: NO

On Tue 22-09-26 19:07:02, Zhang Yi wrote:
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
> filemap_release_folio() fails on a dirty folio and folio_split() aborts
> with -EBUSY before any split, leaving the straddler safely unsplit. The
> bug is only reachable on paths that produce dirty large folios without
> filesystem private data, and it was caught on the upcoming ext4 iomap
> buffered I/O path when no ifs is attached.
> 
> Rework the contract so the caller is told the folio range to discard:
> 
>   - Add pgoff_t *pstart and *pend out-parameters that receive the folio
>     range fully covered by [lstart, lend] after any split (or none),
>     aligned inwards to min_order, i.e. the folios wholly within the
>     range and safe to discard.
> 
>   - Report a reliable end position to the caller. The straddler is
>     looked up at an index aligned inwards to the mapping minimum folio
>     order, and *pend is set to that boundary on success. If nothing
>     covers the boundary, discarding up to it stays safe. If the
>     straddler is locked by someone else, fall back to folio->index.
>     This best-effort fallback may leave the in-range sub-folios to a
>     later pass but never discards the out-of-range tail. If the
>     straddler cannot be split, fall back to folio2->index so the caller
>     keeps the out-of-range tail.
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

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/internal.h |  4 +--
>  mm/shmem.c    | 13 +++-----
>  mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
>  3 files changed, 68 insertions(+), 37 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c9..3278a5e360e3 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -624,8 +624,8 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
>  unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
>  		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
>  int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
> -		loff_t end);
> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
> +		loff_t lend, pgoff_t *pstart, pgoff_t *pend);
>  long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
>  unsigned long mapping_try_invalidate(struct address_space *mapping,
>  		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 897fa2b61346..30e7df7d7309 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1176,11 +1176,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  	if (folio) {
>  		same_folio = lend < folio_next_pos(folio);
>  		folio_mark_dirty(folio);
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
> @@ -1190,8 +1187,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
>  	if (folio) {
>  		folio_mark_dirty(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend))
> -			end = folio->index;
> +		truncate_inode_partial_folio(folio, lstart, lend, NULL, &end);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  	}
> @@ -1259,7 +1255,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  
>  				if (!folio_test_large(folio)) {
>  					truncate_inode_folio(mapping, folio);
> -				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
> +				} else if (truncate_inode_partial_folio(folio,
> +						lstart, lend, NULL, NULL)) {
>  					/*
>  					 * If we split a page, reset the loop so
>  					 * that we pick up the new sub pages.
> diff --git a/mm/truncate.c b/mm/truncate.c
> index a8a179b38252..81fb4de6226b 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -206,30 +206,43 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
>  /*
>   * Handle partial folios.  The folio may be entirely within the
>   * range if a split has raced with us.  If not, we zero the part of the
> - * folio that's within the [start, end] range, and then split the folio if
> + * folio that's within the [lstart, lend] range, and then split the folio if
>   * it's large.  split_page_range() will discard pages which now lie beyond
>   * i_size, and we rely on the caller to discard pages which lie within a
>   * newly created hole.
>   *
> + * When @pstart and/or @pend are non-NULL they receive the indexes of the
> + * folio range fully covered by [lstart, lend] after any split (or none),
> + * aligned inwards to min_order, i.e. the range of folios wholly within
> + * [lstart, lend] and so safe to discard.
> + *
>   * Returns false if splitting failed so the caller can avoid
>   * discarding the entire folio which is stubbornly unsplit.
>   */
> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
> +				  loff_t lend, pgoff_t *pstart, pgoff_t *pend)
>  {
>  	loff_t pos = folio_pos(folio);
>  	size_t size = folio_size(folio);
>  	unsigned int offset, length;
>  	struct page *split_at, *split_at2;
> +	unsigned long min_nrbytes;
>  	unsigned int min_order;
>  
> -	if (pos < start)
> -		offset = start - pos;
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
> +
> +	if (pstart)
> +		*pstart = offset ? folio_next_index(folio) : folio->index;
> +	if (pend)
> +		*pend = (pos + size > (u64)lend) ? folio->index :
> +						   folio_next_index(folio);
>  
>  	folio_wait_writeback(folio);
>  	if (length == size) {
> @@ -251,6 +264,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		return true;
>  
>  	min_order = mapping_min_folio_order(folio->mapping);
> +	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
>  	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
>  	if (!folio_split_or_unmap(folio, split_at, min_order)) {
>  		/*
> @@ -259,34 +273,57 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> -		pgoff_t end_idx;
> +		pgoff_t end, aligned_end = round_down(pos + offset + length,
> +						min_nrbytes) >> PAGE_SHIFT;
>  
> +		if (pstart)
> +			*pstart = round_up(pos + offset,
> +					   min_nrbytes) >> PAGE_SHIFT;
> +
> +		end = aligned_end;
>  		if (offset + length == size)
> -			goto no_split;
> +			goto out;
>  
>  		/*
>  		 * After the first split at the start edge, the folio at the
>  		 * end edge may be freed and reused concurrently.
> -		 * __filemap_get_folio() looks up the straddler at end_idx
> +		 * __filemap_get_folio() looks up the straddler at aligned_end
>  		 * and returns it locked and ref'd with the mapping
>  		 * validated.
>  		 */
> -		end_idx = (pos + offset + length) >> PAGE_SHIFT;
> -		folio2 = __filemap_get_folio(folio->mapping, end_idx,
> +		folio2 = __filemap_get_folio(folio->mapping, aligned_end,
>  					     FGP_LOCK | FGP_NOWAIT, 0);
> -		if (IS_ERR(folio2))
> -			goto no_split;
> -
> -		/* make sure folio2 is large */
> -		if (!folio_test_large(folio2))
> +		if (IS_ERR(folio2)) {
> +			/*
> +			 * No sub-folio straddles the boundary when
> +			 * aligned_end is empty, so discarding up to it is
> +			 * safe.  Otherwise the straddler is locked by
> +			 * someone else and we cannot obtain a reliable end
> +			 * position, so we fall back to folio->index, which
> +			 * is safe but leaves the sub-folios split off at
> +			 * the offset edge in the page cache.
> +			 */
> +			if (PTR_ERR(folio2) != -ENOENT)
> +				end = folio->index;
>  			goto out;
> +		}
>  
> -		split_at2 = folio_page(folio2, (end_idx - folio2->index));
> -		folio_split_or_unmap(folio2, split_at2, min_order);
> -out:
> +		/* Already at the minimum order, nothing to split */
> +		if (folio_order(folio2) == min_order)
> +			goto out_put;
> +
> +		split_at2 = folio_page(folio2, (aligned_end - folio2->index));
> +
> +		/* Split failed, keep the straddler intact */
> +		if (folio_split_or_unmap(folio2, split_at2, min_order))
> +			end = folio2->index;
> +
> +out_put:
>  		folio_unlock(folio2);
>  		folio_put(folio2);
> -no_split:
> +out:
> +		if (pend)
> +			*pend = end;
>  		return true;
>  	}
>  	if (folio_test_dirty(folio))
> @@ -421,11 +458,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
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
> @@ -435,8 +469,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
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
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
