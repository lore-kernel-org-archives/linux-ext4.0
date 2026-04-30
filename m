Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC824218B7
	for <linux-ext4@vger.kernel.org>; Thu, 30 Apr 2026 13:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777555421; cv=none; b=kTKneNv/FSFuB9PNdPpGLCpn9X1oK+ZPJZ2BwiLvqQHooYuKObSftdoBMpwG8UgBArqkKvcIGlbh09WFL2/yx+yGnYcsdvkBRrKt7VuVvogNegKtAHKKvORJyigK01xUhAvGuqjzhAiPkP6wuAG1/EslFUkZnWO/0TY5qNkAozk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777555421; c=relaxed/simple;
	bh=n6mIQ1SY+KMkSAuVisw3yTa0kMmmDndhkyUXNmRVxkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KNwbt9TAOdc/BRG1Z4ukNv6fB03An3Rlyz4nZfioZE5/er9CmV8xd/2Nrpf1bzYhLQd1hql6Hru8mEhSmzkUusTBnfFxTZ6KmrYFCwrXZN7J8JDrk/39M8T0RVDixMH6TP6cO+4SdyP6Hqxo2rTLoNa6uqbOO1fRFIOD9Pk6axo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dQdQ3u66; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=l8Jky8Si; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dQdQ3u66; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=l8Jky8Si; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dQdQ3u66";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="l8Jky8Si";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dQdQ3u66";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="l8Jky8Si"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F3D885BD3C;
	Thu, 30 Apr 2026 13:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777555418; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4ghvDTgv9dsIwv4C2A0WXSHxDlHKLnoYUmvKo4tl2GU=;
	b=dQdQ3u66PcUFyL1L+y0Rp631W0JdyIz1xO5Rp4PVhd4MfqCB1bAqGh7e+IY18PC/km7dur
	zolVeeAS1OEQ9sJ6PEgCdf6JHNjw4VJXqY2TZSzRA1ltP3TK39939tZW8Rj4N3taey8bea
	x6lBY682FE/xaW/JXCI7ovf959IFvOs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777555418;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4ghvDTgv9dsIwv4C2A0WXSHxDlHKLnoYUmvKo4tl2GU=;
	b=l8Jky8SiqaI5kmDFOv0lCuM4QcKCcL/GXikIgYX73klx3XKoaoq+G9ml6mh7tjuXkKe5xS
	XTs9W4sAwNNRreCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777555418; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4ghvDTgv9dsIwv4C2A0WXSHxDlHKLnoYUmvKo4tl2GU=;
	b=dQdQ3u66PcUFyL1L+y0Rp631W0JdyIz1xO5Rp4PVhd4MfqCB1bAqGh7e+IY18PC/km7dur
	zolVeeAS1OEQ9sJ6PEgCdf6JHNjw4VJXqY2TZSzRA1ltP3TK39939tZW8Rj4N3taey8bea
	x6lBY682FE/xaW/JXCI7ovf959IFvOs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777555418;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4ghvDTgv9dsIwv4C2A0WXSHxDlHKLnoYUmvKo4tl2GU=;
	b=l8Jky8SiqaI5kmDFOv0lCuM4QcKCcL/GXikIgYX73klx3XKoaoq+G9ml6mh7tjuXkKe5xS
	XTs9W4sAwNNRreCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB40A593B0;
	Thu, 30 Apr 2026 13:23:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EoZtOdlX82nLMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Apr 2026 13:23:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A4CF9A0523; Thu, 30 Apr 2026 15:23:29 +0200 (CEST)
Date: Thu, 30 Apr 2026 15:23:29 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 04/22] ext4: add iomap address space operations for
 buffered I/O
Message-ID: <l3drgv2f6spaxojcudhg3nakq6tzcikbasxgnyr2fuqz64tukt@vrjellznccu2>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
 <20260422021042.4157510-5-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422021042.4157510-5-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Wed 22-04-26 10:10:24, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Introduce initial support for iomap in the buffered I/O path for regular
