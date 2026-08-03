Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7227B368296
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 16:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773616; cv=none; b=SfY+7TUe7daZWnpZ9KkCVIHnd90qayeYHfSDfYGijyrpAQDql8tCM9p8NmYT9sM+uVeGF3bxcPBeyX3I1iNeuqXPaCDtpRbTnWYEvvWfmQdgI0+NtsT1yHv7s1SpvqQLg3WEnceRU3YRvd9U9rRY6lVxX8PKZ9pYEnce37BYiQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773616; c=relaxed/simple;
	bh=pA62roMzym3VdqyVPmwl46inIHr3IOER9jyguTSQGjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K7c0oYUf1RBZWZUjsu98vXVspEzyB1/cEQ8ZGaZfkGZSOsmc9UVFrtWe0sPIFAj8P1n6PouSrVwKRD9q4DzSt2AfRUs93a3stE3uP3VvKtQYO+fZHSUiP4nKYmKG5BODxPp3Hm474zE4muSKt8JhcdN7rfMu0yOKtUGG3Pl8Pag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=njDBIX5u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rQ3tSH54; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jZT8C7Up; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+2bJVGkW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="njDBIX5u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rQ3tSH54";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jZT8C7Up";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+2bJVGkW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C8FF3EEF;
	Mon,  3 Aug 2026 16:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785773608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1iasutn8jVE4MQb0uCn1XoCjky74p9ZnZMJyWJKX7wg=;
	b=njDBIX5uiGJ28vrS92LZUoP8eFyMow+BjaUIUQUIs3DQqEaOqV2riEKGnR4tqmEjAuEQA2
	2KekwO0QQ+lARXwApBjCXoh908OyXtPxAvEtfUqjNSwpnO/Ol2TPVMw/lOdZHZ+XFpbCLH
	xyCcK7eaK9gr5f5XYKHmzu5dV1p/xx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785773608;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1iasutn8jVE4MQb0uCn1XoCjky74p9ZnZMJyWJKX7wg=;
	b=rQ3tSH54ZTQNiK7YuVDs/LKnhpf58O+p5xU9AT2aEYFURHA5/lx4p0HJLalI5Ivrfnl32/
	e+dWHF26q4Plf7Cg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785773604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1iasutn8jVE4MQb0uCn1XoCjky74p9ZnZMJyWJKX7wg=;
	b=jZT8C7UphmYU/r0NLLvqmT7OfSF+WeV6V05JCBF3FdpyRX4d7+wLgZ0HzyjCh39uJcPtdq
	M4iGKPY4rBS2SbYzUCc0u77UkMaICb+9x7aJz+IbGowFLmXlFf/mHFXMOx5m643pd2TA/7
	Nn7aKvEqelnUpOMVNBYSJWjAU7XCCRU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785773604;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1iasutn8jVE4MQb0uCn1XoCjky74p9ZnZMJyWJKX7wg=;
	b=+2bJVGkWOwEWQCRDRS8qT/vHDbRFJDBBQ76gCijVK81UdbIHXTlmYJWprfJHEmM5/gY1PK
	F1oSPMPkgC6tVEAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6A0CD779A1;
	Mon,  3 Aug 2026 16:13:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Dc9lGSS+cGqoKwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 16:13:24 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C0693A13A4; Mon, 03 Aug 2026 18:13:19 +0200 (CEST)
Date: Mon, 3 Aug 2026 18:13:19 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] buffer: allow a buffer_head to point at memory
 outside the page cache
Message-ID: <z5jfe6bsxhgqqgjtxcm7ass2fslc4ynizvpmzlqxtr6rrfaopu@fxzntlxafmxj>
References: <cover.1785621505.git.coshi036@gmail.com>
 <41c6fee66724e374d4682124a1eb80041e22efb9.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41c6fee66724e374d4682124a1eb80041e22efb9.1785621505.git.coshi036@gmail.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	URIBL_BLOCKED(0.00)[infradead.org:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Sat 01-08-26 18:00:46, Chao Shi wrote:
> jbd2 builds a temporary buffer_head to write out the frozen copy of a
> metadata block, and that copy lives in slab memory.  Today jbd2 points the
> temporary buffer at the slab folio backing it.  A slab folio's ->mapping is
> not an address_space, so anything that follows bh->b_folio->mapping there
> gets garbage rather than NULL; mark_buffer_write_io_error() does exactly
> that, and we are about to start calling it on this buffer.
> 
> Rather than teach every such helper about slab folios, allow bh->b_folio to
> be NULL and let b_data point straight at the memory.  Code that needs the
> folio has to check.  There are two places in this file:
> 
>  - __bh_submit() adds the data by virtual address using
>    bio_add_virt_nofail(), and skips the cgroup accounting: a buffer that is
>    not in the page cache has no owning folio to attribute writeback to.
> 
>  - buffer_set_crypto_ctx() returns early.  fscrypt has no interest in a
>    buffer that is not part of a file mapping, which is why it already
>    returns when folio_mapping() comes back NULL.
> 
> Nothing sets b_folio to NULL yet, so this patch is a no-op on its own.
> 
> This is deliberately not a general capability.  Buffers over highmem have
> no permanent kernel virtual address, which is why folio_set_bh() records a
> folio and an offset instead of an address.  A folio-less buffer_head is
> only valid over memory that is always mapped, and must not be passed to
> bh_offset().

There are much more things you cannot do with a bh that doesn't have valid
b_folio - touch_buffer(), end_buffer_async_read(), ... and many more. But
that's a bussiness of the code that sets up such temporary bhs. I agree
that setting b_folio to NULL will if nothing else lead to much more obvious
failures than when we accidentally get slab folio. So I'd prefer we update
the description a bit in this direction but otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Chao Shi <coshi036@gmail.com>
> ---
>  fs/buffer.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index be8b57a635cd..04fcc34e4fa6 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1099,12 +1099,16 @@ EXPORT_SYMBOL(__bforget);
>  static void buffer_set_crypto_ctx(struct bio *bio, const struct buffer_head *bh,
>  				  gfp_t gfp_mask)
>  {
> -	const struct address_space *mapping = folio_mapping(bh->b_folio);
> +	const struct address_space *mapping;
>  
>  	/*
>  	 * The ext4 journal (jbd2) can submit a buffer_head it directly created
> -	 * for a non-pagecache page.  fscrypt doesn't care about these.
> +	 * for memory that is not in the page cache at all.  fscrypt doesn't
> +	 * care about these.
>  	 */
> +	if (!bh->b_folio)
> +		return;
> +	mapping = folio_mapping(bh->b_folio);
>  	if (!mapping)
>  		return;
>  	fscrypt_set_bio_crypt_ctx(bio, mapping->host,
> @@ -1142,7 +1146,11 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
>  	bio->bi_write_hint = write_hint;
>  
> -	bio_add_folio_nofail(bio, bh->b_folio, bh->b_size, bh_offset(bh));
> +	if (bh->b_folio)
> +		bio_add_folio_nofail(bio, bh->b_folio, bh->b_size,
> +				     bh_offset(bh));
> +	else
> +		bio_add_virt_nofail(bio, bh->b_data, bh->b_size);
>  
>  	bio->bi_end_io = end_bio;
>  	bio->bi_private = bh;
> @@ -1152,7 +1160,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  
>  	if (wbc) {
>  		wbc_init_bio(wbc, bio);
> -		wbc_account_cgroup_owner(wbc, bh->b_folio, bh->b_size);
> +		if (bh->b_folio)
> +			wbc_account_cgroup_owner(wbc, bh->b_folio, bh->b_size);
>  	}
>  
>  	blk_crypto_submit_bio(bio);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
