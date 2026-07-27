Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C9F3BFE4C
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 19:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785179203; cv=none; b=G4flbbVC0gsDVnXmmX2ihn34OUbW/iFCPkyHYkUS2yF1gQFpnEUwPPq7SO484SKeCnjKvtuVO988Do8oYB8w2IT8bmD1GkVXutPuMI0NuS4XV3jZD7birEcA8+TNxAmo1eWRExmPPAmNm3hlGiJcBc5y9K9R2NqFGHbDxfAjB/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785179203; c=relaxed/simple;
	bh=NX1d6gUm5snemPENm9Fc2fUVR2rgAbZ1xaohg6gz91I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dO0AfcGnNEX1W7xUMg7J73SIaoTOtBL2Eml55J5l9+ItKEG96DumsRjmml01JSwzSlNAteIZtZsgINnJbPmEIaezwZhV+Brq04cJ30tcae2E1hbzm6YtuD6IkNw2V/Lb7to87du+CsolGY3x9DOtnByhtKLPA9VpiYczd43TA6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NW+eHTKg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uNWhDToo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ctRNkA2O; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5wS+BzEc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NW+eHTKg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uNWhDToo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ctRNkA2O";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5wS+BzEc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C53207BEE9;
	Mon, 27 Jul 2026 19:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785179195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9sOq2maMJ+7NMfut4p9LdBdFCLpt4WJE5XAK9NRQc9c=;
	b=NW+eHTKgHzCHGZNSvVsuoiFTDXKPjv1l6UlyRB0NqxqJXZyXLuMbpF3QN/8FCbzJgQ5ycC
	LC0jLpx8v0JVSzNBSoeo4LrFtteuUZgkmIOozAdtoZRWld57GtHFWAmYqcOsoXL/iHiMaf
	mCLAzQ+HGpt+U41KgtmcoW8PY5EPUVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785179195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9sOq2maMJ+7NMfut4p9LdBdFCLpt4WJE5XAK9NRQc9c=;
	b=uNWhDTooJlKkC3EzWLp/AnypBEsbj+guQ5tTeZiisEQ8cMr3vZnC4CLMHVKFjUeGo7pHXQ
	PKg9dsDNxF+6e9Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785179191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9sOq2maMJ+7NMfut4p9LdBdFCLpt4WJE5XAK9NRQc9c=;
	b=ctRNkA2OXb1DBs3NOnnbPbCWhLhbpLFHXIqDZm667R35mFD/Dghm2Xgsq1O+txnwcX2Hb2
	KV9aXFXEXja7Z268osIl/QH1F4Q0UrO4XZSXTWmtc61GZXquI3/l9nBVQCafteYkBBiuW6
	A5fuEk+TUyQcm7xJrLcQFvK+zjN1xKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785179191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9sOq2maMJ+7NMfut4p9LdBdFCLpt4WJE5XAK9NRQc9c=;
	b=5wS+BzEcAQ7z+xGhlw0/khn1F4z++FkYQRmqQLbdGuFdzlRFFIq5nETjWQyenOa0c6b8X5
	Wz6TKN6BAkslsrCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA3A1779B9;
	Mon, 27 Jul 2026 19:06:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2NR0LTesZ2qUSgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 19:06:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 54A7EA0BA1; Mon, 27 Jul 2026 21:06:23 +0200 (CEST)
