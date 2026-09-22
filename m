Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0F43DD862;
	Tue, 22 Sep 2026 11:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790076914; cv=none; b=RLR8EB2kIOxns4CZ1cu2sozrqpNvPfD4lwmX6oMWJGGAUUUhAexc+I/+PqV3ei2qoNOpKnGOzkbuJhJFZmGsL4teAD5k61sx/CyR3zztncrFDxoxuUBeoXuEdSOx3JWLp7U0ByXn2vBa5BT3T1UGA0C8LYbEGyE+mJlrrAeZtQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790076914; c=relaxed/simple;
	bh=iongsWRzhtIVBamgQFIm65qd3lNrHWGKTPupxrNqcgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cg4qiLNoR1YhhF1XbA5VrZCkpGh1yPYHWaqH1ooiFZD4HnF04pMN/IEjEbzyvlg1cIsRu9ty8RGOSTbobB73hXJVKDJ4kvBy+bN3rquQNdNpHfXxOT8wJfzjzUTC9fPDPg4iUsPLcicnE5WKwbZpgTHVNjjxDmclLCX6UG0T8UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dnuYEvhV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FQSJM2lW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kB/aZ+Ol; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZO0zUPM/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dnuYEvhV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FQSJM2lW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kB/aZ+Ol";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZO0zUPM/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 094B01F769;
	Tue, 22 Sep 2026 11:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790076906; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oypy0douIFW7EKquJ4goZfdutHxcrX5ecmHjC0AHCmA=;
	b=dnuYEvhVPbmvayuEgEWwWquR8F4sHLQrOxLAH5VyRQcEfSz3ylC/KUrgdxt1Qt/t+T6V/4
	nmgs3pIZ6j7L0DlDKuibxWj2Xf5/iJhAlxa6BvhGlQ8c7qYK16/E6vkbWipEmDZgGhiopx
	Vhyn1x1mpppG2XUoR5gZ85qqKoUsQ8g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790076906;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oypy0douIFW7EKquJ4goZfdutHxcrX5ecmHjC0AHCmA=;
	b=FQSJM2lWhQZcnLYpgfaUvhbTkaeEfVokk4QPLgydhiUlnsjHhjiufEU+WhL4vls9tN9XVq
	TQXu9Oz30jPoj0DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790076902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oypy0douIFW7EKquJ4goZfdutHxcrX5ecmHjC0AHCmA=;
	b=kB/aZ+OlFZ9UZ7yqapZcNkHIcapcK43UIxyW6fSQSvMdpl3Uu93M6X5hvw7ytzbJFZ2Cv+
	72UZTKdlBWZbylykbR7MmBC+OVmB2Wo5RJYJEp/tjGeN5BH0Jr87cVgXRXtIiHJVQj232w
	5FACwHrmNQlob8dVjL5Ul/9kFr4w8+w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790076902;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oypy0douIFW7EKquJ4goZfdutHxcrX5ecmHjC0AHCmA=;
	b=ZO0zUPM/DyUZAl8qbb8OeQThGVkzh4U+O4Y8VpZ6aUuMXNzR1XA/Lp/N5gRZgri+vQ0qfG
	Eu7Gc3ZeKg3ItUAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D2C37132D3;
	Tue, 22 Sep 2026 11:35:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ksqgK+VnsmqmdAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Sep 2026 11:35:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 63538A13D4; Tue, 22 Sep 2026 13:35:01 +0200 (CEST)
Date: Tue, 22 Sep 2026 13:35:01 +0200
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
Subject: Re: [PATCH v4 2/4] mm/truncate: look up the end-edge straddler by
 index
Message-ID: <beaedzhoq4frb4nyeecva4plxxpalojnqomxuyfaphflskttqq@vecce4gwtr45>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-3-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922110703.468389-3-yi.zhang@huaweicloud.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.cz:email,sashiko.dev:url,nvidia.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO

On Tue 22-09-26 19:07:01, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In truncate_inode_partial_folio(), after the first split at the start
> edge, folio_split() unlocks and drops the refcount of the after-split
> sub-folios. The sub-folio straddling the end of the truncation range is
> therefore unlocked and only transiently ref'd in the page cache while
> the code still derives it from a page pointer inside the original folio.
> 
> Between the first split finishing and page_folio() resolving split_at2,
> that tail page can be reclaimed, freed and reallocated as a new large
> folio in the same mapping at a different file offset. folio2 then points
> at a folio that does not cover the end boundary, yet
> folio2->mapping == folio->mapping still holds, so the stale pointer
> passes the mapping check and folio_split_or_unmap() splits a folio at a
> wrong position (or, with a transient refcount, a use-after-free window
> opens between try_get and the split). __folio_split()'s own
> folio != page_folio(split_at) check cannot catch this either since
> split_at2 has been reallocated as part of the new folio, so
> page_folio(split_at2) resolves back to folio2.
> 
> Look the straddler up by its page index instead. __filemap_get_folio()
> returns the folio currently covering the boundary, ref'd and locked,
> with the mapping validated under the lock, so the split target is always
> the real folio at the end edge.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/message/20260916094500.C30061F00893%40smtp.kernel.org
> Link: https://lore.kernel.org/linux-mm/DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
> Cc: stable@vger.kernel.org
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/truncate.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index f9625bb4916f..a8a179b38252 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -259,30 +259,32 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> +		pgoff_t end_idx;
>  
>  		if (offset + length == size)
>  			goto no_split;
>  
> -		split_at2 = folio_page(folio,
> -				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
> -		folio2 = page_folio(split_at2);
> -
> -		if (!folio_try_get(folio2))
> +		/*
> +		 * After the first split at the start edge, the folio at the
> +		 * end edge may be freed and reused concurrently.
> +		 * __filemap_get_folio() looks up the straddler at end_idx
> +		 * and returns it locked and ref'd with the mapping
> +		 * validated.
> +		 */
> +		end_idx = (pos + offset + length) >> PAGE_SHIFT;
> +		folio2 = __filemap_get_folio(folio->mapping, end_idx,
> +					     FGP_LOCK | FGP_NOWAIT, 0);
> +		if (IS_ERR(folio2))
>  			goto no_split;
>  
> +		/* make sure folio2 is large */
>  		if (!folio_test_large(folio2))
>  			goto out;
>  
> -		if (!folio_trylock(folio2))
> -			goto out;
> -
> -		/* make sure folio2 is large and does not change its mapping */
> -		if (folio_test_large(folio2) &&
> -		    folio2->mapping == folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> -
> -		folio_unlock(folio2);
> +		split_at2 = folio_page(folio2, (end_idx - folio2->index));
> +		folio_split_or_unmap(folio2, split_at2, min_order);
>  out:
> +		folio_unlock(folio2);
>  		folio_put(folio2);
>  no_split:
>  		return true;
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
