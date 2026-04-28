Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F933340A62
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2026 07:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777361909; cv=none; b=Vdoq+VnuwVmJKpF6t2fHqBAQUtAKazEWUvRdrK40BB5qJ2l373QaPHpFuOdktB2IeORSOS/UbMuNJyi+n8i8X6nT9CZs+OrvT9fgJDG+kBq/piZv3qKMGGydITnXrRbOj33cUUjfbKmCIcsQyCgMQWvjvrbUzCyqgVMit3HOIKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777361909; c=relaxed/simple;
	bh=ORllD8SYxqg8ONkBeCCdm+Q/TcPESEZ+9T1Rjt6Yc0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bqd0ATjrhkYPnCNUWSRN/i6BO+kFaFGCJ7kSymmS1lRSrQVuQ9cuSnA2oCtGqIbETvvPZbYa+BrEoqMd+oVvViyI97m/vI9Ps2WrxseDFz017XAnBtYtyK2lHJRweOldeHva4EbjZjl9RGf7n2FgxK4QUXwfp0gNEtZL8ljvV3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oRd5T5bJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+6T+yg+E; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oRd5T5bJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+6T+yg+E; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oRd5T5bJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+6T+yg+E";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oRd5T5bJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+6T+yg+E"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BCAE46A81D;
	Tue, 28 Apr 2026 07:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777361905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xwdulIiaaKLgZrV/lJNHyJbHzx0M+9VluyBt041n3GE=;
	b=oRd5T5bJrx05M3ar5uu5WNIx2dBQ0j+ye1lRHPm1s/6alc3tU7b8kLYmejPyTjEvNZotDb
	CZB3IHM7jX8DSiC81c/kv7ukWwrCkJaJX3X2mat/7dyGexyLnoNECTcl9TDCm6mYavgddk
	h0uwFkHV+B+AXo4My6GW0IRGdmT88F4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777361905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xwdulIiaaKLgZrV/lJNHyJbHzx0M+9VluyBt041n3GE=;
	b=+6T+yg+ELr+MAv2u6UoEu4XVbCVbqTcSDnpS9WgLt2/7CGcNClHk7mlOq6hXzc5ryj+1i6
	cJz4Jmtfv93pucDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oRd5T5bJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+6T+yg+E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777361905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xwdulIiaaKLgZrV/lJNHyJbHzx0M+9VluyBt041n3GE=;
	b=oRd5T5bJrx05M3ar5uu5WNIx2dBQ0j+ye1lRHPm1s/6alc3tU7b8kLYmejPyTjEvNZotDb
	CZB3IHM7jX8DSiC81c/kv7ukWwrCkJaJX3X2mat/7dyGexyLnoNECTcl9TDCm6mYavgddk
	h0uwFkHV+B+AXo4My6GW0IRGdmT88F4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777361905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xwdulIiaaKLgZrV/lJNHyJbHzx0M+9VluyBt041n3GE=;
	b=+6T+yg+ELr+MAv2u6UoEu4XVbCVbqTcSDnpS9WgLt2/7CGcNClHk7mlOq6hXzc5ryj+1i6
	cJz4Jmtfv93pucDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE54A593B0;
	Tue, 28 Apr 2026 07:38:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IQWJKvFj8GltAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Apr 2026 07:38:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 66A73A0B62; Tue, 28 Apr 2026 09:38:21 +0200 (CEST)
Date: Tue, 28 Apr 2026 09:38:21 +0200
From: Jan Kara <jack@suse.cz>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun1@huawei.com, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com
Subject: Re: [PATCH] ext4: avoid BUG_ON() in ext4_get_inline_entry()
Message-ID: <qnbtbpu4awi3hktmfkmmrng7jaa4df42mpruuiiynyux6ua7ky@ba5mlsy5fst4>
References: <20260427162020.49723-1-agarwal.vineet2006@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427162020.49723-1-agarwal.vineet2006@gmail.com>
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
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,huawei.com,suse.cz,linux.ibm.com,gmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim]
X-Rspamd-Queue-Id: BCAE46A81D
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Mon 27-04-26 21:50:20, Vineet Agarwal wrote:
> Corrupted inline directory metadata can cause offset to exceed
> the inline data size through rec_len processing in
> empty_inline_dir().
> 
> This triggers BUG_ON() in ext4_get_inline_entry(), causing a
> kernel panic before ext4_check_dir_entry() can handle the
> corruption gracefully.
> 
> Replace BUG_ON() with a NULL return and handle the invalid
> offset in the caller by emitting a warning and exiting safely.
> 
> This prevents a kernel panic from corrupted inline directory
> metadata.
> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>

I guess this is motivated by some syskaller fuzzing (would be good to
reference). It however doesn't explain how the BUG_ON can trigger when
empty_inline_dir() just did:

	inline_len = ext4_get_inline_size(dir);
	...
	while (offset < inline_len) {
		de = ext4_get_inline_entry(dir, &iloc, offset, ...)

I suspect modification of the fs image while being mounted which is not
something we care about.

								Honza

> ---
>  fs/ext4/inline.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 8045e4ff270c..bca9936ed6d0 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1718,7 +1718,8 @@ ext4_get_inline_entry(struct inode *inode,
>  {
>  	void *inline_pos;
>  
> -	BUG_ON(offset > ext4_get_inline_size(inode));
> +	if (offset > ext4_get_inline_size(inode))
> +		return NULL;
>  
>  	if (offset < EXT4_MIN_INLINE_DATA_SIZE) {
>  		inline_pos = (void *)ext4_raw_inode(iloc)->i_block;
> @@ -1773,6 +1774,12 @@ bool empty_inline_dir(struct inode *dir, int *has_inline_data)
>  	while (offset < inline_len) {
>  		de = ext4_get_inline_entry(dir, &iloc, offset,
>  					   &inline_pos, &inline_size);
> +		if (!de) {
> +			ext4_warning(dir->i_sb,
> +				     "bad inline directory (dir #%llu) - invalid offset",
> +				     dir->i_ino);
> +			goto out;
> +		}
>  		if (ext4_check_dir_entry(dir, NULL, de,
>  					 iloc.bh, inline_pos,
>  					 inline_size, offset)) {
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
