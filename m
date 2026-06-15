Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D14F411694
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 17:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781542936; cv=none; b=hd9j7gS+ZuZ3TPwE9dGhOe7m6oNok++dx7XPh4gycFQnkDN3TFkAMrKp2gQlud9mttORZc4l5+RhNj/yvgNa1Ob5k/AGHSl4a2tVGUv4+GXMckMTTOrjwo1ntMsMspYDilPOeN3vHZKQgw8pO2muEODcBiSTPvuxowEXnfSSzYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781542936; c=relaxed/simple;
	bh=bqSPbucFF6oS4+F55XDZy2rtqvyXyxr+kSGrN4tNnSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCthUv/IubyDfzpMS282QEUaKFNBH39saYxgVlBJtE7Vgl3COk42kCLC9KhP/5kpKYNKUpM1C7aYY+LkczmvrDAhh2U7D+mSvFOS74fmKPfWErRHilDH5lT/qJ3u3b71r4PiDI1dCbKrsmT+a6g+bYp5cnveBgWpR+RQhYdoK+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TrSZdQ/t; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hDAOLczy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TrSZdQ/t; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hDAOLczy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TrSZdQ/t";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hDAOLczy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TrSZdQ/t";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hDAOLczy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 38E7975A3E;
	Mon, 15 Jun 2026 17:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781542932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rMoC9sq5Mm+wxhWVnq4VkCS96jyJvBcZlWm9PT6W0yM=;
	b=TrSZdQ/ty7iACIrapwo3N0tGJnXCBQpNicOvCBT1RybsQTzbwHmitWM3xa+o8H2+ejlcxC
	/e8MFYl4nAOTKCdWYpweGGdIPVmKK3K/KqUB+jrro9HpPTCbjm9k5iISSNoMIF42UCuMoY
	lV+XrynsjAbnUCRElYAxNy1moNWQ/rA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781542932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rMoC9sq5Mm+wxhWVnq4VkCS96jyJvBcZlWm9PT6W0yM=;
	b=hDAOLczykPNeU/9CJaNBx9W8cq+QttEI8EzUM+HKant/cY98ZqNHPeS5/XFr+KqrzOjTQt
	Y8WZJTxzfPjm89Aw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781542932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rMoC9sq5Mm+wxhWVnq4VkCS96jyJvBcZlWm9PT6W0yM=;
	b=TrSZdQ/ty7iACIrapwo3N0tGJnXCBQpNicOvCBT1RybsQTzbwHmitWM3xa+o8H2+ejlcxC
	/e8MFYl4nAOTKCdWYpweGGdIPVmKK3K/KqUB+jrro9HpPTCbjm9k5iISSNoMIF42UCuMoY
	lV+XrynsjAbnUCRElYAxNy1moNWQ/rA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781542932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rMoC9sq5Mm+wxhWVnq4VkCS96jyJvBcZlWm9PT6W0yM=;
	b=hDAOLczykPNeU/9CJaNBx9W8cq+QttEI8EzUM+HKant/cY98ZqNHPeS5/XFr+KqrzOjTQt
	Y8WZJTxzfPjm89Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 266C4779A7;
	Mon, 15 Jun 2026 17:02:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PztfCRQwMGprBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 15 Jun 2026 17:02:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B3C01A12D2; Mon, 15 Jun 2026 19:02:03 +0200 (CEST)
Date: Mon, 15 Jun 2026 19:02:03 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, ebiggers@google.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] ext4: defer iput() on ea_inodes to reduce lock
 holding scope
Message-ID: <daxmj7i3wv3kadfwnnlfpbq2tjax5juqrikwb7dhp5vgszr2ky@y4xqmfiocyhm>
References: <20260615115317.3549469-1-yun.zhou@windriver.com>
 <20260615115317.3549469-4-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615115317.3549469-4-yun.zhou@windriver.com>
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
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,google.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,bs.bh:url,suse.com:email]
X-Spam-Level: 

