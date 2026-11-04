Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812169;
	b=Xik5vy90rWfG8XosFJ3M/xUOCCIhZdG5E3ezib8SVO5gH2YMVvP/yEHjMQodyuoz2JaX
	 d6uI3iPhmoYJ/sYER6J1WeZujYw3Lsn6QWriydss20pTEgQ+f0yeEkcBwdbgHNpxnWHFV
	 S7v7YfdL9ekgY2N1dK8XMmNtxw+9ROa2zrLPUJFsOfFsK6t4MbLT7USnN1Mg28j/jfCvM
	 y+vS00xBbYc45TmnM1JD9QzeeXEYSMX+tdq88SCRiTfK6CkRetZp3P/U0PaL5uQusO0jZ
	 mP1s1A5H7yltBz7VK1JzIZDz3naiv1nKwzKPvGv61l4rdI2S3Y9Jy+osTloxxWx9NnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812169;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=WilHG0AKhZKZ2BVfJGb7KuywI2g+/0gLU0st4Fvh0io=;
	b=mrSPum2vUwwfnvq+4aVwq9DHiJ0HoDuuYCo+VlaJfyyFd6JJVzSbX1cEdSTFvc1iJlQV
	 hg7REr0GBfZ7ncLOEHjWNJ9pfNvxFE7XeG3w5PkeJLTPVIZRahIPJkjVUvWgQ4adVLlN5
	 pE1EEiPMBU2qVvlutdoUWTubzZXnGdRj8iEq4tGkc6k1dUSb5jRnyPPiMkh9D0rWhnPrg
	 aOtMZrkiydVMlQVQ8aG7CtIex5XJldZbII7xMwgP95oOmtY+fnVFb8cVWR8nM5Xycvkgi
	 ddxQn+WjK+qEBdaz6nGE2Add5fvClMF1RaWqGXE+jPbqsu6QPcilRNXvzM6N+xQsU5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=in4H9WqV;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4wpX4qYW;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=in4H9WqV;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4wpX4qYW;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4476606A329;
	Wed,  4 Nov 2026 17:09:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4476606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=in4H9WqV;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4wpX4qYW;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=in4H9WqV;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4wpX4qYW
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1E98D1F441;
	Wed,  4 Nov 2026 17:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793812167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WilHG0AKhZKZ2BVfJGb7KuywI2g+/0gLU0st4Fvh0io=;
	b=in4H9WqVp9PNB7trUXEiPzaKXZdQkroTK4iKmWfeQ/F80opabkzqsbFhT4V5AGvsnZpfmM
	R/DwGeOJmJlQLhHz/IHHwvfmAViS6kFTBjSb0zXLlL5UHlop+xDdaQzbEwGkexHUG4N/t+
	AkJ4q6V/hWdFBXaxUmr5VJfpzV1IM8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793812167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WilHG0AKhZKZ2BVfJGb7KuywI2g+/0gLU0st4Fvh0io=;
	b=4wpX4qYWWn7NbajRsVu5aVduq+t4C2Y7v6xUQT2vLL/XMVZ6fY1Skc2GPgCw9OJYyKqRL5
	Lmszdhxhezc1wrBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=in4H9WqV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4wpX4qYW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793812167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WilHG0AKhZKZ2BVfJGb7KuywI2g+/0gLU0st4Fvh0io=;
	b=in4H9WqVp9PNB7trUXEiPzaKXZdQkroTK4iKmWfeQ/F80opabkzqsbFhT4V5AGvsnZpfmM
	R/DwGeOJmJlQLhHz/IHHwvfmAViS6kFTBjSb0zXLlL5UHlop+xDdaQzbEwGkexHUG4N/t+
	AkJ4q6V/hWdFBXaxUmr5VJfpzV1IM8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793812167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WilHG0AKhZKZ2BVfJGb7KuywI2g+/0gLU0st4Fvh0io=;
	b=4wpX4qYWWn7NbajRsVu5aVduq+t4C2Y7v6xUQT2vLL/XMVZ6fY1Skc2GPgCw9OJYyKqRL5
	Lmszdhxhezc1wrBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB356134A5;
	Wed,  4 Nov 2026 17:09:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qjVwMsZm62o+FwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 17:09:26 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 85AEAB449; Wed, 04 Nov 2026 18:09:11 +0100 (CET)
Date: Wed, 4 Nov 2026 18:09:11 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 6/9] minix: don't read the inode block in
 minix_sync_inode_metadata()
Message-ID: <bpxofkghemsq2zjs5xacet6jqevkpvaenkc44j4xxrqrr2ltjq@c42zwfhmc6rh>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-6-7d6c678a585d@kernel.org>
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
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-6-7d6c678a585d@kernel.org>
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
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 1E98D1F441

On Thu 29-10-26 14:28:21, Christian Brauner wrote:
> minix_sync_inode_metadata() looks up the inode block with
> minix_V1_raw_inode() or minix_V2_raw_inode() which read it from disk if
> it isn't cached. But a block that isn't in the buffer cache is neither
> dirty nor under writeback. So there's nothing to write or to wait for
> and reading it in is pointless.
> 
> It's also not something we can afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> sb_find_get_block_nonatomic() instead.
> 
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/minix/inode.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/minix/inode.c b/fs/minix/inode.c
> index 670179173645..756bef4dc832 100644
> --- a/fs/minix/inode.c
> +++ b/fs/minix/inode.c
> @@ -702,24 +702,24 @@ static int minix_sync_inode_metadata(struct inode *inode,
>  {
>  	int err = 0;
>  	struct buffer_head *bh;
> -	void *raw_inode;
> +	int block;
>  
> -	if (INODE_VERSION(inode) == MINIX_V1)
> -		raw_inode = minix_V1_raw_inode(inode->i_sb, inode->i_ino, &bh);
> -	else
> -		raw_inode = minix_V2_raw_inode(inode->i_sb, inode->i_ino, &bh);
> -	if (!raw_inode)
> +	block = minix_inode_block(inode->i_sb, inode->i_ino);
> +	if (!block)
>  		return -EIO;
>  	err = mmb_sync(&minix_i(inode)->i_metadata_bhs);
>  	if (err)
> -		goto out;
> +		return err;
> +	/* A block that isn't cached is neither dirty nor under writeback. */
> +	bh = sb_find_get_block_nonatomic(inode->i_sb, block);
> +	if (!bh)
> +		return 0;
>  	sync_dirty_buffer(bh);
>  	if (buffer_write_io_error(bh)) {
>  		printk("IO error syncing minix inode [%s:%08llx]\n",
>  			inode->i_sb->s_id, inode->i_ino);
>  		err = -EIO;
>  	}
> -out:
>  	brelse(bh);
>  	return err;
>  }
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
