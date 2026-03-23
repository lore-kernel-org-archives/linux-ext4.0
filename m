Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B9F3BF69D
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 16:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774284578; cv=none; b=T1svmNMyBDuNT4rs4taoC5LxoWkAtPTNXWCt6SEcQz/2QwmdTQ9qOIXxsWMFgz1ySHvaNg+Erd+E1IHtU2hN8KkcqG+bgXhW4W4xp5+k/+QyKhFWWt7THN923rVCQ4s5eRenws5rllIPN3/81BS0Kt/8DX/Y0vjjLrVGjU+IO4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774284578; c=relaxed/simple;
	bh=68qrIq1ll36yaS+puDeKl33Il9+T61E/MU4be9WC0/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rr5t3LBbgPA9Z68JbIZ15JpW7hg9HdpYQTNCDI9cIdlaahkEnUp/YOgZnmbC9lllrTDxmW1M+YuIgcKQu254a9R81PC/VNDmRxuBi22zyojKYmtwVlnslm0qky+OtzPaKGAPLVzQWhVn34JGlKnzEIuWmRwz0VpXhaWBACa6VFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nNEQdUmd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pAR2VQg4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nNEQdUmd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pAR2VQg4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nNEQdUmd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pAR2VQg4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nNEQdUmd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pAR2VQg4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4DC8F5BFD7;
	Mon, 23 Mar 2026 16:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774284573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pVXZ4/3/SGUIY4hY3zum++uN2dxElJ7rv1+9iQys1T8=;
	b=nNEQdUmdNVbUKnI9OWIuCe1SdbOqMxenou1l4058I9wp539Tg6IxMrWzMQbV9SrnxxJs8k
	Q9RuZqheF0Ws4S8fo1BXM0qv7j8+Ve9wV2kieqZhXGVOg4eDN0KCYO7N97mJDI+LNpOpeN
	eDfkoB6Y4Yxc8qeXfKijuboLymiQ2p4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774284573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pVXZ4/3/SGUIY4hY3zum++uN2dxElJ7rv1+9iQys1T8=;
	b=pAR2VQg4f2KJt6cMSMLaLROa0G5MQZF3/bH3TnBm0nX+nNX36awSGTeqxa8qpA596UYEQ9
	K2J9J7lcscD3T0Bw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nNEQdUmd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pAR2VQg4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774284573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pVXZ4/3/SGUIY4hY3zum++uN2dxElJ7rv1+9iQys1T8=;
	b=nNEQdUmdNVbUKnI9OWIuCe1SdbOqMxenou1l4058I9wp539Tg6IxMrWzMQbV9SrnxxJs8k
	Q9RuZqheF0Ws4S8fo1BXM0qv7j8+Ve9wV2kieqZhXGVOg4eDN0KCYO7N97mJDI+LNpOpeN
	eDfkoB6Y4Yxc8qeXfKijuboLymiQ2p4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774284573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pVXZ4/3/SGUIY4hY3zum++uN2dxElJ7rv1+9iQys1T8=;
	b=pAR2VQg4f2KJt6cMSMLaLROa0G5MQZF3/bH3TnBm0nX+nNX36awSGTeqxa8qpA596UYEQ9
	K2J9J7lcscD3T0Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F84943995;
	Mon, 23 Mar 2026 16:49:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yuZ8Dx1vwWnBNAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 16:49:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E9BA9A0B32; Mon, 23 Mar 2026 17:49:32 +0100 (CET)
Date: Mon, 23 Mar 2026 17:49:32 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 05/10] ext4: rename ext4_block_zero_page_range() to
 ext4_block_zero_range()
Message-ID: <4dc32xledyqa427du4y5ljynwniowrandj3547f457gzetbbrg@t3t7667jblyb>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-6-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310014101.4140698-6-yi.zhang@huaweicloud.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.51 / 50.00];
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
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,huawei.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Queue-Id: 4DC8F5BFD7
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Tue 10-03-26 09:40:56, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Rename ext4_block_zero_page_range() to ext4_block_zero_range() since the
> "page" naming is no longer appropriate for current context. Also change
> its signature to take an inode pointer instead of an address_space. This
> aligns with the caller ext4_block_zero_eof() and
> ext4_zero_partial_blocks().
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d63d455831b9..86f169df226a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4147,11 +4147,9 @@ static int ext4_block_journalled_zero_range(handle_t *handle,
>   * the end of the block it will be shortened to end of the block
>   * that corresponds to 'from'
>   */
> -static int ext4_block_zero_page_range(handle_t *handle,
> -		struct address_space *mapping, loff_t from, loff_t length,
> -		bool *did_zero)
> +static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
> +				 loff_t from, loff_t length, bool *did_zero)
>  {
> -	struct inode *inode = mapping->host;
>  	unsigned blocksize = inode->i_sb->s_blocksize;
>  	unsigned int max = blocksize - (from & (blocksize - 1));
>  
> @@ -4198,8 +4196,7 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
>  	if (length > blocksize - offset)
>  		length = blocksize - offset;
>  
> -	err = ext4_block_zero_page_range(handle, inode->i_mapping, from, length,
> -					 &did_zero);
> +	err = ext4_block_zero_range(handle, inode, from, length, &did_zero);
>  	if (err)
>  		return err;
>  
> @@ -4210,7 +4207,6 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>  			     loff_t lstart, loff_t length)
>  {
>  	struct super_block *sb = inode->i_sb;
> -	struct address_space *mapping = inode->i_mapping;
>  	unsigned partial_start, partial_end;
>  	ext4_fsblk_t start, end;
>  	loff_t byte_end = (lstart + length - 1);
> @@ -4225,22 +4221,22 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>  	/* Handle partial zero within the single block */
>  	if (start == end &&
>  	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
> -		err = ext4_block_zero_page_range(handle, mapping,
> -						 lstart, length, NULL);
> +		err = ext4_block_zero_range(handle, inode, lstart,
> +					    length, NULL);
>  		return err;
>  	}
>  	/* Handle partial zero out on the start of the range */
>  	if (partial_start) {
> -		err = ext4_block_zero_page_range(handle, mapping, lstart,
> -						 sb->s_blocksize, NULL);
> +		err = ext4_block_zero_range(handle, inode, lstart,
> +					    sb->s_blocksize, NULL);
>  		if (err)
>  			return err;
>  	}
>  	/* Handle partial zero out on the end of the range */
>  	if (partial_end != sb->s_blocksize - 1)
> -		err = ext4_block_zero_page_range(handle, mapping,
> -						 byte_end - partial_end,
> -						 partial_end + 1, NULL);
> +		err = ext4_block_zero_range(handle, inode,
> +					    byte_end - partial_end,
> +					    partial_end + 1, NULL);
>  	return err;
>  }
>  
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
