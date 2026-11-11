Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395527;
	b=4imVjJk7BJwUe0xI2+ylw3KkG3/Y27yUMNWpZ88OhwEigo5VzbbOZU9gGIbqE8B6N1sN
	 Jbb/LBvAw34vaMc6RGEe4HHHybq7oD2LNG36cJbCvoEZxAwcns1Su85gEI8CBKOodK1f2
	 OMkIetD/tCvmtq+wtEKg99Pt3MBMj1zPDxCmCKtvjodhpj+gnbGKLKDBU+117hr6n0bTg
	 JsRNZpd7W+KQ6flUDrFBqTEVqMaJhPPk5R8s0Rqvq2fr+u7hzcSA/SC8r0YrynTRHKT/p
	 x9LKcZbuDnCutHSvjo6AZqXljQ2RKbZAO/dolrqEUvlgLybIrv9dDx3Yy2QijEQ4FZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395527;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=EplsJOyJhXMqWC0WpcKkXMdEbiZRLy8DUQfPYhX4OPk=;
	b=UBcjpryutcDQXiA1AGUlRWmvp1H9JLoj+IVeRpTG1W4izvHuTReQEYe6lib0ENOaelUE
	 DVVPfReEFNE8prlQKloi0tzMJ4zFfrinz3EVPJd/y8zD7J1txngd7Ginc7pLSgUcsMcUc
	 IxYSkXY5lHiDdgY2cXg2LDkby6DhCz6SSe6ITKrvOlV+3IRI6xkYAMXV/uda3FZxesV06
	 Lu/7xeayJ2exhPRSHinn5LiMKi6tWwXhEL3PMDaPAu/prXfiWmCPMnxuLXEao9nl8FUZS
	 sGuap3krLV0LEFfUkpZbRuK3GRKaG+x9BMEiGawTcHtFPJDXRID4vii4d5QDCwD8MSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=t0YCTbF1;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=y7ILrEzc;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=t0YCTbF1;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=y7ILrEzc;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B57606A31C;
	Wed, 11 Nov 2026 11:12:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84B57606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=t0YCTbF1;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=y7ILrEzc;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=t0YCTbF1;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=y7ILrEzc
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0202721D9E;
	Wed, 11 Nov 2026 11:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794395519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EplsJOyJhXMqWC0WpcKkXMdEbiZRLy8DUQfPYhX4OPk=;
	b=t0YCTbF1QZkTm57HjdhB17aPv6TIvKeN09DLy7LgujUYV7XraTykJar6M07G8Wy8d9D9nw
	Rm2C2Sno2i+BJb2z7EosxjIqITn0YIU5mdJbhRodEKUf4Eg93Rsz4Hu5kzbYZ0HHIQQnpr
	LzrMuN4Z0tuyQtsr6PMvmmgP8eXs6cY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794395519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EplsJOyJhXMqWC0WpcKkXMdEbiZRLy8DUQfPYhX4OPk=;
	b=y7ILrEzcOm3veR2gKCT284Ir/AZE+rD7bU1D40UTzUXXcc9Iuxjm8HqzSZh/NT3C0PanGe
	JQ9/tqtZo4EmXdCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=t0YCTbF1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y7ILrEzc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794395519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EplsJOyJhXMqWC0WpcKkXMdEbiZRLy8DUQfPYhX4OPk=;
	b=t0YCTbF1QZkTm57HjdhB17aPv6TIvKeN09DLy7LgujUYV7XraTykJar6M07G8Wy8d9D9nw
	Rm2C2Sno2i+BJb2z7EosxjIqITn0YIU5mdJbhRodEKUf4Eg93Rsz4Hu5kzbYZ0HHIQQnpr
	LzrMuN4Z0tuyQtsr6PMvmmgP8eXs6cY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794395519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EplsJOyJhXMqWC0WpcKkXMdEbiZRLy8DUQfPYhX4OPk=;
	b=y7ILrEzcOm3veR2gKCT284Ir/AZE+rD7bU1D40UTzUXXcc9Iuxjm8HqzSZh/NT3C0PanGe
	JQ9/tqtZo4EmXdCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CDB181339F;
	Wed, 11 Nov 2026 11:11:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CBMOKn5N9GrHQQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 11 Nov 2026 11:11:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 5DB77225DB; Wed, 11 Nov 2026 12:11:58 +0100 (CET)
