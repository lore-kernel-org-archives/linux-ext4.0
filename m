Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF243358C9
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jan 2026 12:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769430141; cv=none; b=PvvunM6rADVzEmkcNWjrVqx/NxDFVLTRJB6popWiql/eknrdK31Osy+ze1srLaAXz4AjJK6Xozho+tm3DQ+dP43p7abEukrZoa/KTSsV2049ipNE6dQwX1zHTT5FOvKuP1oQAfghx2o96+tBL9YYfo13cySj/YcM6ISI9RcIjOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769430141; c=relaxed/simple;
	bh=K6ujGXL4OGQe/iBZTLMHc0/mo66cug8bqp3SHVGf+3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TxgAgef3RynSzhe2k3MS+JC1XMr+argPOmirWEGiocpQEFvmKn+WPXyRyiZP1kTU1/12MnOK7A/n0YzHst5fhpEyNpc6BSZaPhG7kwakKep1oTyL0CkdWv4WHFWBgpBYnDHV8XH1PDVpqnk7fhrQfE0WL/mSe+lHBgppxe1oB2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uzguEx/c; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Roe7cxTE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0ayVdLJn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=17nEggQQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uzguEx/c";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Roe7cxTE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0ayVdLJn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="17nEggQQ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D973833707;
	Mon, 26 Jan 2026 12:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769430138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XLK1XBcRKQJ5+EygseMZc3MfbkeMPZUxQu+WfGHZ1r8=;
	b=uzguEx/c1NB9HIbf6dlkv9sq5b+MRYYlZMrc6AP0m5cAaQI6RvBrBsK7S/iDaqTXFYu5d0
	vbaRjYTJrgdX82RdWCsGQrlj6a10D44TvCG1cUMTZpJfvKd5r2TOEsHNrnoeIev4ir1rPA
	h7Xp0JNVwA4WymDmOF34lsYN4CK/Cj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769430138;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XLK1XBcRKQJ5+EygseMZc3MfbkeMPZUxQu+WfGHZ1r8=;
	b=Roe7cxTERHwk7aeETdABWWys3eYFhd4Ft5oBBxfbvx7moS9nNqi0LJYEEd/UmYGO2c8cse
	0qd2bjtmt3X/pRBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0ayVdLJn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=17nEggQQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769430137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XLK1XBcRKQJ5+EygseMZc3MfbkeMPZUxQu+WfGHZ1r8=;
	b=0ayVdLJncgowm9/fbhNwe1TbFR8oW3/TSoCb6pQWI0KwM8jG3XXJc93VTt3fLnx/20qZem
	DPFpeiMHJhh6WrGon2VupMHD5P3pHNUachVe+4IQb1Uc1cuZ/V0GLhvAW3WZnAAkoMnSaw
	7vrJJgjUt8iCR+KqJfpx1udih4HwMm0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769430137;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XLK1XBcRKQJ5+EygseMZc3MfbkeMPZUxQu+WfGHZ1r8=;
	b=17nEggQQPUCQlB3yIcK+KJaN51xDVxWj4RFIrAnquVrU9XLSGGU9pLTQAJmLHp5KHnJomy
	AdfcVMbHW2EdELBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C072B139F0;
	Mon, 26 Jan 2026 12:22:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lwjzLnlcd2nSDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 26 Jan 2026 12:22:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 75F78A0A4F; Mon, 26 Jan 2026 13:22:17 +0100 (CET)
Date: Mon, 26 Jan 2026 13:22:17 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.com>, 
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Andrey Albershteyn <aalbersh@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, fsverity@lists.linux.dev
Subject: Re: [PATCH 03/16] ext4: don't build the fsverity work handler for
 !CONFIG_FS_VERITY
Message-ID: <sxtvrsol43ygrpxdxxu6uecpfrtdzs2ryfvbxituivi5htg5ms@decdqt7bjgcx>
References: <20260126045212.1381843-1-hch@lst.de>
 <20260126045212.1381843-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126045212.1381843-4-hch@lst.de>
X-Spam-Score: -4.01
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D973833707
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Mon 26-01-26 05:50:49, Christoph Hellwig wrote:
> Use IS_ENABLED to disable this code, leading to a slight size reduction:
> 
>    text	   data	    bss	    dec	    hex	filename
>    4121	    376	     16	   4513	   11a1	fs/ext4/readpage.o.old
>    4030	    328	     16	   4374	   1116	fs/ext4/readpage.o
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/readpage.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> index e7f2350c725b..267594ef0b2c 100644
> --- a/fs/ext4/readpage.c
> +++ b/fs/ext4/readpage.c
> @@ -130,7 +130,8 @@ static void bio_post_read_processing(struct bio_post_read_ctx *ctx)
>  		ctx->cur_step++;
>  		fallthrough;
>  	case STEP_VERITY:
> -		if (ctx->enabled_steps & (1 << STEP_VERITY)) {
> +		if (IS_ENABLED(CONFIG_FS_VERITY) &&
> +		    ctx->enabled_steps & (1 << STEP_VERITY)) {
>  			INIT_WORK(&ctx->work, verity_work);
>  			fsverity_enqueue_verify_work(&ctx->work);
>  			return;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
