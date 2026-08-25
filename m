Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C0038F945;
	Wed, 26 Aug 2026 07:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730669; cv=none; b=r2ws/2tkAtC1B+pqrl2Oqkva8FyevcusBCIOPtnc274/gCLO3nsfEDsNYdNJK2S48iCjG16mCm/lN7M7KUCRn4oISTQZzlRykl79EUVoEyf0NXlvhm3epMiC9IzVkcoKsQDmuIgXAt+3iUCBal46FTDHtDNlLZbJdOWjODBhZEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730669; c=relaxed/simple;
	bh=i6NCOICGVtvGcy4FZW/c7bFeSOTDTlv0mLViiYjIDS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWgxfeIbXESZu0KT3DdXcrfbfoMKitmruS2iPiKPir0PjmMJuA5JSI1oQXm4q/0whuzik3hjWxmuF0+8zXnfCwWclpuLgaaZqDGMkDHhlBWWkowyw6+/ryHDnKR9K792m1WCLC7cRDUyQQvDnfkvexdrckbgdiP6BfpHIkeKiAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UkEEhaQP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vFlO55ye; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=U5WDpH7x; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZTQneH5A; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UkEEhaQP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vFlO55ye";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="U5WDpH7x";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZTQneH5A"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AAE2E8735E;
	Wed, 26 Aug 2026 07:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nEC/Gv24hamlh95icgdBAMFkCRVIb1AISUf3N5E2+r0=;
	b=UkEEhaQPliTBARmeI9uN89WCWdjY5oVOYKxRW0Qv2b3abLe3TmyFN4dGl3o1HowCehzziO
	sDtXcyDCVIz9ubjxXOFtIuWEJ3GhuwtZ09+rFW0TqhUCDqI3j0DO2xEZxJwoMQmxKy2IhS
	zzy1n8xb9SReDXg5bSYd8SE3x2AkyjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nEC/Gv24hamlh95icgdBAMFkCRVIb1AISUf3N5E2+r0=;
	b=vFlO55yeyDylgfChQDkPY453zbKb0mCgoS7+TZlbF09s46yb36ew2opq6yyAr/vgzC5+s6
	qhztHdOZhWKYDlDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=U5WDpH7x;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZTQneH5A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nEC/Gv24hamlh95icgdBAMFkCRVIb1AISUf3N5E2+r0=;
	b=U5WDpH7xFaZEFTVd8mEp4bAay+BC44JLfRaReBXnIOpLmKorWKRlXYiXl5koxtQvqin9cW
	FmI9hBiA1fwaSrNZoltseK09SUQJ3UCCknIbAvoYmD4YYHi6BW3aHmmtKR1PSTygXfg+cv
	3/oFJomhBG88VevUj35zLD/L2o56Qk4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nEC/Gv24hamlh95icgdBAMFkCRVIb1AISUf3N5E2+r0=;
	b=ZTQneH5ASMW7pHapbPz8HG8QQk1ZlXFSZlvi5RPLV7emkgpO7aNztvi3WHlDQ//fWrZmDa
	xN+zQMGkMr4xmsDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A645F1368F;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fB+XKKOajmoQDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EC0FBA13A6; Tue, 25 Aug 2026 18:10:45 +0200 (CEST)
Date: Tue, 25 Aug 2026 18:10:45 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
Subject: Re: [PATCH v2 04/21] buffer: read the folio's mapping directly in
 buffer_set_crypto_ctx()
Message-ID: <5oqsn2wtvdtobeehgenfqvubxqm73yucenwvl2sqgg3r43xwrc@q3v7xqacrz3h>
References: <cover.1785951556.git.coshi036@gmail.com>
 <3fe72ec37bf8491a69031db5f3ba1319da935b97.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fe72ec37bf8491a69031db5f3ba1319da935b97.1785951556.git.coshi036@gmail.com>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: AAE2E8735E
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[infradead.org:email,suse.cz:email,suse.cz:dkim,suse.com:email,fiu.edu:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[27];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	R_RATELIMIT(0.00)[to_ip_from(RLr6u35b1fsnb818ss3au1oekd)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Thu 06-08-26 12:58:27, Chao Shi wrote:
> folio_mapping() was doing two jobs here.  One was to turn a slab folio into
> NULL, which is what made this safe for jbd2's shadow buffers; the previous
> patch removed the need for that by giving those buffers no folio at all.
> 
> The other is a hazard.  folio_mapping() maps a folio in the swap cache to
> its swap_address_space, so if a buffer_head were ever attached to such a
> folio this would hand fscrypt a swap mapping and dereference ->host on it.
> There is no reason to want that here: this path wants the file's mapping or
> nothing.
> 
> Read ->mapping directly.  Buffers with no folio are already handled above.
> 
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 04fcc34e4fa6..2851830995d8 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1108,7 +1108,7 @@ static void buffer_set_crypto_ctx(struct bio *bio, const struct buffer_head *bh,
>  	 */
>  	if (!bh->b_folio)
>  		return;
> -	mapping = folio_mapping(bh->b_folio);
> +	mapping = bh->b_folio->mapping;
>  	if (!mapping)
>  		return;
>  	fscrypt_set_bio_crypt_ctx(bio, mapping->host,
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
