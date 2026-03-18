Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5203624A8
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 18:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773857042; cv=none; b=NskYJlnXcx0l/K/vUPYv4JMzKt5o3y1x48/7d153cfZ3JgutKGGFrLDngj2yqYNwRrxNjzit67/gnyTNttG3batpNWNXyXXz7DnZFUyQuP/Wp++JOjVX/EcOPRBwvHA0PT6l7uiPOMMHqdskc6NTxuDb5P/tYnjleJiHkscOvQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773857042; c=relaxed/simple;
	bh=x9laqgJl2iW9i4VlvpVhS9KRIKmsEYNBTSYAwoDGTuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGrJg8uOQI84FhoJnSP3Xs1g3SlLFhMb/r4JHX1a6HPjd9QfAJxl5COOGj2uMX64kDx7NQm0LhUcHdZnGU3vSY8XWX6xqOici+mfPeEiMxJofn0dmy2UgZcyJ2cipwiVaUfH1ROUrSPsYIxc9r7FZu7WWVcne7qjGD6gXNGGaxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VyooIo2m; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DaHyD/x/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tvVPqbt3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0NW3R+LH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VyooIo2m";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DaHyD/x/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tvVPqbt3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0NW3R+LH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D6B274D3FF;
	Wed, 18 Mar 2026 18:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773857038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G87/r1L8i4KqlxPSVM5/SPGd/iWO3A+cSbOyySyB3Ac=;
	b=VyooIo2mqgha8DDB57Rg87Ij/A9/4bK+ndSXjH4CCsocO/5b1crdrtHBj5A4qbuHgZVidy
	h1ohtjKyP24vJGyu2nhXz4lv5J787zVbcA+oxvnMwNoMgFiM+dTsMuNkYytx50fQ+99iYZ
	LkF56M3W+UN4MfArDa8CcI62WDMl1o4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773857038;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G87/r1L8i4KqlxPSVM5/SPGd/iWO3A+cSbOyySyB3Ac=;
	b=DaHyD/x/QfSK1513f9Tt06V/trbjzymjLffgxmi9rW69X/AEanYhw9u3tEkxYfNTNmFmmD
	ADFEW2dN8TTgJfCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tvVPqbt3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0NW3R+LH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773857037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G87/r1L8i4KqlxPSVM5/SPGd/iWO3A+cSbOyySyB3Ac=;
	b=tvVPqbt3U4oFRCfCxem64owyWzKgKz9xTKSM9Ez4MDD1HFEG7BheHUqRfo+nXdtV28unWX
	oIFHgpQsjPyHYabN0GroE81eCuEKC6ar2eBGrJhIgCpmjuNmSmZ4Td6xMGWm2xS26SJEFc
	o1MtkhsxclgG03gn+liiSLFPIHGW2Hk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773857037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G87/r1L8i4KqlxPSVM5/SPGd/iWO3A+cSbOyySyB3Ac=;
	b=0NW3R+LH/K9zjZ9S868OY7ZQxkSHSb+qb8u6CsvXS5f8yzIJn0h3rnPowV5aULBZVGAeUW
	xfjGnJsY5h6lkhAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6A224273B;
	Wed, 18 Mar 2026 18:03:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UKvKLw3pumnARwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Mar 2026 18:03:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 89C25A0AFF; Wed, 18 Mar 2026 19:03:49 +0100 (CET)
