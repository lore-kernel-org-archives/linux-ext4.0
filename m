Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF0B426EAA
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 10:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781604089; cv=none; b=nmVRiMIqumORJPTu+yv6W3J/O9iwmB0g7TYk5W/ntGVTOsijynZcJyb2Fmq3sx3db0ngWaQL/4TyRdWjeTKZqay5Nf9uilBksmmFMTx+ck96m6zpohghQdVnfwfvpo3RoMbBoFyfc/CF2EbReXF9aSPBNWFf4MbeaBj3emkJRno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781604089; c=relaxed/simple;
	bh=0PPV699pB//1GK7jD76JQ13YcA307/qErFmSNbDE038=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLuzyElrXlp5+BV3bjh0nemE21U7jXyf5JjClh2imoIeKX4cgtizZoPrufpYoO8AJcWKAbGC9LbktM35tcl7H9Ed3/Ak8q5GOuDi/QxVCgvRnUiVQrgxPfX+FriADPthrrXIhJoPVC3U9q+eqJxZrqLbxr0LuTQ2kouErWCcM/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LQBSfd/I; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jpzQnb9e; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lP9Z+h8l; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cYwrbcD3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LQBSfd/I";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jpzQnb9e";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lP9Z+h8l";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cYwrbcD3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5491B7590E;
	Tue, 16 Jun 2026 10:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781604086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AZHdxNTSN+QFgubhisegxM08jjOSW/SoZ+mUm6Offcc=;
	b=LQBSfd/I18z/P4wSLve8pEF5L13rro4QYNerpviYUxJhTJEKlzhN032AKIDbcEZpT9yyit
	Q8PMVC1KIx5072FJdqoxX4OWBWipBAjQeXInTPE7BYoADybyCubcb55kgtNI1NfUYSUHBS
	1QVnOpqLJNk35JOPUX0MaQYG0h0dxjk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781604086;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AZHdxNTSN+QFgubhisegxM08jjOSW/SoZ+mUm6Offcc=;
	b=jpzQnb9eGJ2/bY6IXvM/5X973Mgwv/O1u/jDhRKDFSOJvB84PmC2dMxl7HD16hfBVAolgs
	Peki8bSfO1nMfSDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781604085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AZHdxNTSN+QFgubhisegxM08jjOSW/SoZ+mUm6Offcc=;
	b=lP9Z+h8lRkIuS/t12O9FfJtN1TyHzzTUmtrIguSycVOIuTjOOeFZffh55ClacluGBdMoNt
	jL6QVTULGp0gDnvysFOa5D4gZtTu/6P9Qyf0ZO3z5AFCM2fnbZFsKXqcEmCt6ty6Zjx71u
	NmeRHrhEC/yp0xDCgXRdqjsiCVhT9NQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781604085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AZHdxNTSN+QFgubhisegxM08jjOSW/SoZ+mUm6Offcc=;
	b=cYwrbcD3zJ24JXpV1sdSFo/OJwplabRDlX93gRJ0gIlrLdyChNpRnoXC/z3QrbsmklZtIP
	/ILlf3e0C5ETPCCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 492DF779A8;
	Tue, 16 Jun 2026 10:01:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Bd7aEfUeMWqmWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Jun 2026 10:01:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DDE4DA12D3; Tue, 16 Jun 2026 12:01:20 +0200 (CEST)
Date: Tue, 16 Jun 2026 12:01:20 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 07/23] ext4: do not use data=ordered mode for inodes
 using buffered iomap path
Message-ID: <ffjzk5fvdn2juavzct2e33y5v7qqzekpr4365z5nwl4nrxn5oc@iug2osr5kw77>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-8-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-8-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,huawei.com:email,suse.com:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,huawei.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Mon 11-05-26 15:23:27, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The data=ordered mode introduces two fundamental conflicts with the
> iomap buffered write path, leading to potential deadlocks.
> 
> 1) Lock ordering conflict
>    In the iomap writeback path, each folio is processed sequentially:
>    the folio lock is acquired first, followed by starting a transaction
>    to create block mappings. In data=ordered mode, writeback triggered
>    by the journal commit process may attempt to acquire a folio lock
>    that is already held by iomap. Meanwhile, iomap, under that same
>    folio lock, may start a new transaction and wait for the currently
>    committing transaction to finish, resulting in a deadlock.
> 
> 2) Partial folio submission not supported
>    When block size is smaller than folio size, a folio may contain both
>    mapped and unmapped blocks. In data=ordered mode, if the journal
>    waits for such a folio to be written back while the regular writeback
>    process has already started committing it (with the writeback flag
>    set), mapping the remaining unmapped blocks can deadlock. This is
>    because the writeback flag is cleared only after the entire folio is
>    processed and committed.
> 
> To support data=ordered mode, the iomap core would need two invasive
> changes:
>  - Acquire the transaction handle before locking any folio for
>    writeback.
>  - Support partial folio submission.
> 
> Both changes are complicated and risk performance regressions.
> Therefore, we must avoid using data=ordered mode when converting to the
> iomap path.
> 
> Currently, data=ordered mode is used in three scenarios:
>  - Append write
>  - Post-EOF partial block truncate-up followed by append write
>  - Online defragmentation
> 
> We can address the first two without data=ordered mode:
>  - For append write: always allocate unwritten blocks (i.e. always
>    enable dioread_nolock), preserving the behavior of current
>    extent-type inodes.
>  - For post-EOF truncate-up + append write: postpone updating i_disksize
>    until after the zeroed partial block has been written back.
> 
> Online defragmentation does not yet support iomap; this can be resolved
> separately in the future.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4_jbd2.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 63d17c5201b5..26999f173870 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -383,7 +383,12 @@ static inline int ext4_should_journal_data(struct inode *inode)
>  
>  static inline int ext4_should_order_data(struct inode *inode)
>  {
> -	return ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE;
> +	/*
> +	 * inodes using the iomap buffered I/O path do not use the
> +	 * data=ordered mode.
> +	 */
> +	return !ext4_inode_buffered_iomap(inode) &&
> +		(ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE);
>  }
>  
>  static inline int ext4_should_writeback_data(struct inode *inode)
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
