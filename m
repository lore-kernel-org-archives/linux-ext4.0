Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA22392C4B
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 10:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779878528; cv=none; b=OSd2nhgBO8vkHDivNks9QIZBaKSwxOAuvx4BzIOHmT0W5XmmfBv+y4ENXnY+KI3GlosTf0LhGAGGlb9/iVd4UfUfI5EHTB+9MHeIiWlTMly3/Es9siZs/RU6+B/nh5sL7Nf3WU8qazK+vTe2nUUEFfSSS9hFADTu3fnDPUgblGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779878528; c=relaxed/simple;
	bh=E+4vQJ6LDe6WKGtNGFK9z5HCzOsPKxl1QPbivqPyi5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFxBjx8OG2jgEo29AK7HY2KmxkcCUkKnsYDblCP6jymiWWD/J+9f27mKA7oFvqw/z12YxU6X+6lokcpvB/Ib0d1+zkXxfkMkp01imAYe6ziEf8U7BuiWf/3vut/Yquxdrfow1haYN9O4TWjm5fGW/JbCA7x4G2HNw24EPw1DUHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fyiFKxfw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rlD5hFBF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ETBo67lD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CVs3rQ+l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fyiFKxfw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rlD5hFBF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ETBo67lD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CVs3rQ+l"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F92E6B282;
	Wed, 27 May 2026 10:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779878525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Z1F1AQymbjB7+epP6FDqAcv1UpKf2+7yEiAwDa0HMA=;
	b=fyiFKxfwpGC2LHI1ZLYqkWqR0OljRb9vIG8b2PuFKLnBPgb18tL8CPV3QZKuDkhpjXURCp
	KX6lnuL+vNbUvPLdvnjwYuy/KxU07rTj7xYa4yW/lafdRn3y4Vv7r19IJ9+GaeMIEUBvk8
	2eZ33RkECecCMrPaK1m6/o59HvPLp7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779878525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Z1F1AQymbjB7+epP6FDqAcv1UpKf2+7yEiAwDa0HMA=;
	b=rlD5hFBFDDvp6nVlzC0xosJOyJXeo9fqEEjAK7mfTj7eo6vQ2YL1SIS0uZYa83A2n7bpTx
	2q8g4rwZVSo240Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779878524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Z1F1AQymbjB7+epP6FDqAcv1UpKf2+7yEiAwDa0HMA=;
	b=ETBo67lDFO8kTjtMeuP1WKiottE8G78+SQVgbhRC7cN+9EdhcEA21kI0IkQqhczgHAoHxc
	9dk25TkR98pmLJWxbTHUbBhLgc9eR89RdNe2Hqy2l7xe+dkUlimHJoj66K/JjkxyYgJipk
	5QkNlkKqucZagQ9ghkzzj2k7XdswS9w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779878524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Z1F1AQymbjB7+epP6FDqAcv1UpKf2+7yEiAwDa0HMA=;
	b=CVs3rQ+lh5dDKotxRP28vUfmeEVWASun+eu3BeLQRiu4ODMyvQWDRxbMuoLdjRRp9Ojd9H
	7fqrg+IblXXX5NBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1711A5A7B5;
	Wed, 27 May 2026 10:42:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ahugBXzKFmoNegAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 27 May 2026 10:42:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CA60EA0EB5; Wed, 27 May 2026 12:42:03 +0200 (CEST)
Date: Wed, 27 May 2026 12:42:03 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 14/34] ext4: Convert write_mmp_block_thawed() to
 bh_submit()
Message-ID: <ymmg5cgpxiy35j4loz6vimnf3rz6t2vu5tm6765vbmzpd3fcxt@4u24gsp2dgmy>
References: <20260525171931.4144395-1-willy@infradead.org>
 <20260525171931.4144395-15-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525171931.4144395-15-willy@infradead.org>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,infradead.org:email]

On Mon 25-05-26 18:19:07, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call by using bh_submit() instead of
> submit_bh().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-ext4@vger.kernel.org

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/mmp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index 6f57c181ff77..493528fbed75 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -46,9 +46,9 @@ static int write_mmp_block_thawed(struct super_block *sb,
>  
>  	ext4_mmp_csum_set(sb, mmp);
>  	lock_buffer(bh);
> -	bh->b_end_io = end_buffer_write_sync;
>  	get_bh(bh);
> -	submit_bh(REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO, bh);
> +	bh_submit(bh, REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO,
> +			bh_end_write);
>  	wait_on_buffer(bh);
>  	if (unlikely(!buffer_uptodate(bh)))
>  		return -EIO;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
