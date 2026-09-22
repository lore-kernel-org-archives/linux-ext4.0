Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8496F3AFAF8;
	Tue, 22 Sep 2026 11:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790076784; cv=none; b=i4N1U/loy/wPy/b825RPx/Uq/XdJluWnFyxIu0iiuoL4NcVXD42ZxFzsL2uH1tqz93v+QAtjUCswDY3YHHSvmtfGrb7anZFo+E2E9FPjgnlk07/SSul+QBdgoCmdTbBs1Y19Zt5NuaK66f22GK5edBIcfhNvZSfkF1qS2s0ZJ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790076784; c=relaxed/simple;
	bh=UZcpxsK7+haISNbUhHekrYGgLE/nNFgu9VzubUjAvZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tbsdGc0L86JVRrYhceliCim0jRcXBoacviPYz52x1ZWaBoCFSotENC/Ht8aegvnSJCENyJdrUWkoJ5QdF/DZJJ4LkpO7ZskkDK7wT+C19sbo+XEvQzTKp9x7ftUvtpvq/uzOV6JoVRgA7xoVH2NZNn//u7Ey61bDh931AnD3oII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lqw/VHsF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Bt7fouIx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z7nMRJA3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=g82nSuCf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lqw/VHsF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Bt7fouIx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z7nMRJA3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="g82nSuCf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1F39F1F769;
	Tue, 22 Sep 2026 11:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790076769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qHNqRhZsY4PDDoaGfo9Y4rMrXjw8S4znraHltHttsGg=;
	b=lqw/VHsFOyM1PsjsKWmUnjEAiCZrbCnlFP2c7OK+0emnIHPmzIbSp1YpgckUrEHrz2AjrC
	/aWIoTkEXg8IG0wwc6BsWf1vGj9FIih8N+MsndNSIotYIWQbAi16PyUfu0l/F5ZxazwUu0
	D7t+jRi1ynyV3tEtiFWjEZ2J9nt4SSk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790076769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qHNqRhZsY4PDDoaGfo9Y4rMrXjw8S4znraHltHttsGg=;
	b=Bt7fouIx/zmaW99whmgqogNbfULuwiK8aUDCtch2h0xdWVV8aNbOOh48S9YFiJQO1/U7I7
	N46r8uF2MkoG7lAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790076765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qHNqRhZsY4PDDoaGfo9Y4rMrXjw8S4znraHltHttsGg=;
	b=Z7nMRJA3v3h9WyGyPMrFub5U360su5GbXavnZdD3x71RC76+r8aj4DqIxF2+lT6vTLsEZi
	tz3IkGHeqZQKzlpmnjbKbwVKmS/uyNNA3TW7nHY7PkNnz7f6/w1Gbg0cju42okiZ0tMzOx
	TTkuY2HSZWOHUN6TVyOA5wO4PVMcbxY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790076765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qHNqRhZsY4PDDoaGfo9Y4rMrXjw8S4znraHltHttsGg=;
	b=g82nSuCfFgyI2FLYZDCH/OAHmR7BQZm0QS3txU3OBpo0yR30jLM02PapAsE9RY8V8EeHGk
	Aih5aEjTgmXiYZAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2D60132D3;
	Tue, 22 Sep 2026 11:32:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mNjuLFxnsmpTcgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Sep 2026 11:32:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 67F14A13D4; Tue, 22 Sep 2026 13:32:36 +0200 (CEST)
Date: Tue, 22 Sep 2026 13:32:36 +0200
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
Subject: Re: [PATCH v4 1/4] mm/truncate: align truncation boundaries to
 mapping minimum folio order
Message-ID: <uo7xgm7zk53f77i6qnrubqbhxf3tg6tp7qscci5nkylifnfahv@nf2xpxbkqwbe>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922110703.468389-2-yi.zhang@huaweicloud.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.com:email,nvidia.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO

