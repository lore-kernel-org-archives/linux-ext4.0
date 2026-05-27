Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3B33BD657
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 10:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779879286; cv=none; b=rfR9AY36iyeAg+6uzDlgyzPmPtOC5IMx4Ent3IBKeMf3Tp/ru8F79ypdg5PxX7oxWv/GVLzNhzX9l9PuviTsShPdxjITbbVCtzcMWyq3p3tM4FnQvO5dPnJQoZMPTGkymLQRDljCe+mcqEQncpAxKy+6U95niEN2PHkYebwEd+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779879286; c=relaxed/simple;
	bh=zId7FBrJA0/id38awQyexPi4MmqDkdA4XPKdQo1m7lI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBYev6675sqHF35WoBQPg/heKJoqGVfTgRxmcuUeLFYpVemsXG4g7mTT/P9qzCaf9F6CrNiMwjVTw8uwimdPMlxqpbNNgLbsE2hEabSzRyzlZ50wetd6CVcSHjleyLpD1bFDNhIS3MGay+oOhZlsILTa0hexVJY0BcXVfkudcTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MqJ69iq/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yB8K2sTV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OGXcWC+E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4D3q7Gkz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MqJ69iq/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yB8K2sTV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OGXcWC+E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4D3q7Gkz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 45FBF6AC00;
	Wed, 27 May 2026 10:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779879282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yjhUN7W7l7wcKIQxuJtCdsddmRxKWaQOKr+SmIkuT68=;
	b=MqJ69iq/vkn+pwR9qABkbQ71Tf6pFPfHgCuCCT/V64S/WdFXy3+krO/DdiTEjfZhZBeF1J
	tNvmuVAJ9mSf8wma/t86ae2gSACkhcKnDLoYNCSjFwnyewMzjuw195O4b6UUNaV4QTs5ul
	PsDt9bUBR9xY7MbVXrdd1eX9pzPxZNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779879282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yjhUN7W7l7wcKIQxuJtCdsddmRxKWaQOKr+SmIkuT68=;
	b=yB8K2sTVam/Nhle2oXHdN/+s4YE4HnJhrqliGu8OwF5x+jGdZGbWD8HkgsbsF72IO6mqIn
	R1ozO+2ZkAxBCtBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OGXcWC+E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4D3q7Gkz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779879281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yjhUN7W7l7wcKIQxuJtCdsddmRxKWaQOKr+SmIkuT68=;
	b=OGXcWC+EowTEJFVSGaBwYU6BbkftoKe99nscVJmOEB9OKOb3l/WYljiKTr4laqwt27rFLp
	nHvTs57Bw91AQz8JOC0rZr0uWQqefBS2FkBIyzxUaUcbw6JLW6pwW3MZ3mp+xKMw618+Se
	AWb5YhF5gmoWiLp9ZKGKoWK5b/KyQUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779879281;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yjhUN7W7l7wcKIQxuJtCdsddmRxKWaQOKr+SmIkuT68=;
	b=4D3q7Gkzx6XBDpHb7m6An+5DEPgRTRavY/r5udxIOFQlazhQWJ2s6G8plL9jhzAt1IXeHF
	RZH5ETY5Rs75lwCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DAC65A7C1;
	Wed, 27 May 2026 10:54:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cb0ID3HNFmolCAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 27 May 2026 10:54:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EF474A0EB5; Wed, 27 May 2026 12:54:40 +0200 (CEST)
Date: Wed, 27 May 2026 12:54:40 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 17/34] jbd2: Convert jbd2_write_superblock() to
 bh_submit()
Message-ID: <5cyl4apva4vkj2gfzutam42332yl37obef2evlem4tcyy5gfln@6n54rt7tjm2k>
References: <20260525171931.4144395-1-willy@infradead.org>
 <20260525171931.4144395-18-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525171931.4144395-18-willy@infradead.org>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 45FBF6AC00
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

On Mon 25-05-26 18:19:10, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call by using bh_submit() instead of
> submit_bh().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-ext4@vger.kernel.org

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/journal.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 4f397fcdb13c..a6616380ce38 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1821,8 +1821,7 @@ static int jbd2_write_superblock(journal_t *journal, blk_opf_t write_flags)
>  	if (jbd2_journal_has_csum_v2or3(journal))
>  		sb->s_checksum = jbd2_superblock_csum(sb);
>  	get_bh(bh);
> -	bh->b_end_io = end_buffer_write_sync;
> -	submit_bh(REQ_OP_WRITE | write_flags, bh);
> +	bh_submit(bh, REQ_OP_WRITE | write_flags, bh_end_write);
>  	wait_on_buffer(bh);
>  	if (buffer_write_io_error(bh)) {
>  		clear_buffer_write_io_error(bh);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
