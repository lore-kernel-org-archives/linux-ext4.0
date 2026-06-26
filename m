Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CE53E6DE8
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782484181; cv=none; b=lnW00gPhvqNx1ZuKuLuHgu0QNCNTba6zGy/JJnskDJ84mwxeZgfVskeEUiDLjGIlsxGmpZ6RoUnOpIk3UVZYLv8LnKTD7+dn9P1WA30xY+TccBXkifoSTIEdtSkyTAC2vjRD4Rw8Mb6dBFLhslwLZAkeVA0hc8M/cV0FRMvhpmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782484181; c=relaxed/simple;
	bh=/vm7/XyovAf1DkxVnKVrGMlc4qZf8Xw30xj7uXkOGa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gqzw9jjNtdDBXiRiX63ny1GrhDuRdjCd02aysVaTt+v/PKS3Nu9OoMoPnR9+1KyylMIOU99f5q0xSt3jBV2v0xQYIiSQuyVUxY3aBKF9o759gTA2swW/T8uKmM+kvdiDmfBfeEL+RWYMU4ld7tZfrkzE3g84YYo0q4MHFlxnqoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DL1cxoMd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RM2KAAzg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DL1cxoMd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RM2KAAzg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DL1cxoMd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RM2KAAzg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DL1cxoMd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RM2KAAzg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0E0087583D;
	Fri, 26 Jun 2026 14:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782484177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TN0rZu05alKdoPMzwU6denfgHKnIMieqwDj2EfaGSY0=;
	b=DL1cxoMdsUpBTgMOWb3c+saU/Viy9xGeDUmW0aN31rF2Q2aHLsXPtASjoD2fBAKVBYBMzZ
	av61DTwlrMEIE16kwTrkH5P+CV1TtnPOZ+ggY+iFEtmgCmFGRZ8BSDiAZOOrb+pS1ipDFt
	0GgAFHGZA3T+mlOc+Qr+8nnMIB60lOU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782484177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TN0rZu05alKdoPMzwU6denfgHKnIMieqwDj2EfaGSY0=;
	b=RM2KAAzgRlEz074XO/v2nOyJmiVwjdmirGiZIsRGK/Zv0J5dpHMpS43Oqj8iBFRJBlqUL9
	eOaAf5CkXNrzO8CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DL1cxoMd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RM2KAAzg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782484177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TN0rZu05alKdoPMzwU6denfgHKnIMieqwDj2EfaGSY0=;
	b=DL1cxoMdsUpBTgMOWb3c+saU/Viy9xGeDUmW0aN31rF2Q2aHLsXPtASjoD2fBAKVBYBMzZ
	av61DTwlrMEIE16kwTrkH5P+CV1TtnPOZ+ggY+iFEtmgCmFGRZ8BSDiAZOOrb+pS1ipDFt
	0GgAFHGZA3T+mlOc+Qr+8nnMIB60lOU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782484177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TN0rZu05alKdoPMzwU6denfgHKnIMieqwDj2EfaGSY0=;
	b=RM2KAAzgRlEz074XO/v2nOyJmiVwjdmirGiZIsRGK/Zv0J5dpHMpS43Oqj8iBFRJBlqUL9
	eOaAf5CkXNrzO8CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2550779A8;
	Fri, 26 Jun 2026 14:29:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XR4dO9CMPmqfaAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 26 Jun 2026 14:29:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 70CA9A10A3; Fri, 26 Jun 2026 16:29:36 +0200 (CEST)
Date: Fri, 26 Jun 2026 16:29:36 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: tytso@mit.edu, jack@suse.cz, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ritesh.list@gmail.com, yi.zhang@huawei.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colin Ian King <colin.i.king@gmail.com>
Subject: Re: [PATCH v6] ext4: fix ABBA deadlock in
 ext4_xattr_inode_cache_find()
Message-ID: <bipyfjnmca4gx7dguiigrxgnrinalmcovio3tsepyqxdusz5av@4b7cbxjh27f7>
References: <20260626054821.1729-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626054821.1729-1-aditya.ansh182@gmail.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,suse.cz,dilger.ca,linux.alibaba.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0E0087583D
X-Spam-Score: -2.51

