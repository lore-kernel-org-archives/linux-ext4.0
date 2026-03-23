Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456613AE6E6
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 16:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283662; cv=none; b=JHPXI9MQhBmgbcWGSdkS5YLMACbpzBfZnwoGsOeJJlqrpCLiB60Q/UZvWz714jeJFbtkW6zMzBoc9w1ycHaggbY9qj7+4SU0IPMqKyLWYSjsrpN783jNUTzqCvCwD7hokOMUfZp9DzGVRKj15fZkp1llFYQcVj+0U8bs5eY4vaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283662; c=relaxed/simple;
	bh=0GAz85IXm7wHJEHEdmu3ebQxL0hfAJy3JK+x7aXYU20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5qYxHoZZ6JjB5AzXsWBBKszX5EXLgGhEn1+N5SDikSbjwmBuwrVIgxwWAW8pY+EMgf86zWFB/gXhN7CyKSyanq7/DeU+65pmkMpnMhRjhZIl1Je/cRK15ZpHUMxdkjwVO7tty1yPwsf6zOSkiSY3xAvvRhNGj/Q1uathKofg/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p1PYuaGP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bC9BSPob; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p1PYuaGP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bC9BSPob; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p1PYuaGP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bC9BSPob";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p1PYuaGP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bC9BSPob"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7702E5C01E;
	Mon, 23 Mar 2026 16:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774283658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hA++5ASk4ljZTWyWGa9VhHxtimiX8NWkiOTeKM3Pfao=;
	b=p1PYuaGP1gXhT8USOmuV2BPmxlLVwoCgYHZIeVtexx17OlUhD0Un3y1n9KRJl3ZGWaKnY6
	f8aGIyHZY5UVhsIUKE6LBOjb1kvtjvQGMUlHa+gxM0zF/vemKB/N/gcMGx/ojgIBd8/ueG
	CQ3RnO3yi2Wz9tATb8WMl+4c21qdpzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774283658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hA++5ASk4ljZTWyWGa9VhHxtimiX8NWkiOTeKM3Pfao=;
	b=bC9BSPobZxqvlcHfdJ3rl+lv7s7OnmHYqSUZpvrpzxDy9u7MmHoBN+odzg8UuGI2XinQen
	Yo3eI01rlETfF5BQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774283658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hA++5ASk4ljZTWyWGa9VhHxtimiX8NWkiOTeKM3Pfao=;
	b=p1PYuaGP1gXhT8USOmuV2BPmxlLVwoCgYHZIeVtexx17OlUhD0Un3y1n9KRJl3ZGWaKnY6
	f8aGIyHZY5UVhsIUKE6LBOjb1kvtjvQGMUlHa+gxM0zF/vemKB/N/gcMGx/ojgIBd8/ueG
	CQ3RnO3yi2Wz9tATb8WMl+4c21qdpzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774283658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hA++5ASk4ljZTWyWGa9VhHxtimiX8NWkiOTeKM3Pfao=;
	b=bC9BSPobZxqvlcHfdJ3rl+lv7s7OnmHYqSUZpvrpzxDy9u7MmHoBN+odzg8UuGI2XinQen
	Yo3eI01rlETfF5BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D0F443986;
	Mon, 23 Mar 2026 16:34:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oqWcGoprwWkkJQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 16:34:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 34121A0B32; Mon, 23 Mar 2026 17:34:18 +0100 (CET)
Date: Mon, 23 Mar 2026 17:34:18 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 02/10] ext4: ext4_block_truncate_page() returns zeroed
 length on success
Message-ID: <yeiwg3jydk4fo3wqpxulzgkinkakb5ln3i5qrh26qbluqzotro@tz5hgdbxfh4i>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-3-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310014101.4140698-3-yi.zhang@huaweicloud.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,huawei.com:email,suse.com:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO

On Tue 10-03-26 09:40:53, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Return the actual zeroed length instead of 0 on success. This prepares
> for the upcoming iomap buffered I/O conversion by exposing zeroed length
> information to callers.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1e037a314dab..a737ce05e768 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4136,6 +4136,7 @@ static int ext4_block_zero_page_range(handle_t *handle,
>   * up to the end of the block which corresponds to `from'.
>   * This required during truncate. We need to physically zero the tail end
>   * of that block so it doesn't yield old data if the file is later grown.
> + * Return the zeroed length on success.
>   */
>  static int ext4_block_truncate_page(handle_t *handle,
>  		struct address_space *mapping, loff_t from)
> @@ -4143,6 +4144,8 @@ static int ext4_block_truncate_page(handle_t *handle,
>  	unsigned length;
>  	unsigned blocksize;
>  	struct inode *inode = mapping->host;
> +	bool did_zero = false;
> +	int err;
>  
>  	/* If we are processing an encrypted inode during orphan list handling */
>  	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
> @@ -4151,7 +4154,12 @@ static int ext4_block_truncate_page(handle_t *handle,
>  	blocksize = i_blocksize(inode);
>  	length = blocksize - (from & (blocksize - 1));
>  
> -	return ext4_block_zero_page_range(handle, mapping, from, length, NULL);
> +	err = ext4_block_zero_page_range(handle, mapping, from, length,
> +					 &did_zero);
> +	if (err)
> +		return err;
> +
> +	return did_zero ? length : 0;
>  }
>  
>  int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
