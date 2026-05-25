Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31BF3ED5D9
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 15:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779723791; cv=none; b=CwZ/fIty/N+tukI0eMHgxGteDQ6+S32uo1KcRxURGbedtaazvS0d0Ebhh6yU0XovxCPxmg13X2R6/v7AMplBs/XXW0u9L0T0qiGb6O/2qb5siYy/XAmV73C870hgvlAdyCOeM1MLDcN838qP0VFLa6cHW9b+xidMQHDYA1gAvhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779723791; c=relaxed/simple;
	bh=Y4fYIPxehjCL0KYQ9k/3kcJZSfWg1/Q/QTzCuXZIQe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oq0w7vz+8TaM1Vszdr/8NKBSf3IXQ4ata1YFBaLCJSHPuXaiHGztUTIyJFOJPoFm19KweLUeWLH/5VwHDV4ZPsmhfuHckmeoXPM03f1Zb2u6QA1oaxaeslxVVO5r3jnsMjY8i39uBNFhBJzt2oPSlAn+LzqEijSsQwQVw0wPsz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rhIrntdq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/kBvJAn9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rhIrntdq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/kBvJAn9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rhIrntdq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/kBvJAn9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rhIrntdq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/kBvJAn9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1BF096B1E2;
	Mon, 25 May 2026 15:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779723788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wYojGRofkOehfu43x23RRnt9McKigI79nBMd3+tgQrQ=;
	b=rhIrntdqHUK1pOYTx3b0YkXImT+nSWkoGG4kBuiH61z4VzDrAZ66stSEHhltIBK7iyuvxm
	wwU0Vv9olSHsSlORUxdkG5ENxDNfK6zqdFIwip2QFfU6YAUwmlP0huaDKKPdNeIoqOtOaQ
	Dia/z53slKAkx3mV4sz+UQ/lylojOm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779723788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wYojGRofkOehfu43x23RRnt9McKigI79nBMd3+tgQrQ=;
	b=/kBvJAn9bav5INNHNZ0DHHW38425x2p9RSBqA58L/tIQJt7Gy/T99dJ/4g15wU8BsJi2MU
	viCFK/u9FTiiRDAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rhIrntdq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/kBvJAn9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779723788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wYojGRofkOehfu43x23RRnt9McKigI79nBMd3+tgQrQ=;
	b=rhIrntdqHUK1pOYTx3b0YkXImT+nSWkoGG4kBuiH61z4VzDrAZ66stSEHhltIBK7iyuvxm
	wwU0Vv9olSHsSlORUxdkG5ENxDNfK6zqdFIwip2QFfU6YAUwmlP0huaDKKPdNeIoqOtOaQ
	Dia/z53slKAkx3mV4sz+UQ/lylojOm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779723788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wYojGRofkOehfu43x23RRnt9McKigI79nBMd3+tgQrQ=;
	b=/kBvJAn9bav5INNHNZ0DHHW38425x2p9RSBqA58L/tIQJt7Gy/T99dJ/4g15wU8BsJi2MU
	viCFK/u9FTiiRDAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F14CA59D02;
	Mon, 25 May 2026 15:43:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OfrmOgtuFGpYfAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 15:43:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 61208A08D7; Mon, 25 May 2026 17:42:59 +0200 (CEST)
Date: Mon, 25 May 2026 17:42:59 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH] jbd2: update outdated comment for
 jbd2_journal_try_to_free_buffers()
Message-ID: <rccewzvv3cyixfilzq5fvffzyqti3ol6va6uobvz3zw3pspwxl@fxgitfrlipxy>
References: <20260522030540.3896201-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522030540.3896201-1-yi.zhang@huaweicloud.com>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 1BF096B1E2
X-Rspamd-Action: no action
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
	internal_greylist_whitelist(0.00)[2a07:de40:b281:104:10:150:64:97];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Fri 22-05-26 11:05:40, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> jbd2_journal_try_to_free_buffers() currently only tries to remove
> checkpointed data buffers from the checkpoint list for data=journal
> mode, and bails out if any buffer is still attached to a transaction.
> For data=ordered and writeback modes, data buffers never have
> journal_heads, so the function degenerates to a plain
> try_to_free_buffers() call.
> 
> Besides, The release of metadata buffers has been delegated to the jbd2
> journal shrinker in commit 4ba3fcdde7e3 ("jbd2,ext4: add a shrinker to
> release checkpointed buffers"). jbd2_journal_try_to_free_buffers() is
> not used for handling metadata buffers now.
> 
> However, the comment above the function still references
> jbd2_journal_dirty_data(), __jbd2_journal_unfile_buffer(), t_datalist,
> BKL, and BUF_CLEAN, all of which were removed in commit 87c89c232c8f
> ("jbd2: Remove data=ordered mode support using jbd buffer heads").
> 
> Replace it with a description of what the function actually does now.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Thanks for the update. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/transaction.c | 39 ++++++++++++---------------------------
>  1 file changed, 12 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 4885903bbd10..239bcf88ed1c 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -2139,38 +2139,23 @@ static void __jbd2_journal_unfile_buffer(struct journal_head *jh)
>  }
>  
>  /**
> - * jbd2_journal_try_to_free_buffers() - try to free page buffers.
> + * jbd2_journal_try_to_free_buffers() - try to free folio buffers.
>   * @journal: journal for operation
>   * @folio: Folio to detach data from.
>   *
> - * For all the buffers on this page,
> - * if they are fully written out ordered data, move them onto BUF_CLEAN
> - * so try_to_free_buffers() can reap them.
> + * For each buffer_head on @folio, if the buffer has a journal_head but
> + * is not attached to a running or committing transaction, try to remove
> + * it from the checkpoint list.  This is needed for data=journal mode
> + * where data buffers are journaled: once they are checkpointed, the
> + * journal_head can be detached and the buffer freed.  If any buffer is
> + * still attached to a transaction, the folio cannot be released and we
> + * bail out.  Otherwise we call try_to_free_buffers() to detach all
> + * buffer_heads from the folio.
>   *
> - * This function returns non-zero if we wish try_to_free_buffers()
> - * to be called. We do this if the page is releasable by try_to_free_buffers().
> - * We also do it if the page has locked or dirty buffers and the caller wants
> - * us to perform sync or async writeout.
> + * For data=ordered and writeback modes, data buffers never have
> + * journal_heads, so this degenerates to a plain try_to_free_buffers().
>   *
> - * This complicates JBD locking somewhat.  We aren't protected by the
> - * BKL here.  We wish to remove the buffer from its committing or
> - * running transaction's ->t_datalist via __jbd2_journal_unfile_buffer.
> - *
> - * This may *change* the value of transaction_t->t_datalist, so anyone
> - * who looks at t_datalist needs to lock against this function.
> - *
> - * Even worse, someone may be doing a jbd2_journal_dirty_data on this
> - * buffer.  So we need to lock against that.  jbd2_journal_dirty_data()
> - * will come out of the lock with the buffer dirty, which makes it
> - * ineligible for release here.
> - *
> - * Who else is affected by this?  hmm...  Really the only contender
> - * is do_get_write_access() - it could be looking at the buffer while
> - * journal_try_to_free_buffer() is changing its state.  But that
> - * cannot happen because we never reallocate freed data as metadata
> - * while the data is part of a transaction.  Yes?
> - *
> - * Return false on failure, true on success
> + * Return: true if the folio's buffers were freed, false otherwise
>   */
>  bool jbd2_journal_try_to_free_buffers(journal_t *journal, struct folio *folio)
>  {
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
