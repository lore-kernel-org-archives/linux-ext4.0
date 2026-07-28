Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2567D3B6BFD
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 13:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785245384; cv=none; b=rYEUg7FCue/22ZCz5VY2KpA2wd3TrhRJ9GfM8gloeC5VcCl3AnUZG9wjqEX7cpZZMYNlsPTrzcu2w05trNOJ0gouMgIeO//o7Kb8cS+WU6a/B48SKW5Mm+EYRLR4yPw3dIfK+JbH6O/PSBQurQiqLwq6Y0tPm/aotR3DqeEhvfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785245384; c=relaxed/simple;
	bh=4vzyU2IvDg5/4oe5+Zn0lePsxUbv1TI2goMkATFJPEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dWpF+2Na1Hq9+6C9cwlIsF17p7CYvJ9MQbJzMRmk3iJi0uw9P2XmZPeFsIxB7s2k3a/dD5xRjeZ3HNM9E6gwufq9RlzliXiz1YiiDVYq+zs7VE46hhVK49WydPf7FScTX6WR9y+zdKkfLT/e0Y6obJviXMfyQBs/iDjncENHtrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hawPO5Ms; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=x8K0omKz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GNDU2kS1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aXniKVIN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hawPO5Ms";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="x8K0omKz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GNDU2kS1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aXniKVIN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A2C07C3D3;
	Tue, 28 Jul 2026 13:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785245377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d9PzCVM5nRoGRo1iWon1jCmwSAzSXvE/xicOEAH7o4o=;
	b=hawPO5MsPDI/JrViZjFoT3WxYLOxRQSFDB9B7HBZ7TOdyDh1tdXzCb85d/NVAd778R6Yob
	NkZppxGTsyAa0aFlU7TUNX8kSkaca5tdMLBrRbWPXTi360uuSyokya2FLSsiSspBTMUMI6
	36phYGHDlVeuSVjNsQmYZ7nKbvHjuQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785245377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d9PzCVM5nRoGRo1iWon1jCmwSAzSXvE/xicOEAH7o4o=;
	b=x8K0omKz2rBvXVDnCun54fqTAp+sM/rldYB3F/YbAs53VYmsCgHAuOJTHQGUMAChBvL/fd
	DNTuTZ9dUWi2p3Bg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GNDU2kS1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aXniKVIN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785245373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d9PzCVM5nRoGRo1iWon1jCmwSAzSXvE/xicOEAH7o4o=;
	b=GNDU2kS1MTw211rRxXA6WKf5ox8mUdMcKIcVjeX+qimwgDKX+vQezXRJNYaI7ZYnrMhhMA
	+gxn+51qtZ1K28j43KEjxmCQTW+rwFg2rhQDd5Q8pO4XXymZucgR9J69bfol6mhevyeAc6
	lksP+3m3I91Gmb+C9A+XMAn9puQQK0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785245373;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d9PzCVM5nRoGRo1iWon1jCmwSAzSXvE/xicOEAH7o4o=;
	b=aXniKVINm7gsyIqfkH9whY+thaiCATWU25may4adHHu9QIihKdZLdmJBzapAINbC0vy4CH
	H/vTscOqQUaDwCAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1748779B1;
	Tue, 28 Jul 2026 13:29:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zWfrOryuaGpsWgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Jul 2026 13:29:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A123EA10B6; Tue, 28 Jul 2026 15:29:32 +0200 (CEST)
Date: Tue, 28 Jul 2026 15:29:32 +0200
From: Jan Kara <jack@suse.cz>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org, 
	Baokun Li <libaokun@linux.alibaba.com>, Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [PATCH] ext4: turn off DAX on new files when encryption is set
