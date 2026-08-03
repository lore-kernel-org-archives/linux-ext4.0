Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430B0348896
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 16:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773020; cv=none; b=lmDjo/3OvFuwSk7j8h/s9Yg9B1lHBIafUjwObQ1rTh2UJYToI+BpH/rnAGkEWQG5v4v7ykDwpb1AGVHn8h9UN2CY4Uy2zqgIeJuBHw65a/yhLGj8kwmDHKhOiRmLcSFPJbgCyj5rFI+73kc/CRdJ7C55C93djmBB5q9sm9v9JOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773020; c=relaxed/simple;
	bh=fxgrDFn2ovPuwPObF4his0gLm+ifitfZ5D4aJhwPHd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SfxdXMrntvDKlZTvU396WPzBW5LOOfEGYYkkaX30IiJbW+JJCZIJ+AeYZ91RstHKvk6gNOPJYeguCQOMT88Kra6X4KnHEVIg8D1HUcghL3T1udCTdWX+5RVCP/6JigV7M+SVZiTyTh0kcVyymS0Lv0O7apfAwjnjvLI+h5hwU78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J1DOmKlw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YHLwkzkk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zj08XAoS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=g00+0xcM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J1DOmKlw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YHLwkzkk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zj08XAoS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="g00+0xcM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44BDC3DF7;
	Mon,  3 Aug 2026 16:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785773012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMIViUzrrSvUd0khSjNT+ysqZzR3xemsqastuCXEw+I=;
	b=J1DOmKlwR1Naz+UeDLmHtpuxWxBw7BKVOXGqYlqIKL0CkkQ7GSFiOiYoSEkpywep5Z/nsu
	jryu+3bS13lEDaOWu+1eqLWhjukv04Vp1offOJnQ5cRpgEH8T2xJbZyUdK6GoExclE7mrc
	Ei6Z4eilfMXuRMIt/6KxWGQkc5nROrw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785773012;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMIViUzrrSvUd0khSjNT+ysqZzR3xemsqastuCXEw+I=;
	b=YHLwkzkkRSKLL1mosl3DfxxYHnH9tOvkrDmZYgB7RSpQFuNA9nrk/4we4vLp8Po4+rBek8
	1CdL/NcZUB03D1CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zj08XAoS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g00+0xcM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785773008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMIViUzrrSvUd0khSjNT+ysqZzR3xemsqastuCXEw+I=;
	b=zj08XAoStTVaL46Y5CWSSDI1F+mtSpbz4XRU+XihIwOCgcB+dDEeIlBmyBdN2sjmcYwVoS
	9bzbyIq03MR3wfXiKQ4Ang74Tu05L0HumtppWWsG4ejyNYG1vxXBkilgYmqpcNmJ12RVAl
	bMx/h9kI2rSBlNZkGrL0giDcUPE8UAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785773008;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMIViUzrrSvUd0khSjNT+ysqZzR3xemsqastuCXEw+I=;
	b=g00+0xcMj9bDSe4BASQkEFi0kGsx9jaHn8SfFau+jk52acyy1Q1kpAXux990T5PPei098j
	mKsS9gm7h5MYf+DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36BCD779A1;
	Mon,  3 Aug 2026 16:03:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CRlVDdC7cGqeIAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 16:03:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D3903A13A4; Mon, 03 Aug 2026 18:03:23 +0200 (CEST)
Date: Mon, 3 Aug 2026 18:03:23 +0200
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
Subject: Re: [PATCH 01/19] buffer_head: Remove b_page
Message-ID: <opz7bk3tmzyejeqkxyjhm6siyud6rsefjz7cu3y4benupb4yyf@jx7t75od2vyt>
References: <cover.1785621505.git.coshi036@gmail.com>
 <e0780ecfda9137d5755b4ac3e227152bf4c7983c.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0780ecfda9137d5755b4ac3e227152bf4c7983c.1785621505.git.coshi036@gmail.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email,infradead.org:email];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,infradead.org:email,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 44BDC3DF7
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Sat 01-08-26 18:00:45, Chao Shi wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> All users except bh_offset() have been converted to use b_folio instead.
> Convert bh_offset() and remove b_page.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/buffer_head.h | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index fd2c7115c054..699970b4bbf2 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -59,10 +59,7 @@ struct address_space;
>  struct buffer_head {
>  	unsigned long b_state;		/* buffer state bitmap (see above) */
>  	struct buffer_head *b_this_page;/* circular list of page's buffers */
> -	union {
> -		struct page *b_page;	/* the page this bh is mapped to */
> -		struct folio *b_folio;	/* the folio this bh is mapped to */
> -	};
> +	struct folio *b_folio;		/* the folio this bh is mapped to */
>  
>  	sector_t b_blocknr;		/* start block number */
>  	size_t b_size;			/* size of mapping */
> @@ -172,7 +169,7 @@ static __always_inline int buffer_uptodate(const struct buffer_head *bh)
>  
>  static inline unsigned long bh_offset(const struct buffer_head *bh)
>  {
> -	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
> +	return (unsigned long)(bh)->b_data & (folio_size(bh->b_folio) - 1);
>  }
>  
>  /* If we *know* page->private refers to buffer_heads */
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
