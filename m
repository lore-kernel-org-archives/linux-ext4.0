Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26B83603C9
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 17:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856574; cv=none; b=O7ejo4/672znkjBb+Oz0hQbSjS51HCn5Qug+g3CRZ+c/SMuLxsKBosRCmz5jF8UXU8S18BKR8U1KHQZ5kQ2V8A8m7S3aloQ/ZczIQiEZgzR2jRdYWyt8rpRYdrGnjqmd0aQYWzBLZ9OpCPiqUtXkzhKRQsX0LRNe7MzCBpcU/PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856574; c=relaxed/simple;
	bh=a0bEepMJMAlnImg6xOc2GsuDkAPUpDq57w++17XPp1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYqD8ugb7iJHkdJoTaKLPWjYAL8vet6E3IIk97CThq6j7k4LiGQSMDNulinpgoB+P9g2+6QjrduDaClCOKtfYwMfLmzTZJ0H5+aE+AbopjpgHjJcSE+JdkH3fFZ0dxngZBGv32WMR6cqdBoxFIAPnChl1ddCIAQk4palbSR8PqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2Qx1JsF4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=U9Gmg1pf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2Qx1JsF4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=U9Gmg1pf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2Qx1JsF4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="U9Gmg1pf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2Qx1JsF4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="U9Gmg1pf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B77255BED5;
	Wed, 18 Mar 2026 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773856566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rK22DN/9OfLgI2F8oDLcdNE1PM9qJ9unpelc7P9ZCQ8=;
	b=2Qx1JsF4epz2dYoff1TebFOIbV8DNvezDELv4++meNF8uzGUjHuSGdic/dGuz3xbMrJZ4b
	DfcQcmrXda6swNCt9617FdkTY0GJllW+O0hH5XUu5D9Fjsl5K70QZ1am4dNxJZIZyL9/nV
	Lom2VdnJcPlWXEjCzALg9vHAkTRjahU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773856566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rK22DN/9OfLgI2F8oDLcdNE1PM9qJ9unpelc7P9ZCQ8=;
	b=U9Gmg1pflu3H2G3PxRpRpCKfAzUlLnI2NGhSUvHNIeVRkw4OnPlr3h75RlgBmEgg9Lv0V0
	nAoEzxmni0rYP4CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2Qx1JsF4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=U9Gmg1pf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773856566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rK22DN/9OfLgI2F8oDLcdNE1PM9qJ9unpelc7P9ZCQ8=;
	b=2Qx1JsF4epz2dYoff1TebFOIbV8DNvezDELv4++meNF8uzGUjHuSGdic/dGuz3xbMrJZ4b
	DfcQcmrXda6swNCt9617FdkTY0GJllW+O0hH5XUu5D9Fjsl5K70QZ1am4dNxJZIZyL9/nV
	Lom2VdnJcPlWXEjCzALg9vHAkTRjahU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773856566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rK22DN/9OfLgI2F8oDLcdNE1PM9qJ9unpelc7P9ZCQ8=;
	b=U9Gmg1pflu3H2G3PxRpRpCKfAzUlLnI2NGhSUvHNIeVRkw4OnPlr3h75RlgBmEgg9Lv0V0
	nAoEzxmni0rYP4CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AED784273B;
	Wed, 18 Mar 2026 17:56:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2YGvKjbnumlKPwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Mar 2026 17:56:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7346FA0AFF; Wed, 18 Mar 2026 18:56:06 +0100 (CET)
Date: Wed, 18 Mar 2026 18:56:06 +0100
From: Jan Kara <jack@suse.cz>
To: NeilBrown <neil@brown.name>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] ext4: split __ext4_add_entry() out of
 ext4_add_entry()
Message-ID: <sj37ibfmsn2mfujykdpq5k7r5dloyalyzketwnjoxyqx5h6s4l@pxgmcbb6vcp4>
References: <20260317224638.3809014-1-neilb@ownmail.net>
 <20260317224638.3809014-2-neilb@ownmail.net>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317224638.3809014-2-neilb@ownmail.net>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B77255BED5

On Wed 18-03-26 09:39:49, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> __ext4_add_entry() is not given a dentry - just inodes and name.
> This will help the next patch which simplifies __ex4_link().
> 
> Signed-off-by: NeilBrown <neil@brown.name>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/namei.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index c4b5e252af0e..768036a109d7 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2353,10 +2353,10 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
>   * may not sleep between calling this and putting something into
>   * the entry, as someone else might have used it while you slept.
>   */
> -static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
> +static int __ext4_add_entry(handle_t *handle, struct inode *dir,
> +			  const struct qstr *d_name,
>  			  struct inode *inode)
>  {
> -	struct inode *dir = d_inode(dentry->d_parent);
>  	struct buffer_head *bh = NULL;
>  	struct ext4_dir_entry_2 *de;
>  	struct super_block *sb;
> @@ -2373,13 +2373,10 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
>  	sb = dir->i_sb;
>  	blocksize = sb->s_blocksize;
>  
> -	if (fscrypt_is_nokey_name(dentry))
> -		return -ENOKEY;
> -
> -	if (!generic_ci_validate_strict_name(dir, &dentry->d_name))
> +	if (!generic_ci_validate_strict_name(dir, d_name))
>  		return -EINVAL;
>  
> -	retval = ext4_fname_setup_filename(dir, &dentry->d_name, 0, &fname);
> +	retval = ext4_fname_setup_filename(dir, d_name, 0, &fname);
>  	if (retval)
>  		return retval;
>  
> @@ -2460,6 +2457,16 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
>  	return retval;
>  }
>  
> +static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
> +			  struct inode *inode)
> +{
> +	struct inode *dir = d_inode(dentry->d_parent);
> +
> +	if (fscrypt_is_nokey_name(dentry))
> +		return -ENOKEY;
> +	return __ext4_add_entry(handle, dir, &dentry->d_name, inode);
> +}
> +
>  /*
>   * Returns 0 for success, or a negative error value
>   */
> -- 
> 2.50.0.107.gf914562f5916.dirty
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
