Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13207371043
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 11:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778499206; cv=none; b=ADtfWzV2OgNy/wAOff1r5jo1LgN0RuRU4LZjpU8JkISXJIFuWU/XXuPsU+Mmdypmq/N5HsrsZGprsS/n62zOHvdZibK5HwNup9Z9OtIQ4LGJM7nKx7UMuYtEHhlbH6Aa9N3kJpxqda/Tc3dzskqrwAW6WcUtz97OgwNoQJXo/hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778499206; c=relaxed/simple;
	bh=i6tZQMdWN1qjmtNkjjQygfk9+4yTzt4j3uU3rDJlm9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lI8vBHUvGXEsbeLnGhfn+HSCFkYFg2eWdpJvOoOLfjD6rxeHMlvycH7iedI2xd9r7dcvggKuxq8jIopccZKJx0IcztvXvA2P02fvtMRI5XuLPMVZKE+f33N87p5wfKC4pnu4BxCxDWQSWJFfiqrsmgVZU9kRBrCuZbqbHmzFD0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HFVKac14; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3F2ee2iR; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HFVKac14; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3F2ee2iR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HFVKac14";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3F2ee2iR";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HFVKac14";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3F2ee2iR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 308A26869F;
	Mon, 11 May 2026 11:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778499202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=muTCtGdZ9tBur4gsVjQibtcaqES36PXZujAiLQBRoLU=;
	b=HFVKac14+WM44qH8SMpQgxh0nELHLLDaHaKUPXl8H3+5joFOla7MNYUMxHhmim6dkPG8/D
	KPqIFsoeqEaEL2FzbYhjOSFHCoSKMVzKzevhM5Sa5RUc3dApxzL0hEEB4Sc/0NmbvfNuZJ
	k9y0ot7ji2O09vq26s6+CEWmCEExuSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778499202;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=muTCtGdZ9tBur4gsVjQibtcaqES36PXZujAiLQBRoLU=;
	b=3F2ee2iRFaP/ynIYoo3AVBX2MF6y+0QNHbgLE9cLt6pRKbvGbbNE0wK4Ws7p4YpBIb/TGO
	yn2LV81nlg4n3kAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HFVKac14;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3F2ee2iR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778499202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=muTCtGdZ9tBur4gsVjQibtcaqES36PXZujAiLQBRoLU=;
	b=HFVKac14+WM44qH8SMpQgxh0nELHLLDaHaKUPXl8H3+5joFOla7MNYUMxHhmim6dkPG8/D
	KPqIFsoeqEaEL2FzbYhjOSFHCoSKMVzKzevhM5Sa5RUc3dApxzL0hEEB4Sc/0NmbvfNuZJ
	k9y0ot7ji2O09vq26s6+CEWmCEExuSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778499202;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=muTCtGdZ9tBur4gsVjQibtcaqES36PXZujAiLQBRoLU=;
	b=3F2ee2iRFaP/ynIYoo3AVBX2MF6y+0QNHbgLE9cLt6pRKbvGbbNE0wK4Ws7p4YpBIb/TGO
	yn2LV81nlg4n3kAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2700B593A3;
	Mon, 11 May 2026 11:33:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CDx3CYK+AWo5LwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 11:33:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BCE34A079E; Mon, 11 May 2026 13:33:21 +0200 (CEST)
Date: Mon, 11 May 2026 13:33:21 +0200
From: Jan Kara <jack@suse.cz>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
Subject: Re: [PATCH] jbd2: check for aborted handle in
 jbd2_journal_dirty_metadata()
Message-ID: <3yumx4zxs7lpnnwpb3vl76btnr3xy6vjc2qzmmyde5a5enzsqn@l3eicc2vhwlj>
References: <20260507050605.50081-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507050605.50081-1-kartikey406@gmail.com>
X-Spam-Flag: NO
X-Spam-Score: -2.51
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
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[98f651460e558a21baae];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,syzkaller.appspot.com:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,appspotmail.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 308A26869F
X-Spam-Level: 

