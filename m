Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6625E3033FD
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 20:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781556117; cv=none; b=IHEYHvYGCJdj3/FoJfbOIcNyUwyZ4xeJ+aclgINJDDkrv6GYTnt4tfdZP09kEtUgN51NElXn14JtOcBtTQeDJoerk6+Gzoe6RkLQidg9+QhAX/4iV8xD4w5bjwboALXRJwFRlD/TLq6ia8AfULBKIUtUFDgXpGMC6+ZD4Oc4pgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781556117; c=relaxed/simple;
	bh=lH4wGU0CzX6Q973rEOnrVW9bH3hltgvNT+ygKNmndR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fueT7aSG+ztNhSgv/DFB0e7ISoV79HeQYnvX5F25V8NgoE5pSWRdKp9XBDBYyUfhMcNHRxL2yshUMqkvIM+jE+wC8o1x3db2wS1G2egDLJNmg6Tli/1oahxFdIiJauWFwP6Gnv5RJ5puQtYR/J9IN98R49QUIh18IYgpOGVmLT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VpuCy/4Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZLdg1lmh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2lC7VLTa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AzDO1wcY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VpuCy/4Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZLdg1lmh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2lC7VLTa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AzDO1wcY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 739626C742;
	Mon, 15 Jun 2026 20:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781556114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vQmEAeJcNIVKx74dnNwST25Fr8U7rEactrsqnCLY0w4=;
	b=VpuCy/4YML0+21z7P8Q4k9q0HIHPG4nO0xS/pZAAZh+s/fiuwiB07/4vXVnwJ7ka79zUMV
	3U+ydjO05mImDyD7Xvy1arS9kvKzJPfjTnoiUpiVOVzqF9GMCkY9rR3FyDbKPS2uar4tIV
	MpAuTOy7jdLhBRi8KUgDKmggw7tQhdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781556114;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vQmEAeJcNIVKx74dnNwST25Fr8U7rEactrsqnCLY0w4=;
	b=ZLdg1lmh6IWPHDvcyXI7gtZURWoQCiLkkf6cLNh4gEg4Kg3c/eYlUrqgTOVHXg4U/xOMxT
	JNCExcrBGAKowdBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2lC7VLTa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AzDO1wcY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781556113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vQmEAeJcNIVKx74dnNwST25Fr8U7rEactrsqnCLY0w4=;
	b=2lC7VLTa6N0EMrkH9MXDHQtU/k6pEhBBHXz/629FDP6QxGEIrZuIHjWLmaxdrtZyTesoZ9
	MUfrQyXAYA1o1d9YSk6VQLbB7fNyM7Vg2aowmEtI2FJ2O3LuTdJHyDHjDIMNnX925AU/u+
	d1vhz89dqBVgQeF2A8gSLJybav6DuwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781556113;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vQmEAeJcNIVKx74dnNwST25Fr8U7rEactrsqnCLY0w4=;
	b=AzDO1wcYhMMUP7J5R/C9gvjTjLz6OJRJMYPrPerO/2tt60MBo0nAMGjOUvYL+9IC2rnIqy
	hQ81WdMQ1P2+94BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 68105779A7;
	Mon, 15 Jun 2026 20:41:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 66FlGZFjMGqIWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 15 Jun 2026 20:41:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0630FA12D2; Mon, 15 Jun 2026 22:41:49 +0200 (CEST)
Date: Mon, 15 Jun 2026 22:41:48 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Remove ext4_end_buffer_io_sync()
Message-ID: <lfhruw537fr5ohvuxky4djlchm3ftwj4bn4clorjlaelnu6fck@yqbz2nl732o7>
References: <20260615182527.2208479-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615182527.2208479-1-willy@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 739626C742
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,gmail.com,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,infradead.org:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon 15-06-26 19:25:25, Matthew Wilcox (Oracle) wrote:
> There's no need for a custom end_io routine here.  We lose some
> tracing of I/O completions, but we gain better error handling.
> Well, consistent error handling anyway.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Yes, I think this is better. I was also considering that when revieweing
your patch series but decided to leave that as a future cleanup. The future
is now! :) Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/fast_commit.c | 21 +--------------------
>  1 file changed, 1 insertion(+), 20 deletions(-)
> 
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 5773b85e43cb..6b00a7285344 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -184,25 +184,6 @@
>  #include <trace/events/ext4.h>
>  static struct kmem_cache *ext4_fc_dentry_cachep;
>  
> -static void ext4_end_buffer_io_sync(struct bio *bio)
> -{
> -	struct buffer_head *bh;
> -	bool uptodate = bio_endio_bh(bio, &bh);
> -
> -	BUFFER_TRACE(bh, "");
> -	if (uptodate) {
> -		ext4_debug("%s: Block %lld up-to-date",
> -			   __func__, bh->b_blocknr);
> -		set_buffer_uptodate(bh);
> -	} else {
> -		ext4_debug("%s: Block %lld not up-to-date",
> -			   __func__, bh->b_blocknr);
> -		clear_buffer_uptodate(bh);
> -	}
> -
> -	unlock_buffer(bh);
> -}
> -
>  static inline void ext4_fc_reset_inode(struct inode *inode)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(inode);
> @@ -662,7 +643,7 @@ static void ext4_fc_submit_bh(struct super_block *sb, bool is_tail)
>  	lock_buffer(bh);
>  	set_buffer_dirty(bh);
>  	set_buffer_uptodate(bh);
> -	bh_submit(bh, REQ_OP_WRITE | write_flags, ext4_end_buffer_io_sync);
> +	bh_submit(bh, REQ_OP_WRITE | write_flags, bh_end_write);
>  	EXT4_SB(sb)->s_fc_bh = NULL;
>  }
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
