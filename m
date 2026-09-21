Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A67463B8B;
	Mon, 21 Sep 2026 09:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981544; cv=none; b=hzpf4hefX72ehoBf6JHDqDbU0+D5HJSXQPS1mKcgQnZTyEWE2GleMkBo8jGXGsOIeaLwO4FeoTZNWC3C9xFCLRByNdOjSAfV1z7fvhR+8G4TqGuu+kartZltqy788QazsoNk6wdEy7fA48KS84BiikglGz2NLe9esLDendI7ycA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981544; c=relaxed/simple;
	bh=z3y8CQaub2T2qNp/Kr+jLqEkn1yTvqNFG1g0u/SDVYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQecpUQW5HXF1TPdpAWacObpypaOijUH+ybanTsYIjT6QJ6+JJVjZSXXOIe3fStkEBqXYHW4B+rIUFJGLPjADKMRqtiE5g2DFZP9qGhoi6PVnyVVVTcrGEzqahAYc6VFxkRpvs4/09H0cU8Z7+V0BsYMZ45E3r0rS2vs4s1eAOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=w3sT7iiC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=h67AoicV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2u63eRNe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Er2ICYL+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="w3sT7iiC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="h67AoicV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2u63eRNe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Er2ICYL+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 11E2E21BEB;
	Mon, 21 Sep 2026 09:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789981536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qM3WFeKUFpvCjJ8UIMGd6U0TzUGKAEa9PlIpW6zUaJA=;
	b=w3sT7iiCAazpsuKTVMrFJHv6mMjNCatc59il/499A4jHrA3PPIW+eKsxLzcFS44O3LFvbz
	MA6g5laDghLb8hboOBExIiD0qpqnm2nFq59ClXXbAmBOPs/G2nMNUwcm9uij3xNhl4X/yr
	sT0q15Y4qnX0akqIQ5fy2LSDxnqS6cc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789981536;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qM3WFeKUFpvCjJ8UIMGd6U0TzUGKAEa9PlIpW6zUaJA=;
	b=h67AoicVyYvGnf/OlXQt8jfuHXBhzkkxk69LRi3LBCeeivUlRSGkR7pEFBJYww3KaIU2w4
	gIKU2icDXWiuevBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789981532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qM3WFeKUFpvCjJ8UIMGd6U0TzUGKAEa9PlIpW6zUaJA=;
	b=2u63eRNeWiQn/VmGZAhYh4Tmg57l9C7Sf7ypON88JJI0s9g2LvbXSERb4QDUwYYpYXXSNL
	3/eBO7bvoM+Y07V9NDETMBLqHTm+JNL3EkPB6jaI9yHw4RSDVEmtM/GuHlmTpUxyrnbdEM
	AdmsEiBKFwWCmKaoDKi8Qld1OPqoVYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789981532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qM3WFeKUFpvCjJ8UIMGd6U0TzUGKAEa9PlIpW6zUaJA=;
	b=Er2ICYL+dW3cGUa5xH/JfrS49D9KyhwzeDp9mJKF2x1OnV2ZKye68YV+6aEY2JUcAHXLhG
	dAcpqEgoe+X1/kDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC9291368D;
	Mon, 21 Sep 2026 09:05:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BXzSLVvzsGqsXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 21 Sep 2026 09:05:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6E8DFA13D5; Mon, 21 Sep 2026 11:05:31 +0200 (CEST)
Date: Mon, 21 Sep 2026 11:05:31 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Zhang Yi <yizhang089@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hughd@google.com, 
	baolin.wang@linux.alibaba.com, willy@infradead.org, bfoster@redhat.com, joannelkoong@gmail.com, 
	djwong@kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
