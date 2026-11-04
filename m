Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811120;
	b=AIiMf/D+fXs8k1+q3YhbqA8Rz/jsQ/ZzdEy3oq69eQyoBMn3j5vK0uPqRBjNJLGUdtBl
	 AEVYML8ShfDUt1iGXQNBczZTRN4L4xHIW3NxLgdDKnj4/a/mvt+PE93Rtg87dzT8ikp9E
	 n94krKMwrxB6PF//NfnYaz9s5cHcRmJL2kye6FVoxjDWcGM+Gk+B5OnqQy6X0DdXJJzkj
	 a65O4Njmb7s+7b4GNfPnt7v9Rm/+f+n990EgO0byhbr1nb51KdjqoH73582hpgJOP3lHh
	 V3ZcmNWI6CVrwK+jSHXYOCiBqOz0JTRnfi53LhivL+ZA6REc5JSOhAIFKknwwSHod9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811120;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=q09G0Aw7d4VDdeSkcwEBqgMj77+p3jsgBtovOOCEeOA=;
	b=CcI3HvY5WaBtZaN65zfbYYWgjn4HG++Q1NE0i+nuD//o3i0aUOpnJjYd7X+mBwKdc5yV
	 xE/DMl0JfBhj33O8QKxcJ71MHoVc0r0jmFzkSusnCb1iXnPc0OZUKl3mVXxfqS1rd0hfZ
	 q2hL9NiZYSSKsTNmlg8bN/yh6oFY7LFPSP9km1C3OT64wPEMBdLN/BA/kGXLYqq9KdJTe
	 jNsVHNBqIu/z5aNFCCJRSfZoFd5qiWVw9d76B6s+6Vn82NPnThncd80iRiL5tfJW3c8kO
	 IQorVrwgcnxsLKm+Nbah0Al4Y3OOTWYnBB8o/KXcJZfFRlrwhwo59F8Il9dFZ3SrZNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=iErJK+Y5;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="+bx8X/OK";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=iErJK+Y5;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="+bx8X/OK";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A4A606EEBD;
	Wed,  4 Nov 2026 16:51:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49A4A606EEBD
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=iErJK+Y5;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+bx8X/OK;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=iErJK+Y5;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+bx8X/OK
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 27D011F79A;
	Wed,  4 Nov 2026 16:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793811117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q09G0Aw7d4VDdeSkcwEBqgMj77+p3jsgBtovOOCEeOA=;
	b=iErJK+Y5gR9Gjv5/k1apT/Mm9VefEZ3QHI8OVAWHhxGjfibPOHdcr9L14vudbkPXO+n7HE
	w43aVdDcwY88l0u3RHsqK04HAWGgKI7LAf7aQUmPKzjiKzrXR/cb94RwNFONj0N8urFns8
	+vyxQFFP5zFbpDRH4ii/OyovvagUzmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793811117;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q09G0Aw7d4VDdeSkcwEBqgMj77+p3jsgBtovOOCEeOA=;
	b=+bx8X/OK8p1hwRjp2QabLmwn/CFYBIAhxHIOoHnSHKtSPpoctrnA+D3Z/UxSXhr6KZHnIf
	RdGtXzIpb2pbeCDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iErJK+Y5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="+bx8X/OK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793811117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q09G0Aw7d4VDdeSkcwEBqgMj77+p3jsgBtovOOCEeOA=;
	b=iErJK+Y5gR9Gjv5/k1apT/Mm9VefEZ3QHI8OVAWHhxGjfibPOHdcr9L14vudbkPXO+n7HE
	w43aVdDcwY88l0u3RHsqK04HAWGgKI7LAf7aQUmPKzjiKzrXR/cb94RwNFONj0N8urFns8
	+vyxQFFP5zFbpDRH4ii/OyovvagUzmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793811117;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q09G0Aw7d4VDdeSkcwEBqgMj77+p3jsgBtovOOCEeOA=;
	b=+bx8X/OK8p1hwRjp2QabLmwn/CFYBIAhxHIOoHnSHKtSPpoctrnA+D3Z/UxSXhr6KZHnIf
	RdGtXzIpb2pbeCDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 05477134F0;
	Wed,  4 Nov 2026 16:51:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wy9JNqxi62r2BQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 16:51:57 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 864D4B437; Wed, 04 Nov 2026 17:51:56 +0100 (CET)
