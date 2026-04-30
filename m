Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6A825393B
	for <linux-ext4@vger.kernel.org>; Thu, 30 Apr 2026 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777553744; cv=none; b=ULqcBNUSkCBch02PsNkFGO+O54Zl12RS4jcVj3/fI6odAIOMLAu/kGfH8VtzRSLGU+TxiAVibX3f01zrxVJkfQKKGzdTFjqziO9aU0OpxagQSl0yHo7vXdMyHjirnKdryWf5Zx2YbOYjp6M0eLoP2d1InS4DFWom383A5v4Tu58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777553744; c=relaxed/simple;
	bh=VWdx5G+1v/OkK8tTgREN9ZF7RbO6CNmaFD3Iku2Sq5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6dYUqZoHCsPjIS4yyMtBPP2UCxiEiGiy8lUwHEklEIFYgleQ88UG95Thq3DSJVvkHHaZ1HoiXPeP03c2gmmVKLpyhQeOiwr4KyP5L3CWfLsbkUTMnzz5kTFGth9aBtzrUdB24ltxdjBFMPdz1UTGrSndpFWGMNtFeyyoqVxqf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kimTWDfH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XpJbnw4x; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kimTWDfH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XpJbnw4x; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kimTWDfH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XpJbnw4x";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kimTWDfH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XpJbnw4x"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B3DB26A821;
	Thu, 30 Apr 2026 12:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777553741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b8eN5yl+ioafMhSiq/S8RU+z1lYH18PTGpxReKtmWVA=;
	b=kimTWDfH2TYsOoeGuBjf33JdJ/oQwboirxZIjVl6LySWp6niFdhF0Ohdq0vxwpah3yHnnq
	tObqJotTPQlLAEgVk5wnKDYNfIttG6iYwLDUk6A9wb2eANTebQuRzDofnCNYbCY1W5tN6j
	uqSbnie6k2Ymr3q7YSLJy2jWLe+2nTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777553741;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b8eN5yl+ioafMhSiq/S8RU+z1lYH18PTGpxReKtmWVA=;
	b=XpJbnw4xE8WxiSIEyh3PKBWkibUf/paPt5hPlMFP9NLwO7Sd4A9CXK7EPFBFn8dGGT/NrR
	QnpofZSxqQJZuPDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777553741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b8eN5yl+ioafMhSiq/S8RU+z1lYH18PTGpxReKtmWVA=;
	b=kimTWDfH2TYsOoeGuBjf33JdJ/oQwboirxZIjVl6LySWp6niFdhF0Ohdq0vxwpah3yHnnq
	tObqJotTPQlLAEgVk5wnKDYNfIttG6iYwLDUk6A9wb2eANTebQuRzDofnCNYbCY1W5tN6j
	uqSbnie6k2Ymr3q7YSLJy2jWLe+2nTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777553741;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b8eN5yl+ioafMhSiq/S8RU+z1lYH18PTGpxReKtmWVA=;
	b=XpJbnw4xE8WxiSIEyh3PKBWkibUf/paPt5hPlMFP9NLwO7Sd4A9CXK7EPFBFn8dGGT/NrR
	QnpofZSxqQJZuPDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A8075593B0;
	Thu, 30 Apr 2026 12:55:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tJIAKU1R82mVFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Apr 2026 12:55:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 500C3A0640; Thu, 30 Apr 2026 14:55:37 +0200 (CEST)
Date: Thu, 30 Apr 2026 14:55:37 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 02/22] ext4: factor out ext4_truncate_[up|down]()
Message-ID: <ucwp5hqcp6yghqbvpnmfsznzzuw6g7uerajm5x2zqtcyvsv33f@5ppt5hcffnsf>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
 <20260422021042.4157510-3-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422021042.4157510-3-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,huawei.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Wed 22-04-26 10:10:22, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Refactor ext4_setattr() by introducing two helper functions,
> ext4_truncate_up() and ext4_truncate_down(), to handle size changes. The
> current ATTR_SIZE processing consolidates checks for both shrinking and
> non-shrinking cases, leading to cluttered code. Separating the
> truncation paths improves readability.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Just a few nits below.

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 94283a991e5c..9e4353432325 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3501,6 +3501,23 @@ static inline int ext4_update_inode_size(struct inode *inode, loff_t newsize)
>  	return changed;
>  }
>  
> +/*
> + * Set i_size and i_disksize to 'newsize'.
> + *
> + * Both i_rwsem and i_data_sem are required here to avoid races between
> + * generic append writeback and concurrent truncate that also modify
> + * i_size and i_disksize.
> + */
> +static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
> +{
> +	WARN_ON_ONCE(S_ISREG(inode->i_mode) && !inode_is_locked(inode));
> +
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	i_size_write(inode, newsize);
> +	EXT4_I(inode)->i_disksize = newsize;
> +	up_write(&EXT4_I(inode)->i_data_sem);
> +}
> +

Do we need this in the header later or can we keep it local to inode.c?

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0751dc55e94f..5e913aca6499 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5855,6 +5855,83 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
>  	}
>  }
>  
> +static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t newsize)
> +{
> +	ext4_lblk_t old_lblk, new_lblk;
> +	handle_t *handle;
> +	int ret;
> +
> +	if (!IS_ALIGNED(oldsize | newsize, i_blocksize(inode))) {
> +		ret = ext4_inode_attach_jinode(inode);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
> +	if (oldsize & (i_blocksize(inode) - 1)) {

When you transitioned to IS_ALIGNED above, use it here as well?

> +		ret = ext4_block_zero_eof(inode, oldsize, LLONG_MAX);
> +		if (ret)
> +			return ret;
> +	}

...

> +		if (attr->ia_size > oldsize)
> +			error = ext4_truncate_up(inode, oldsize, attr->ia_size);
> +		else if (shrink)
> +			error = ext4_truncate_down(inode, oldsize,
> +						   attr->ia_size, &orphan);
> +		if (error)
> +			goto out_mmap_sem;
>  
>  		/*
>  		 * Truncate pagecache after we've waited for commit

Hum, why not move the truncate_pagecache() call and ext4_truncate() call
into ext4_truncate_down()? They are not needed in the truncate up case...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
