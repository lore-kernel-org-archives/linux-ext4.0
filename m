Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85E73F54C5
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 09:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782724335; cv=none; b=Cyf8US8J52jM+fF9nvHFyivNfu/40NTCUJ6vmZ/CZohqAFqNSTGJs4WT7gcm3mpZZZ0OQwXA6Cedpw/4TRRK6W6YfEBeHTuh9kowniVDEZ5IBG5o1tEtjXU9jk53Dl3t7ffHYUJQkIDPwCwtu5eXaNzSTrk1tRHAV7WKxiVKWw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782724335; c=relaxed/simple;
	bh=9AcDbVt+ow7xwloyKVpgajG+sLeIQzH8rN7fyHe0cV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmFIzcN/lmg6QyFSRZL6Yj79hDF313Q0flrieT3F8yQJaMZilV6s7yI/57zeWMRPzdOJWc3jYWeJ+3ygkg2A12er0c0dZl0LHHTiLBcLwsne5hzMqXHTdSNdk+33z7LXoa53uS4uF5UwqmMSvE9cwpbHcEbHCcfwsR/fOA0O2LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KePxFrbg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RGCJO+87; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=u+2qpcI3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yHZwFsd1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KePxFrbg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RGCJO+87";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="u+2qpcI3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yHZwFsd1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D5A3E72FB7;
	Mon, 29 Jun 2026 09:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782724332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gNC1hzbQPDmtisuPxPlCAFSnvliXYhFVaSYtWNsFNYs=;
	b=KePxFrbgTljT+YkxWFvXxnQsazw4Z5IsHy+2hhTxDGYOydcd4YZTiMVoleVgR0uLZOcFT1
	/vXTNHNVD5RZjmcKEG1gLmq1qIrKYcfyxMFujunIOdEUeex6vj3uOHFaUsK05tA8ycAZXt
	dLJu9dImHZMkuTKwzVxDV09E8/iKxOg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782724332;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gNC1hzbQPDmtisuPxPlCAFSnvliXYhFVaSYtWNsFNYs=;
	b=RGCJO+87awe9tuINWja+bUolwvCLDG7ZDZNArSPnDWLrwIvhBBG/xAlzNL0McQDvjPmd/f
	mexVSJXXJcHJAhCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782724330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gNC1hzbQPDmtisuPxPlCAFSnvliXYhFVaSYtWNsFNYs=;
	b=u+2qpcI3eZFRVDMxDROA/CkVQ+R/HIVHvKZ56pbg0KtDJaYRyj9Xi8PRosTbLx71LWWbAV
	OwkrBD3BU0llGpemOWqzwhEcKIWdpp7WUgyTS/AHwessomRq4F1At2ykIJck7XWN1b6npK
	Jhk8TKZ0eYvjL6fVVBJ61g457qkYL+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782724330;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gNC1hzbQPDmtisuPxPlCAFSnvliXYhFVaSYtWNsFNYs=;
	b=yHZwFsd1PuRsq87+/l5plcB78MHFCc77lJ4Sg+PRJYeJWgSxGnq6b4mLNjnTNg1FdxTnCw
	4W4iwJs5AAKZIzBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C46B8779A8;
	Mon, 29 Jun 2026 09:12:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WiRzL+o2QmrwSgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 29 Jun 2026 09:12:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 69B03A10B5; Mon, 29 Jun 2026 11:12:06 +0200 (CEST)
Date: Mon, 29 Jun 2026 11:12:06 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix deadlock in ext4_evict_ea_inode() vs
 cache_find()
Message-ID: <it6akotjfbd5vqs3vtr5ginz25bswnfu36ji6476cd7wlso53d@45sc2niokuk7>
References: <20260629052732.1442618-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629052732.1442618-1-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,syzkaller.appspot.com:url,imap1.dmz-prg2.suse.org:helo,appspotmail.com:email,windriver.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 29-06-26 13:27:32, Yun Zhou wrote:
> ext4_evict_ea_inode() calls mb_cache_entry_wait_unused() to wait for
> the EA inode's mb_cache entry refcount to drop before deleting it.
> This can deadlock against ext4_xattr_inode_cache_find() which holds
> an mb_cache entry reference while calling ext4_iget():
> 
>   Thread A (evicting EA inode X):
>     ext4_evict_ea_inode -> mb_cache_entry_wait_unused  [waits for refcnt]
> 
>   Thread B (setxattr looking for dedup):
>     ext4_xattr_inode_cache_find -> mb_cache_entry_find  [holds refcnt]
>       -> ext4_iget(X) -> __wait_on_freeing_inode       [waits on I_FREEING]
> 
> Thread A's eviction sets I_FREEING and then waits for the mb_cache
> refcount to drop.  Thread B holds that refcount and waits for
> I_FREEING to clear -- circular dependency.
> 
> Fix by making ext4_evict_ea_inode() non-blocking: try to delete the
> entry once, and if it's currently in use, just leave it.  A stale
> entry is harmless -- subsequent cache_find() calls will iget the
> evicted inode, fail validation or data comparison, and skip it.
> 
> Fixes: 458aee4a6e5b ("ext4: remove EA inode entry from mbcache on inode eviction")
> Reported-by: syzbot+fd5533bcd0f7343bb8ca@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=fd5533bcd0f7343bb8ca
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

We already have another fix for this [1] and I think it is better. Frankly,
I'd be wary of leaving stale mbcache entries behind. If nothing else, it slows
down things and effectively leaks memory and it could be actually triggered
by user more or less at their will...

								Honza

[1] https://lore.kernel.org/all/20260626054821.1729-1-aditya.ansh182@gmail.com/

> ---
>  fs/ext4/xattr.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 85ad2561474b..8ca2c87b1db3 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -471,12 +471,16 @@ void ext4_evict_ea_inode(struct inode *inode)
>  
>  	if (!EA_INODE_CACHE(inode))
>  		return;
> -	/* Wait for entry to get unused so that we can remove it */
> -	while ((oe = mb_cache_entry_delete_or_get(EA_INODE_CACHE(inode),
> -			ext4_xattr_inode_get_hash(inode), inode->i_ino))) {
> -		mb_cache_entry_wait_unused(oe);
> +	/*
> +	 * Try to delete the cache entry.  If it's currently in use by
> +	 * another thread (e.g. ext4_xattr_inode_cache_find), just leave
> +	 * it -- the stale entry is harmless.  Waiting here would deadlock
> +	 * if the other thread's iget is blocked on this inode's I_FREEING.
> +	 */
> +	oe = mb_cache_entry_delete_or_get(EA_INODE_CACHE(inode),
> +			ext4_xattr_inode_get_hash(inode), inode->i_ino);
> +	if (oe)
>  		mb_cache_entry_put(EA_INODE_CACHE(inode), oe);
> -	}
>  }
>  
>  static int
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
