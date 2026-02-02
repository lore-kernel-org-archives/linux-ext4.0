Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C7A37E306
	for <linux-ext4@vger.kernel.org>; Mon,  2 Feb 2026 16:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770050502; cv=none; b=NE1eDFLTrHN7Bk9n2RIfrg1YOW7DhgkOo++K2wPib7Z2oBplEQCtTPcHbpravU1Ho352YOEvY1CvzZnnfhZ5yn5NcqlxkOr6PNPChUhGpryPgZxZeBwxD9szYVFsZtUP+4gqyFFVV+OLASXFNc4pU7zRMhy5mMEQQ0BMzwaCQ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770050502; c=relaxed/simple;
	bh=vnyIvt1sScwiipdrjCPX/N+y6uGqbNMEtO86CILV8HA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/Xwn7lvf9h/L6I/k6WbFK2IQkrGApe1JYEExQJDyDGrXutLUV8n83Ty/YeSYfDsbnaw8ZDondBqh6lr0F8He6RZCwD4p2qWzdorm5ZvWQc88r/PgGtfehgYOuKeWsI29zvRzkxzLgol+SXH0vCuKMM7e56ZNYkpVptWkc5dPGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=153kQ41j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=sZ71oRd1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=153kQ41j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=sZ71oRd1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="153kQ41j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="sZ71oRd1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="153kQ41j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="sZ71oRd1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 819F65BD2A;
	Mon,  2 Feb 2026 16:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770050499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B6OCSTr1X7K4gTzXIhUGdQfQFBQrVU/POk98Hv4PCbU=;
	b=153kQ41jXMrMySedvVd2a37xaGwkEuGvr9kOBIo/AaSaaGUxxvwpDmMnxq8iPr1jieZOQn
	SKNzoJzsV3YZoS9R95xOdzTOHgpmlb96v+DxXuEXbuF53wZqha5AfN2J1bbepICzDLwckO
	cQxF56biYTeZfngctq4hJfLy15iAZuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770050499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B6OCSTr1X7K4gTzXIhUGdQfQFBQrVU/POk98Hv4PCbU=;
	b=sZ71oRd1HSQ6OLuc+hZ/LBFcJykmWBe3Vjwan2vJYxwmwbp/YfS6OjYreyr4dCRkYvIkG9
	0SPabci4GCISkBAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=153kQ41j;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sZ71oRd1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770050499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B6OCSTr1X7K4gTzXIhUGdQfQFBQrVU/POk98Hv4PCbU=;
	b=153kQ41jXMrMySedvVd2a37xaGwkEuGvr9kOBIo/AaSaaGUxxvwpDmMnxq8iPr1jieZOQn
	SKNzoJzsV3YZoS9R95xOdzTOHgpmlb96v+DxXuEXbuF53wZqha5AfN2J1bbepICzDLwckO
	cQxF56biYTeZfngctq4hJfLy15iAZuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770050499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B6OCSTr1X7K4gTzXIhUGdQfQFBQrVU/POk98Hv4PCbU=;
	b=sZ71oRd1HSQ6OLuc+hZ/LBFcJykmWBe3Vjwan2vJYxwmwbp/YfS6OjYreyr4dCRkYvIkG9
	0SPabci4GCISkBAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E68C3EA62;
	Mon,  2 Feb 2026 16:41:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZqfzGsPTgGllKQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Feb 2026 16:41:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 37A70A08F8; Mon,  2 Feb 2026 17:41:39 +0100 (CET)
Date: Mon, 2 Feb 2026 17:41:39 +0100
From: Jan Kara <jack@suse.cz>
To: Li Chen <me@linux.beauty>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jan Kara <jack@suse.com>
Subject: Re: [PATCH 2/3] ext4: use READ_ONCE for lockless jinode reads
Message-ID: <emoxxh6xn5mm5dl2ra5vz2g7t553z4kxricolekz6umiwcu5ys@ogxvdjfq66u3>
References: <20260130031232.60780-1-me@linux.beauty>
 <20260130031232.60780-3-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130031232.60780-3-me@linux.beauty>
X-Spam-Score: -4.01
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:email,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 819F65BD2A
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Fri 30-01-26 11:12:31, Li Chen wrote:
> ext4 journal commit callbacks access jbd2_inode fields such as
> i_transaction and i_dirty_start/end without holding journal->j_list_lock.
> 
> Use READ_ONCE() for these reads to correct the concurrency assumptions.
> 
> Suggested-by: Jan Kara <jack@suse.com>
> Signed-off-by: Li Chen <me@linux.beauty>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c |  6 ++++--
>  fs/ext4/super.c | 13 ++++++++-----
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d99296d7315f..2d451388e080 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3033,11 +3033,13 @@ static int ext4_writepages(struct address_space *mapping,
>  
>  int ext4_normal_submit_inode_data_buffers(struct jbd2_inode *jinode)
>  {
> +	loff_t dirty_start = READ_ONCE(jinode->i_dirty_start);
> +	loff_t dirty_end = READ_ONCE(jinode->i_dirty_end);
>  	struct writeback_control wbc = {
>  		.sync_mode = WB_SYNC_ALL,
>  		.nr_to_write = LONG_MAX,
> -		.range_start = jinode->i_dirty_start,
> -		.range_end = jinode->i_dirty_end,
> +		.range_start = dirty_start,
> +		.range_end = dirty_end,
>  	};
>  	struct mpage_da_data mpd = {
>  		.inode = jinode->i_vfs_inode,
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 5cf6c2b54bbb..acb2bc016fd4 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -521,6 +521,7 @@ static bool ext4_journalled_writepage_needs_redirty(struct jbd2_inode *jinode,
>  {
>  	struct buffer_head *bh, *head;
>  	struct journal_head *jh;
> +	transaction_t *trans = READ_ONCE(jinode->i_transaction);
>  
>  	bh = head = folio_buffers(folio);
>  	do {
> @@ -539,7 +540,7 @@ static bool ext4_journalled_writepage_needs_redirty(struct jbd2_inode *jinode,
>  		 */
>  		jh = bh2jh(bh);
>  		if (buffer_dirty(bh) ||
> -		    (jh && (jh->b_transaction != jinode->i_transaction ||
> +		    (jh && (jh->b_transaction != trans ||
>  			    jh->b_next_transaction)))
>  			return true;
>  	} while ((bh = bh->b_this_page) != head);
> @@ -550,12 +551,14 @@ static bool ext4_journalled_writepage_needs_redirty(struct jbd2_inode *jinode,
>  static int ext4_journalled_submit_inode_data_buffers(struct jbd2_inode *jinode)
>  {
>  	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
> +	loff_t dirty_start = READ_ONCE(jinode->i_dirty_start);
> +	loff_t dirty_end = READ_ONCE(jinode->i_dirty_end);
>  	struct writeback_control wbc = {
> -		.sync_mode =  WB_SYNC_ALL,
> +		.sync_mode = WB_SYNC_ALL,
>  		.nr_to_write = LONG_MAX,
> -		.range_start = jinode->i_dirty_start,
> -		.range_end = jinode->i_dirty_end,
> -        };
> +		.range_start = dirty_start,
> +		.range_end = dirty_end,
> +	};
>  	struct folio *folio = NULL;
>  	int error;
>  
> -- 
> 2.52.0
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
