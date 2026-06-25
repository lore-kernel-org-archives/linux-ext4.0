Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5DF3CC7F1
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 10:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782382487; cv=none; b=ph+JhNHt9i3HVAMomvQgJWth0379ovgHoWe6LA9TxKq8F7CF44GO4RXmC1hsXPPq7G07P1qu3HilusHSRH545ybmDpsD5KLkVf6bQaDdqie7HnPmpNeBNYwEs+gDzK2JfZKimlYc764Ovmw+/QiWfO7nJwn6O82YsUtHtdXd2ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782382487; c=relaxed/simple;
	bh=QpOk9W42kwjLN2apZ6OjTuOxx6uaSFwTa2DuqTPZhHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BP1WkwlyeRtcT94vLt31jAmuIiS48Cg/tA5/V9zHPZKnbRiIJng5Ycmj827kALSLqfxelnlUdBE2kax9G1Ch3N6Upu/9CDgrFDR3xP9nOmeROIHcLEz3bTTN2xKLvRjH0fStdmwmXnpLkZ47KPWgAeWjKBJ4WAn4nuXsQM4JLcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QEcRAltz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IKAvGBlf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oKiMgnU9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=T7G/hl14; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QEcRAltz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IKAvGBlf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oKiMgnU9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="T7G/hl14"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 25159719A0;
	Thu, 25 Jun 2026 10:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782382484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cwjgz8rG1xwhjhceAE5Lnnpi7U2eAOY/pBa9CtYuLjE=;
	b=QEcRAltz6g87QVmExBiz1BkErvJculv4NBAqOXIdPwlQQl2KADxqEuEYvmt/ceCuoxmsKA
	GB6l1aMXpKSIlRajQf2TD5JYRsNpAkJ7Ax4+Yr5XG23GpEonlgLuHev3l8+wL9+f3sAyZP
	DVk+F/F6n9nTWXhqmyXdJ06NWQRtfLE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782382484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cwjgz8rG1xwhjhceAE5Lnnpi7U2eAOY/pBa9CtYuLjE=;
	b=IKAvGBlfmPAdMIXhFA2WPAaBEbhsmsL8s141foPBom8r/P3tq+s9niWukVHhcWOslT1yEi
	lcNKOX4A6fRyeaDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782382483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cwjgz8rG1xwhjhceAE5Lnnpi7U2eAOY/pBa9CtYuLjE=;
	b=oKiMgnU9I06YB7mFa/SXPxaHFKlNkvWSfYVgAId+Op7i7kHsmADcXSKtK3FlomedsCE6Qe
	bMTFNrm+01OR6b+aLYUdOKWcsKLbw95uDWLMagPkqBvapoa9xEHDgi5Szy9C6/aBvoYv/s
	WjONzW269uVwRAguyyIp4I9sm/r6PJI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782382483;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cwjgz8rG1xwhjhceAE5Lnnpi7U2eAOY/pBa9CtYuLjE=;
	b=T7G/hl14ro2WU1fITp+tCj7JMqrchnSXg9syn0Dcod79NRhhzrJVNxHlFUaOIfVrfUpyus
	N9jg9kguV8ijezCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19DB3779A8;
	Thu, 25 Jun 2026 10:14:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id My9LBpP/PGqlIQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 25 Jun 2026 10:14:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B1F4AA10A3; Thu, 25 Jun 2026 12:14:38 +0200 (CEST)
Date: Thu, 25 Jun 2026 12:14:38 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: tytso@mit.edu, jack@suse.cz, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ritesh.list@gmail.com, yi.zhang@huawei.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colin Ian King <colin.i.king@gmail.com>
Subject: Re: [PATCH v3] ext4: fix ABBA deadlock in
 ext4_xattr_inode_cache_find()
