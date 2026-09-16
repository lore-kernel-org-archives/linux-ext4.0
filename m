Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFCF39937C;
	Wed, 16 Sep 2026 12:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560603; cv=none; b=gbs+fAE+pYJ5N5yZZi4bwMeKbnWqmK0368+U4+iGd1NDZgAQhTWQHJFxOG7nbq6jMyBNty4za9+pkMAWrxEfBDZV7vcMVQfd6VdqpmfzZRKzNrNe3hibiGPoaf5Ip1Ki5y13HsDXqSwbmT2GIgc856HIeaNPknbIOCDT46VCCPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560603; c=relaxed/simple;
	bh=AfSEswlCLRdBhKXBn5vkb9ejpwkPsuTDmPP3Axe+f7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9XkhtUkikMbDHQxplt+HuF3X0hNbLstO47H9wyj7seXsv8Dwrohp8hvY7JioTSUereuiVucn9iJUUd3hto7P8Fhk4uGG6pQYr0PWThqcjj0lFpYNMtGwVsljQqY+LUkn9hmc90dMTD7ScUo6J+uhoDv5HqW0GDrxe5J184tf3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SQzgqKj7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ii9UL340; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=h4lTgrcS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=drprDADX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SQzgqKj7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ii9UL340";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="h4lTgrcS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="drprDADX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E73E81FE5D;
	Wed, 16 Sep 2026 12:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789560587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D85vXBe2xfk1jvSWs9TcMey2V3KKLMoyz3bWz1rk7eI=;
	b=SQzgqKj7lsf2UAcZl4s6jxmS3A9EcIP48QnkWkH5uJB7nLt0OSGd0HBtKtZJp3VCnxOD+X
	0T1OIq6Uv3JtwGfGX1k01qAagOOWDn49od7h+lcstDyBMU1y07mnLTv1oLA+PvRI19RPZ/
	SdieQeijm6/QDJgPmbZloi3vnFO3+X0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789560587;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D85vXBe2xfk1jvSWs9TcMey2V3KKLMoyz3bWz1rk7eI=;
	b=Ii9UL340WKjT4dH6mhNsOgZQXueEg1OOvbp0RTHkrvOmG2okjBZ/XspMz+9mPrH8dh74tT
	LHuc4DG7kr6axGAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h4lTgrcS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=drprDADX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789560582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D85vXBe2xfk1jvSWs9TcMey2V3KKLMoyz3bWz1rk7eI=;
	b=h4lTgrcS795S9e5ofKlTaEjGmbVI2CkNtSx/AtITpaUCyI/SCevJy38l6BjHP+1VGltIk+
	jchB4o4X0wR2jn8CsL137siGXmvL74GQax7VWBFq38mODg3zU02r8IVylbVQf9Dbvj3XiE
	C8N38rLTvs3SkbJUoOuuaGfp0V1OTrg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789560582;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D85vXBe2xfk1jvSWs9TcMey2V3KKLMoyz3bWz1rk7eI=;
	b=drprDADXBAHHVtDPk/j7Gyn+5Kqcv1TvhWJ7bBltu38WJ0A34FsbiLt/LsK3v+KTaI6AxQ
	V1ArPhoThqRmuDDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F11C11348F;
	Wed, 16 Sep 2026 12:09:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OVrVIQSHqmp0SAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 16 Sep 2026 12:09:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 81E26A13D5; Wed, 16 Sep 2026 14:02:35 +0200 (CEST)
Date: Wed, 16 Sep 2026 14:02:35 +0200
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
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
Message-ID: <xl2rtnntlxoxoozkddgrlkcsgukcngvvcwazm7gb7q5g32yxir@ef5ltcwueboh>
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
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: E73E81FE5D
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim,huawei.com:email];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL77qb5igscudnz1iomstzbaxb)];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[kvack.org,vger.kernel.org,linux-foundation.org,kernel.org,infradead.org,google.com,suse.com,linux.alibaba.com,suse.cz,nvidia.com,redhat.com,gmail.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email]
X-Spam-Flag: NO

On Wed 16-09-26 17:24:48, Zhang Yi wrote:
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

The changes mostly look good to me but I have some confusion around the
folio2 splitting below.

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

So I always found this folio2 lookup and revalidation somewhat suspicious
and now that we're digging into it I'll ask: As you note in the changelog,
by the time we compute split_at2 the page can be already freed and reused
because it was split off from the original 'folio'. It can be for example a
slab page or anything else. So is it guaranteed that page_folio() actually
returns something sensible? What guarantees we properly detect the "reuse
for something else" case in all possible cases for which the page can be
reused? I understand this is mostly a preexisting issue so maybe these
questions are more for MM guys than you...

So for me as an filesystem guy I'd appreciate some comment in this code
explaining why grabbing folio2 this way is actually safe. The really safe
way of getting to folio2 would be to use
  __filemap_get_folio(mapping, (offset+length) >> PAGE_SHIFT, FGP_LOCK, 0)
but I suppose we don't use the mapping lookup as it is more expensive?

								Honza

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
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
