Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5D2279907
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 14:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781791769; cv=none; b=cWZ0UH8HW3Yk2EIG+tJAag3sSPpTgi7YNdJXkPphQCDJZtgp4rXohHgVdbpyApf00u/OfI3qXBwSexBqs4XGuLNChhX4UNTwNa+diTQJZBduuJj3iE9nSVaZJ6fRrfPZFy2yCq8YoWjt19d9Or/dELZvZxPWRkCQ9E/ieS6bi0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781791769; c=relaxed/simple;
	bh=6BLyiCwEEwB7WLtzQhw426+90iQIVNnbniXMxP7Q/6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQDNkEpPz4wsoZCqvRfOkd8vNQP9ra7Uxyi2njrR0F/2B5T0DYNKUN4G8IadWVxtOpeB020uIRyemj7tl/J0ZptZ9jFWxU9yKYj2Zdbrb44o5v1Bi85wPSrOELBqCxK5S7djqANiJSwBCbWvhp4NGi7CUhW8sz8UbF2YOLhLfCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AkTM3RO1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EF+Hxwzb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zlGyVBAn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Nh+M5q7R; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AkTM3RO1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EF+Hxwzb";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zlGyVBAn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Nh+M5q7R"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DB0D575E69;
	Thu, 18 Jun 2026 14:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781791766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fR6BzY2jFM/99D2ei/drSKsHjT0HjSwqJcoYF6KDMKU=;
	b=AkTM3RO1BEaTZZdER0AZq5lPK4QTJxbfeEg2+h3FOeS8h0ZpjPuvxgXotAhS+QzhBgLMml
	uxJg0iap9nOeKUPXGxYWhdDrh5C88YalVhooZS13ICrsSz9tUaNpWUiLMZQA2AbNjD1GKu
	B8SHQAutu/x1D2NxrScWHdbyeyMIdfg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781791766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fR6BzY2jFM/99D2ei/drSKsHjT0HjSwqJcoYF6KDMKU=;
	b=EF+HxwzbDASFlRuWZ7MzkORkEKbDLWDnKZiwCmtbAoftFNg/c5NMIGla1VwSEjh/kE95DY
	m8CnI7+Sx8Ce7RCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zlGyVBAn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Nh+M5q7R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781791765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fR6BzY2jFM/99D2ei/drSKsHjT0HjSwqJcoYF6KDMKU=;
	b=zlGyVBAnpLW7cerozHPqYle5hz9SLZAhiEnzUcitgwpt6rBJlrnOF4Eq/A7A1eklXuSgji
	jP624IhSUHmlUIWHiIw4HG6Mkce0Xo/efFilePqO6ekvtC/5Gzhz4lIETXfbMiurWNBB34
	sGVwu9c+o5YRQWnMdum5dJ6soeHB/PU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781791765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fR6BzY2jFM/99D2ei/drSKsHjT0HjSwqJcoYF6KDMKU=;
	b=Nh+M5q7RwZRWl6hCVOXqF5g04Ru5Q9+MaCxJXRUGdMqfhwE3aESftc46SWOzlQl/Bs9V6c
	DvXcq9ae+T2zaWCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CEF9E779A8;
	Thu, 18 Jun 2026 14:09:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tnyFMhX8M2r/CAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 14:09:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6FC7FA12D9; Thu, 18 Jun 2026 16:09:25 +0200 (CEST)
Date: Thu, 18 Jun 2026 16:09:25 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, peng_wang@linux.alibaba.com
Subject: Re: [PATCH v2 6/8] ext4: return -EAGAIN from ext4_map_blocks() in
 NOWAIT cache miss
Message-ID: <ekslfvokadqeiqmfbhv7d3v4ayguuqt7z53i5ze4u55fqkvkjg@waocl7jdgpja>
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-7-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618125735.4156639-7-libaokun@linux.alibaba.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: DB0D575E69
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
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com,linux.alibaba.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim,alibaba.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Thu 18-06-26 20:57:33, Baokun Li wrote:
> Make ext4_map_blocks() return -EAGAIN instead of 0 when
> EXT4_GET_BLOCKS_CACHED_NOWAIT is set and the extent status cache
> misses. This allows callers to easily distinguish between a successful
> cache lookup (positive return value) and a cache miss requiring disk
> access (-EAGAIN), simplifying error handling in NOWAIT paths.
> 
> The change affects two locations:
> 1. After cache hit: return retval ? retval : -EAGAIN
>    (return -EAGAIN if cache hit is hole/delayed)

Are you sure about this case? -EAGAIN looks wrong here - we have the valid
information cached and provide it to the caller without blocking. So at
least from the POV of ext4_map_blocks() there's no reason to return -EAGAIN.

								Honza

> 2. After cache miss: return -EAGAIN
>    (instead of 0, indicating need for disk lookup)
> 
> The only existing caller using EXT4_GET_BLOCKS_CACHED_NOWAIT is the
> ext4_get_link() -> ext4_getblk() path. Although ext4_getblk() now
> takes a different return branch (err < 0 instead of err == 0) and
> propagates -EAGAIN instead of NULL, ext4_get_link() converts both
> cases to -ECHILD via IS_ERR_OR_NULL(), so the final error seen by
> the VFS remains unchanged.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
> ---
>  fs/ext4/inode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 832794294ccf..03adbca3ec78 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -760,7 +760,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  		}
>  
>  		if (flags & EXT4_GET_BLOCKS_CACHED_NOWAIT)
> -			return retval;
> +			return retval ? retval : -EAGAIN;
> +
>  #ifdef ES_AGGRESSIVE_TEST
>  		ext4_map_blocks_es_recheck(handle, inode, map,
>  					   &orig_map, flags);
> @@ -776,7 +777,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  	 * cannot find extent in the cache.
>  	 */
>  	if (flags & EXT4_GET_BLOCKS_CACHED_NOWAIT)
> -		return 0;
> +		return -EAGAIN;
>  
>  	/*
>  	 * Try to see if we can get the block without requesting a new
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