Message-ID: <5szef5t4ypf4ertpl25qac3costs27itof3a7tw3eiln2yiuwn@qvoccwrbzkge>
References: <20260625040935.2244-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625040935.2244-1-aditya.ansh182@gmail.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,suse.cz,dilger.ca,linux.alibaba.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Thu 25-06-26 04:09:35, Aditya Srivastava wrote:
> From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> 
> Syzbot/stress-ng reported an ABBA deadlock in ext4 when exercising
> concurrent xattr workloads (using the ea_inode mount/format option).
> 
> The deadlock occurs between the running transaction and the eviction
> thread:
> - Task 1 (stress-ng): Holds a reference to a shared mbcache_entry (ce)
>   and calls ext4_xattr_inode_cache_find() -> ext4_iget() to retrieve
>   the corresponding EA inode. Since the EA inode is currently being
>   evicted, ext4_iget() blocks in __wait_on_freeing_inode() waiting for
>   eviction to complete.
> - Task 2 (eviction thread): Currently evicting the same EA inode in
>   ext4_evict_ea_inode(). It calls mb_cache_entry_wait_unused(oe) which
>   blocks waiting for Task 1 to release the reference to the mbcache_entry.
> 
> To break this deadlock, implement a new ext4_iget() configuration flag
> named EXT4_IGET_NOWAIT. When set, perform a non-blocking lookup of the
> inode via VFS's find_inode_nowait() API.
> 
> If the inode is currently being evicted (marked with I_FREEING or
> I_WILL_FREE) or created (I_CREATING), simply skip it (returning -ESTALE)
> rather than waiting for eviction/creation to complete, breaking the ABBA
> cycle. If the returned inode is I_NEW, wait for its initialization to
> clear via wait_on_new_inode(). Finally, standard validation checks
> (including is_bad_inode, EXT4_EA_INODE_FL, file_acl, and xattr flags) are
> executed as normal inside check_igot_inode() to fully guarantee VFS-layer
> safety.
> 
> In ext4_xattr_inode_cache_find(), invoke ext4_iget() with the new
> EXT4_IGET_NOWAIT flag to perform the non-blocking cache search.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Reported-by: Colin Ian King <colin.i.king@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219283
> Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

...

> +static int ext4_iget_match(struct inode *inode, u64 ino, void *data)
> +{
> +	bool *is_freeing = data;
> +
> +	if (inode->i_ino != ino)
> +		return 0;
> +	spin_lock(&inode->i_lock);
> +	if (inode_state_read(inode) & (I_FREEING | I_WILL_FREE | I_CREATING)) {
> +		if (is_freeing)
> +			*is_freeing = true;
> +		spin_unlock(&inode->i_lock);
> +		return -1;
> +	}
> +	__iget(inode);
> +	spin_unlock(&inode->i_lock);
> +	return 1;
> +}
> +
>  struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
>  			  ext4_iget_flags flags, const char *function,
>  			  unsigned int line)
> @@ -5298,9 +5316,26 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
>  		return ERR_PTR(-EFSCORRUPTED);
>  	}
>  
> -	inode = iget_locked(sb, ino);
> -	if (!inode)
> -		return ERR_PTR(-ENOMEM);
> +	if (flags & EXT4_IGET_NOWAIT) {
> +		bool is_freeing = false;
> +
> +		inode = find_inode_nowait(sb, ino, ext4_iget_match, &is_freeing);
> +		if (is_freeing)
> +			return ERR_PTR(-ESTALE);

In case of EXT4_IGET_NOWAIT I just would not bother with returning errors
like this. Just if the inode was not found or cannot be grabbed, I'd return
say -ENOENT from __ext4_iget() and be done with it. Due to the nature of
EXT4_IGET_NOWAIT it is unreliable and the caller thus has to decide what to
do in case the inode cannot be grabbed.

> +		if (!inode) {
> +			inode = iget_locked(sb, ino);
> +			if (!inode)
> +				return ERR_PTR(-ENOMEM);

Hu, what's the point of this? It defeats the purpose of EXT4_IGET_NOWAIT as
it can block...

								Honza

> +		} else {
> +			if (inode_state_read_once(inode) & I_NEW)
> +				wait_on_new_inode(inode);
> +		}
> +	} else {
> +		inode = iget_locked(sb, ino);
> +		if (!inode)
> +			return ERR_PTR(-ENOMEM);
> +	}
> +
>  	if (!(inode_state_read_once(inode) & I_NEW)) {
>  		ret = check_igot_inode(inode, flags, function, line);
>  		if (ret) {
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 982a1f831e22..21b5670d8503 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1550,7 +1550,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
>  
>  	while (ce) {
>  		ea_inode = ext4_iget(inode->i_sb, ce->e_value,
> -				     EXT4_IGET_EA_INODE);
> +				     EXT4_IGET_EA_INODE | EXT4_IGET_NOWAIT);
>  		if (IS_ERR(ea_inode))
>  			goto next_entry;
>  		ext4_xattr_inode_set_class(ea_inode);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