On Thu 07-05-26 10:36:05, Deepanshu Kartikey wrote:
> jbd2_journal_dirty_metadata() unconditionally dereferences
> handle->h_transaction at function entry to obtain the journal pointer:
> 
> 	transaction_t *transaction = handle->h_transaction;
> 	journal_t *journal = transaction->t_journal;
> 
> However, h_transaction may legitimately be NULL for an aborted handle.
> The is_handle_aborted() helper in include/linux/jbd2.h explicitly
> treats !h_transaction as one of the aborted states:
> 
> 	if (handle->h_aborted || !handle->h_transaction)
> 		return 1;
> 
> Every other entry point in fs/jbd2/transaction.c
> (jbd2_journal_get_{write,undo,create}_access, jbd2_journal_extend,
> jbd2_journal_restart, jbd2_journal_stop, etc.) guards against this
> with an is_handle_aborted() check before any dereference of
> h_transaction. jbd2_journal_dirty_metadata() was missing this guard.
> 
> This is reachable from ocfs2's xattr code. ocfs2_xa_set() intentionally
> falls through to ocfs2_xa_journal_dirty() even after
> ocfs2_xa_prepare_entry() fails, on the assumption that the buffer
> needs to be journaled to record any partial modifications (see the
> comment above the out_dirty label in fs/ocfs2/xattr.c). If the failure
> was caused by the journal being aborted -- e.g. an underlying I/O
> error during a sub-operation such as __ocfs2_remove_xattr_range() --
> the handle's h_transaction has been cleared by the abort path, and
> the unconditional deref in jbd2_journal_dirty_metadata() becomes a
> NULL deref.
> 
> Reproduced by syzbot with a crafted ocfs2 image where I/O against the
> loop device backing the mount is sabotaged via LOOP_SET_STATUS64
> between two setxattr() calls, causing the second setxattr (which
> truncates an external xattr value) to abort the journal mid-flight:
> 
>   Oops: general protection fault, probably for non-canonical
>         address 0xdffffc0000000000
>   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>   RIP: jbd2_journal_dirty_metadata+0x4a/0xd30 fs/jbd2/transaction.c:1520
>   Call Trace:
>    ocfs2_journal_dirty+0x130/0x700 fs/ocfs2/journal.c:831
>    ocfs2_xa_journal_dirty fs/ocfs2/xattr.c:1483 [inline]
>    ocfs2_xa_set+0x15e3/0x2ec0 fs/ocfs2/xattr.c:2294
>    ocfs2_xattr_block_set+0x3e0/0x33c0 fs/ocfs2/xattr.c:3016
>    __ocfs2_xattr_set_handle+0x6b3/0xf50 fs/ocfs2/xattr.c:3418
>    ocfs2_xattr_set+0xf3f/0x13e0 fs/ocfs2/xattr.c:3681
>    __vfs_setxattr+0x43c/0x480 fs/xattr.c:218
>    ...
> 
> Fix by adding the standard is_handle_aborted() guard at the top of
> jbd2_journal_dirty_metadata() and returning -EROFS, matching the
> pattern used by every other entry point in this file.
> ocfs2_journal_dirty() already handles a non-zero return from
> jbd2_journal_dirty_metadata() correctly.
> 
> Reported-by: syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=98f651460e558a21baae
> Tested-by: syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Looks sensible. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/transaction.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 4885903bbd10..aa0be9e9c876 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1516,14 +1516,19 @@ void jbd2_buffer_abort_trigger(struct journal_head *jh,
>   */
>  int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
>  {
> -	transaction_t *transaction = handle->h_transaction;
> -	journal_t *journal = transaction->t_journal;
> +	transaction_t *transaction;
> +	journal_t *journal;
>  	struct journal_head *jh;
>  	int ret = 0;
>  
> +	if (is_handle_aborted(handle))
> +		return -EROFS;
>  	if (!buffer_jbd(bh))
>  		return -EUCLEAN;
>  
> +	transaction = handle->h_transaction;
> +	journal = transaction->t_journal;
> +
>  	/*
>  	 * We don't grab jh reference here since the buffer must be part
>  	 * of the running transaction.
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