On Fri 26-06-26 05:48:21, Aditya Srivastava wrote:
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
> inode cache (cache miss), simply skip it (returning -ENOENT) rather than
> waiting for eviction/creation to complete, breaking the ABBA cycle.
> 
> Since we return -ENOENT immediately on a cache miss, we never attempt to
> allocate a new inode or call iget_locked(), completely eliminating any
> TOCTOU race window.
> 
> If the returned inode is I_NEW, wait for its initialization to clear via
> wait_on_new_inode(). If initialization fails and the inode is unhashed
> during wait_on_new_inode() waking up (e.g., due to an I/O read error in
> another thread), safely drop the reference and return -ENOENT. This
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

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v6:
>   - Drop the redundant is_freeing tracking variable completely, as pointed
>     out by Jan Kara.
>   - Return -ENOENT instead of -ESTALE on cache misses and unhashed inode
>     checks, as requested by Jan Kara.
> 
> Changes in v5:
>   - Address two critical concurrency issues flagged by the Sashiko AI bot in v4:
>     1. Resolve the Time-Of-Check to Time-Of-Use (TOCTOU) race window between
>        find_inode_nowait() and iget_locked() by returning -ESTALE immediately
>        on a VFS cache miss. This completely bypasses fallback to iget_locked()
>        and prevents potential ABBA deadlocks.
>     2. Fix the improperly nested inode_unhashed() safety check by moving it
>        outside the I_NEW condition block, ensuring it runs unconditionally
>        on all cache-hit pathways to prevent false-positive filesystem
>        corruption errors during concurrent initialization failures.
> 
> Changes in v4:
>   - Check if the inode was unhashed during wait_on_new_inode() waking up
>     to handle transient initialization failures (like I/O read errors)
>     gracefully. Dropping the reference and returning -ESTALE prevents
>     false filesystem corruption errors (__ext4_error), as found by the
>     Sashiko AI bot.
> 
> Changes in v3:
>   - Implement a new ext4_iget() configuration flag named EXT4_IGET_NOWAIT to
>     fully contain the non-blocking lookup and VFS-level validations within
>     inode.c, as requested by Jan Kara.
>   - Skip inodes currently being created (I_CREATING), following Jan Kara's
>     direct feedback.
>   - Remove all open-coded match helpers and VFS state-checks from xattr.c.
> 
> Changes in v2:
>   - Read inode state locklessly using inode_state_read_once() to resolve
>     a lockdep assertion on cache hit.
>   - Manually restore essential inode/ea_inode validations on the retrieved
>     inode (is_bad_inode, EXT4_EA_INODE_FL, file_acl, and xattr checks) to
>     match VFS safety guarantees and prevent using corrupted/failed inodes.
> 
>  fs/ext4/ext4.h  |  3 ++-
>  fs/ext4/inode.c | 35 ++++++++++++++++++++++++++++++++---
>  fs/ext4/xattr.c |  2 +-
>  3 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..c76dd0bdd3d8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3144,7 +3144,8 @@ typedef enum {
>  	EXT4_IGET_SPECIAL =	0x0001, /* OK to iget a system inode */
>  	EXT4_IGET_HANDLE = 	0x0002,	/* Inode # is from a handle */
>  	EXT4_IGET_BAD =		0x0004, /* Allow to iget a bad inode */
> -	EXT4_IGET_EA_INODE =	0x0008	/* Inode should contain an EA value */
> +	EXT4_IGET_EA_INODE =	0x0008,	/* Inode should contain an EA value */
> +	EXT4_IGET_NOWAIT =	0x0010	/* Non-blocking lookup (skip if freeing) */
>  } ext4_iget_flags;
>  
>  extern struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..a091a43959a3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5270,6 +5270,20 @@ void ext4_set_inode_mapping_order(struct inode *inode)
>  	mapping_set_folio_order_range(inode->i_mapping, min_order, max_order);
>  }
>  
> +static int ext4_iget_match(struct inode *inode, u64 ino, void *data)
> +{
> +	if (inode->i_ino != ino)
> +		return 0;
> +	spin_lock(&inode->i_lock);
> +	if (inode_state_read(inode) & (I_FREEING | I_WILL_FREE | I_CREATING)) {
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
> @@ -5298,9 +5312,24 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
>  		return ERR_PTR(-EFSCORRUPTED);
>  	}
>  
> -	inode = iget_locked(sb, ino);
> -	if (!inode)
> -		return ERR_PTR(-ENOMEM);
> +	if (flags & EXT4_IGET_NOWAIT) {
> +		inode = find_inode_nowait(sb, ino, ext4_iget_match, NULL);
> +		if (!inode)
> +			return ERR_PTR(-ENOENT);
> +
> +		if (inode_state_read_once(inode) & I_NEW)
> +			wait_on_new_inode(inode);
> +
> +		if (unlikely(inode_unhashed(inode))) {
> +			iput(inode);
> +			return ERR_PTR(-ENOENT);
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
