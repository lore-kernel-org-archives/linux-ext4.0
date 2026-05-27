Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D053B5F63
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 10:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779878483; cv=none; b=rR3lldDJ+DB5fhYgVi34NCaQBtM+IsInB8r9Rx4Ld6qaDZHHKgEB8609+EYFjso1kkmcuBbmbSYmxiFgPU60+KjhV85kqDoGlMy10jmMdJOKoRHGDQLb/5Ixl/jzXDzahQ1vxyS/Vy8mwRgygHgrMcey+v/vrKLxJwguX3Geu3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779878483; c=relaxed/simple;
	bh=eddPB3j5fnzpXOhDAe4DjJQLUZvg8l7o+2iop1j5zxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hMfmu2+7HniyDM/NOFE3mK2ZrLyTWM9I39z5qhFTJr1uDy0BhlEGlBxWnis56lSjmyhlZuDmwbLLb0rQFX8/EgYoAtsBMBeSHkNCyq4YpK7td9OXFnob/+0HH0awSUJBM5SlA6UVHkjVKJ5cb9EX22HIJP7ldeKm4A6hNxNVUB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x+ijon5w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6FTLXjV5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x+ijon5w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6FTLXjV5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x+ijon5w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6FTLXjV5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x+ijon5w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6FTLXjV5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE9326B238;
	Wed, 27 May 2026 10:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779878480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lHBDCj/Mnv9HT4TW7eGCTc0pzs8coUHxFg8hHwRk99Y=;
	b=x+ijon5wWUac8dp4upxNe1Mmvx0jln+q4PoUhtg92i3GNBepxhrC3/hJguAiUrIpu/jAY3
	6tE0/36I5WRRQMgxahap/MQsgSnw6d6as+79WgMnY63w9krJiawQYjXeUni+j2R25D/5l0
	1zY9NE3PBZ+iNc7TR2kPSkArc2yBENw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779878480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lHBDCj/Mnv9HT4TW7eGCTc0pzs8coUHxFg8hHwRk99Y=;
	b=6FTLXjV5Y1eD8UUP09k9j3J/F7wtF2Jg8TrDoRLuVhtzgQQnaz9raJBP9rSyGqilKQO2rC
	qAJgmFBp3V3n/4Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779878480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lHBDCj/Mnv9HT4TW7eGCTc0pzs8coUHxFg8hHwRk99Y=;
	b=x+ijon5wWUac8dp4upxNe1Mmvx0jln+q4PoUhtg92i3GNBepxhrC3/hJguAiUrIpu/jAY3
	6tE0/36I5WRRQMgxahap/MQsgSnw6d6as+79WgMnY63w9krJiawQYjXeUni+j2R25D/5l0
	1zY9NE3PBZ+iNc7TR2kPSkArc2yBENw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779878480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lHBDCj/Mnv9HT4TW7eGCTc0pzs8coUHxFg8hHwRk99Y=;
	b=6FTLXjV5Y1eD8UUP09k9j3J/F7wtF2Jg8TrDoRLuVhtzgQQnaz9raJBP9rSyGqilKQO2rC
	qAJgmFBp3V3n/4Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A54605A7B4;
	Wed, 27 May 2026 10:41:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P35SKFDKFmpNeQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 27 May 2026 10:41:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 53B2AA0EB5; Wed, 27 May 2026 12:41:20 +0200 (CEST)
Date: Wed, 27 May 2026 12:41:20 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 13/34] ext4: Convert ext4_fc_submit_bh() to bh_submit()
Message-ID: <7pthwqjwf27adzsrryi5rqwolcefgih3w33nyml5mfllkozwrf@vh4kuu4olxbz>
References: <20260525171931.4144395-1-willy@infradead.org>
 <20260525171931.4144395-14-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525171931.4144395-14-willy@infradead.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,infradead.org:email,suse.com:email]

On Mon 25-05-26 18:19:06, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call by converting
> ext4_end_buffer_io_sync() from bh_end_io_t to bio_end_io_t and
> calling bh_submit().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-ext4@vger.kernel.org

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/fast_commit.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index b3c22636251d..d52c64adf416 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -184,8 +184,11 @@
>  #include <trace/events/ext4.h>
>  static struct kmem_cache *ext4_fc_dentry_cachep;
>  
> -static void ext4_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
> +static void ext4_end_buffer_io_sync(struct bio *bio)
>  {
> +	bool uptodate = bio->bi_status == BLK_STS_OK;
> +	struct buffer_head *bh = bio_endio_bh(bio);
> +
>  	BUFFER_TRACE(bh, "");
>  	if (uptodate) {
>  		ext4_debug("%s: Block %lld up-to-date",
> @@ -659,8 +662,7 @@ static void ext4_fc_submit_bh(struct super_block *sb, bool is_tail)
>  	lock_buffer(bh);
>  	set_buffer_dirty(bh);
>  	set_buffer_uptodate(bh);
> -	bh->b_end_io = ext4_end_buffer_io_sync;
> -	submit_bh(REQ_OP_WRITE | write_flags, bh);
> +	bh_submit(bh, REQ_OP_WRITE | write_flags, ext4_end_buffer_io_sync);
>  	EXT4_SB(sb)->s_fc_bh = NULL;
>  }
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
