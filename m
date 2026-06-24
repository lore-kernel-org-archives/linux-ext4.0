Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954813B2FF9
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782306805; cv=none; b=tm5I6mvN0EiQIQOnp9xIwFzUFCgALUpS5M16A+k78BbYdDsCq23GGdyUgH8MyNH+GcV8+gNAh2zxlkH20hNYZY0x2CShO5TfqRsqUf/UVTbwaHmw7FV6jSQROfT0EhWKLYuCiCKymAvfM93PJTO1ka+puN7E5af9cg1n+ItsnN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782306805; c=relaxed/simple;
	bh=mC8Gzx0hRBhEGjzLBdhXV/BUGoJ1meZWTLAjjmi63sA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hThHAdqY5tHJVQZ71y3rExLQDlu7GMv3Wq27rrU8b6wzCakq7+zOPND0Z5J/UKKsYtTDa5ner5EGk/RxrTPYPFApEv9YEM9zuFIpnSc7cgUa+MIKPuSitZbDx8BcVKS7xvF633A5pHCkCUy/Jb8rgQBk+t+xvPGwo3ejEm7CJCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a0c31hek; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KT4dlhot; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a0c31hek; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KT4dlhot; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a0c31hek";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KT4dlhot";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a0c31hek";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KT4dlhot"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3F9EC75ED7;
	Wed, 24 Jun 2026 13:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782306801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LX6xJumGntXXDUbv4cEYrK5CrV1eQ+w6mTItoSxKhxA=;
	b=a0c31hekPNDGxzflcjKgbHIbo6n4oW4HM+RNtWMXPZaOmb7FEi4wVi6dJAgs2ntXxysoqr
	xa4CV3Co89WvSpBjr318ohXh4DD/H+mMJnN9x9osyWAgxQObfuOlGa6kMutynqHK6RRICs
	Jm2lqXKAG58EGDoi2OhGmx47DX2YZMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782306801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LX6xJumGntXXDUbv4cEYrK5CrV1eQ+w6mTItoSxKhxA=;
	b=KT4dlhotsL8ZmWaO24EjzMp/BrwBz1JFXznkdyQsff90PkcaIEJGVEWF37GsYG5byAwWma
	cke/Wx/k7ls7uhCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782306801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LX6xJumGntXXDUbv4cEYrK5CrV1eQ+w6mTItoSxKhxA=;
	b=a0c31hekPNDGxzflcjKgbHIbo6n4oW4HM+RNtWMXPZaOmb7FEi4wVi6dJAgs2ntXxysoqr
	xa4CV3Co89WvSpBjr318ohXh4DD/H+mMJnN9x9osyWAgxQObfuOlGa6kMutynqHK6RRICs
	Jm2lqXKAG58EGDoi2OhGmx47DX2YZMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782306801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LX6xJumGntXXDUbv4cEYrK5CrV1eQ+w6mTItoSxKhxA=;
	b=KT4dlhotsL8ZmWaO24EjzMp/BrwBz1JFXznkdyQsff90PkcaIEJGVEWF37GsYG5byAwWma
	cke/Wx/k7ls7uhCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34E2C779A8;
	Wed, 24 Jun 2026 13:13:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mxTkDPHXO2qOeAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 24 Jun 2026 13:13:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D83D3A093E; Wed, 24 Jun 2026 15:13:20 +0200 (CEST)
Date: Wed, 24 Jun 2026 15:13:20 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: tytso@mit.edu, jack@suse.cz, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ritesh.list@gmail.com, yi.zhang@huawei.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colin Ian King <colin.i.king@gmail.com>
Subject: Re: [PATCH v2] ext4: fix ABBA deadlock in
 ext4_xattr_inode_cache_find()
Message-ID: <rq3vdbtn2mm4jjs6rsk6xtsvykj2mzc5ug42eyrlolj7m7eojp@tizep73vm3yo>
References: <20260623095911.2372-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623095911.2372-1-aditya.ansh182@gmail.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Tue 23-06-26 09:59:11, Aditya Srivastava wrote:
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
> To break this deadlock, perform a non-blocking lookup of the EA inode
> using VFS's find_inode_nowait() API. If the EA inode is currently being
> evicted (marked with I_FREEING or I_WILL_FREE), simply skip it (treat
> as a cache miss) rather than waiting for eviction to complete. If the
> returned inode is found to be I_NEW, wait for its initialization to
> clear using wait_on_new_inode().
> 
> This deadlock was made much easier to hit after commit 0a46ef234756
> ("ext4: do not create EA inode under buffer lock") which removed
> synchronization on the buffer lock.
> 
> Reported-by: Colin Ian King <colin.i.king@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219283
> Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

I was looking into this for quite some time in the past and then run out of
time when redesigning locking of the xattrs (which is a mess). Your
solution is a bit hacky but as a quick stability fix before we can rework
xattr locking it actually looks as a neat idea!

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 982a1f831e22..ef13e7a76153 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1523,6 +1523,20 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
>  	return ea_inode;
>  }
>  
> +static int ext4_xattr_inode_match(struct inode *inode, u64 ino, void *data)
> +{
> +	if (inode->i_ino != ino)
> +		return 0;
> +	spin_lock(&inode->i_lock);
> +	if (inode_state_read(inode) & (I_FREEING | I_WILL_FREE)) {
> +		spin_unlock(&inode->i_lock);
> +		return 0;
> +	}

I think you should also skip I_CREATING inodes here... I don't think you
can really spot them here but just that we don't have to worry.

> +	__iget(inode);
> +	spin_unlock(&inode->i_lock);
> +	return 1;
> +}
> +
>  static struct inode *
>  ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
>  			    size_t value_len, u32 hash)
> @@ -1549,10 +1563,19 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
>  	}
>  
>  	while (ce) {
> -		ea_inode = ext4_iget(inode->i_sb, ce->e_value,
> -				     EXT4_IGET_EA_INODE);
> -		if (IS_ERR(ea_inode))
> +		ea_inode = find_inode_nowait(inode->i_sb, ce->e_value,
> +					     ext4_xattr_inode_match, NULL);
> +		if (!ea_inode)
>  			goto next_entry;
> +		if (inode_state_read_once(ea_inode) & I_NEW)
> +			wait_on_new_inode(ea_inode);
> +		if (is_bad_inode(ea_inode) ||
> +		    !(EXT4_I(ea_inode)->i_flags & EXT4_EA_INODE_FL) ||
> +		    ext4_test_inode_state(ea_inode, EXT4_STATE_XATTR) ||
> +		    EXT4_I(ea_inode)->i_file_acl) {
> +			iput(ea_inode);
> +			goto next_entry;
> +		}

So instead of opencoding these checks here, I'd rather implement
EXT4_IGET_NOWAIT flag which will use find_inode_nowait() like above for the
inode lookup and then you don't have to opencode the sanity checks here and
they can stay contained in ext4_iget() code...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
