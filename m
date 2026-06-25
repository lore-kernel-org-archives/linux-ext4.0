Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539D03D1715
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 10:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782383018; cv=none; b=Cih+uUSIPwiYA8LTHY5Eaz5vKWHeQZhvOZGn7kMIjCVTYQlK5Vsnz2YRbqC2FM0m6Rd6KKdtkHJpqyHwIEq+pJiq541/E4AP5bKxep+HERVs2zWdvJYD7egf+w0NTPCTmN2sAPLXdRnxYjTsR7oPyDHk0OXKNm3dJ14Phashvuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782383018; c=relaxed/simple;
	bh=tJIOVsiMoksQSXO1SVicdw0/JBl/a+Qr+UAzzWeaL6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uaJ2WIfZ+aCOQu/A1C6D34b8NEaFEq73ihe5SM6ZqhQnbm5kymrUoTkyR8rF6w08MKPVuRrRCOLK+mvjejWCSRjEmxqLX0tmp+c7CV9RoYDzipcenqwdvhsZKixdQv0DVp28WBS7j4/hRXBIVgaZe2fbps+Uc4GNI7Os/iFfIcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OOyIXI71; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SiIgCgyP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OOyIXI71; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SiIgCgyP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OOyIXI71";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SiIgCgyP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OOyIXI71";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SiIgCgyP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 675A171A68;
	Thu, 25 Jun 2026 10:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782383015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o6acj0uiw83/C9f4OD4aMFOACTYyOQvWfT8D4WTrhig=;
	b=OOyIXI710/c0TweACjluimZjVCvBxI0peNBp7sa+nST6QNxkqWY/jwK9yrfPnPzHlk3+oJ
	Ixur4kYdUJLj/GI+ag5eG71LrZoArwajESZYa2cMxrDyopihR4/sf/O0A2cyqQkrgkq1gG
	0uNZ+rPEZ34SYjSEirtCkaT+s+DVxcA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782383015;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o6acj0uiw83/C9f4OD4aMFOACTYyOQvWfT8D4WTrhig=;
	b=SiIgCgyPK3Yxejx+Ju++LkWOOzXySo6Ow9o7Fu4Twi+cqMf4RzwWbZsC2WRPpqc1zuKS25
	iP64agRCSTD3JODQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OOyIXI71;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SiIgCgyP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782383015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o6acj0uiw83/C9f4OD4aMFOACTYyOQvWfT8D4WTrhig=;
	b=OOyIXI710/c0TweACjluimZjVCvBxI0peNBp7sa+nST6QNxkqWY/jwK9yrfPnPzHlk3+oJ
	Ixur4kYdUJLj/GI+ag5eG71LrZoArwajESZYa2cMxrDyopihR4/sf/O0A2cyqQkrgkq1gG
	0uNZ+rPEZ34SYjSEirtCkaT+s+DVxcA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782383015;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o6acj0uiw83/C9f4OD4aMFOACTYyOQvWfT8D4WTrhig=;
	b=SiIgCgyPK3Yxejx+Ju++LkWOOzXySo6Ow9o7Fu4Twi+cqMf4RzwWbZsC2WRPpqc1zuKS25
	iP64agRCSTD3JODQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4CAC8779A8;
	Thu, 25 Jun 2026 10:23:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id H9kQEqcBPWrgKQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 25 Jun 2026 10:23:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E513CA10A3; Thu, 25 Jun 2026 12:23:26 +0200 (CEST)
Date: Thu, 25 Jun 2026 12:23:26 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: tytso@mit.edu, jack@suse.cz, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ritesh.list@gmail.com, yi.zhang@huawei.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colin Ian King <colin.i.king@gmail.com>
Subject: Re: [PATCH v5] ext4: fix ABBA deadlock in
 ext4_xattr_inode_cache_find()
Message-ID: <emhyf7w5rac5e2bgaxnbphgo5tlbpud24utygg22dobqnhuacx@2t76kf3yooca>
References: <20260625065010.2332-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625065010.2332-1-aditya.ansh182@gmail.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,suse.cz,dilger.ca,linux.alibaba.com,gmail.com,huawei.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 675A171A68
X-Spam-Score: -2.51

On Thu 25-06-26 06:50:09, Aditya Srivastava wrote:
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
> I_WILL_FREE) or created (I_CREATING), or if it is not present in the VFS
> inode cache (cache miss), simply skip it (returning -ESTALE) rather than
> waiting for eviction/creation to complete, breaking the ABBA cycle.
> 
> Since we return -ESTALE immediately on a cache miss, we never attempt to
> allocate a new inode or call iget_locked(), completely eliminating any
> TOCTOU race window.
> 
> If the returned inode is I_NEW, wait for its initialization to clear via
> wait_on_new_inode(). If initialization fails and the inode is unhashed
> during wait_on_new_inode() waking up (e.g., due to an I/O read error in
> another thread), safely drop the reference and return -ESTALE. This
> unhashed check is executed unconditionally on all cache-hit pathways to
> properly handle concurrent initialization failures.
> 
> Finally, standard validation checks (including is_bad_inode,
> EXT4_EA_INODE_FL, file_acl, and xattr flags) are executed as normal inside
> check_igot_inode() to fully guarantee VFS-layer safety.
> 
> In ext4_xattr_inode_cache_find(), invoke ext4_iget() with the new
> EXT4_IGET_NOWAIT flag to perform the non-blocking cache search.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Reported-by: Colin Ian King <colin.i.king@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219283
> Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Three patch submissions in a day? I think you are overdoing it. Please test
more, think more about what you do (i.e., really understand what the code
does, not just whatever some AI agent suggested) and submit less.

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
> +		if (is_freeing || !inode)

is_freeing is pointless. Just drop it and use !inode.

> +			return ERR_PTR(-ESTALE);

I'd prefer -ENOENT here instead of -ESTALE. It's kind of more specific.

> +		if (inode_state_read_once(inode) & I_NEW)
> +			wait_on_new_inode(inode);
> +
> +		if (unlikely(inode_unhashed(inode))) {
> +			iput(inode);
> +			return ERR_PTR(-ESTALE);

Here -ENOENT as well please.

Otherwise the patch looks good to me.

								Honza

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
