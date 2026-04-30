Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B340B413247
	for <linux-ext4@vger.kernel.org>; Thu, 30 Apr 2026 13:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777555401; cv=none; b=Z9xSxqbZ0SkZ9JsRK3mpokg21ZaamNiUAVVzyxbJr2awvY1aXTnrk59rAzWC4QyZvTkjD15iYLf3O+V9VpcFO/0jOI3+/PR8vi1cTwEv5qxnXq6c41hfDdHj//xNYvFj4S/Z3tiqbzFcm6lkXJZY5eQXfWpvleTp1MfVmcVwxKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777555401; c=relaxed/simple;
	bh=FOrMjnKBaX9i6lZMqyfe0DgRMtB3s0yfdYOGUJpW4PM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dx3PuddPKOwauqOt3Fj/CQDQVyOp9221FIaq9+90AgHJV1QPYy2haGMib2kdQel9n6GRVhxnyOIMxaWZZvYvdQwgeUqbO0JDYMGFHVrv+qOrHkOxvg31nCvZAPls4Q4HF7Ygv2t9/Bk+NzLfawIIHeXA9QnRvXHHHBO0Hl1FUtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dIgxGwzq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TBFdGpFe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dIgxGwzq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TBFdGpFe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dIgxGwzq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TBFdGpFe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dIgxGwzq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TBFdGpFe"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D21B5BD56;
	Thu, 30 Apr 2026 13:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777555397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ruqM/U1qAm4e+ArmQmo/a/Cr0pBlZQFsZCHSjpM6G3s=;
	b=dIgxGwzqHetY/cs8w2Yv9nocwyXp2wDmgIdCnXXyGSJ6g9ofZ38nwC/B6lcWmgzdkk1dB8
	HrzO63tPZD+q+yobTShLfstHKIBMehYPAw250IDXd7LD11udSH3k5quWbtmyNLP2y6mHec
	0ICitMN2EE5Dq82QPJVU2H+VcywkuOY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777555397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ruqM/U1qAm4e+ArmQmo/a/Cr0pBlZQFsZCHSjpM6G3s=;
	b=TBFdGpFemNdxfhZcjpXevifGhwuc1XhyNTosNrCcU2WbOfbjjmDItONS9D40HBckhl8otC
	xH/8LyNNjk6kFCCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dIgxGwzq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TBFdGpFe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777555397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ruqM/U1qAm4e+ArmQmo/a/Cr0pBlZQFsZCHSjpM6G3s=;
	b=dIgxGwzqHetY/cs8w2Yv9nocwyXp2wDmgIdCnXXyGSJ6g9ofZ38nwC/B6lcWmgzdkk1dB8
	HrzO63tPZD+q+yobTShLfstHKIBMehYPAw250IDXd7LD11udSH3k5quWbtmyNLP2y6mHec
	0ICitMN2EE5Dq82QPJVU2H+VcywkuOY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777555397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ruqM/U1qAm4e+ArmQmo/a/Cr0pBlZQFsZCHSjpM6G3s=;
	b=TBFdGpFemNdxfhZcjpXevifGhwuc1XhyNTosNrCcU2WbOfbjjmDItONS9D40HBckhl8otC
	xH/8LyNNjk6kFCCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11E02593B0;
	Thu, 30 Apr 2026 13:23:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4CBbBMVX82mYMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Apr 2026 13:23:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BD07BA0523; Thu, 30 Apr 2026 15:23:16 +0200 (CEST)
Date: Thu, 30 Apr 2026 15:23:16 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 05/22] ext4: implement buffered read path using iomap
Message-ID: <nz3ieqivswig4tdec4k2yo55w3qskn54f6mynmhqg7kplkcpg3@3pjcib7ehomc>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
 <20260422021042.4157510-6-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422021042.4157510-6-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim,suse.cz:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1D21B5BD56

On Wed 22-04-26 10:10:25, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Implement the iomap read path for ext4 by introducing a new
> ext4_iomap_buffered_read_ops instance. This provides the read_folio()
> and readahead() callbacks for ext4_iomap_aops. The implementation
> introduces:
> 
>  - ext4_iomap_map_blocks(): Helper function to query extent mappings for
>    a given read range using ext4_map_blocks() and convert the mapping
>    information to iomap type
>  - ext4_iomap_buffered_read_begin(): The iomap_begin callback that maps
>    blocks, validates filesystem state, and populates the iomap. It
>    returns -ERANGE for inline data which is not yet supported.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9e9f421888ed..df21f6870ec4 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3908,14 +3908,57 @@ const struct iomap_ops ext4_iomap_report_ops = {
>  	.iomap_begin = ext4_iomap_begin_report,
>  };
>  
> +static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
> +		loff_t length, struct ext4_map_blocks *map)
> +{
> +	u8 blkbits = inode->i_blkbits;
> +
> +	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
> +		return -EINVAL;
> +
> +	/* Calculate the first and last logical blocks respectively. */
> +	map->m_lblk = offset >> blkbits;
> +	map->m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
> +			   EXT4_MAX_LOGICAL_BLOCK) - map->m_lblk + 1;
> +
> +	return ext4_map_blocks(NULL, inode, map, 0);
> +}
> +
> +static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
> +		loff_t length, unsigned int flags, struct iomap *iomap,
> +		struct iomap *srcmap)
> +{
> +	struct ext4_map_blocks map;
> +	int ret;
> +
> +	if (unlikely(ext4_forced_shutdown(inode->i_sb)))
> +		return -EIO;
> +
> +	/* Inline data support is not yet available. */
> +	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
> +		return -ERANGE;
> +
> +	ret = ext4_iomap_map_blocks(inode, offset, length, &map);
> +	if (ret < 0)
> +		return ret;
> +
> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
> +	return 0;
> +}
> +
> +const struct iomap_ops ext4_iomap_buffered_read_ops = {
> +	.iomap_begin = ext4_iomap_buffered_read_begin,
> +};
> +
>  static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
>  {
> +	iomap_bio_read_folio(folio, &ext4_iomap_buffered_read_ops);
>  	return 0;
>  }
>  
>  static void ext4_iomap_readahead(struct readahead_control *rac)
>  {
> -
> +	iomap_bio_readahead(rac, &ext4_iomap_buffered_read_ops);
>  }
>  
>  static int ext4_iomap_writepages(struct address_space *mapping,
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
