Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC1838E5FF
	for <linux-ext4@vger.kernel.org>; Tue,  7 Apr 2026 11:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775560738; cv=none; b=QKk6w4cw0+goX+rNORtWY5++UcP4s/IiurgUUWhyh5On8OOf0XZjT3ns4tbVckbIYoDyfYqoOrKvQ/edkfvNJwhoQyKosVMEH2+dPf4vEBWzi3B2LuP/ZziCegFtHZRjYWCIMUCswNvrxfjER7PMj1CqUPhQwVr1bLp2NcW5vSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775560738; c=relaxed/simple;
	bh=oHSLnQm8FBZr69KQkxF2q4QPJktH/VQrEkuD2T/fnlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1y5j0JCDecIldIVdHyFyeZo46PMVgMTVDcuLb6VBPqx2sGwY7mLdpqjYUUvJ6fBJ+3sM1ISJ0M8C+V0kf81vmaqQTeOSMp4ylL3kC9e9Ht0AxPgepRwdKJi7FUdEfo97xsE2aJBj5XALpJpcFMh1oNo99AREI8rbte49bXIiJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=X61wEbtJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9twqe/m7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=orzDSBR3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8riQ2kch; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="X61wEbtJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9twqe/m7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="orzDSBR3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8riQ2kch"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DCF714E411;
	Tue,  7 Apr 2026 11:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775560734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l9YLYmtluis1tpq73mggYRWZ92paW/jIuBfk41i/2Z4=;
	b=X61wEbtJ3sTVtfbN5e42XIv0DH6WJ5xXFx3/cOZi7ibEjOefnUsvoDnUNov9Gjbb7SeP8q
	BuIR+NhrhGBUfGbhy4/1kah6oe7fENu/uDBrQBSq8zoHhe/wDUlLxmzab33vLBz5zAbMZt
	kD0PJWpR5K81w+FvU45WmjG1kskOdiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775560734;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l9YLYmtluis1tpq73mggYRWZ92paW/jIuBfk41i/2Z4=;
	b=9twqe/m7jPDUUCDJI+fuAf+6DgVkWCYjcSa2L958F29ehD7cGmCxWbPdkgTR0yopP/7AwR
	7FIEjk5x3NkO5xDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=orzDSBR3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8riQ2kch
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775560733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l9YLYmtluis1tpq73mggYRWZ92paW/jIuBfk41i/2Z4=;
	b=orzDSBR3bUkGdLppu6w82oLYrekNznY2sjQAwuDhEObMUfmchHKoFSBi986R27+ID9zX+9
	ov8oecN/jkdzGjNNxSPZQperX4HLTPbOi1BmBuU/lvK1IDh4KrPdPkh/vxwRpseiEK3fNw
	hUYRWoHklVchEcCrD/DjdjifmAY7wgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775560733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l9YLYmtluis1tpq73mggYRWZ92paW/jIuBfk41i/2Z4=;
	b=8riQ2kchranqa8pD9iW0iDe0CH9bC06QlFDwTaQXIU5weXibx8XXdyvJudVaJbAPR7/BRQ
	Zx9y1QIPlLr98iAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D3A244A0B0;
	Tue,  7 Apr 2026 11:18:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4u+iMx3o1GnSTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 07 Apr 2026 11:18:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 93485A0A81; Tue,  7 Apr 2026 13:18:45 +0200 (CEST)
Date: Tue, 7 Apr 2026 13:18:45 +0200
From: Jan Kara <jack@suse.cz>
To: David Carlier <devnexen@gmail.com>
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ext2: use get_random_u32() where appropriate
Message-ID: <c3c6n77kcdtvjracxc2xoyrg4qkg6mtpmhvgfmpqmu7tath53x@d3gdgyue4qqc>
References: <20260405154717.4705-1-devnexen@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405154717.4705-1-devnexen@gmail.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: DCF714E411

On Sun 05-04-26 16:47:17, David Carlier wrote:
> Use the typed random integer helpers instead of
> get_random_bytes() when filling a single integer variable.
> The helpers return the value directly, require no pointer
> or size argument, and better express intent.
> 
> Signed-off-by: David Carlier <devnexen@gmail.com>

Thanks! I've added the patch to my tree.

								Honza

> ---
>  fs/ext2/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 603f2641fe10..e4136490c883 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1151,7 +1151,7 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
>  		goto failed_mount2;
>  	}
>  	sbi->s_gdb_count = db_count;
> -	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
> +	sbi->s_next_generation = get_random_u32();
>  	spin_lock_init(&sbi->s_next_gen_lock);
>  
>  	/* per filesystem reservation list head & lock */
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
