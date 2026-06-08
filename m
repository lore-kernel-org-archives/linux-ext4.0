Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AF733FE02
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 13:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780923982; cv=none; b=aPJewkG6n0mhUSiqO+BgEFJ6mmdJ7UCf+By5QjL5yvnTbc4TPlNNEA9p3lFJ1e5yQVoaWfpgyetjecejthbQfL/5g1vBTEOK5UB4hS+bkBajt+dRX+0zMQZpaeKsOhJp3ExF/FvhhdZchRR9q+I0vGlDfgf/yt3fbhPID+n9S+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780923982; c=relaxed/simple;
	bh=ep0WguZQAZSNbW0FWByBNjNW4teDigRO6p4TA2lA3NM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LmeaRQf+7iaMQZBCX+6zegpkCCJonJN6tAeo7ugqXFagQ9hHwCxOJEER4qCUlSh6btt+MVd7KnMB4r9pbmQew0c99Cxww/5SQSm7Iqm6bMzqmqsJWTn1Snz2S/+mXS1NrCzOhGexfSW5z9RIM/htR6Tw47ZqmIzAKDKVXPH9hpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=f0laCf9C; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=icACAcuz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=f0laCf9C; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=icACAcuz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="f0laCf9C";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="icACAcuz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="f0laCf9C";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="icACAcuz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8153567E4B;
	Mon,  8 Jun 2026 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780923979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HMB4AqGU9r85UvCAjl82db9r/yv2VFlIMAfWID79ax8=;
	b=f0laCf9CeYs7H4jIE7BgDu1Y0vO4qgBzUOFLHP32Nv7iRyfknylZUVac8tkISaFgtZIXmz
	r5nwj7f9DMQxYzPLwX5lbP92xb8d179gZBlkrB3FeXKPU58q5A8Wwa5Q4Mo/7h5/XoJ6Kq
	95VA3BnJm45z/cUIaHTddcLAABfWEv8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780923979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HMB4AqGU9r85UvCAjl82db9r/yv2VFlIMAfWID79ax8=;
	b=icACAcuzRIbQD3F//ITzaUpe5nopu8Cn6Rfy3Kc+9qaQ6YC+fF2z1OICYw5Cj3AnlZKn0m
	zRZhh6Kbc/8Y0DDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780923979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HMB4AqGU9r85UvCAjl82db9r/yv2VFlIMAfWID79ax8=;
	b=f0laCf9CeYs7H4jIE7BgDu1Y0vO4qgBzUOFLHP32Nv7iRyfknylZUVac8tkISaFgtZIXmz
	r5nwj7f9DMQxYzPLwX5lbP92xb8d179gZBlkrB3FeXKPU58q5A8Wwa5Q4Mo/7h5/XoJ6Kq
	95VA3BnJm45z/cUIaHTddcLAABfWEv8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780923979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HMB4AqGU9r85UvCAjl82db9r/yv2VFlIMAfWID79ax8=;
	b=icACAcuzRIbQD3F//ITzaUpe5nopu8Cn6Rfy3Kc+9qaQ6YC+fF2z1OICYw5Cj3AnlZKn0m
	zRZhh6Kbc/8Y0DDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7310D779A7;
	Mon,  8 Jun 2026 13:06:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id upkPHEu+JmpqZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 08 Jun 2026 13:06:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1023BA0923; Mon, 08 Jun 2026 15:06:15 +0200 (CEST)
Date: Mon, 8 Jun 2026 15:06:15 +0200
From: Jan Kara <jack@suse.cz>
To: Jia Zhu <zhujia.zj@bytedance.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] fs/buffer: avoid tail commit walk for uptodate
 folios
Message-ID: <ariq5gm6azlmrsx2luoqetrmn44vtyz6j6mt327ftrhnxod5zc@h4db2nnexn7c>
References: <20260603134800.25155-1-zhujia.zj@bytedance.com>
 <20260608120131.45146-1-zhujia.zj@bytedance.com>
 <20260608120131.45146-2-zhujia.zj@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608120131.45146-2-zhujia.zj@bytedance.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,infradead.org,zeniv.linux.org.uk,kernel.org,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Level: 

On Mon 08-06-26 20:01:30, Jia Zhu wrote:
> block_commit_write() always walks every buffer_head attached to the
> folio.  That was cheap for order-0 folios, but large folios can contain
> hundreds of buffer_heads.  For a small buffered overwrite of an
> already-uptodate large folio, the commit work is therefore proportional
> to the folio size rather than the copied range.
> 
> This became visible with ext4 regular-file large folios, where cached
> small overwrites reach block_commit_write() through block_write_end().
> Before ext4 enabled large folios for regular files, this path was only
> hit with order-0 folios for normal ext4 buffered writes, so the full walk
> was bounded.  The ext4 large-folio commit is therefore the regression
> point for this generic helper cost.
> 
> The full walk is still needed when the folio is not uptodate, because
> block_commit_write() uses per-buffer uptodate state to decide whether
> the whole folio can be marked uptodate.  Keep those folios on the old
> full-buffer path.
> 
> For a folio that was already uptodate on entry, the commit no longer
> needs tail buffers for folio-uptodate discovery.  The copied range has
> already been processed once block_start reaches @to, so stop there and
> avoid the suffix walk.
> 
> Fixes: 7ac67301e82f0 ("ext4: enable large folio for regular file")
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index b0b3792b1496e..c8c41c799030d 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2096,6 +2096,7 @@ void block_commit_write(struct folio *folio, size_t from, size_t to)
>  {
>  	size_t block_start, block_end;
>  	bool partial = false;
> +	bool uptodate = folio_test_uptodate(folio);
>  	unsigned blocksize;
>  	struct buffer_head *bh, *head;
>  
> @@ -2118,6 +2119,8 @@ void block_commit_write(struct folio *folio, size_t from, size_t to)
>  			clear_buffer_new(bh);
>  
>  		block_start = block_end;
> +		if (uptodate && block_start >= to)
> +			break;
>  		bh = bh->b_this_page;
>  	} while (bh != head);
>  
> -- 
> 2.20.1
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
