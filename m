Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8929735C1BD
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 12:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612901; cv=none; b=qDf4ShJhm6ByCn2O5Ohh2Vewv/kARowOLPcqOwOgILnZPxo2J/6VbPohO27u3Qyji3g9/YhfhpY8AuY4gjmGuNXf5JNCjkqwtBLIcP6DwGh5ctkXs4/60t9NYzloS2Ia306oIvH56s9+Y0OZ1Z0W9P3wk2f9ceVS2KVvOFXLsCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612901; c=relaxed/simple;
	bh=IJzz3AUa/fKAzmvSO5sFPiYC4YUlQ04PFwaAk/AFmMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Syp+bf2kPQ5y4QX3eMtlHhNXWCk1/VddUGLgFHxIfPzO/9yJrY6TdxuthEl4ApR6edFKf1uXTWAKy56D8fZvoWbqVlCgI91eboD/i8FcRTiY1XrpH/ZfxxGa2vgFZ/yvVdiEgiOfVGKBQhptfPlW7Wgy/Biu/ZqVA+yq0DjQklI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bV0s3XO3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lAoyKulM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bV0s3XO3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lAoyKulM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bV0s3XO3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lAoyKulM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bV0s3XO3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lAoyKulM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B02A675971;
	Tue, 16 Jun 2026 12:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781612897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7HwjqLn4MM0BC8WdaPSWwy1b/pEhkUls9I9uGJQju2A=;
	b=bV0s3XO3K1kWDk8Ao5GVJVPfFNs9zoMsK2QyEy4byq5wCbjsOUGHxfR7dKHC31z7drPDeg
	kckjz4VGGq3vl61QrXChHebH4CsxY/VlGu1WAnVGcd80CbpzDdGmPZmzovM4auNejgG5vr
	5R4lMSDMlvvLgknNjToFrEk61Upa0uA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781612897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7HwjqLn4MM0BC8WdaPSWwy1b/pEhkUls9I9uGJQju2A=;
	b=lAoyKulM5t0RYCKBbf6EJSVKlXUajZUm67Ktn18LV6fEcBCyLYlDuSio+aHPwD7y4rGQCX
	1iP++Wl23OIzg7Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781612897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7HwjqLn4MM0BC8WdaPSWwy1b/pEhkUls9I9uGJQju2A=;
	b=bV0s3XO3K1kWDk8Ao5GVJVPfFNs9zoMsK2QyEy4byq5wCbjsOUGHxfR7dKHC31z7drPDeg
	kckjz4VGGq3vl61QrXChHebH4CsxY/VlGu1WAnVGcd80CbpzDdGmPZmzovM4auNejgG5vr
	5R4lMSDMlvvLgknNjToFrEk61Upa0uA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781612897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7HwjqLn4MM0BC8WdaPSWwy1b/pEhkUls9I9uGJQju2A=;
	b=lAoyKulM5t0RYCKBbf6EJSVKlXUajZUm67Ktn18LV6fEcBCyLYlDuSio+aHPwD7y4rGQCX
	1iP++Wl23OIzg7Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A48B4779A8;
	Tue, 16 Jun 2026 12:28:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EuUkKGFBMWpCbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Jun 2026 12:28:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 426EFA12D3; Tue, 16 Jun 2026 14:28:17 +0200 (CEST)
Date: Tue, 16 Jun 2026 14:28:17 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 14/23] ext4: implement partial block zero range path
 using iomap
Message-ID: <c2q54d6u724xctkzwm6x7sbmg5cpvcackfz3toc47qts6iaj77@ci2czn4fqjik>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-15-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-15-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,huawei.com:email];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 11-05-26 15:23:34, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Introduce a new iomap_ops instance, ext4_iomap_zero_ops, along with
> ext4_iomap_block_zero_range() to implement block zeroing via the iomap
> infrastructure for ext4.
> 
> ext4_iomap_block_zero_range() calls iomap_zero_range() with
> ext4_iomap_zero_begin() as the callback. The callback locates and zeros
> out either a mapped partial block or a dirty, unwritten partial block.
> 
> Important constraints:
> 
> Zeroing out under an active journal handle can cause deadlock, because
> the order of acquiring the folio lock and starting a handle is
> inconsistent with the iomap writeback path.
> 
> Therefore, ext4_iomap_block_zero_range():
> - Must NOT be called under an active handle.
> - Cannot rely on data=ordered mode to ensure zeroed data persistence
>   before updating i_disksize (for the cases of post-EOF append write,
>   post-EOF fallocate, and truncate up). In subsequent patches, we will
>   address this by synchronizing commit I/O but doesn't waiting for
>   completion, and updating i_disksize to i_size only after the zeroed
>   data has been written back.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/inode.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 92 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c6fe42d012fc..e0dae2501292 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4101,6 +4101,51 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
>  	return 0;
>  }
>  
> +static int ext4_iomap_zero_begin(struct inode *inode,
> +		loff_t offset, loff_t length, unsigned int flags,
> +		struct iomap *iomap, struct iomap *srcmap)
> +{
> +	struct iomap_iter *iter = container_of(iomap, struct iomap_iter, iomap);

This looks like a layering violation to me. I don't think you can safely
assume the iomap you're passed is a part of iomap_iter...

> +	struct ext4_map_blocks map;
> +	u8 blkbits = inode->i_blkbits;
> +	unsigned int iomap_flags = 0;
> +	int ret;
> +
> +	ret = ext4_emergency_state(inode->i_sb);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	if (WARN_ON_ONCE(!(flags & IOMAP_ZERO)))
> +		return -EINVAL;
> +
> +	ret = ext4_iomap_map_blocks(inode, offset, length, NULL, &map);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * Look up dirty folios for unwritten mappings within EOF. Providing
> +	 * this bypasses the flush iomap uses to trigger extent conversion
> +	 * when unwritten mappings have dirty pagecache in need of zeroing.
> +	 */
> +	if (map.m_flags & EXT4_MAP_UNWRITTEN) {
> +		loff_t start = ((loff_t)map.m_lblk) << blkbits;
> +		loff_t end = ((loff_t)map.m_lblk + map.m_len) << blkbits;
> +
> +		iomap_fill_dirty_folios(iter, &start, end, &iomap_flags);
> +		if ((start >> blkbits) < map.m_lblk + map.m_len)
> +			map.m_len = (start >> blkbits) - map.m_lblk;
> +	}

... and you need access to iter only for this which seems to be really a
hack that's trying to outsmart the iomap code. I have to admit I don't
fully understand what you are trying to achieve here. Are you trying to
avoid flushing of the range that will be zeroed out?

> +	ret = iomap_zero_range(inode, from, length, did_zero,
> +			       &ext4_iomap_zero_ops, &ext4_iomap_write_ops,
> +			       NULL);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * TODO: The iomap does not distinguish between different types of
> +	 * zeroing and always sets zero_written if a zeroing operation is
> +	 * performed, which may result in unnecessary order operations.
> +	 */

Is this still true after your fix to did_zero handling?

> +	if (did_zero && zero_written)
> +		*zero_written = *did_zero;
> +
> +	return 0;
> +}
> +
>  /*
>   * Zeros out a mapping of length 'length' starting from file offset
>   * 'from'.  The range to be zero'd must be contained with in one block.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