> files on ext4.
> 
>   - Add a new inode state flag EXT4_STATE_BUFFERED_IOMAP to indicate the
>     inode uses iomap instead of buffer_head for buffered I/O
>   - Add helper ext4_inode_buffered_iomap() to check the flag
>   - Add new address space operations ext4_iomap_aops with callbacks that
>     will use generic iomap implementations
>   - Add ext4_iomap_aops to ext4_set_aops() when the flag is set
> 
> The following callbacks(read_folio(), readahead(), writepages()) are
> provided as placeholders and will be implemented in later patches.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h  |  7 +++++++
>  fs/ext4/inode.c | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 9e4353432325..fe3491ad2129 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1972,6 +1972,7 @@ enum {
>  	EXT4_STATE_FC_COMMITTING,	/* Fast commit ongoing */
>  	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
>  	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
> +	EXT4_STATE_BUFFERED_IOMAP,	/* Inode use iomap for buffered IO */
>  };
>  
>  #define EXT4_INODE_BIT_FNS(name, field, offset)				\
> @@ -2040,6 +2041,12 @@ static inline bool ext4_inode_orphan_tracked(struct inode *inode)
>  		!list_empty(&EXT4_I(inode)->i_orphan);
>  }
>  
> +/* Whether the inode pass through the iomap infrastructure for buffered I/O */
> +static inline bool ext4_inode_buffered_iomap(struct inode *inode)
> +{
> +	return ext4_test_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP);
> +}
> +
>  /*
>   * Codes for operating systems
>   */
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 59405a95ecfc..9e9f421888ed 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3908,6 +3908,22 @@ const struct iomap_ops ext4_iomap_report_ops = {
>  	.iomap_begin = ext4_iomap_begin_report,
>  };
>  
> +static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
> +{
> +	return 0;
> +}
> +
> +static void ext4_iomap_readahead(struct readahead_control *rac)
> +{
> +
> +}
> +
> +static int ext4_iomap_writepages(struct address_space *mapping,
> +				 struct writeback_control *wbc)
> +{
> +	return 0;
> +}
> +
>  /*
>   * For data=journal mode, folio should be marked dirty only when it was
>   * writeably mapped. When that happens, it was already attached to the
> @@ -3994,6 +4010,20 @@ static const struct address_space_operations ext4_da_aops = {
>  	.swap_activate		= ext4_iomap_swap_activate,
>  };
>  
> +static const struct address_space_operations ext4_iomap_aops = {
> +	.read_folio		= ext4_iomap_read_folio,
> +	.readahead		= ext4_iomap_readahead,
> +	.writepages		= ext4_iomap_writepages,
> +	.dirty_folio		= iomap_dirty_folio,
> +	.bmap			= ext4_bmap,
> +	.invalidate_folio	= iomap_invalidate_folio,
> +	.release_folio		= iomap_release_folio,
> +	.migrate_folio		= filemap_migrate_folio,
> +	.is_partially_uptodate  = iomap_is_partially_uptodate,
> +	.error_remove_folio	= generic_error_remove_folio,
> +	.swap_activate		= ext4_iomap_swap_activate,
> +};
> +
>  static const struct address_space_operations ext4_dax_aops = {
>  	.writepages		= ext4_dax_writepages,
>  	.dirty_folio		= noop_dirty_folio,
> @@ -4015,6 +4045,8 @@ void ext4_set_aops(struct inode *inode)
>  	}
>  	if (IS_DAX(inode))
>  		inode->i_mapping->a_ops = &ext4_dax_aops;
> +	else if (ext4_inode_buffered_iomap(inode))
> +		inode->i_mapping->a_ops = &ext4_iomap_aops;
>  	else if (test_opt(inode->i_sb, DELALLOC))
>  		inode->i_mapping->a_ops = &ext4_da_aops;
>  	else
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
