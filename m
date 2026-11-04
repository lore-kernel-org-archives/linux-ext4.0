Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811228;
	b=ILu5cum2zx6OYqGsHF/Y91pSBUm+P/bviL30c0cS3hBcXJTFj+wUhkLg7O66Q+Whjais
	 Y/yitvXvb7PrdKmiOxgstVV+wGqo8Wua5t2mBEmfXMkoe3jypdUzCj5wpwsU2Sfi61bFW
	 vXTJkPjFG4ndjViv8s5mYMTE13mNVQ+tfGNfA9CjE5+up2QY2XpUmmcTpMnlXHTVE87wV
	 I1QIcyJAJ5T87I+0nsXQL2CCKGNCei6XGByqe+YYN0k/vclHCHWr1LhZmkTNYvf+oTeo0
	 Unno/cYv4He0SmlSVFDI32H8pLSXvl6dB5JHiwFtp5y50ZbvCr/YRQHLyesGLYEw5iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811228;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=4G+6DIPOVHtjtGmntgfDSVsJzFwPyFWDveLCz6VShN8=;
	b=XgoKt5jh7lGhKCLjvhDYcnapaE6vm5Id86Cq3DoQMrHWgs6eyUKApIbDOOfi7Elc73ZJ
	 rBphI7Qb80oUv7XcSGOoWTbwZap9oqDLpo1roBKkXlKVYULTvh2UIokSrFDf58KKVHvtp
	 ++DQ5KMKvB6C16BTu/APNOvHQWfqY/pco1QG5pLMFBhAmD29FEhUHStnUZYj1AVfeotcH
	 ilRvBNHvB/Gybc5Y7XLi71eflnAqGFL5S9Atnw+zj+b8+6SU5QwZHXzXH21RNpBLblU3L
	 XFeDgfX7bLrRkFxJBR9YvSye2XczGoHaN8zxUYxZV7O8Z8uNkokmt94XlvpJ68+uM7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="LJ/z7pF0";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5b8uXr4t;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="LJ/z7pF0";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5b8uXr4t;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7112E606A330;
	Wed,  4 Nov 2026 16:53:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7112E606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=LJ/z7pF0;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5b8uXr4t;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=LJ/z7pF0;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5b8uXr4t
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A833B1F388;
	Wed,  4 Nov 2026 16:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793811225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4G+6DIPOVHtjtGmntgfDSVsJzFwPyFWDveLCz6VShN8=;
	b=LJ/z7pF0VqGEvjMGbdjtpFsaVmmxMIyEyeUH2Nsk+Ds6Y2YAqHhExUHzTLgBxLIU4obXoT
	67bUTK8UA+1sfr+Qs7G3FsTWZCIFY6mp5ig3/ueQTq5RixgbpyngMO8qsTWflm06NoWwAa
	oJY4tiq7lmZNPTJkbPbnkKP8LzG7f3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793811225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4G+6DIPOVHtjtGmntgfDSVsJzFwPyFWDveLCz6VShN8=;
	b=5b8uXr4tMOajkwxeEPPuG50AWnf7Mq6lEWshBBU3mpyehhtlW3sJjk8yQqy9MGddjre/tv
	Eh/KVn8pXEdPnZAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="LJ/z7pF0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5b8uXr4t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793811225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4G+6DIPOVHtjtGmntgfDSVsJzFwPyFWDveLCz6VShN8=;
	b=LJ/z7pF0VqGEvjMGbdjtpFsaVmmxMIyEyeUH2Nsk+Ds6Y2YAqHhExUHzTLgBxLIU4obXoT
	67bUTK8UA+1sfr+Qs7G3FsTWZCIFY6mp5ig3/ueQTq5RixgbpyngMO8qsTWflm06NoWwAa
	oJY4tiq7lmZNPTJkbPbnkKP8LzG7f3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793811225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4G+6DIPOVHtjtGmntgfDSVsJzFwPyFWDveLCz6VShN8=;
	b=5b8uXr4tMOajkwxeEPPuG50AWnf7Mq6lEWshBBU3mpyehhtlW3sJjk8yQqy9MGddjre/tv
	Eh/KVn8pXEdPnZAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73A29134F0;
	Wed,  4 Nov 2026 16:53:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mImBDxlj62q9BwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 16:53:45 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E5A16B439; Wed, 04 Nov 2026 17:53:40 +0100 (CET)
Date: Wed, 4 Nov 2026 17:53:40 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 2/9] ext2: don't read the inode block in
 ext2_sync_inode_metadata()
Message-ID: <rczezs5hk6alwpfpd3h3yevzbpc462lv2cgqxxgh7vfkro67u4@cmz3zcc3hjyj>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-2-7d6c678a585d@kernel.org>
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
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-2-7d6c678a585d@kernel.org>
X-Rspamd-Queue-Id: A833B1F388
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
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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

On Thu 29-10-26 14:28:17, Christian Brauner wrote:
> ext2_sync_inode_metadata() looks up the inode block with
> ext2_get_inode() which reads it from disk if it isn't cached. But a
> block that isn't in the buffer cache is neither dirty nor under
> writeback. So there's nothing to write or to wait for and reading it in
> is pointless.
> 
> It's also not something we can afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> sb_find_get_block_nonatomic() instead, the same way
> fat_sync_inode_metadata() already does.
> 
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/ext2/inode.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 940f61a4dde3..efb50cb48da3 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1586,19 +1586,22 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
>  int ext2_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
>  {
>  	struct buffer_head *bh;
> -	struct ext2_inode *raw_inode = ext2_get_inode(inode->i_sb, inode->i_ino,
> -						      &bh);
> +	unsigned long block, offset;
>  	int err = 0;
>  
> -	if (IS_ERR(raw_inode))
> +	if (ext2_inode_block(inode->i_sb, inode->i_ino, &block, &offset))
>  		return -EIO;
>  	err = mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
>  	if (err) {
>  		ext2_error(inode->i_sb, __func__,
>  			"Error syncing inode metadata ino=%lu\n",
>  			(unsigned long)inode->i_ino);
> -		goto out;
> +		return err;
>  	}
> +	/* A block that isn't cached is neither dirty nor under writeback. */
> +	bh = sb_find_get_block_nonatomic(inode->i_sb, block);
> +	if (!bh)
> +		return 0;
>  	sync_dirty_buffer(bh);
>  	if (buffer_write_io_error(bh)) {
>  		ext2_error(inode->i_sb, __func__,
> @@ -1606,7 +1609,6 @@ int ext2_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
>  			(unsigned long)inode->i_ino);
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
