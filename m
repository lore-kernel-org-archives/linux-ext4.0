Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313913;
	b=kLM0NCkMPeiVOxViOvMquH9/6ZURcvDiEI7hCfSyYiixXg7NqLs8MicHbOryjOtKWsnV
	 b/vOSBesNRf0KsiB1z+RodJ8yPcbntqqa8mQEgu+rFguqUche4+HHQ6pTRNRZzT3oLVLD
	 7k3T9AqwAHxuOfIs+HJbxO9EHOtJIR+Q6Xv0qUucGaHKUbKEObh3t6ht2rLR+IP0xdtbS
	 eWCnIPH/48VQdcJifmdYNYMHfvxVDXLX5uhk/jUOFKtIH0Xg5j0zh+T3gAMjcNyErW3To
	 3+V3TeKJKV5rgtHq2dvSFxe5fC/1qskUMPO3WFQgH4kzASc0Fkfjcd1oifOhdSwUt/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313913;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=Qb1NmpwfxsibhcfNuBMjvr2vACZ6jsFgtlWvUWxwjbM=;
	b=o8jSTNXvHpiPs9pXFbfDHtwMyExb/+M5Ixb/ZBl8iD7FzGbqdZGhSoQU447okgC/LfSa
	 lMpqL+XfVEzIuXZ2tXG7gBrMuTMe3X4oicQxgkfVMXma3y0WYTLVWbR127McU2VDI3rbg
	 1cirDITUGmwPvVVXU37gHQygoSoGCqFSQPF5UJuLabZRjHBmmgpIhKANh6Ypnp7bfP7D2
	 6rpYIrBPtWUekcjFDSboZblETOdGanbuFuKWXOVLfS6NDccAE5oKRohvc7iLo6TvGdfp4
	 x+Tmdd+ddxycdCLLPQ6AC7i5TmwuuMgSWfEvfBbKOdqXHg1IfFRIHD1jhebks8cQiaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=pfLagRcV;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=h8OtgKmS;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="B7a/enga";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fmo+lr8H;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F659606A31C;
	Tue, 10 Nov 2026 12:31:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F659606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=pfLagRcV;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=h8OtgKmS;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=B7a/enga;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fmo+lr8H
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 66A171F84C;
	Tue, 10 Nov 2026 12:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794313910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qb1NmpwfxsibhcfNuBMjvr2vACZ6jsFgtlWvUWxwjbM=;
	b=pfLagRcVMXKr4d9vPRelm7IOVVImPOLNwpwuwITEKPSU8vexIFkL36yrUSv42xy+PvfH8a
	0iajZLMo2Hd5cEtj5b8XTQGF95wL636kZe5nDIevlA6OOnn8NyXyY9G+rylpoDTIBXLkac
	CF0CiL1fHy6kHGThKlBXTo+IesTgjp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794313910;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qb1NmpwfxsibhcfNuBMjvr2vACZ6jsFgtlWvUWxwjbM=;
	b=h8OtgKmS7W5tIUSEbf2k4CtX89ff7cpKXdKDUdFis1c1yZw6HuKpY90YhDu2c54TSrggpC
	VHPwIz+19JYEgXAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="B7a/enga";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fmo+lr8H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794313909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qb1NmpwfxsibhcfNuBMjvr2vACZ6jsFgtlWvUWxwjbM=;
	b=B7a/engajOJx1AN0ExlsuI12nC41K7fETFxKv75p9oIDTlklDi3VmqPMpem4awrnT6nc9R
	86w7Sdydt4prGAdN6rT8Wph303jtvZLBmoDMYcHTfp88+viISscH5KuiB9UWgSNYhc2BQr
	8zlKJIOfJi5dQjcWEvWES79hiSz1bCo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794313909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qb1NmpwfxsibhcfNuBMjvr2vACZ6jsFgtlWvUWxwjbM=;
	b=fmo+lr8HNxf4btYuX2oZ8EXC1HMH01l0RpgckL8x9NhaG7tOlJbsowuhd71tCzoOVdHBFo
	USWfxn5kg7J1CrCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A8351339F;
	Tue, 10 Nov 2026 12:31:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QcYKBrUO82ojKwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:31:49 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id BE697224C7; Tue, 10 Nov 2026 13:31:48 +0100 (CET)
Date: Tue, 10 Nov 2026 13:31:48 +0100
From: Jan Kara <jack@suse.cz>
To: Alan <3164729207@qq.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: free the new extent block when getting its buffer
 fails
Message-ID: <c24v3lxh2tbx5uw4622vbzrur4dq6hdcezswv7ecqw7n4sxg72@sfx24x535qrq>
References: <tencent_9EB8EBE910378E46C80E006C6A7DA918BA08@qq.com>
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
In-Reply-To: <tencent_9EB8EBE910378E46C80E006C6A7DA918BA08@qq.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,qq.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 66A171F84C

On Tue 10-11-26 15:27:23, Alan wrote:
> ext4_ext_grow_indepth() allocates and accounts a metadata block before
> calling sb_getblk_gfp(). If the buffer allocation fails, the new block
> has not been linked into the extent tree, but the error path returns
> without freeing it. This leaks the block and leaves i_blocks larger
> than the number of blocks reachable from the inode.
> 
> Commit 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
> removed the implicit __GFP_NOFAIL from this allocation, making this
> error path reachable.
> 
> Free the new metadata block before returning -ENOMEM. Use
> ext4_free_blocks() to undo both the allocation and inode accounting.
> 
> Tested on Linux 6.12.1 by injecting a NULL result at the caller's buffer
> acquisition boundary. Before the fix, seven failed extent tree growth
> operations left seven allocated but unreachable blocks and i_blocks of
> 40 instead of 32 on a filesystem with 4 KiB blocks. After the fix, the
> same failures leave i_blocks at 32, and e2fsck -fn passes after a normal
> unmount. Retrying the operation, truncating the file, and growing the
> tree without injection also succeed.
> 
> Fixes: 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alan <3164729207@qq.com>

OK, but this holds for any error in that function at least until we call
ext4_idx_store_pblock(). So please fix at least all occurences in that one
function. Thanks.

								Honza

> ---
>  fs/ext4/extents.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ad0d80e33f6090..7358df54bcd4ae 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1333,8 +1333,12 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
>  		return err;
>  
>  	bh = sb_getblk_gfp(inode->i_sb, newblock, __GFP_MOVABLE | GFP_NOFS);
> -	if (unlikely(!bh))
> +	if (unlikely(!bh)) {
> +		/* The new block has not been linked into the extent tree yet. */
> +		ext4_free_blocks(handle, inode, NULL, newblock, 1,
> +				 EXT4_FREE_BLOCKS_METADATA);
>  		return -ENOMEM;
> +	}
>  	lock_buffer(bh);
>  
>  	err = ext4_journal_get_create_access(handle, inode->i_sb, bh,
> 
> base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