Date: Wed, 4 Nov 2026 17:51:56 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 1/9] ext2: add ext2_inode_block() helper
Message-ID: <rqitd4futx6jkcl7nd6qjmjhwr7q24cmlpbbbidg5osbovetdj@5oaqbqpui5sb>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-1-7d6c678a585d@kernel.org>
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
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-1-7d6c678a585d@kernel.org>
X-Rspamd-Queue-Id: 27D011F79A
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -11.51

On Thu 29-10-26 14:28:16, Christian Brauner wrote:
> Move the lookup of the inode table block that holds an inode out of
> ext2_get_inode() into a helper. ext2_sync_inode_metadata() is going to
> use it to find the block without reading it from disk.
> 
> No functional changes.
> 
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/inode.c | 49 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 31 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 12ac4cfe1500..940f61a4dde3 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1272,46 +1272,59 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
>  	return 0;
>  }
>  
> -static struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
> -					struct buffer_head **p)
> +/*
> + * Find the inode table block that holds inode @ino and the offset of the
> + * inode in that block.
> + */
> +static int ext2_inode_block(struct super_block *sb, ino_t ino,
> +			    unsigned long *block, unsigned long *offset)
>  {
> -	struct buffer_head * bh;
>  	unsigned long block_group;
> -	unsigned long block;
> -	unsigned long offset;
>  	struct ext2_group_desc * gdp;
>  
> -	*p = NULL;
>  	if ((ino != EXT2_ROOT_INO && ino < EXT2_FIRST_INO(sb)) ||
> -	    ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
> -		goto Einval;
> +	    ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count)) {
> +		ext2_error(sb, "ext2_get_inode", "bad inode number: %lu",
> +			   (unsigned long) ino);
> +		return -EINVAL;
> +	}
>  
>  	block_group = (ino - 1) / EXT2_INODES_PER_GROUP(sb);
>  	gdp = ext2_get_group_desc(sb, block_group, NULL);
>  	if (!gdp)
> -		goto Egdp;
> +		return -EIO;
>  	/*
>  	 * Figure out the offset within the block group inode table
>  	 */
> -	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(sb)) * EXT2_INODE_SIZE(sb);
> -	block = le32_to_cpu(gdp->bg_inode_table) +
> -		(offset >> EXT2_BLOCK_SIZE_BITS(sb));
> +	*offset = ((ino - 1) % EXT2_INODES_PER_GROUP(sb)) * EXT2_INODE_SIZE(sb);
> +	*block = le32_to_cpu(gdp->bg_inode_table) +
> +		(*offset >> EXT2_BLOCK_SIZE_BITS(sb));
> +	*offset &= (EXT2_BLOCK_SIZE(sb) - 1);
> +	return 0;
> +}
> +
> +static struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
> +					struct buffer_head **p)
> +{
> +	struct buffer_head *bh;
> +	unsigned long block;
> +	unsigned long offset;
> +	int err;
> +
> +	*p = NULL;
> +	err = ext2_inode_block(sb, ino, &block, &offset);
> +	if (err)
> +		return ERR_PTR(err);
>  	if (!(bh = sb_bread(sb, block)))
>  		goto Eio;
>  
>  	*p = bh;
> -	offset &= (EXT2_BLOCK_SIZE(sb) - 1);
>  	return (struct ext2_inode *) (bh->b_data + offset);
>  
> -Einval:
> -	ext2_error(sb, "ext2_get_inode", "bad inode number: %lu",
> -		   (unsigned long) ino);
> -	return ERR_PTR(-EINVAL);
>  Eio:
>  	ext2_error(sb, "ext2_get_inode",
>  		   "unable to read inode block - inode=%lu, block=%lu",
>  		   (unsigned long) ino, block);
> -Egdp:
>  	return ERR_PTR(-EIO);
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