On Tue 22-09-26 19:07:00, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> When the mapping has a non-zero minimum folio order (min_order),
> folio_split() in truncate_inode_partial_folio() stops at min_order
> instead of order 0, so the sub-folio containing a split point stays
> aligned to 1 << min_order rather than to a single page. The original
> boundaries in truncate_inode_pages_range() were based on page
> granularity, so either boundary could land inside the min_order chunk at
> its edge, and the truncation loop would drop that whole chunk, valid
> out-of-range tail included.
> 
> For example, a 64K (order-4) folio with min_order = 2 (16K) punched from
> offset 0 to 36K:
> 
>   split @p0 -> [p0-p3, p4-p7, p8-p15]         # non-uniform, min_order
>   folio2 = p8-p15           # straddles: p8 in range, p9-p15 tail valid
>   2nd split of folio2 -> [p8-p11, p12-p15]    # success
>   end(old) = p9                               # BUG: p9 inside [p8-p11]
>   loop truncates ... p8-p11               # p9-p11's valid tail is lost
> 
> It has gone unnoticed so far for two reasons. A non-zero min_order is
> only used by filesystems with a block or sector size larger than the
> page size, and those either always write back the affected range before
> punching a hole or truncating, or they carry filesystem private data on
> dirty folios (e.g. buffer_head), which makes filemap_release_folio()
> fail and folio_split() abort with -EBUSY, so the folio is never split
> and the old start/end boundaries remain valid. The bug only becomes
> reachable on paths that truncate dirty large folios without prior
> writeback and without filesystem private data, such as the upcoming ext4
> iomap buffered I/O path.
> 
> Align both start (rounded up) and end (rounded down) to the mapping
> minimum folio order so they always fall on a folio boundary.
> 
> Reported-by: Joanne Koong <joannelkoong@gmail.com>
> Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com/
> Fixes: e220917fa5077 ("mm: split a folio in minimum folio order chunks")
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/truncate.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..f9625bb4916f 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -345,9 +345,11 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
>   * @lstart: offset from which to truncate
>   * @lend: offset to which to truncate (inclusive)
>   *
> - * Truncate the page cache, removing the pages that are between
> - * specified offsets (and zeroing out partial pages
> - * if lstart or lend + 1 is not page aligned).
> + * Truncate the page cache, removing the folios that are between specified
> + * offsets (and zeroing out partial folios if lstart or lend + 1 is not
> + * folio aligned).  For mappings with a non-zero minimum folio order, the
> + * boundaries are aligned inwards to 1 << min_order so the edge sub-folio
> + * straddling the range is kept.
>   *
>   * Truncate takes two passes - the first pass is nonblocking.  It will not
>   * block on page locks and it will not block on writeback.  The second pass
> @@ -374,14 +376,14 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	int		i;
>  	struct folio	*folio;
>  	bool		same_folio;
> +	pgoff_t		min_nrpages = mapping_min_folio_nrpages(mapping);
>  
>  	if (mapping_empty(mapping))
>  		return;
>  
>  	/*
> -	 * 'start' and 'end' always covers the range of pages to be fully
> -	 * truncated. Partial pages are covered with 'partial_start' at the
> -	 * start of the range and 'partial_end' at the end of the range.
> +	 * 'start' and 'end' always covers the range of folios to be fully
> +	 * truncated, with both boundaries aligned inwards to 1 << min_order.
>  	 * Note that 'end' is exclusive while 'lend' is inclusive.
>  	 */
>  	start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
> @@ -395,6 +397,10 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	else
>  		end = (lend + 1) >> PAGE_SHIFT;
>  
> +	start = round_up(start, min_nrpages);
> +	if (end != (pgoff_t)-1)
> +		end = round_down(end, min_nrpages);
> +
>  	folio_batch_init(&fbatch);
>  	index = start;
>  	while (index < end && find_lock_entries(mapping, &index, end - 1,
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
