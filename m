Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431132D0C9D;
	Wed,  9 Sep 2026 12:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788956582; cv=none; b=mD5+AnQPkBQv0KuFaGVQYpnV1y0v2jT6lbhzmEtUrNjPG7sj3Swsf4lE0CfU1ts5vUEtB5DPObD0EByORPEXjagqSIRfsvDEJKOXc7DKNEdcyFYxZCvwTMM0Id/BFD4FoQEr1WsUgxI0j27+vZpfetzIWjgORNenBkC8ypShoTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788956582; c=relaxed/simple;
	bh=awAM1LLxjahXIQF8tz6AN6uDdylj0mNprVj8g2xJGrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hi/D4wrKmrS8bj4GL4vGnhHF9TB71BC6uIaZFrr6H6miuKl9+/xxFslt8DCD2njD5RyEAt25XQL8v8D4V1YgsJcQUG0kERzIrdZp/7sYdYg5fAA+xghrbFL8c1vHSTZyS+yCYV31Fhsx+vNPsT47rMTiPecJ/oKb1gQBjTbEF+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xMWzteXn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZMbUSxJ/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zdHebBXT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YNAOxb7a; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xMWzteXn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZMbUSxJ/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zdHebBXT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YNAOxb7a"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F12FA1FB08;
	Wed,  9 Sep 2026 12:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788956574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=081DfqZYJ67fRJ5TkbDWVgSiZBa+jC0p668G6F1xrBQ=;
	b=xMWzteXnfOvr7W/s7ivuFQmm1nlxThsjWE0HAkNslw1uwfBaLlsryFeMB2s4CbjmZDvyaH
	Wm31pN6IPVn4hegx3fOi8jcTG/TmG1AM66E1zoK7U8uuPEA9g3mBS2byIK1N9dCwcO89Ry
	RHcXcT3kKrkvX5g8l6nRqb2i+YE5hZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788956574;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=081DfqZYJ67fRJ5TkbDWVgSiZBa+jC0p668G6F1xrBQ=;
	b=ZMbUSxJ/GVHkPN16J2Fs02WbLJnnhKmXXfDL8RE4Z1tE6k6D8ZT/xDlGUtx9Y46Xv9nChp
	AaD/CISA+VhJ91CA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zdHebBXT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YNAOxb7a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788956570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=081DfqZYJ67fRJ5TkbDWVgSiZBa+jC0p668G6F1xrBQ=;
	b=zdHebBXTZQjkq3KtkxN7ruIv0KBfyUtw9VqFEBn/pTJsh4tmTd6+B3lpoejpP9nCPYYiFW
	z9mDDum2fy6LC0jACYDUf9mtnJ45Ya+qi4/hp5zT8X3TkKmicu2Lc2rH5sACjhSmSYUX+L
	8fbuepQB/rJvg4bFoI5fXUq6g/RPi1I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788956570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=081DfqZYJ67fRJ5TkbDWVgSiZBa+jC0p668G6F1xrBQ=;
	b=YNAOxb7aa8SvbTfib3kKfv+UtI8CkNa9qTIJjYiWbTDqJBScyo1FrwAmegiA4nD7++exuL
	oK1huHaABmBohyBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C93D213185;
	Wed,  9 Sep 2026 12:22:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DrsZMZlPoWpWMgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 09 Sep 2026 12:22:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4C6C3A1341; Wed, 09 Sep 2026 14:22:45 +0200 (CEST)
Date: Wed, 9 Sep 2026 14:22:45 +0200
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
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating straddling
 large folios