Date: Wed, 11 Nov 2026 12:11:58 +0100
From: Jan Kara <jack@suse.cz>
To: Alan <3164729207@qq.com>
Cc: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: free the new extent block on failure to grow
 the tree
Message-ID: <ssjxx24dqhcimjd6w7xu4xgkmayzz3zygm3we324uxlxyaouhg@47xvodoxxlhl>
References: <tencent_9EB8EBE910378E46C80E006C6A7DA918BA08@qq.com>
 <tencent_DF25FDEF46DA68C4E18D6DB40F08E30BB705@qq.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_DF25FDEF46DA68C4E18D6DB40F08E30BB705@qq.com>
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
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
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[qq.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 0202721D9E

On Wed 11-11-26 15:34:44, Alan wrote:
> ext4_ext_grow_indepth() allocates and accounts a metadata block before
> getting its buffer, obtaining journal create access and dirtying the
> new extent block. If any of these operations fails, the new block has
> not been linked into the extent tree. However, the error paths return
> without freeing it, leaking the block and leaving i_blocks larger
> than the number of blocks reachable from the inode.
> 
> Commit 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
> removed the implicit __GFP_NOFAIL from the buffer allocation, making
> the allocation failure path reachable. The two journal error paths
> already lacked cleanup before that commit and are fixed here as well.
> 
> Route all three failures through a common cleanup label to free the
> unpublished metadata block and undo its inode accounting. Keep the
> existing buffer unlock and release handling. Once the new block has
> been linked by ext4_idx_store_pblock(), an ext4_mark_inode_dirty()
> failure must not free it because the extent tree already references it.
> 
> Tested on Linux 6.12.1 by injecting NULL for buffer acquisition and
> -EIO for each of the two metadata helper calls at their caller
> boundaries. Each unfixed case leaves seven unreachable blocks and
> i_blocks of 40 instead of 32 on a filesystem with 4 KiB blocks. With
> the fix, all three cases retain i_blocks of 32, preserve the original
> data and pass e2fsck -fn after a normal unmount. Retry, truncate and
> uninjected growth also pass for each case.
> 
> Fixes: 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alan <3164729207@qq.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ad0d80e33f6090..f0b2852f8a9342 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1333,15 +1333,17 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
>  		return err;
>  
>  	bh = sb_getblk_gfp(inode->i_sb, newblock, __GFP_MOVABLE | GFP_NOFS);
> -	if (unlikely(!bh))
> -		return -ENOMEM;
> +	if (unlikely(!bh)) {
> +		err = -ENOMEM;
> +		goto out_free;
> +	}
>  	lock_buffer(bh);
>  
>  	err = ext4_journal_get_create_access(handle, inode->i_sb, bh,
>  					     EXT4_JTR_NONE);
>  	if (err) {
>  		unlock_buffer(bh);
> -		goto out;
> +		goto out_free;
>  	}
>  
>  	ext_size = sizeof(EXT4_I(inode)->i_data);
> @@ -1366,7 +1368,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
>  
>  	err = ext4_handle_dirty_metadata(handle, inode, bh);
>  	if (err)
> -		goto out;
> +		goto out_free;
>  
>  	/* Update top-level index: num,max,pointer */
>  	neh = ext_inode_hdr(inode);
> @@ -1389,6 +1391,12 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
>  	brelse(bh);
>  
>  	return err;
> +
> +out_free:
> +	/* The new block has not been linked into the extent tree yet. */
> +	ext4_free_blocks(handle, inode, NULL, newblock, 1,
> +			 EXT4_FREE_BLOCKS_METADATA);
> +	goto out;
>  }
>  
>  /*
> 
> base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