Message-ID: <647oon5c5duh2eo7trkxxrs5czlmjxsavjokrzyngozemcaxza@j5rfa5wsyu27>
References: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
 <kekum3d7vakufwz75guyr5mzn6w4rujmssyom5qynpbxucbqpf@f4va7cswqspx>
 <20260727194350.GC1021387@google.com>
 <20260727201339.GD1021387@google.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727201339.GD1021387@google.com>
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
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,linux.ibm.com,vger.kernel.org,mit.edu,gmail.com,huawei.com,linux.alibaba.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 0A2C07C3D3
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Mon 27-07-26 20:13:39, Eric Biggers wrote:
> On Mon, Jul 27, 2026 at 07:43:50PM +0000, Eric Biggers wrote:
> > On Mon, Jul 27, 2026 at 09:06:23PM +0200, Jan Kara wrote:
> > > On Thu 23-07-26 14:26:48, Ojaswin Mujoo wrote:
> > > > Currently, when setting the S_ENCRYPTED flag on a new regular inode in
> > > > a -o dax=always mounted FS, we seem to be erroneously retaining the S_DAX
> > > > flag. This is because the newly created inode ends up with the following:
> > > > 
> > > >   __ext4_new_inode()
> > > >     ext4_set_inode_flags(init=true) // sets S_DAX
> > > >       fscrypt_set_context()
> > > >         ext4_set_context()
> > > >           ext4_set_inode_flags(init=false) // sets S_ENCRYPTED but
> > > >                                               doesn't clears S_DAX
> > > >       ext4_set_aops
> > > >         inode->i_mapping->a_ops = &ext4_dax_aops;
> > > > 
> > > > Due to the S_DAX flag, the excrypted inode gets ext4_dax_aops and it
> > > > silently ends up bypassing encryption completely. This is reflected in
> > > > multiple xfstests failures like generic/548. To fix this, ensure we disable
> > > > S_DAX correctly when S_ENCRYPTED is being set on a newly created inode. It
> > > > is safe to change DAX state there because ext4_set_aops() later can
> > > > correctly detect S_DAX unset and assign the correct aops.
> > > > 
> > > > The fix was actually the intended behavior however it seemed to have
> > > > silently changed in 043546e46dc7.
> > > > 
> > > > Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
> > > > Reported-by: Disha Goel <disgoel@linux.ibm.com>
> > > > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > > > ---
> > > >  fs/ext4/crypto.c | 15 +++++++++++----
> > > >  fs/ext4/inode.c  | 10 ++++++----
> > > >  2 files changed, 17 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> > > > index f41f320f4437..2d409114e02e 100644
> > > > --- a/fs/ext4/crypto.c
> > > > +++ b/fs/ext4/crypto.c
> > > > @@ -134,6 +134,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> > > >  {
> > > >  	handle_t *handle = fs_data;
> > > >  	int res, res2, credits, retries = 0;
> > > > +	bool init = S_ISREG(inode->i_mode);
> > > 
> > > Hum, I have some comments: IMHO the change is confusing because the meaning
> > > of 'init' argument of ext4_set_inode_flags() doesn't mean the first setting
> > > of flags any longer. And the reliance on ext4_set_context() getting called
> > > in a safe place exactly for regular files is rather subtle as well.
> > > 
> > > Also does the change to ext4_set_inode_flags() really work? As far as I'm
> > > reading the ext4 crypto implementation, I don't see where we'd be setting
> > > EXT4_INODE_ENCRYPT for inodes with already enabled encryption (where we
> > > load the context from xattrs through ext4_get_context()) and thus DAX would
> > > still get enabled for such inodes? What am I missing?
> > 
> > Maybe __ext4_new_inode() should set the encryption flag on the inode
> > earlier?  Currently it decides whether the inode will be encrypted, then
> > calls ext4_set_inode_flags(), then calls fscrypt_set_context() (and thus
> > ext4_set_context()).  That last step sets the flag and calls
> > ext4_set_inode_flags() *again*.
> > 
> > I don't remember if there's a reason for that redundancy, but it might
> > just be for historical reasons.  ext4_set_context() is called in two
> > different cases: when a new inode is created and it's encrypted from the
> > beginning, and when FS_IOC_SET_ENCRYPTION_POLICY is executed on an empty
> > directory.  The latter does have to set the encrypt flag there.
> >  
> > - Eric
> 
> Here's an idea.  I haven't tested it though.
> 
> Note that this would align ext4 closer with f2fs, which already sets the
> encrypt flag before it calls fscrypt_set_context().

Thanks! This definitely looks much more obvious than Ojaswin's fix.
Ojaswin, does this fix work for you?

								Honza

> 
> diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> index f41f320f4437..c4bfe18fd527 100644
> --- a/fs/ext4/crypto.c
> +++ b/fs/ext4/crypto.c
> @@ -144,7 +144,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>  	if (inode->i_ino == EXT4_ROOT_INO)
>  		return -EPERM;
>  
> -	if (WARN_ON_ONCE(IS_DAX(inode) && i_size_read(inode)))
> +	if (WARN_ON_ONCE(IS_DAX(inode)))
>  		return -EINVAL;
>  
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
> @@ -163,6 +163,14 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>  	 */
>  
>  	if (handle) {
> +		/*
> +		 * ext4 should have set the encrypt flag on the inode already,
> +		 * and it should not have enabled inline data.
> +		 */
> +		if (WARN_ON_ONCE(!IS_ENCRYPTED(inode)))
> +			return -EINVAL;
> +		if (WARN_ON_ONCE(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)))
> +			return -EINVAL;
>  		/*
>  		 * Since the inode is new it is ok to pass the
>  		 * XATTR_CREATE flag. This is necessary to match the
> @@ -170,21 +178,10 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>  		 * function with the credits allocated for the new
>  		 * inode.
>  		 */
> -		res = ext4_xattr_set_handle(handle, inode,
> -					    EXT4_XATTR_INDEX_ENCRYPTION,
> -					    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> -					    ctx, len, XATTR_CREATE);
> -		if (!res) {
> -			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
> -			ext4_clear_inode_state(inode,
> -					EXT4_STATE_MAY_INLINE_DATA);
> -			/*
> -			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
> -			 * S_DAX may be disabled
> -			 */
> -			ext4_set_inode_flags(inode, false);
> -		}
> -		return res;
> +		return ext4_xattr_set_handle(handle, inode,
> +					     EXT4_XATTR_INDEX_ENCRYPTION,
> +					     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> +					     ctx, len, XATTR_CREATE);
>  	}
>  
>  	res = dquot_initialize(inode);
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index a40cb27f8116..3848244af77a 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -997,6 +997,8 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
>  		err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
>  		if (err)
>  			goto out;
> +		if (encrypt)
> +			i_flags |= EXT4_ENCRYPT_FL;
>  	}
>  
>  	err = dquot_initialize(inode);
> @@ -1306,6 +1308,7 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
>  	ei->i_extra_isize = sbi->s_want_extra_isize;
>  	ei->i_inline_off = 0;
>  	if (ext4_has_feature_inline_data(sb) &&
> +	    !(ei->i_flags & EXT4_ENCRYPT_FL) &&
>  	    (!(ei->i_flags & (EXT4_DAX_FL|EXT4_EA_INODE_FL)) || S_ISDIR(mode)))
>  		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
>  	ret = inode;
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
