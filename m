Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793020586;
	b=ZZ0eLv1fiR/6J0KTpmHMmT6L8XEyEnWrmdv4ahfdNlqqg7sMoXZmIBZ1KvK9P/tjjSzJ
	 Ixt+N/BceJifx3Inj46MVJ8LTfAIupQ4sY98/gSWgU1Pf5FGfE6h6tYVobuX0+uY5Mq6T
	 WB2yaSR/kDi1RFcFdDnrkfpQItWThd4mMOGkKddNWEIKlzuAzx8Q91ZQQA9d3nCzCSuha
	 0czElQ6hB+XMQIPB8TbUpz67VdZgcOeFiYq0gZ6h5xw9sGlojVNdY2b2wf/tR79TGmtC8
	 Mt1xQ1macWE8FB4C2aMP70iJsGBC4QzXZJm0rfzGXIpTBL5K6JVPysIq+6x800Yuvpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020586;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=uPBVY13550N14hL+IGk35wKKeTHr4lxO3h9f95jd7JQ=;
	b=a4slnb196ZNZMiRH/vcJN5y9g3a1l5SN1ACafTuilCIVdM8KZ/y4K7I18ZTroZeS+EE+
	 KY7peAFaciLMG4NjsvEJFkhtTj19+hUtzaMjWIGcpuFwqOp+ZqyOyuUZTJ7F3ROZ1jr/k
	 wFTniAAt+TauSxytRWmRmQdnJ+9HF5kEw0zbSfnk8g0K3qLJ+9fVBT0yR3oLSQfDqXtAN
	 8XigNfqv+xYVnomPTTeYqEGaHlJc5B3sDPg0/yLotroZs0KqpZvXVDDLiMiN8BzQU+YsO
	 m2NGXEi1pap4217774JKcWkT5TeDLc5h1PT6kTTsrFqJj3hGqlU5ltWg+gAlat3alug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KMTpm5F1;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BuF6fJSo;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KMTpm5F1;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BuF6fJSo;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9C3606A31A;
	Mon, 26 Oct 2026 13:16:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E9C3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KMTpm5F1;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BuF6fJSo;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KMTpm5F1;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BuF6fJSo
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4F7B11F80B;
	Mon, 26 Oct 2026 13:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793020584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uPBVY13550N14hL+IGk35wKKeTHr4lxO3h9f95jd7JQ=;
	b=KMTpm5F1MJ9oPBIgv02dnTf1lEdUrWZkVIgdBh2sfnVkCgiJ/l0X2CfypgCEjP0w+YKqAr
	EEe4cf1mZABSq7+BJIjdPJ4dKGs63Q2JviYnrGQIOo393iVGDNB0Ywbh+A9xRm8vmo0ey2
	GncvAFg57tryIokdExbnVQed4UXW55M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793020584;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uPBVY13550N14hL+IGk35wKKeTHr4lxO3h9f95jd7JQ=;
	b=BuF6fJSoCOyPGLUVfudXR18pY+Qs2WKmkxzbSHXjKcyqE1dxuxO7FiD3CLq+p6EmMu28c8
	3e6t4X48ppg0HPCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793020584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uPBVY13550N14hL+IGk35wKKeTHr4lxO3h9f95jd7JQ=;
	b=KMTpm5F1MJ9oPBIgv02dnTf1lEdUrWZkVIgdBh2sfnVkCgiJ/l0X2CfypgCEjP0w+YKqAr
	EEe4cf1mZABSq7+BJIjdPJ4dKGs63Q2JviYnrGQIOo393iVGDNB0Ywbh+A9xRm8vmo0ey2
	GncvAFg57tryIokdExbnVQed4UXW55M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793020584;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uPBVY13550N14hL+IGk35wKKeTHr4lxO3h9f95jd7JQ=;
	b=BuF6fJSoCOyPGLUVfudXR18pY+Qs2WKmkxzbSHXjKcyqE1dxuxO7FiD3CLq+p6EmMu28c8
	3e6t4X48ppg0HPCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 272FB13408;
	Mon, 26 Oct 2026 13:16:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YpPYAKhS32pkaQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 26 Oct 2026 13:16:24 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AADADA1419; Mon, 26 Oct 2026 14:16:19 +0100 (CET)
Date: Mon, 26 Oct 2026 14:16:19 +0100
From: Jan Kara <jack@suse.cz>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: take invalidate_lock in ext2_write_failed()
Message-ID: <akdbsbqjyqpju5a42sh64yovrl47p7ty3yp5nm36pmfgrduaxj@tlx6yc5atpiy>
References: <20261024222726.889520-1-pfalcato@suse.de>
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
In-Reply-To: <20261024222726.889520-1-pfalcato@suse.de>
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.de:email]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO

On Sat 24-10-26 23:27:26, Pedro Falcato wrote:
> Currently, ext2_write_failed() takes care of removing extra data
> (folios & blocks) from the page cache by first truncating the page cache,
> then truncating the actual inode's blocks.
> 
> Understanding that this is correct - namely, that a concurrent page cache
> lookup can't create stale pages and stale block mappings between
> truncate_pagecache() and ext2_truncate_blocks() - is non trivial. This is
> correct for two non-obvious reasons:
> 
> 1) every caller of ext2_write_failed() holds some sort of exclusion
> against truncation. In most cases, callers hold (in some way) the inode
> lock. ext2_write_failed() is only reachable from buffered/direct IO write
> paths, which hold it. page_symlink() can also call write_begin _without
> the inode lock_, but at that point the inode is I_NEW, so there are no other
> users.
> 
> 2) the page cache is generally extremely careful at never instantiating
> pages beyond EOF.
> 
> This is all quite confusing. Holding the invalidate lock across both
> operations is largely simpler, and mirrors other bits of other filesystems
> (like ext4_truncate_failed_write). Do that.
> 
> This has the side effect of making it so ext2_evict_inode() doesn't take
> the invalidate_lock when truncating blocks on inode deletion. This is safe
> as the inode should not have any users at that point.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

There's actually one more reason - filesystems that don't support hole
punching are generally ok with the synchronization provided by inode lock
and i_size checks (as within i_size allocated space can never disappear
under you). But I agree this is all too subtle so you're change is a good
one. Added to my tree.

								Honza

> ---
> 
> This is a patch that fell out of trying to understand whether
> 20261021162105.62525-1-matheus.aalmeida@inf.ufrgs.br was correct. I think
> it is, for the same reason ext2 is correct. I find this to be easier to reason
> about if we just take the invalidate lock across both operations.
> 
>  fs/ext2/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 12ac4cfe1500..723b31dc7dac 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -58,8 +58,10 @@ void ext2_write_failed(struct address_space *mapping, loff_t to)
>  	struct inode *inode = mapping->host;
>  
>  	if (to > inode->i_size) {
> +		filemap_invalidate_lock(mapping);
>  		truncate_pagecache(inode, inode->i_size);
>  		ext2_truncate_blocks(inode, inode->i_size);
> +		filemap_invalidate_unlock(mapping);
>  	}
>  }
>  
> @@ -1236,9 +1238,7 @@ static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
>  	if (ext2_inode_is_fast_symlink(inode))
>  		return;
>  
> -	filemap_invalidate_lock(inode->i_mapping);
>  	__ext2_truncate_blocks(inode, offset);
> -	filemap_invalidate_unlock(inode->i_mapping);
>  }
>  
>  static int ext2_setsize(struct inode *inode, loff_t newsize)
> -- 
> 2.56.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
