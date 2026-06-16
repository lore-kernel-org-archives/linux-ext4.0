Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B7F436379
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 11:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611018; cv=none; b=Y/DPwTLpUZJ+w32AAis0HD1ESaj0Fm9ep++QeJnET7ZrKttDJpE/xasqFOVub7+swwmq3d/gagYKFijjPbvR4fraCwCgc9ZseCG+f10AEkCDvjm0CYjY6KKsnG0DbuKquPYKPyQHvNq7aqXP3Iztd0404WkvT72ESTcWJR5RZnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611018; c=relaxed/simple;
	bh=jNoPDE9nlHI0+O+RyLWmFSeh1UNDd1tYGSl/VJwt+io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQqJ/XscY+69ANlzd+CD/3+tw95tVs2mNtIN1JeqTfoTH8nTO5qhcIIa/otGSlH8wAIP/pDVWVpfCySHxN4dexE9kpfQWb3HeJ7oELJyMik/uqVV05BHJ1hJ9Dclwg0xE1oKVtj8HuuckeuhwttpbGFnLlv/LMIkoR5up9pvC/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OMSENhOE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=a5go1Lha; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OMSENhOE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=a5go1Lha; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OMSENhOE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="a5go1Lha";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OMSENhOE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="a5go1Lha"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD2716CBDE;
	Tue, 16 Jun 2026 11:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781611015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yxIqZq9KpNR6KdhK4DeFacTSGCWfb4FHNNW6cFC1bZo=;
	b=OMSENhOEm2r/iFkghl6zl1hf3IqrRcqjHy8J1TNu1eYLl4RE4003bR+bdKo6w0PgobLcIH
	4RQHN7fsCw437cO5pYrpBMjHUbS5ugzrNqkBJxKaARTgPxEBNZdKWge5AVwb1y2KEYX4jM
	xmWEwHaZlFeEaJb/qi62m1/DScA2rHQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781611015;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yxIqZq9KpNR6KdhK4DeFacTSGCWfb4FHNNW6cFC1bZo=;
	b=a5go1Lha6UeOlZpNwgCx0Cgr3Utjye9nCGJDZ2Z1iadYZEwZ0JIM4yQ41+U39Sm5hIW0U1
	kO/RU3wWGP/+jNAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OMSENhOE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a5go1Lha
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781611015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yxIqZq9KpNR6KdhK4DeFacTSGCWfb4FHNNW6cFC1bZo=;
	b=OMSENhOEm2r/iFkghl6zl1hf3IqrRcqjHy8J1TNu1eYLl4RE4003bR+bdKo6w0PgobLcIH
	4RQHN7fsCw437cO5pYrpBMjHUbS5ugzrNqkBJxKaARTgPxEBNZdKWge5AVwb1y2KEYX4jM
	xmWEwHaZlFeEaJb/qi62m1/DScA2rHQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781611015;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yxIqZq9KpNR6KdhK4DeFacTSGCWfb4FHNNW6cFC1bZo=;
	b=a5go1Lha6UeOlZpNwgCx0Cgr3Utjye9nCGJDZ2Z1iadYZEwZ0JIM4yQ41+U39Sm5hIW0U1
	kO/RU3wWGP/+jNAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B2416779A8;
	Tue, 16 Jun 2026 11:56:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FEmAKwc6MWqcTgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Jun 2026 11:56:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5AEA5A12D3; Tue, 16 Jun 2026 13:56:51 +0200 (CEST)
Date: Tue, 16 Jun 2026 13:56:51 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 10/23] ext4: implement mmap path using iomap
Message-ID: <qox76cb36ofsg2zxzi6ij7d3yk3qfp75umsur53nic3yfnyuhj@jcnscyxfesht>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-11-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-11-yi.zhang@huaweicloud.com>
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
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BD2716CBDE
X-Spam-Score: -2.51

On Mon 11-05-26 15:23:30, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Introduce ext4_iomap_page_mkwrite() to implement the mmap iomap path
> for ext4. The heavy lifting is delegated to iomap_page_mkwrite(), which
> only requires ext4_iomap_buffered_write_ops and
> ext4_iomap_buffered_da_write_ops to allocate and map blocks.
> 
> Note that the lock ordering between folio lock and transaction start in
> this path is reversed compared to the buffer_head buffered write path.
> The lock ordering documentation in super.c has been updated accordingly.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 32 +++++++++++++++++++++++++++++++-
>  fs/ext4/super.c |  8 ++++++--
>  2 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a80195bd6f20..c6fe42d012fc 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4020,7 +4020,7 @@ static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
>  		return -ERANGE;
>  	if (WARN_ON_ONCE(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>  		return -EINVAL;
> -	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
> +	if (WARN_ON_ONCE(!(flags & (IOMAP_WRITE | IOMAP_FAULT))))
>  		return -EINVAL;
>  
>  	if (delalloc)
> @@ -4080,6 +4080,14 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
>  	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
>  		return 0;
>  
> +	/*
> +	 * iomap_page_mkwrite() will never fail in a way that requires delalloc
> +	 * extents that it allocated to be revoked.  Hence never try to release
> +	 * them here.
> +	 */
> +	if (flags & IOMAP_FAULT)
> +		return 0;
> +
>  	/* Nothing to do if we've written the entire delalloc extent */
>  	start_byte = iomap_last_written_block(inode, offset, written);
>  	end_byte = round_up(offset + length, i_blocksize(inode));
> @@ -7191,6 +7199,23 @@ static int ext4_block_page_mkwrite(struct inode *inode, struct folio *folio,
>  	return ret;
>  }
>  
> +static vm_fault_t ext4_iomap_page_mkwrite(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	const struct iomap_ops *iomap_ops;
> +
> +	/*
> +	 * ext4_nonda_switch() could writeback this folio, so have to
> +	 * call it before lock folio.
> +	 */
> +	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
> +		iomap_ops = &ext4_iomap_buffered_da_write_ops;
> +	else
> +		iomap_ops = &ext4_iomap_buffered_write_ops;
> +
> +	return iomap_page_mkwrite(vmf, iomap_ops, NULL);
> +}
> +
>  vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
> @@ -7213,6 +7238,11 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
>  
>  	filemap_invalidate_lock_shared(mapping);
>  
> +	if (ext4_inode_buffered_iomap(inode)) {
> +		ret = ext4_iomap_page_mkwrite(vmf);
> +		goto out;
> +	}
> +
>  	err = ext4_convert_inline_data(inode);
>  	if (err)
>  		goto out_ret;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 51d87db53543..62bfe05a64bc 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -100,8 +100,12 @@ static const struct fs_parameter_spec ext4_param_specs[];
>   * Lock ordering
>   *
>   * page fault path:
> - * mmap_lock -> sb_start_pagefault -> invalidate_lock (r) -> transaction start
> - *   -> page lock -> i_data_sem (rw)
> + * - buffer_head path:
> + *   mmap_lock -> sb_start_pagefault -> invalidate_lock (r) ->
> + *     transaction start -> folio lock -> i_data_sem (rw)
> + * - iomap path:
> + *   mmap_lock -> sb_start_pagefault -> invalidate_lock (r) ->
> + *     folio lock -> transaction start -> i_data_sem (rw)
>   *
>   * buffered write path:
>   * sb_start_write -> i_rwsem (w) -> mmap_lock
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
