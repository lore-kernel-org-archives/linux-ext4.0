Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8D33E3D86
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 10:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779878290; cv=none; b=emASWruGyF1OYz+vSBtglyKx4HxKxcbJ3aMNiVHT/O8yC6uT8G9WVV+DpZAEzQHadBYhy+weqJFji+QYjTx3pW+xkGhZVoLbioSq9m1cKNYuZX5j5aFV1oBuTqSKwtc/lEKoNUuw1v9sYimzb3/GvL0GBI1T4XTsCCWjAUuePjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779878290; c=relaxed/simple;
	bh=28GNSn3/e+XJATcKmG8qgAvZ5/hI5YuKhTdxpXyoy8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBXJNjLuNEyUddSiJ+pnieyBDtLn76l7ySUoXEQJEHz8nwSteyTd8xPiYzQ3kyAsuIJb8f1HFCeVsTRtYZ4XQ0CgY8P8Hil9LmOm0ngQMww+ZWeozWiredVvTUTwzs5CGcIV+AFTkuV7emvTGAy0RCdgh7zoi8ebwywE+BDnpTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SMaZFApR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=X0PKGWYE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SMaZFApR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=X0PKGWYE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SMaZFApR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="X0PKGWYE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SMaZFApR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="X0PKGWYE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D38F76700F;
	Wed, 27 May 2026 10:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779878286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gihZ+8fWDLM9rjS305SEdtXvjktruTqxjsmA3hZhlUA=;
	b=SMaZFApRjotz5Lfuu3usucEmuslRS2VPvqmAhBolp3B44Ojs9TIw8ojBXMQK9XA28qN0cr
	lhwgIgFnd2Izl26Ll4lnO6VM+MVGB40zKcm3Pb+7DFXM8UoFXx4kF5ksWbl8PWtlIw4E58
	VwYyqHiTMfKRxMZsfyH+yOQn/6tlm8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779878286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gihZ+8fWDLM9rjS305SEdtXvjktruTqxjsmA3hZhlUA=;
	b=X0PKGWYELx79nXAXYmfEEPVpH9O0mG+wnB6ec4t9zvyjC07qNvtfnrmbaP6FCqX4kS5MDA
	8B34WQgYQ5O7TzBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SMaZFApR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X0PKGWYE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779878286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gihZ+8fWDLM9rjS305SEdtXvjktruTqxjsmA3hZhlUA=;
	b=SMaZFApRjotz5Lfuu3usucEmuslRS2VPvqmAhBolp3B44Ojs9TIw8ojBXMQK9XA28qN0cr
	lhwgIgFnd2Izl26Ll4lnO6VM+MVGB40zKcm3Pb+7DFXM8UoFXx4kF5ksWbl8PWtlIw4E58
	VwYyqHiTMfKRxMZsfyH+yOQn/6tlm8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779878286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gihZ+8fWDLM9rjS305SEdtXvjktruTqxjsmA3hZhlUA=;
	b=X0PKGWYELx79nXAXYmfEEPVpH9O0mG+wnB6ec4t9zvyjC07qNvtfnrmbaP6FCqX4kS5MDA
	8B34WQgYQ5O7TzBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CAE585A7B0;
	Wed, 27 May 2026 10:38:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uYiHMY7JFmr2dQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 27 May 2026 10:38:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 52B88A0EB5; Wed, 27 May 2026 12:38:02 +0200 (CEST)
Date: Wed, 27 May 2026 12:38:02 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 12/34] ext4; Convert __ext4_read_bh() to bh_submit()
Message-ID: <mgyyeyydvvhtwdzlquqjpotbmjxpjoiqr5b5a2r3mdo6aeuvxk@7znuqgqbyz54>
References: <20260525171931.4144395-1-willy@infradead.org>
 <20260525171931.4144395-13-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525171931.4144395-13-willy@infradead.org>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D38F76700F
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,infradead.org:email,suse.cz:email,suse.cz:dkim];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]

On Mon 25-05-26 18:19:05, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call by converting
> ext4_end_bitmap_read() from bh_end_io_t to bio_end_io_t and
> calling bh_submit().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-ext4@vger.kernel.org

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h   | 10 +++++-----
>  fs/ext4/ialloc.c |  5 ++++-
>  fs/ext4/super.c  | 11 ++++++-----
>  3 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 94283a991e5c..6af11f0ff1c5 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2959,7 +2959,7 @@ extern unsigned long ext4_count_dirs(struct super_block *);
>  extern void ext4_mark_bitmap_end(int start_bit, int end_bit, char *bitmap);
>  extern int ext4_init_inode_table(struct super_block *sb,
>  				 ext4_group_t group, int barrier);
> -extern void ext4_end_bitmap_read(struct buffer_head *bh, int uptodate);
> +void ext4_end_bitmap_read(struct bio *bio);
>  
>  /* fast_commit.c */
>  int ext4_fc_info_show(struct seq_file *seq, void *v);
> @@ -3184,10 +3184,10 @@ extern struct buffer_head *ext4_sb_bread_unmovable(struct super_block *sb,
>  						   sector_t block);
>  extern struct buffer_head *ext4_sb_bread_nofail(struct super_block *sb,
>  						sector_t block);
> -extern void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
> -				bh_end_io_t *end_io, bool simu_fail);
> -extern int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
> -			bh_end_io_t *end_io, bool simu_fail);
> +void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
> +		bio_end_io_t end_io, bool simu_fail);
> +int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
> +		bio_end_io_t end_io, bool simu_fail);
>  extern int ext4_read_bh_lock(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
>  extern void ext4_sb_breadahead_unmovable(struct super_block *sb, sector_t block);
>  extern int ext4_seq_options_show(struct seq_file *seq, void *offset);
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 3fd8f0099852..2db68b1bf855 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -66,8 +66,11 @@ void ext4_mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
>  		memset(bitmap + (i >> 3), 0xff, (end_bit - i) >> 3);
>  }
>  
> -void ext4_end_bitmap_read(struct buffer_head *bh, int uptodate)
> +void ext4_end_bitmap_read(struct bio *bio)
>  {
> +	bool uptodate = bio->bi_status == BLK_STS_OK;
> +	struct buffer_head *bh = bio_endio_bh(bio);
> +
>  	if (uptodate) {
>  		set_buffer_uptodate(bh);
>  		set_bitmap_uptodate(bh);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6a77db4d3124..fbe175951e01 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -161,7 +161,7 @@ MODULE_ALIAS("ext3");
>  
>  
>  static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
> -				  bh_end_io_t *end_io, bool simu_fail)
> +				  bio_end_io_t end_io, bool simu_fail)
>  {
>  	if (simu_fail) {
>  		clear_buffer_uptodate(bh);
> @@ -176,13 +176,14 @@ static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
>  	 */
>  	clear_buffer_verified(bh);
>  
> -	bh->b_end_io = end_io ? end_io : end_buffer_read_sync;
> +	if (!end_io)
> +		end_io = bh_end_read;
>  	get_bh(bh);
> -	submit_bh(REQ_OP_READ | op_flags, bh);
> +	bh_submit(bh, REQ_OP_READ | op_flags, end_io);
>  }
>  
>  void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
> -			 bh_end_io_t *end_io, bool simu_fail)
> +			 bio_end_io_t end_io, bool simu_fail)
>  {
>  	BUG_ON(!buffer_locked(bh));
>  
> @@ -194,7 +195,7 @@ void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
>  }
>  
>  int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
> -		 bh_end_io_t *end_io, bool simu_fail)
> +		 bio_end_io_t end_io, bool simu_fail)
>  {
>  	BUG_ON(!buffer_locked(bh));
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
