Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6652C2D97BB
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 14:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781791833; cv=none; b=rzR9pHqsAzwv85ixwz0wmMaOozFT1Yfoz36GmwTvksXVY+VNh5YR1GdcZtIIxhx2LO+XPN6Zg4oFTNFtGDr8ICsdYJGOvgu3cYYJBfVLE1so8XcQUwd+yySvppOCN3MLMPqFccRhHz5sozIeXd1CiHd5u7l+70BYyyvZBo+FCnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781791833; c=relaxed/simple;
	bh=+kFohhxfIEbxWAU+cH+Fr27GTWnloCUKy4q8WwUl+6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2CqNKf9WriFBRhi/HUR9+URt2yZGCsPMlQTlq8JZniCjzO+9fSYg86NCtkmi5m30pvf5eXtQXlCOkLOdchgF+0+brXZ3njpjieqDtRi09D39UYnHqvONEmZoEZjTENq5qSDfZKMH5an1qrBQRdE0w+GNhvIqbXFMky8vYEWcSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WpLy4R+a; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nqy/OhcL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WpLy4R+a; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nqy/OhcL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WpLy4R+a";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nqy/OhcL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WpLy4R+a";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nqy/OhcL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B52FF6D3D3;
	Thu, 18 Jun 2026 14:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781791830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vf61mp0IwxXPRB6nJ3X2jaWZF9nlxRMRToffXvdvsh4=;
	b=WpLy4R+atACNrf73xh5V0iXZwNtdJQikgHSM9JJxOFl44KQyy5SxPRWggCq609pJmmwJLn
	mRTHYrGN4qZ8rudLpQEdH7Qjr5qaACSWsTnWeUucmUI8bnFnD1HGCYwNm8rmmavYPUKTvd
	idyxvR2nxJycnWjZpQqCCViAH3yQhsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781791830;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vf61mp0IwxXPRB6nJ3X2jaWZF9nlxRMRToffXvdvsh4=;
	b=nqy/OhcLe0wXKJ1hSEuo2WnKd2NFCdZwI1VDS6G0TmzECer4J+MP1IQGhFNqNO4qyN6oyO
	FgAPTy6iTYCGGdBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781791830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vf61mp0IwxXPRB6nJ3X2jaWZF9nlxRMRToffXvdvsh4=;
	b=WpLy4R+atACNrf73xh5V0iXZwNtdJQikgHSM9JJxOFl44KQyy5SxPRWggCq609pJmmwJLn
	mRTHYrGN4qZ8rudLpQEdH7Qjr5qaACSWsTnWeUucmUI8bnFnD1HGCYwNm8rmmavYPUKTvd
	idyxvR2nxJycnWjZpQqCCViAH3yQhsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781791830;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vf61mp0IwxXPRB6nJ3X2jaWZF9nlxRMRToffXvdvsh4=;
	b=nqy/OhcLe0wXKJ1hSEuo2WnKd2NFCdZwI1VDS6G0TmzECer4J+MP1IQGhFNqNO4qyN6oyO
	FgAPTy6iTYCGGdBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6FAC779A8;
	Thu, 18 Jun 2026 14:10:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SuTCKFb8M2qDCgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 14:10:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5C1F5A12D9; Thu, 18 Jun 2026 16:10:30 +0200 (CEST)
Date: Thu, 18 Jun 2026 16:10:30 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, peng_wang@linux.alibaba.com
Subject: Re: [PATCH v2 8/8] ext4: handle IOCB_NOWAIT in
 ext4_dio_needs_zeroing() with cache-only lookup
Message-ID: <ktw6csahokq6qmm74mkp4wpr2bbetoc3s7kesql4qv4j5wm3nx@dux4mkmyvwp4>
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-9-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618125735.4156639-9-libaokun@linux.alibaba.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
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
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com,linux.alibaba.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email,alibaba.com:email]
X-Spam-Level: 

On Thu 18-06-26 20:57:35, Baokun Li wrote:
> Add a nowait parameter to ext4_dio_needs_zeroing() and pass
> EXT4_GET_BLOCKS_CACHED_NOWAIT flag to ext4_map_blocks() when
> IOCB_NOWAIT is set. This ensures the needs_zeroing check only uses
> cached extent info. If cache misses, ext4_map_blocks() returns
> -EAGAIN, causing ext4_dio_needs_zeroing() to conservatively return
> true (needs zeroing). The caller then tries to upgrade to exclusive
> lock, which returns -EAGAIN for NOWAIT, avoiding potential sleep on
> down_read(i_data_sem).
> 
> The caller in ext4_dio_write_checks() is updated to pass the
> IOCB_NOWAIT flag from the kiocb.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 5ffc1afd8050..44d1658d2b5a 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -228,7 +228,8 @@ ext4_extending_io(struct inode *inode, loff_t offset, size_t len)
>   * unwritten conversion for middle blocks are protected by i_data_sem
>   * and inode_dio_begin().
>   */
> -static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
> +static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len,
> +				   bool nowait)
>  {
>  	struct ext4_map_blocks map;
>  	unsigned int blkbits = inode->i_blkbits;
> @@ -236,10 +237,14 @@ static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
>  	bool head_partial, tail_partial;
>  	ext4_lblk_t head_lblk, tail_lblk;
>  	int err;
> +	int map_flags = 0;
>  
>  	if (pos + len > i_size_read(inode))
>  		return true;
>  
> +	if (nowait)
> +		map_flags = EXT4_GET_BLOCKS_CACHED_NOWAIT;
> +
>  	head_partial = (pos & blockmask) != 0;
>  	tail_partial = ((pos + len) & blockmask) != 0;
>  	head_lblk = pos >> blkbits;
> @@ -249,7 +254,7 @@ static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
>  	if (head_partial) {
>  		map.m_lblk = head_lblk;
>  		map.m_len = tail_lblk - head_lblk + 1;
> -		err = ext4_map_blocks(NULL, inode, &map, 0);
> +		err = ext4_map_blocks(NULL, inode, &map, map_flags);
>  		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
>  			return true;
>  		/* If this mapping already covers the tail block, we're done. */
> @@ -261,7 +266,7 @@ static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
>  	if (tail_partial) {
>  		map.m_lblk = tail_lblk;
>  		map.m_len = 1;
> -		err = ext4_map_blocks(NULL, inode, &map, 0);
> +		err = ext4_map_blocks(NULL, inode, &map, map_flags);
>  		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
>  			return true;
>  	}
> @@ -516,7 +521,8 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	 * under shared lock is safe.
>  	 */
>  	if (ext4_unaligned_io(inode, from, offset))
> -		needs_zeroing = ext4_dio_needs_zeroing(inode, offset, count);
> +		needs_zeroing = ext4_dio_needs_zeroing(inode, offset, count,
> +						iocb->ki_flags & IOCB_NOWAIT);
>  
>  	/* Determine whether we need to upgrade to an exclusive lock. */
>  	if (*ilock_shared &&
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
