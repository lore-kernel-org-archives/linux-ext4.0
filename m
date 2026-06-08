Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59763D47B5
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 14:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929004; cv=none; b=t7spN6il70GO0ogtKjK8ANRmJvQD5tn9XqrDlRvayszkvNQEljhHkGoK/U67FwCffWf5F9Takrxeg2b4U6+dYav5vgyjOxs9qC9o54EpUt9huPGGkDKdOD2bK5/wfV3qwMFot9fMt+T3GKTWkH047/pLtmbd5SgKku8dtSdVNRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929004; c=relaxed/simple;
	bh=wxjmUAkexLEtYIWugWizRowmod73De0kpaIjPusdsGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MI9PYEo+K81F+qB4ujVvKyJaGKh6BDji66xAO0R/42InTYfnv5kxXlZPbcypwoaHHQU83z34FaTpCKgG7wu5p+qsj8ywBj5+r1YXXmSxYxHoCn549xBLiT8SEUKnYoCoZ2sx6jLlizNszuFHIqYoNap6XmHipKIj9QtctnyvbSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QyMe5XtF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zmG9OjsP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ml20sXzN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mbZOlCec; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QyMe5XtF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zmG9OjsP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ml20sXzN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mbZOlCec"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E34C867F28;
	Mon,  8 Jun 2026 14:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780929000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VvDUonLT3OCgA9MeK40rKo/yeppeOcBcsKLLUTrR2wE=;
	b=QyMe5XtFrdHqLQzrQtnnf6D9TBmXc5f8lZSU16D5Tdq2U51PlxzBJHx+CdCYSUo/W+h4Cq
	yyLLOy6NCUVAv09QK+brFLs3PlkdD8girCsAwZ46gObReTLCICZHxVB3oebyvbobduaPnx
	Z5L/7G7wgqBgeEMoE7truUnGboK7/Uc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780929000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VvDUonLT3OCgA9MeK40rKo/yeppeOcBcsKLLUTrR2wE=;
	b=zmG9OjsPUYOC6v3t2SazniR6f1KxnWihsB0ZuE3vXU3yZ9qYrpLrCZT1Z1ssG0wVGUmrxp
	NoLfbggYSN8szjDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ml20sXzN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mbZOlCec
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780928999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VvDUonLT3OCgA9MeK40rKo/yeppeOcBcsKLLUTrR2wE=;
	b=Ml20sXzNiPZEnH+whGxexmtu4pq+RMpOmohEvzwYLtmxyM/TmGtfXb/XaSPGPITKTQrAfQ
	1l8h/wow+l87HWL5tkklE81N2tmDQnNud/sw7fTNEPUlR2oDiyAbwk01UINl06ro2ri8Pd
	S7IVc7n29lGhqzmgENZVhzw0P30tIwM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780928999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VvDUonLT3OCgA9MeK40rKo/yeppeOcBcsKLLUTrR2wE=;
	b=mbZOlCecyrFySikj68e4XwdyD1zHwPaflkQM/ksUrYK6Bv5l2Eht1I8MYxfHBLAMnm7Rtw
	Tnd273+2HcumCtAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6D4A779A7;
	Mon,  8 Jun 2026 14:29:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xWtpNOfRJmr/PQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 08 Jun 2026 14:29:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 76D82A0923; Mon, 08 Jun 2026 16:29:59 +0200 (CEST)
Date: Mon, 8 Jun 2026 16:29:59 +0200
From: Jan Kara <jack@suse.cz>
To: Jia Zhu <zhujia.zj@bytedance.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ext4: avoid tail write_begin walk for uptodate
 folios
Message-ID: <slupx7cfhq4uuk5bd3xnzu7ybnnqghzrseg3xjao6x7tbj75v3@jxv32j4em2cu>
References: <20260603134800.25155-1-zhujia.zj@bytedance.com>
 <20260608120131.45146-1-zhujia.zj@bytedance.com>
 <20260608120131.45146-3-zhujia.zj@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608120131.45146-3-zhujia.zj@bytedance.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,infradead.org,zeniv.linux.org.uk,kernel.org,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,bytedance.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E34C867F28
X-Spam-Score: -2.51

On Mon 08-06-26 20:01:31, Jia Zhu wrote:
> Ext4 buffered writes into large folios also pay a full buffer_head
> walk in ext4_block_write_begin().  For a small overwrite of an existing
> cached folio, the folio is already uptodate and the write only needs to
> prepare the buffers through the written range.  Walking the suffix still
> makes the write_begin cost proportional to the folio size.
> 
> Before ext4 enabled large folios for regular files, the same loop was
> bounded by a single page of buffers.  That commit made the existing
> full-folio walk visible as a regression for cached small overwrites.
> 
> The suffix walk is needed for non-uptodate folios, where ext4 may have
> to submit reads for partial blocks, preserve new-buffer cleanup, and run
> error zeroing.  Keep those folios on the old full walk.
> 
> For already-uptodate folios, keep the walk starting at the first buffer
> rather than seeking directly to from.  This preserves the existing prefix
> buffer state handling.  Stop once block_start reaches the end of the
> write range, because the skipped suffix would only repeat the
> outside-range uptodate handling for buffers beyond @to.
> 
> On current master, the libMicro ext4 large-folio overwrite test shows
> the following full-series result.  Results are median usecs/call over 10
> runs, lower is better:
> 
> case        nofix     this series   improvement
> write_u1k   1.418     0.3405        76.0%
> write_u10k  1.887     0.4175        77.9%
> pwrite_u1k  1.6775    0.3390        79.8%
> pwrite_u10k 1.9035    0.4130        78.3%
> 
> Fixes: 7ac67301e82f0 ("ext4: enable large folio for regular file")
> Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>

Looks good, just one simplification suggestion:

> @@ -1193,13 +1194,14 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
>  		head = create_empty_buffers(folio, blocksize, 0);
>  	block = EXT4_PG_TO_LBLK(inode, folio->index);
>  
> -	for (bh = head, block_start = 0; bh != head || !block_start;
> +	for (bh = head, block_start = 0;
> +	     (bh != head || !block_start) &&
> +	     (!folio_uptodate || block_start < to);

You simplify this condition to:

  block_start < to || (!folio_uptodate && bh != head)

With this updated feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


>  	    block++, block_start = block_end, bh = bh->b_this_page) {
>  		block_end = block_start + blocksize;
>  		if (block_end <= from || block_start >= to) {
> -			if (folio_test_uptodate(folio)) {
> +			if (folio_uptodate)
>  				set_buffer_uptodate(bh);
> -			}
>  			continue;
>  		}
>  		if (WARN_ON_ONCE(buffer_new(bh)))
> @@ -1220,7 +1222,7 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
>  				if (should_journal_data)
>  					do_journal_get_write_access(handle,
>  								    inode, bh);
> -				if (folio_test_uptodate(folio)) {
> +				if (folio_uptodate) {
>  					/*
>  					 * Unlike __block_write_begin() we leave
>  					 * dirtying of new uptodate buffers to
> @@ -1237,7 +1239,7 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
>  				continue;
>  			}
>  		}
> -		if (folio_test_uptodate(folio)) {
> +		if (folio_uptodate) {
>  			set_buffer_uptodate(bh);
>  			continue;
>  		}
> -- 
> 2.20.1
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
