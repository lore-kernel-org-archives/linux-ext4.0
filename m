Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307AD1F91F6;
	Tue, 13 Oct 2026 12:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894448; cv=none; b=KsXICt6XGy6kjVVq/1mViLG6Ql/WCmnU4idi/uFGEwXTGbUNV7TA66FEhUeN1Ie5oLm0Yr8OYZwZXxApnWHWbysJvdZps3mbMtqhnKdiXmPkB2IfoZrIoUf3lu5Bnm6ZXgBDrgNM3T0Y3V+zOb70noGnbC/A1eNslTdBEdD77hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894448; c=relaxed/simple;
	bh=LsqRiRT9h/fhM0hOL9YyO/pZkazR0OUZ8W80Cm+GM1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iap3BM0x93Ms+r7hif3UWWjpa6wZktZBaMg6LFkCfJBe2hN5cpCcZRQZsgT8j2qbkzB75M30uUjV/85rFFPO9HNwYkSX+J6l7uSfDRyRX4Nj1UDIXhXq+5bIWvMdsHWF5OEFj7Esvbesl/gmr50Xh7IC7qHknF+kAmQeWbQ14og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GPWqjMJ8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pGcR327c; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iIDIhD2C; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4bE8LT9l; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GPWqjMJ8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pGcR327c";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iIDIhD2C";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4bE8LT9l"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5BD1F1F38E;
	Tue, 13 Oct 2026 12:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791894445; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zWVAE1lZRQsxqhvh+wudpgfIToirCW/Iu1gheVKptcc=;
	b=GPWqjMJ8zlWbUypp8KwTPOCyiQ9EFDNlz0Dqnj7KwqkFBjzyrFXAH0h4IwJvlMzFA3NqMJ
	hRr1GsFv4he5jK9hkV7qANz3J8R18fPPb4I/sQ/E2N6qMqP93ihcguQQPLdtMnC7FuNe9G
	Yb+q72dte4Z3aVXj9Hsat1K7VfykfhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791894445;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zWVAE1lZRQsxqhvh+wudpgfIToirCW/Iu1gheVKptcc=;
	b=pGcR327cbsogNdP+m+WGWG+x4zJ0ee3pRJan5C68zFF1Vl6Fw9TyGhtrV/gdbtu53t2gvW
	UyaZCzrJFbU/30Cg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791894443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zWVAE1lZRQsxqhvh+wudpgfIToirCW/Iu1gheVKptcc=;
	b=iIDIhD2CDaVoXIIJfYQcTNuXou3RjOYPHLU2SFVUE/32uDqbxswz56LrMXWCdGr86Lq5Xc
	h9cFYQReblC+Hr7XXLNNdvpUirFLIw7JbdMxrgfuhWjSww3LJH37ZXOWVlsIkXSWdIlBw/
	Y1B10vKF/rRAR5a9mZYWbgwaycfpwyQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791894443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zWVAE1lZRQsxqhvh+wudpgfIToirCW/Iu1gheVKptcc=;
	b=4bE8LT9lZDYlIv/gbCyEnqCcPxsaP0o82x7ZjMSjSw25PP64g/GfMjh/BzEdPyAsJxBF/2
	iGTEIbgJHsic4+Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 292E313341;
	Tue, 13 Oct 2026 12:27:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +b8MAasjzmoQLgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 13 Oct 2026 12:27:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A8A0AA1407; Tue, 13 Oct 2026 14:27:18 +0200 (CEST)
Date: Tue, 13 Oct 2026 14:27:18 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	John Garry <john.garry@linux.dev>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH RFC v2 1/3] ext4: reject atomic writes on inodes that
 can't do direct I/O
Message-ID: <4ob5pj55nwlizyuftsuioyk3jlvpzm2mmf6hs4fzlbxo6ierca@2sq3zbflyakh>
References: <20261012-ext4-atomic-no-fallback-v2-0-c4b30c60e500@columbia.edu>
 <20261012-ext4-atomic-no-fallback-v2-1-c4b30c60e500@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-ext4-atomic-no-fallback-v2-1-c4b30c60e500@columbia.edu>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,lst.de,linux.dev,kernel.org,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,suse.com:email,imap1.dmz-prg2.suse.org:helo,columbia.edu:email,suse.cz:email]

On Mon 12-10-26 13:17:40, Tal Zussman wrote:
> ext4_dio_write_iter() falls back to buffered I/O when the inode can't do
> direct I/O at all, i.e. journaled data, inline data or verity. That
> fallback runs before any atomic write handling, and
> ext4_buffered_write_iter() doesn't look at IOCB_ATOMIC, so an atomic
> write to such an inode is silently done as a plain buffered write with
> no torn-write protection.
> 
> ext4_inode_can_atomic_write() makes it worse for journaled data by
> advertising atomic writes for those inodes: statx() reports atomic write
> limits and the file gets FMODE_CAN_ATOMIC_WRITE, so the write passes the
> VFS checks and reaches the fallback. This is reachable with
> data=journal, or with chattr +j on a nodelalloc mount. Inline data
> inodes don't have the extents flag and verity files can't be opened for
> writing, so those are refused before ext4 sees the write, but the
> fallback would still accept them.
> 
> Reject IOCB_ATOMIC in ext4_buffered_write_iter(), next to the existing
> IOCB_NOWAIT rejection, so neither fallback into it can complete an
> atomic write non-atomically. Also require ext4_dio_alignment() to be
> nonzero in ext4_inode_can_atomic_write(), so statx() stops advertising
> atomic writes for these inodes and VFS refuses RWF_ATOMIC early. The
> runtime check is still needed, as the journal data flag can be changed
> on an open file.
> 
> Fixes: b7987a7d69a4 ("ext4: Support setting FMODE_CAN_ATOMIC_WRITE")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260909-ext4-atomic-no-fallback-v1-1-5a6b9539c002%40columbia.edu
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h | 8 +++++++-
>  fs/ext4/file.c | 8 ++++++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 724a27e8be61..5115f067a9f5 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -4057,12 +4057,18 @@ static inline int ext4_buffer_uptodate(struct buffer_head *bh)
>  	return buffer_uptodate(bh);
>  }
>  
> +/*
> + * Atomic writes are only supported through direct I/O, so an inode that
> + * can't do direct I/O at all (journaled data, inline data, verity) can't do
> + * atomic writes either.
> + */
>  static inline bool ext4_inode_can_atomic_write(struct inode *inode)
>  {
>  
>  	return S_ISREG(inode->i_mode) &&
>  		ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
> -		EXT4_SB(inode->i_sb)->s_awu_min > 0;
> +		EXT4_SB(inode->i_sb)->s_awu_min > 0 &&
> +		ext4_dio_alignment(inode) != 0;
>  }
>  
>  extern int ext4_block_write_begin(handle_t *handle, struct folio *folio,
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 374b4bc25bd5..19a8843ac420 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -339,6 +339,14 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>  	if (iocb->ki_flags & IOCB_NOWAIT)
>  		return -EOPNOTSUPP;
>  
> +	/*
> +	 * Buffered I/O provides no torn-write protection. The direct I/O path
> +	 * falls back here for inodes that can't do direct I/O at all, so an
> +	 * atomic write must be rejected rather than silently done non-atomically.
> +	 */
> +	if (iocb->ki_flags & IOCB_ATOMIC)
> +		return -EOPNOTSUPP;
> +
>  	inode_lock(inode);
>  
>  	/*
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