Message-ID: <35me4qswsu2dd3howvfdglh4ge4t5vihkizoutxt2jhiyul6xj@i6kqsnqpvbra>
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com>
 <xl2rtnntlxoxoozkddgrlkcsgukcngvvcwazm7gb7q5g32yxir@ef5ltcwueboh>
 <DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com>
 <9d931f5e-cb34-4721-9def-7aeeda48700c@gmail.com>
 <453d0054-4f53-452a-9737-cd37d30a7d44@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <453d0054-4f53-452a-9737-cd37d30a7d44@huaweicloud.com>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
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
	FREEMAIL_CC(0.00)[gmail.com,nvidia.com,suse.cz,kvack.org,vger.kernel.org,linux-foundation.org,kernel.org,infradead.org,google.com,suse.com,linux.alibaba.com,redhat.com,huawei.com,fnnas.com];
	R_RATELIMIT(0.00)[to_ip_from(RLh65wkrmjx1yjc7agkshaaime)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Thu 17-09-26 20:03:57, Zhang Yi wrote:
> Sorry, the previous diff format was incorrect, reposting it.
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 23c90f00b530..b5e5bdf5f9ef 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -279,51 +279,46 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>  			*pstart = round_up(pos + offset,
>  					   min_nrbytes) >> PAGE_SHIFT;
> 
> -		if (offset + length == size) {
> -			end = aligned_end;
> +		end = aligned_end;
> +		if (offset + length == size)
>  			goto out;
> -		}
> -
> -		split_at2 = folio_page(folio,
> -				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
> -		folio2 = page_folio(split_at2);
> 
>  		/*
> -		 * folio2 may become stale due to a concurrent split or
> -		 * freeing, so validate it before and after taking its lock.
> -		 * If it fails, we can't get an accurate end position and fall
> -		 * back to folio->index, which may leave sub-folios split off
> -		 * at the offset edge in the page cache this round.
> +		 * After the first split at the start edge, the folio at the
> +		 * end edge may be freed and reused concurrently.
> +		 * __filemap_get_folio() looks up the straddler at
> +		 * aligned_end and returns it locked and ref'd with the
> +		 * mapping validated.
>  		 */
> -		end = folio->index;
> -		if (!folio_try_get(folio2))
> +		folio2 = __filemap_get_folio(folio->mapping, aligned_end,
> +					     FGP_LOCK | FGP_NOWAIT, 0);
> +		if (IS_ERR(folio2)) {
> +			/*
> +			 * No sub-folio straddles the boundary when aligned_end
> +			 * is empty so discarding up to it is safe.  Otherwise
> +			 * the straddler is locked by someone else and we
> +			 * cannot obtain a reliable end position, so we fall
> +			 * back to folio->index.  This is safe but may leave
> +			 * pages split off at the offset edge lingering in the
> +			 * page cache this round.
> +			 */
> +			if (PTR_ERR(folio2) != -ENOENT)
> +				end = folio->index;
>  			goto out;
> -
> -		if (folio2->mapping != folio->mapping ||
> -		    !folio_test_large(folio2))
> -			goto out_put;
> -
> -		if (!folio_trylock(folio2))
> -			goto out_put;
> -
> -		if (page_folio(split_at2) != folio2) {
> -			folio_unlock(folio2);
> -			goto out_put;
> -		}
> -		if (!folio_test_large(folio2)) {
> -			end = aligned_end;
> -			folio_unlock(folio2);
> -			goto out_put;
>  		}
> 
> -		/* Split failed: back off to the head of the straddler */
> +		/* Already at the minimum order, nothing to split */
> +		if (folio_order(folio2) == min_order)
> +			goto out_put;
> +
> +		split_at2 = folio_page(folio2, (aligned_end - folio2->index));
> +
> +		/* Split failed, keep the straddler intact */
>  		if (folio_split_or_unmap(folio2, split_at2, min_order))
>  			end = folio2->index;
> -		else
> -			end = aligned_end;
> 
> -		folio_unlock(folio2);
>  out_put:
> +		folio_unlock(folio2);
>  		folio_put(folio2);
>  out:
>  		if (pend)

FWIW this looks much more understandable to me. And since this is a
preexisting issue I agree this should be a separate patch.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