Date: Wed, 18 Mar 2026 19:03:49 +0100
From: Jan Kara <jack@suse.cz>
To: NeilBrown <neil@brown.name>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] ext4: move dcache manipulation out of __ext4_link()
Message-ID: <o474xp3p624xrqfbfflgwqmrnqxwgmr7imrsk7xi4rkclae6bk@tfzh4gcneddd>
References: <20260317224638.3809014-1-neilb@ownmail.net>
 <20260317224638.3809014-4-neilb@ownmail.net>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317224638.3809014-4-neilb@ownmail.net>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[brown.name:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: D6B274D3FF
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Wed 18-03-26 09:39:51, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> __ext4_link() has two callers.
> 
> - ext4_link() calls it during normal handling of the link() system
>   call or similar
> - ext4_fc_replay_link_internal() calls it when replaying the journal
>   at mount time.
> 
> The former needs changes to dcache - instaniating the dentry to the
					^^ instantiating

> inode on success.  The latter doesn't need or want any dcache
> manipluation.
  ^^ manipulation

> So move the manipulation out of __ext4_link() and do it in ext4_link()
> only.
> 
> This requires:
>  - passing the qname from the dentry explicitly to __ext4_link.
>    The parent dir is already passed.  The dentry is still passed
>    in the ext4_link() case purely for use by ext4_fc_track_link().
>  - passing the inode separately to ext4_fc_track_link() as the
>    dentry will not be instantiated yet.
>  - using __ext4_add_entry() in ext4_link, which doesn't need a dentry.
>  - moving ext4_inc_count(), ihold)(, d_instantiate(), drop_nlink() and
>    iput() calls out of __ext4_link() into ext4_link().
> 
> This substantially simplifies ext4_fc_replay_link_internal(), and
> removes a use of d_alloc() which, it is planned, will be removed.
> 
> Signed-off-by: NeilBrown <neil@brown.name>

Looks good to me! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h        |  5 +++--
>  fs/ext4/fast_commit.c | 32 ++++----------------------------
>  fs/ext4/namei.c       | 25 ++++++++++++++-----------
>  3 files changed, 21 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 293f698b7042..e757e9cf9728 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2974,7 +2974,8 @@ void __ext4_fc_track_unlink(handle_t *handle, struct inode *inode,
>  void __ext4_fc_track_link(handle_t *handle, struct inode *inode,
>  	struct dentry *dentry);
>  void ext4_fc_track_unlink(handle_t *handle, struct dentry *dentry);
> -void ext4_fc_track_link(handle_t *handle, struct dentry *dentry);
> +void ext4_fc_track_link(handle_t *handle, struct inode *inode,
> +			struct dentry *dentry);
>  void __ext4_fc_track_create(handle_t *handle, struct inode *inode,
>  			    struct dentry *dentry);
>  void ext4_fc_track_create(handle_t *handle, struct dentry *dentry);
> @@ -3719,7 +3720,7 @@ extern int ext4_handle_dirty_dirblock(handle_t *handle, struct inode *inode,
>  extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
>  			 struct inode *inode, struct dentry *dentry);
>  extern int __ext4_link(struct inode *dir, struct inode *inode,
> -		       struct dentry *dentry);
> +		       const struct qstr *d_name, struct dentry *dentry);
>  
>  #define S_SHIFT 12
>  static const unsigned char ext4_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 3ee302b73f45..175dda11f377 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -497,10 +497,9 @@ void __ext4_fc_track_link(handle_t *handle,
>  	trace_ext4_fc_track_link(handle, inode, dentry, ret);
>  }
>  
> -void ext4_fc_track_link(handle_t *handle, struct dentry *dentry)
> +void ext4_fc_track_link(handle_t *handle, struct inode *inode,
> +			struct dentry *dentry)
>  {
> -	struct inode *inode = d_inode(dentry);
> -
>  	if (ext4_fc_eligible(inode->i_sb))
>  		__ext4_fc_track_link(handle, inode, dentry);
>  }
> @@ -1431,7 +1430,6 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
>  				struct inode *inode)
>  {
>  	struct inode *dir = NULL;
> -	struct dentry *dentry_dir = NULL, *dentry_inode = NULL;
>  	struct qstr qstr_dname = QSTR_INIT(darg->dname, darg->dname_len);
>  	int ret = 0;
>  
> @@ -1442,21 +1440,7 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
>  		goto out;
>  	}
>  
> -	dentry_dir = d_obtain_alias(dir);
> -	if (IS_ERR(dentry_dir)) {
> -		ext4_debug("Failed to obtain dentry");
> -		dentry_dir = NULL;
> -		goto out;
> -	}
> -
> -	dentry_inode = d_alloc(dentry_dir, &qstr_dname);
> -	if (!dentry_inode) {
> -		ext4_debug("Inode dentry not created.");
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -
> -	ret = __ext4_link(dir, inode, dentry_inode);
> +	ret = __ext4_link(dir, inode, &qstr_dname, NULL);
>  	/*
>  	 * It's possible that link already existed since data blocks
>  	 * for the dir in question got persisted before we crashed OR
> @@ -1470,16 +1454,8 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
>  
>  	ret = 0;
>  out:
> -	if (dentry_dir) {
> -		d_drop(dentry_dir);
> -		dput(dentry_dir);
> -	} else if (dir) {
> +	if (dir)
>  		iput(dir);
> -	}
> -	if (dentry_inode) {
> -		d_drop(dentry_inode);
> -		dput(dentry_inode);
> -	}
>  
>  	return ret;
>  }
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 768036a109d7..23942320c515 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3452,7 +3452,8 @@ static int ext4_symlink(struct mnt_idmap *idmap, struct inode *dir,
>  	return err;
>  }
>  
> -int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
> +int __ext4_link(struct inode *dir, struct inode *inode,
> +		const struct qstr *d_name, struct dentry *dentry)
>  {
>  	handle_t *handle;
>  	int err, retries = 0;
> @@ -3467,10 +3468,8 @@ int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
>  		ext4_handle_sync(handle);
>  
>  	inode_set_ctime_current(inode);
> -	ext4_inc_count(inode);
> -	ihold(inode);
>  
> -	err = ext4_add_entry(handle, dentry, inode);
> +	err = __ext4_add_entry(handle, dir, d_name, inode);
>  	if (!err) {
>  		err = ext4_mark_inode_dirty(handle, inode);
>  		/* this can happen only for tmpfile being
> @@ -3478,11 +3477,8 @@ int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
>  		 */
>  		if (inode->i_nlink == 1)
>  			ext4_orphan_del(handle, inode);
> -		d_instantiate(dentry, inode);
> -		ext4_fc_track_link(handle, dentry);
> -	} else {
> -		drop_nlink(inode);
> -		iput(inode);
> +		if (dentry)
> +			ext4_fc_track_link(handle, inode, dentry);
>  	}
>  	ext4_journal_stop(handle);
>  	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
> @@ -3511,9 +3507,16 @@ static int ext4_link(struct dentry *old_dentry,
>  	err = dquot_initialize(dir);
>  	if (err)
>  		return err;
> -	return __ext4_link(dir, inode, dentry);
> +	ext4_inc_count(inode);
> +	err = __ext4_link(dir, inode, &dentry->d_name, dentry);
> +	if (!err) {
> +		ihold(inode);
> +		d_instantiate(dentry, inode);
> +	} else {
> +		drop_nlink(inode);
> +	}
> +	return err;
>  }
> -
>  /*
>   * Try to find buffer head where contains the parent block.
>   * It should be the inode block if it is inlined or the 1st block
> -- 
> 2.50.0.107.gf914562f5916.dirty
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