On Mon 15-06-26 19:53:17, Yun Zhou wrote:
> ext4_xattr_block_set(), ext4_xattr_ibody_set() and ext4_xattr_set_entry()
> call iput() on ea_inodes while xattr_sem and a jbd2 handle are held.
> This creates an unnecessarily wide lock scope and, without the preceding
> !SB_ACTIVE guard, could trigger write_inode_now() -> s_writepages_rwsem
> creating a circular dependency.
> 
> Structurally eliminate iput-under-xattr_sem by collecting ea_inodes into
> a deferred-iput array and releasing them after locks are dropped:
> 
> 1. Convert all iput(ea_inode) calls within ext4_xattr_set_entry(),
>    ext4_xattr_ibody_set(), and ext4_xattr_block_set() to deferred iput
>    via ext4_expand_inode_array().  Thread the ea_inode_array through
>    ext4_xattr_set_handle(), ext4_xattr_move_to_block(), and
>    ext4_expand_extra_isize_ea() as an output parameter.
> 
> 2. Callers that own the journal handle (ext4_xattr_set,
>    ext4_expand_extra_isize) free the array AFTER ext4_journal_stop().
>    For ext4_try_to_expand_extra_isize (called from __ext4_mark_inode_dirty
>    with the caller's handle), free after xattr_sem release -- safe
>    because the preceding patches block the !SB_ACTIVE path.
> 
> 3. Callers that cannot control the handle lifetime (ext4_initxattrs,
>    __ext4_set_acl, ext4_set_context, inline data ops) pass NULL.
>    ext4_expand_inode_array() falls back to synchronous iput() when
>    ea_inode_array is NULL -- safe because these callers only run with
>    SB_ACTIVE where iput cannot trigger write_inode_now().
> 
> 4. Use __GFP_NOFAIL in ext4_expand_inode_array() to guarantee the
>    deferred-iput array never fails to grow, eliminating any fallback
>    to synchronous iput() under locks.
> 
> 5. Pass ea_inode_array directly to ext4_xattr_release_block() in
>    ext4_xattr_block_set() instead of using a local array freed
>    synchronously under xattr_sem.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Frankly, I hate how many places this touches and how this complicates
things, in particular when we don't really need this to fix the deadlock
because the previous two patches addressed the really problematic places.

That being said I fully agree dropping of ea_inodes xattr refs is a mess,
fragile, and there are potentially more deadlocks hiding there. The
architecture that might be more seamless would be something like having a
list of ea inodes to drop anchored in the sb and just queue work to drop
the list from a separate context to avoid the locking dependencies or doing
unexpected modifications in a transaction. That would allow even
simplifying the current code...

								Honza

> ---
>  fs/ext4/acl.c            |  2 +-
>  fs/ext4/crypto.c         |  4 +-
>  fs/ext4/inline.c         |  8 ++--
>  fs/ext4/inode.c          | 16 +++++--
>  fs/ext4/xattr.c          | 93 ++++++++++++++++++++++++----------------
>  fs/ext4/xattr.h          | 10 +++--
>  fs/ext4/xattr_security.c |  3 +-
>  7 files changed, 85 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index 3bffe862f954..21de8276b558 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -215,7 +215,7 @@ __ext4_set_acl(handle_t *handle, struct inode *inode, int type,
>  	}
>  
>  	error = ext4_xattr_set_handle(handle, inode, name_index, "",
> -				      value, size, xattr_flags);
> +				      value, size, xattr_flags, NULL);
>  
>  	kfree(value);
>  	if (!error)
> diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> index f41f320f4437..bca760751c1d 100644
> --- a/fs/ext4/crypto.c
> +++ b/fs/ext4/crypto.c
> @@ -173,7 +173,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>  		res = ext4_xattr_set_handle(handle, inode,
>  					    EXT4_XATTR_INDEX_ENCRYPTION,
>  					    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> -					    ctx, len, XATTR_CREATE);
> +					    ctx, len, XATTR_CREATE, NULL);
>  		if (!res) {
>  			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
>  			ext4_clear_inode_state(inode,
> @@ -202,7 +202,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>  
>  	res = ext4_xattr_set_handle(handle, inode, EXT4_XATTR_INDEX_ENCRYPTION,
>  				    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> -				    ctx, len, 0);
> +				    ctx, len, 0, NULL);
>  	if (!res) {
>  		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
>  		/*
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 8045e4ff270c..2bf2b771929d 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -309,7 +309,7 @@ static int ext4_create_inline_data(handle_t *handle,
>  		goto out;
>  	}
>  
> -	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
> +	error = ext4_xattr_ibody_set(handle, inode, &i, &is, NULL);
>  	if (error) {
>  		if (error == -ENOSPC)
>  			ext4_clear_inode_state(inode,
> @@ -386,7 +386,7 @@ static int ext4_update_inline_data(handle_t *handle, struct inode *inode,
>  	i.value = value;
>  	i.value_len = len;
>  
> -	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
> +	error = ext4_xattr_ibody_set(handle, inode, &i, &is, NULL);
>  	if (error)
>  		goto out;
>  
> @@ -469,7 +469,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
>  	if (error)
>  		goto out;
>  
> -	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
> +	error = ext4_xattr_ibody_set(handle, inode, &i, &is, NULL);
>  	if (error)
>  		goto out;
>  
> @@ -1917,7 +1917,7 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
>  			i.value = value;
>  			i.value_len = i_size > EXT4_MIN_INLINE_DATA_SIZE ?
>  					i_size - EXT4_MIN_INLINE_DATA_SIZE : 0;
> -			err = ext4_xattr_ibody_set(handle, inode, &i, &is);
> +			err = ext4_xattr_ibody_set(handle, inode, &i, &is, NULL);
>  			if (err)
>  				goto out_error;
>  		}
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 60c91c098fa0..a1b0f47f8f4f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6409,7 +6409,8 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
>  static int __ext4_expand_extra_isize(struct inode *inode,
>  				     unsigned int new_extra_isize,
>  				     struct ext4_iloc *iloc,
> -				     handle_t *handle, int *no_expand)
> +				     handle_t *handle, int *no_expand,
> +				     struct ext4_xattr_inode_array **ea_inode_array)
>  {
>  	struct ext4_inode *raw_inode;
>  	struct ext4_xattr_ibody_header *header;
> @@ -6454,7 +6455,7 @@ static int __ext4_expand_extra_isize(struct inode *inode,
>  
>  	/* try to expand with EAs present */
>  	error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
> -					   raw_inode, handle);
> +					   raw_inode, handle, ea_inode_array);
>  	if (error) {
>  		/*
>  		 * Inode size expansion failed; don't try again
> @@ -6476,6 +6477,7 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
>  {
>  	int no_expand;
>  	int error;
> +	struct ext4_xattr_inode_array *ea_inode_array = NULL;
>  
>  	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND))
>  		return -EOVERFLOW;
> @@ -6507,8 +6509,11 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
>  		return -EBUSY;
>  
>  	error = __ext4_expand_extra_isize(inode, new_extra_isize, &iloc,
> -					  handle, &no_expand);
> +					  handle, &no_expand,
> +					  &ea_inode_array);
>  	ext4_write_unlock_xattr(inode, &no_expand);
> +	/* Safe with caller's handle active: !SB_ACTIVE is blocked above */
> +	ext4_xattr_inode_array_free(ea_inode_array);
>  
>  	return error;
>  }
> @@ -6520,6 +6525,7 @@ int ext4_expand_extra_isize(struct inode *inode,
>  	handle_t *handle;
>  	int no_expand;
>  	int error, rc;
> +	struct ext4_xattr_inode_array *ea_inode_array = NULL;
>  
>  	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
>  		brelse(iloc->bh);
> @@ -6545,7 +6551,8 @@ int ext4_expand_extra_isize(struct inode *inode,
>  	}
>  
>  	error = __ext4_expand_extra_isize(inode, new_extra_isize, iloc,
> -					  handle, &no_expand);
> +					  handle, &no_expand,
> +					  &ea_inode_array);
>  
>  	rc = ext4_mark_iloc_dirty(handle, inode, iloc);
>  	if (!error)
> @@ -6554,6 +6561,7 @@ int ext4_expand_extra_isize(struct inode *inode,
>  out_unlock:
>  	ext4_write_unlock_xattr(inode, &no_expand);
>  	ext4_journal_stop(handle);
> +	ext4_xattr_inode_array_free(ea_inode_array);
>  	return error;
>  }
>  
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 982a1f831e22..4eb83917e6b4 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1630,7 +1630,8 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
>  				struct ext4_xattr_search *s,
>  				handle_t *handle, struct inode *inode,
>  				struct inode *new_ea_inode,
> -				bool is_block)
> +				bool is_block,
> +				struct ext4_xattr_inode_array **ea_inode_array)
>  {
>  	struct ext4_xattr_entry *last, *next;
>  	struct ext4_xattr_entry *here = s->here;
> @@ -1848,7 +1849,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
>  
>  	ret = 0;
>  out:
> -	iput(old_ea_inode);
> +	ext4_expand_inode_array(ea_inode_array, old_ea_inode);
>  	return ret;
>  }
>  
> @@ -1898,7 +1899,8 @@ ext4_xattr_block_find(struct inode *inode, struct ext4_xattr_info *i,
>  static int
>  ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  		     struct ext4_xattr_info *i,
> -		     struct ext4_xattr_block_find *bs)
> +		     struct ext4_xattr_block_find *bs,
> +		     struct ext4_xattr_inode_array **ea_inode_array)
>  {
>  	struct super_block *sb = inode->i_sb;
>  	struct buffer_head *new_bh = NULL;
> @@ -1961,7 +1963,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  			}
>  			ea_bdebug(bs->bh, "modifying in-place");
>  			error = ext4_xattr_set_entry(i, s, handle, inode,
> -					     ea_inode, true /* is_block */);
> +					     ea_inode, true /* is_block */,
> +					     ea_inode_array);
>  			ext4_xattr_block_csum_set(inode, bs->bh);
>  			unlock_buffer(bs->bh);
>  			if (error == -EFSCORRUPTED)
> @@ -2030,7 +2033,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  	}
>  
>  	error = ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
> -				     true /* is_block */);
> +				     true /* is_block */, ea_inode_array);
>  	if (error == -EFSCORRUPTED)
>  		goto bad_block;
>  	if (error)
> @@ -2150,7 +2153,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  					ext4_warning_inode(ea_inode,
>  							   "dec ref error=%d",
>  							   error);
> -				iput(ea_inode);
> +				ext4_expand_inode_array(ea_inode_array,
> +							ea_inode);
>  				ea_inode = NULL;
>  			}
>  
> @@ -2182,12 +2186,9 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  
>  	/* Drop the previous xattr block. */
>  	if (bs->bh && bs->bh != new_bh) {
> -		struct ext4_xattr_inode_array *ea_inode_array = NULL;
> -
>  		ext4_xattr_release_block(handle, inode, bs->bh,
> -					 &ea_inode_array,
> +					 ea_inode_array,
>  					 0 /* extra_credits */);
> -		ext4_xattr_inode_array_free(ea_inode_array);
>  	}
>  	error = 0;
>  
> @@ -2203,7 +2204,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  			ext4_xattr_inode_free_quota(inode, ea_inode,
>  						    i_size_read(ea_inode));
>  		}
> -		iput(ea_inode);
> +		ext4_expand_inode_array(ea_inode_array, ea_inode);
>  	}
>  	if (ce)
>  		mb_cache_entry_put(ea_block_cache, ce);
> @@ -2253,7 +2254,8 @@ int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
>  
>  int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
>  				struct ext4_xattr_info *i,
> -				struct ext4_xattr_ibody_find *is)
> +				struct ext4_xattr_ibody_find *is,
> +				struct ext4_xattr_inode_array **ea_inode_array)
>  {
>  	struct ext4_xattr_ibody_header *header;
>  	struct ext4_xattr_search *s = &is->s;
> @@ -2273,7 +2275,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
>  			return PTR_ERR(ea_inode);
>  	}
>  	error = ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
> -				     false /* is_block */);
> +				     false /* is_block */, ea_inode_array);
>  	if (error) {
>  		if (ea_inode) {
>  			int error2;
> @@ -2285,7 +2287,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
>  
>  			ext4_xattr_inode_free_quota(inode, ea_inode,
>  						    i_size_read(ea_inode));
> -			iput(ea_inode);
> +			ext4_expand_inode_array(ea_inode_array, ea_inode);
>  		}
>  		return error;
>  	}
> @@ -2297,7 +2299,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
>  		header->h_magic = cpu_to_le32(0);
>  		ext4_clear_inode_state(inode, EXT4_STATE_XATTR);
>  	}
> -	iput(ea_inode);
> +	ext4_expand_inode_array(ea_inode_array, ea_inode);
>  	return 0;
>  }
>  
> @@ -2348,7 +2350,8 @@ static struct buffer_head *ext4_xattr_get_block(struct inode *inode)
>  int
>  ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
>  		      const char *name, const void *value, size_t value_len,
> -		      int flags)
> +		      int flags,
> +		      struct ext4_xattr_inode_array **ea_inode_array)
>  {
>  	struct ext4_xattr_info i = {
>  		.name_index = name_index,
> @@ -2428,9 +2431,11 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
>  
>  	if (!value) {
>  		if (!is.s.not_found)
> -			error = ext4_xattr_ibody_set(handle, inode, &i, &is);
> +			error = ext4_xattr_ibody_set(handle, inode, &i, &is,
> +						     ea_inode_array);
>  		else if (!bs.s.not_found)
> -			error = ext4_xattr_block_set(handle, inode, &i, &bs);
> +			error = ext4_xattr_block_set(handle, inode, &i, &bs,
> +						     ea_inode_array);
>  	} else {
>  		error = 0;
>  		/* Xattr value did not change? Save us some work and bail out */
> @@ -2444,10 +2449,12 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
>  			EXT4_XATTR_MIN_LARGE_EA_SIZE(inode->i_sb->s_blocksize)))
>  			i.in_inode = 1;
>  retry_inode:
> -		error = ext4_xattr_ibody_set(handle, inode, &i, &is);
> +		error = ext4_xattr_ibody_set(handle, inode, &i, &is,
> +					     ea_inode_array);
>  		if (!error && !bs.s.not_found) {
>  			i.value = NULL;
> -			error = ext4_xattr_block_set(handle, inode, &i, &bs);
> +			error = ext4_xattr_block_set(handle, inode, &i, &bs,
> +						     ea_inode_array);
>  		} else if (error == -ENOSPC) {
>  			if (EXT4_I(inode)->i_file_acl && !bs.s.base) {
>  				brelse(bs.bh);
> @@ -2456,11 +2463,12 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
>  				if (error)
>  					goto cleanup;
>  			}
> -			error = ext4_xattr_block_set(handle, inode, &i, &bs);
> +			error = ext4_xattr_block_set(handle, inode, &i, &bs,
> +						     ea_inode_array);
>  			if (!error && !is.s.not_found) {
>  				i.value = NULL;
>  				error = ext4_xattr_ibody_set(handle, inode, &i,
> -							     &is);
> +							     &is, ea_inode_array);
>  			} else if (error == -ENOSPC) {
>  				/*
>  				 * Xattr does not fit in the block, store at
> @@ -2539,6 +2547,7 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
>  {
>  	handle_t *handle;
>  	struct super_block *sb = inode->i_sb;
> +	struct ext4_xattr_inode_array *ea_inode_array = NULL;
>  	int error, retries = 0;
>  	int credits;
>  
> @@ -2559,10 +2568,13 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
>  		int error2;
>  
>  		error = ext4_xattr_set_handle(handle, inode, name_index, name,
> -					      value, value_len, flags);
> +					      value, value_len, flags,
> +					      &ea_inode_array);
>  		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR,
>  					handle);
>  		error2 = ext4_journal_stop(handle);
> +		ext4_xattr_inode_array_free(ea_inode_array);
> +		ea_inode_array = NULL;
>  		if (error == -ENOSPC &&
>  		    ext4_should_retry_alloc(sb, &retries))
>  			goto retry;
> @@ -2604,7 +2616,8 @@ static void ext4_xattr_shift_entries(struct ext4_xattr_entry *entry,
>   */
>  static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
>  				    struct ext4_inode *raw_inode,
> -				    struct ext4_xattr_entry *entry)
> +				    struct ext4_xattr_entry *entry,
> +				    struct ext4_xattr_inode_array **ea_inode_array)
>  {
>  	struct ext4_xattr_ibody_find *is = NULL;
>  	struct ext4_xattr_block_find *bs = NULL;
> @@ -2668,14 +2681,14 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
>  		goto out;
>  
>  	/* Move ea entry from the inode into the block */
> -	error = ext4_xattr_block_set(handle, inode, &i, bs);
> +	error = ext4_xattr_block_set(handle, inode, &i, bs, ea_inode_array);
>  	if (error)
>  		goto out;
>  
>  	/* Remove the chosen entry from the inode */
>  	i.value = NULL;
>  	i.value_len = 0;
> -	error = ext4_xattr_ibody_set(handle, inode, &i, is);
> +	error = ext4_xattr_ibody_set(handle, inode, &i, is, ea_inode_array);
>  
>  out:
>  	kfree(b_entry_name);
> @@ -2694,7 +2707,8 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
>  static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
>  				       struct ext4_inode *raw_inode,
>  				       int isize_diff, size_t ifree,
> -				       size_t bfree, int *total_ino)
> +				       size_t bfree, int *total_ino,
> +				       struct ext4_xattr_inode_array **ea_inode_array)
>  {
>  	struct ext4_xattr_ibody_header *header = IHDR(inode, raw_inode);
>  	struct ext4_xattr_entry *small_entry;
> @@ -2744,7 +2758,7 @@ static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
>  			total_size += EXT4_XATTR_SIZE(
>  					      le32_to_cpu(entry->e_value_size));
>  		error = ext4_xattr_move_to_block(handle, inode, raw_inode,
> -						 entry);
> +						 entry, ea_inode_array);
>  		if (error)
>  			return error;
>  
> @@ -2761,7 +2775,8 @@ static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
>   * Returns 0 on success or negative error number on failure.
>   */
>  int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
> -			       struct ext4_inode *raw_inode, handle_t *handle)
> +			       struct ext4_inode *raw_inode, handle_t *handle,
> +			       struct ext4_xattr_inode_array **ea_inode_array)
>  {
>  	struct ext4_xattr_ibody_header *header;
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> @@ -2833,7 +2848,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
>  
>  	error = ext4_xattr_make_inode_space(handle, inode, raw_inode,
>  					    isize_diff, ifree, bfree,
> -					    &total_ino);
> +					    &total_ino, ea_inode_array);
>  	if (error) {
>  		if (error == -ENOSPC && !tried_min_extra_isize &&
>  		    s_min_extra_isize) {
> @@ -2869,19 +2884,27 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
>  /* Add the large xattr @inode into @ea_inode_array for deferred iput().
>   * If @ea_inode_array is new or full it will be grown and the old
>   * contents copied over.
> + *
> + * If @inode is NULL this is a no-op.  If @ea_inode_array is NULL the
> + * caller guarantees SB_ACTIVE so synchronous iput is safe.
>   */
>  static int
>  ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
>  			struct inode *inode)
>  {
> +	if (!inode)
> +		return 0;
> +	if (!ea_inode_array) {
> +		iput(inode);
> +		return 0;
> +	}
>  	if (*ea_inode_array == NULL) {
>  		/*
>  		 * Start with 15 inodes, so it fits into a power-of-two size.
>  		 */
>  		(*ea_inode_array) = kmalloc_flex(**ea_inode_array, inodes,
> -						 EIA_MASK, GFP_NOFS);
> -		if (*ea_inode_array == NULL)
> -			return -ENOMEM;
> +						 EIA_MASK,
> +						 GFP_NOFS | __GFP_NOFAIL);
>  		(*ea_inode_array)->count = 0;
>  	} else if (((*ea_inode_array)->count & EIA_MASK) == EIA_MASK) {
>  		/* expand the array once all 15 + n * 16 slots are full */
> @@ -2889,9 +2912,7 @@ ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
>  
>  		new_array = kmalloc_flex(**ea_inode_array, inodes,
>  					 (*ea_inode_array)->count + EIA_INCR,
> -					 GFP_NOFS);
> -		if (new_array == NULL)
> -			return -ENOMEM;
> +					 GFP_NOFS | __GFP_NOFAIL);
>  		memcpy(new_array, *ea_inode_array,
>  		       struct_size(*ea_inode_array, inodes,
>  				   (*ea_inode_array)->count));
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index 1fedf44d4fb6..6771d00d3fa4 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -179,7 +179,9 @@ extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
>  
>  extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
>  extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
> -extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
> +extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *,
> +		const void *, size_t, int,
> +		struct ext4_xattr_inode_array **ea_inode_array);
>  extern int ext4_xattr_set_credits(struct inode *inode, size_t value_len,
>  				  bool is_create, int *credits);
>  extern int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
> @@ -192,7 +194,8 @@ extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
>  
>  extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
> -			    struct ext4_inode *raw_inode, handle_t *handle);
> +			    struct ext4_inode *raw_inode, handle_t *handle,
> +			    struct ext4_xattr_inode_array **ea_inode_array);
>  extern void ext4_evict_ea_inode(struct inode *inode);
>  
>  extern const struct xattr_handler * const ext4_xattr_handlers[];
> @@ -204,7 +207,8 @@ extern int ext4_xattr_ibody_get(struct inode *inode, int name_index,
>  				void *buffer, size_t buffer_size);
>  extern int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
>  				struct ext4_xattr_info *i,
> -				struct ext4_xattr_ibody_find *is);
> +				struct ext4_xattr_ibody_find *is,
> +				struct ext4_xattr_inode_array **ea_inode_array);
>  
>  extern struct mb_cache *ext4_xattr_create_cache(void);
>  extern void ext4_xattr_destroy_cache(struct mb_cache *);
> diff --git a/fs/ext4/xattr_security.c b/fs/ext4/xattr_security.c
> index 776cf11d24ca..6b7ab6e703ad 100644
> --- a/fs/ext4/xattr_security.c
> +++ b/fs/ext4/xattr_security.c
> @@ -44,7 +44,8 @@ ext4_initxattrs(struct inode *inode, const struct xattr *xattr_array,
>  		err = ext4_xattr_set_handle(handle, inode,
>  					    EXT4_XATTR_INDEX_SECURITY,
>  					    xattr->name, xattr->value,
> -					    xattr->value_len, XATTR_CREATE);
> +					    xattr->value_len, XATTR_CREATE,
> +					    NULL);
>  		if (err < 0)
>  			break;
>  	}
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
