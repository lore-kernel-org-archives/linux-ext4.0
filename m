Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC493DFC6F
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 20:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774297889; cv=none; b=l1WX0O3pSiYaG0veNUz6Tk+zkMFpBTJ16zB8dJedboARJ552vqptGJ6HNIEPb84JDWlH+BDSjpuEfoq9uHcpNjpvvyShXv6MWUGSbEXRjhONqa3quSl68FCcE7kVZld+zb5SSa7vbfHwWUgTt8BZ3UgE7qrKMxmPDNIlyMOVcx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774297889; c=relaxed/simple;
	bh=alZ59a43N3b5vV5wbQF9/dRk1iQ1cWHHMZXN7KIeqdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OEXHdq2YclcExS2b9SlOEivVtXG2NKf2TP8wHx07p7xDyktJXpQPDoiR0PuobT4m/FkZTQLCn+ebY1LFSu7sK8PHM/jZ1j/qBptczvc8vDJh+EOGKxGmkJb9C7r2AzS6K9qVXf+NFMM82H6CTXLPLIlW8bzHVpNyZ12dI1mP2QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zQ0mKJhf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=c4tFvY83; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1Drtu9jC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MRiVwWGp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zQ0mKJhf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="c4tFvY83";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1Drtu9jC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MRiVwWGp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DD0C15BE4F;
	Mon, 23 Mar 2026 20:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774297885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xkwEXN4PiEbBLZlhthFn4IlNr+bDzd7DG89qanfhSaw=;
	b=zQ0mKJhf2ly037QiC9eFQn34SmJZLvxQy4vHAzjX1N3NPKKXjRwB4o57NLLcbepoLAKIrh
	aKh7Cu84Y6EIA8eeKnBkiu7OFGyju3S42g2BSKGBP4Tgv8VZ0BZ5OmodHgZaIaeSa6yTxO
	qts3T9NfXdb43B6w/GvQNjTCRUxJDhE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774297885;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xkwEXN4PiEbBLZlhthFn4IlNr+bDzd7DG89qanfhSaw=;
	b=c4tFvY83yTVunDOXAbYQ9GZ5bOhNZVovRG2gYYAYJRMkU+RjzDw5NoFOqjQyF0OqjvTAjy
	3JayLCw6gMMfJHDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1Drtu9jC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MRiVwWGp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774297884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xkwEXN4PiEbBLZlhthFn4IlNr+bDzd7DG89qanfhSaw=;
	b=1Drtu9jCPW3JBfZa/AXdVzla8m50Q2oIsyCbooHqVKz0BYRuxWRdLC2JqBkO5a6Sqpd0gO
	xNCG0VNlQ3i2l8AZKfA1h76D1mG4TrUuGM+MgKXNaKekRUseizQHVR8W28f1W/4jHf38/1
	JBnyJ7FPBbMFw8JvJOx9e/hatBojTd4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774297884;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xkwEXN4PiEbBLZlhthFn4IlNr+bDzd7DG89qanfhSaw=;
	b=MRiVwWGp4LtJC52UY0814hzawLeTBPfJI4aY+aFG9nyd9YXfcIrfEjnkEHFZffBrhtKNtL
	1abJFVUzNIYpvMDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D223443A73;
	Mon, 23 Mar 2026 20:31:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id td5HMxyjwWnSGQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 20:31:24 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 93A9EA0B32; Mon, 23 Mar 2026 21:31:24 +0100 (CET)
Date: Mon, 23 Mar 2026 21:31:24 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 10/10] ext4: zero post-EOF partial block before appending
 write
Message-ID: <fcjjsad6v5v6ubtjidrstg3pjeeqn7njjm2qrovufdklnbhhci@ldy4nrlmtoek>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-11-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310014101.4140698-11-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: DD0C15BE4F

On Tue 10-03-26 09:41:01, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In cases of appending write beyond EOF, ext4_zero_partial_blocks() is
> called within ext4_*_write_end() to zero out the partial block beyond
> EOF. This prevents exposing stale data that might be written through
> mmap.
> 
> However, supporting only the regular buffered write path is
> insufficient. It is also necessary to support the DAX path as well as
> the upcoming iomap buffered write path. Therefore, move this operation
> to ext4_write_checks().
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

I'd note that this allows page fault to race in between the zeroing and
actual write resulting in new possible result - previously for file size 8,
pwrite('WWWW...', 8, 16) racing with mmap writes of 'MMMMMM...' at offset 8
into the page you could see either:

DDDDDDDD00000000WWWWWWWW
or
DDDDDDDDMMMMMMMMMMMMMMMM


now you can see both of the above an also

DDDDDDDMMMMMMMMWWWWWWWWW

But I don't think that's strictly invalid content and userspace that would
depend on the outcome of such race would be silly. So feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c  | 14 ++++++++++++++
>  fs/ext4/inode.c | 21 +++++++--------------
>  2 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index f1dc5ce791a7..b2e44601ab6a 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -271,6 +271,8 @@ static ssize_t ext4_generic_write_checks(struct kiocb *iocb,
>  
>  static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
>  {
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +	loff_t old_size = i_size_read(inode);
>  	ssize_t ret, count;
>  
>  	count = ext4_generic_write_checks(iocb, from);
> @@ -280,6 +282,18 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
>  	ret = file_modified(iocb->ki_filp);
>  	if (ret)
>  		return ret;
> +
> +	/*
> +	 * If the position is beyond the EOF, it is necessary to zero out the
> +	 * partial block that beyond the existing EOF, as it may contains
> +	 * stale data written through mmap.
> +	 */
> +	if (iocb->ki_pos > old_size && !ext4_verity_in_progress(inode)) {
> +		ret = ext4_block_zero_eof(inode, old_size, iocb->ki_pos);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
>  	return count;
>  }
>  
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5288d36b0f09..67a4d12fcb4d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1456,10 +1456,9 @@ static int ext4_write_end(const struct kiocb *iocb,
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
> -	if (old_size < pos && !verity) {
> +	if (old_size < pos && !verity)
>  		pagecache_isize_extended(inode, old_size, pos);
> -		ext4_block_zero_eof(inode, old_size, pos);
> -	}
> +
>  	/*
>  	 * Don't mark the inode dirty under folio lock. First, it unnecessarily
>  	 * makes the holding time of folio lock longer. Second, it forces lock
> @@ -1574,10 +1573,8 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
> -	if (old_size < pos && !verity) {
> +	if (old_size < pos && !verity)
>  		pagecache_isize_extended(inode, old_size, pos);
> -		ext4_block_zero_eof(inode, old_size, pos);
> -	}
>  
>  	if (size_changed) {
>  		ret2 = ext4_mark_inode_dirty(handle, inode);
> @@ -3196,7 +3193,7 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>  	struct inode *inode = mapping->host;
>  	loff_t old_size = inode->i_size;
>  	bool disksize_changed = false;
> -	loff_t new_i_size, zero_len = 0;
> +	loff_t new_i_size;
>  	handle_t *handle;
>  
>  	if (unlikely(!folio_buffers(folio))) {
> @@ -3240,19 +3237,15 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
> -	if (pos > old_size) {
> +	if (pos > old_size)
>  		pagecache_isize_extended(inode, old_size, pos);
> -		zero_len = pos - old_size;
> -	}
>  
> -	if (!disksize_changed && !zero_len)
> +	if (!disksize_changed)
>  		return copied;
>  
> -	handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
> +	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
> -	if (zero_len)
> -		ext4_block_zero_eof(inode, old_size, pos);
>  	ext4_mark_inode_dirty(handle, inode);
>  	ext4_journal_stop(handle);
>  
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
