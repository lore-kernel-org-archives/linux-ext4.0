Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3863B3D6484
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 10:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779878569; cv=none; b=NGIZaPSK0hVAnwoHBxyJA0Av/yprHii083fDeLStwXe4X61mhmEJq+PH5Le6yHU6X6jLBA7ZW/crhHfuTdrbyQUEArK7EQjPApDf1sQCy8dEQSku77O3b57gh6ZfHpW9L7CMXvZNiRWIOIEWnq7jWB6MLRCUgUcBoJpajUdt+Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779878569; c=relaxed/simple;
	bh=aZCtjDLP0wYFq8VFIVUQtObvvr021sdUW1zNRVbaWes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3FbdCLRvBjuNn2Em7jgUK42d7SUfSfBXJqzjkV1CQeyFDtDudi8qAwRh9lpeOokLXcQu8K1/+2iMVN+cMrEIO96JMonzNugQ+kINnpuZX8hWl5RCYz4rykYLcofblBun+Ez9Z/TBBbWgM4jiEM3a+46H1b/7bVpTyVZPovBEhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d7wWWSfq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AakYucP4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d7wWWSfq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AakYucP4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d7wWWSfq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AakYucP4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d7wWWSfq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AakYucP4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7E1416A956;
	Wed, 27 May 2026 10:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779878566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8asi7M0FF/0l0PZoZrlj9+QiVeEKExZbrnQBjCBcp5Y=;
	b=d7wWWSfqQrDF8HovdDp119021yPH9lpqCqQu5fAOif75teh2SaaGx0EaNqHQz3W+hOrplF
	DcKILYp8nsUUv61C/J7KTuNNL1JT0S5a3g1OpmW/RuhQcZgBHRPwLiIHfbISiZSSgtNsHq
	sgxWvyMTcSOg2R/4Rtwqi7ct4KAUerU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779878566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8asi7M0FF/0l0PZoZrlj9+QiVeEKExZbrnQBjCBcp5Y=;
	b=AakYucP4HzAQQu5TTIBm8EiZ16sRMJTPYMMctjHAPtbZs+tOWjN57Oyg0wOe5s1kcEGtaV
	DsW63PH4fMktrKBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d7wWWSfq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AakYucP4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779878566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8asi7M0FF/0l0PZoZrlj9+QiVeEKExZbrnQBjCBcp5Y=;
	b=d7wWWSfqQrDF8HovdDp119021yPH9lpqCqQu5fAOif75teh2SaaGx0EaNqHQz3W+hOrplF
	DcKILYp8nsUUv61C/J7KTuNNL1JT0S5a3g1OpmW/RuhQcZgBHRPwLiIHfbISiZSSgtNsHq
	sgxWvyMTcSOg2R/4Rtwqi7ct4KAUerU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779878566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8asi7M0FF/0l0PZoZrlj9+QiVeEKExZbrnQBjCBcp5Y=;
	b=AakYucP4HzAQQu5TTIBm8EiZ16sRMJTPYMMctjHAPtbZs+tOWjN57Oyg0wOe5s1kcEGtaV
	DsW63PH4fMktrKBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74F255A7B6;
	Wed, 27 May 2026 10:42:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WQmKHKbKFmpQewAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 27 May 2026 10:42:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 34F8FA0EB5; Wed, 27 May 2026 12:42:46 +0200 (CEST)
Date: Wed, 27 May 2026 12:42:46 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 15/34] ext4: Convert ext4_commit_super() to bh_submit()
Message-ID: <ddvhuy34yrugycgyffy2qyfxqhzt6imb23srzl4dl5jpn6qfhk@yd3ge5oo7a25>
References: <20260525171931.4144395-1-willy@infradead.org>
 <20260525171931.4144395-16-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525171931.4144395-16-willy@infradead.org>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7E1416A956
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
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,infradead.org:email,suse.com:email,suse.cz:email,suse.cz:dkim]

On Mon 25-05-26 18:19:08, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call by using bh_submit() instead of
> submit_bh().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-ext4@vger.kernel.org

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index fbe175951e01..905d66cbe3f2 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -6320,9 +6320,8 @@ static int ext4_commit_super(struct super_block *sb)
>  	get_bh(sbh);
>  	/* Clear potential dirty bit if it was journalled update */
>  	clear_buffer_dirty(sbh);
> -	sbh->b_end_io = end_buffer_write_sync;
> -	submit_bh(REQ_OP_WRITE | REQ_SYNC |
> -		  (test_opt(sb, BARRIER) ? REQ_FUA : 0), sbh);
> +	bh_submit(sbh, REQ_OP_WRITE | REQ_SYNC |
> +		  (test_opt(sb, BARRIER) ? REQ_FUA : 0), bh_end_write);
>  	wait_on_buffer(sbh);
>  	if (buffer_write_io_error(sbh)) {
>  		ext4_msg(sb, KERN_ERR, "I/O error while writing "
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