Date: Mon, 27 Jul 2026 21:06:23 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [PATCH] ext4: turn off DAX on new files when encryption is set
Message-ID: <kekum3d7vakufwz75guyr5mzn6w4rujmssyom5qynpbxucbqpf@f4va7cswqspx>
References: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,gmail.com,huawei.com,linux.alibaba.com,suse.cz,linux.ibm.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Thu 23-07-26 14:26:48, Ojaswin Mujoo wrote:
> Currently, when setting the S_ENCRYPTED flag on a new regular inode in
> a -o dax=always mounted FS, we seem to be erroneously retaining the S_DAX
> flag. This is because the newly created inode ends up with the following:
> 
>   __ext4_new_inode()
>     ext4_set_inode_flags(init=true) // sets S_DAX
>       fscrypt_set_context()
>         ext4_set_context()
>           ext4_set_inode_flags(init=false) // sets S_ENCRYPTED but
>                                               doesn't clears S_DAX
>       ext4_set_aops
>         inode->i_mapping->a_ops = &ext4_dax_aops;
> 
> Due to the S_DAX flag, the excrypted inode gets ext4_dax_aops and it
> silently ends up bypassing encryption completely. This is reflected in
> multiple xfstests failures like generic/548. To fix this, ensure we disable
> S_DAX correctly when S_ENCRYPTED is being set on a newly created inode. It
> is safe to change DAX state there because ext4_set_aops() later can
> correctly detect S_DAX unset and assign the correct aops.
> 
> The fix was actually the intended behavior however it seemed to have
> silently changed in 043546e46dc7.
> 
> Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
> Reported-by: Disha Goel <disgoel@linux.ibm.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
>  fs/ext4/crypto.c | 15 +++++++++++----
>  fs/ext4/inode.c  | 10 ++++++----
>  2 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> index f41f320f4437..2d409114e02e 100644
> --- a/fs/ext4/crypto.c
> +++ b/fs/ext4/crypto.c
> @@ -134,6 +134,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>  {
>  	handle_t *handle = fs_data;
>  	int res, res2, credits, retries = 0;
> +	bool init = S_ISREG(inode->i_mode);

Hum, I have some comments: IMHO the change is confusing because the meaning
of 'init' argument of ext4_set_inode_flags() doesn't mean the first setting
of flags any longer. And the reliance on ext4_set_context() getting called
in a safe place exactly for regular files is rather subtle as well.

Also does the change to ext4_set_inode_flags() really work? As far as I'm
reading the ext4 crypto implementation, I don't see where we'd be setting
EXT4_INODE_ENCRYPT for inodes with already enabled encryption (where we
load the context from xattrs through ext4_get_context()) and thus DAX would
still get enabled for such inodes? What am I missing?

								Honza

> @@ -179,10 +180,16 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>  			ext4_clear_inode_state(inode,
>  					EXT4_STATE_MAY_INLINE_DATA);
>  			/*
> -			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
> -			 * S_DAX may be disabled
> +			 * Update inode->i_flags, S_ENCRYPTED will be enabled.
> +			 * If this is a regular inode, then we must be coming
> +			 * via __ext4_new_inode() as only new inodes can be
> +			 * encrypted, so we must set the init flag so
> +			 * S_DAX can be disabled. This is a bit fragile but
> +			 * seems like the easiest way to make sure we don't let
> +			 * the DAX flag linger when encryption is enabled as
> +			 * that result in writes silently bypassing encryption.
>  			 */
> -			ext4_set_inode_flags(inode, false);
> +			ext4_set_inode_flags(inode, init);
>  		}
>  		return res;
>  	}
> @@ -209,7 +216,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>  		 * Update inode->i_flags - S_ENCRYPTED will be enabled,
>  		 * S_DAX may be disabled
>  		 */
> -		ext4_set_inode_flags(inode, false);
> +		ext4_set_inode_flags(inode, init);
>  		res = ext4_mark_inode_dirty(handle, inode);
>  		if (res)
>  			EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..a57179655353 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5113,8 +5113,6 @@ void ext4_set_inode_flags(struct inode *inode, bool init)
>  	unsigned int flags = EXT4_I(inode)->i_flags;
>  	unsigned int new_fl = 0;
>  
> -	WARN_ON_ONCE(IS_DAX(inode) && init);
> -
>  	if (flags & EXT4_SYNC_FL)
>  		new_fl |= S_SYNC;
>  	if (flags & EXT4_APPEND_FL)
> @@ -5129,8 +5127,12 @@ void ext4_set_inode_flags(struct inode *inode, bool init)
>  	/* Because of the way inode_set_flags() works we must preserve S_DAX
>  	 * here if already set. */
>  	new_fl |= (inode->i_flags & S_DAX);
> -	if (init && ext4_should_enable_dax(inode))
> -		new_fl |= S_DAX;
> +	if (init) {
> +		if (ext4_should_enable_dax(inode))
> +			new_fl |= S_DAX;
> +		else
> +			new_fl &= ~S_DAX;
> +	}
>  
>  	if (flags & EXT4_ENCRYPT_FL)
>  		new_fl |= S_ENCRYPTED;
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