Message-ID: <2fu7s7ewyeal353zaum3dzn3t5vcqu5hff7u4kcogcvl77ksur@omxo5kvwi4w3>
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
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: F12FA1FB08
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[27];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kvack.org,vger.kernel.org,linux-foundation.org,kernel.org,infradead.org,google.com,suse.com,linux.alibaba.com,suse.cz,nvidia.com,redhat.com,gmail.com,huawei.com,fnnas.com];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	R_RATELIMIT(0.00)[to_ip_from(RL77qb5igscudnz1iomstzbaxb)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,huawei.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Wed 09-09-26 14:23:39, Zhang Yi wrote:
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

Looks good to me. Thanks! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

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
>  mm/internal.h |  4 +--
>  mm/shmem.c    | 13 +++-----
>  mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
>  3 files changed, 67 insertions(+), 38 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 68db5abd0a4c..6e6ad3187378 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -627,8 +627,8 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
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
> index 89a1495e55f7..4efbbbba5da5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1175,11 +1175,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
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
> @@ -1189,8 +1186,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
>  	if (folio) {
>  		folio_mark_dirty(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend))
> -			end = folio->index;
> +		truncate_inode_partial_folio(folio, lstart, lend, NULL, &end);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  	}
> @@ -1258,7 +1254,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  
>  				if (!folio_test_large(folio)) {
>  					truncate_inode_folio(mapping, folio);
> -				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
> +				} else if (truncate_inode_partial_folio(folio,
> +							lstart, lend, NULL, NULL)) {
>  					/*
>  					 * If we split a page, reset the loop so
>  					 * that we pick up the new sub pages.
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..d88a1b159084 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -206,35 +206,41 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
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
> + * When @pstart and/or @pend are non-NULL they receive the indexes of the
> + * page range fully covered by [lstart, lend] after any split (or none),
> + * i.e. the range of pages that are wholly within [lstart, lend] and so safe
> + * to discard.
> + *
> + * Return %true if the folio was split, %false otherwise.
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
>  
>  	folio_wait_writeback(folio);
>  	if (length == size) {
>  		truncate_inode_folio(folio->mapping, folio);
> -		return true;
> +		goto no_split;
>  	}
>  
>  	/*
> @@ -248,9 +254,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  	if (folio_needs_release(folio))
>  		folio_invalidate(folio, offset, length);
>  	if (!folio_test_large(folio))
> -		return true;
> +		goto no_split;
>  
>  	min_order = mapping_min_folio_order(folio->mapping);
> +	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
>  	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
>  	if (!folio_split_or_unmap(folio, split_at, min_order)) {
>  		/*
> @@ -259,38 +266,67 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> +		bool tail_isolated = true;
> +
> +		if (pend)
> +			*pend = round_down(pos + offset + length,
> +					   min_nrbytes) >> PAGE_SHIFT;
>  
>  		if (offset + length == size)
> -			goto no_split;
> -
> +			goto split;
> +retry:
>  		split_at2 = folio_page(folio,
>  				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>  		folio2 = page_folio(split_at2);
>  
>  		if (!folio_try_get(folio2))
> -			goto no_split;
> +			goto split;
>  
>  		if (!folio_test_large(folio2))
>  			goto out;
>  
> -		if (!folio_trylock(folio2))
> +		if (!folio_trylock(folio2)) {
> +			tail_isolated = false;
>  			goto out;
> +		}
> +
> +		/*
> +		 * split_at2 may no longer belong to folio2 due to concurrent
> +		 * split. Retry to find the correct folio in case it's still
> +		 * large.
> +		 */
> +		if (page_folio(split_at2) != folio2) {
> +			folio_unlock(folio2);
> +			folio_put(folio2);
> +			goto retry;
> +		}
>  
>  		/* make sure folio2 is large and does not change its mapping */
>  		if (folio_test_large(folio2) &&
> -		    folio2->mapping == folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> +		    folio2->mapping == folio->mapping &&
> +		    folio_split_or_unmap(folio2, split_at2, min_order))
> +			tail_isolated = false;
>  
>  		folio_unlock(folio2);
>  out:
> +		if (!tail_isolated && pend)
> +			*pend = folio2->index;
>  		folio_put(folio2);
> -no_split:
> +split:
> +		if (pstart)
> +			*pstart = round_up(pos + offset,
> +					   min_nrbytes) >> PAGE_SHIFT;
>  		return true;
>  	}
> -	if (folio_test_dirty(folio))
> -		return false;
> -	truncate_inode_folio(folio->mapping, folio);
> -	return true;
> +	if (!folio_test_dirty(folio))
> +		truncate_inode_folio(folio->mapping, folio);
> +no_split:
> +	if (pstart)
> +		*pstart = offset ? folio_next_index(folio) : folio->index;
> +	if (pend)
> +		*pend = (pos + size > (u64)lend) ? folio->index :
> +						   folio_next_index(folio);
> +	return false;
>  }
>  
>  /*
> @@ -413,11 +449,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
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
> @@ -427,8 +460,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
>  						FGP_LOCK, 0);
>  		if (!IS_ERR(folio)) {
> -			if (!truncate_inode_partial_folio(folio, lstart, lend))
> -				end = folio->index;
> +			truncate_inode_partial_folio(folio, lstart, lend, NULL, &end);
>  			folio_unlock(folio);
>  			folio_put(folio);
>  		}
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
