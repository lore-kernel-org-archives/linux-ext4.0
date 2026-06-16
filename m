Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEA6421F11
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 09:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781602600; cv=none; b=mO9Wrs5bEugKFB7En35M1/JOcDYIJjYMRTjTrii7O6js+KpCKBqNAjbVpVsBg2dqOY1RLUG9PwnCCuZWv862zwhkiCgHSVYOanEEzeeuXJZUnNQ/ILx3uJZ3yduWjLIUL9GBmM7C/yHJT5lJfZTe//494git3yyYtThZtvTYsik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781602600; c=relaxed/simple;
	bh=PSbkvenPKBGJGnKcaPquPBICUzfQsNK1RXm6+oZS5r4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDBrC1vquNGqFiNSlvRlOLz1O2Xri+X7BMnenQMs/oCfv78jEfZtUe9cWvDYc2alhIFi9M7VN4vKreI8tOkzLPaojOtq6vfez/5G6ZIj4+lDFxZ9R1W5F0KbGS218V5mkNri9s30DdaiofsC8CHTZubnQ6g+KwUj3/b6i2Wshzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cX/S/SCI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pratbqcP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cX/S/SCI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pratbqcP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cX/S/SCI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pratbqcP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cX/S/SCI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pratbqcP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 513C96CA96;
	Tue, 16 Jun 2026 09:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781602592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FKXOPgkTCEku3Y3W+R4Ytz+xhr4vhbVdQhO9wJpwQ9k=;
	b=cX/S/SCIjQr2qnlrHUMRoAGBrWgNNij34tiZinhh2b3IDheeNZNWDecglo7DjdxYC95cIZ
	hErRfiVUDlveZcZp00hE01yR2q9qnF/trA8GF7Hj2k6iDOZtnupfjA2gRKDhiXA7dmtrvH
	Erp/dkKxj7tl/5mUnaPxbprLrna+LO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781602592;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FKXOPgkTCEku3Y3W+R4Ytz+xhr4vhbVdQhO9wJpwQ9k=;
	b=pratbqcPLSpOccocUIMk/8jYa/ukeB6H7Bq8iyvKu0eJOabAqeg/cB/p8vwfeGOfeYEpmE
	U9nyw0SisPBqE0CQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781602592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FKXOPgkTCEku3Y3W+R4Ytz+xhr4vhbVdQhO9wJpwQ9k=;
	b=cX/S/SCIjQr2qnlrHUMRoAGBrWgNNij34tiZinhh2b3IDheeNZNWDecglo7DjdxYC95cIZ
	hErRfiVUDlveZcZp00hE01yR2q9qnF/trA8GF7Hj2k6iDOZtnupfjA2gRKDhiXA7dmtrvH
	Erp/dkKxj7tl/5mUnaPxbprLrna+LO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781602592;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FKXOPgkTCEku3Y3W+R4Ytz+xhr4vhbVdQhO9wJpwQ9k=;
	b=pratbqcPLSpOccocUIMk/8jYa/ukeB6H7Bq8iyvKu0eJOabAqeg/cB/p8vwfeGOfeYEpmE
	U9nyw0SisPBqE0CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 41130779A8;
	Tue, 16 Jun 2026 09:36:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q6DeDyAZMWoqQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Jun 2026 09:36:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D82FAA12D3; Tue, 16 Jun 2026 11:36:27 +0200 (CEST)
Date: Tue, 16 Jun 2026 11:36:27 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 03/23] ext4: simplify error handling in ext4_setattr()
Message-ID: <o4y5u6dnub7aswxpjagiomrxy27lflqsvquvglq7wzwhabtuq3@eu4p2yjrunq4>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-4-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-4-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email,huawei.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 11-05-26 15:23:23, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Refactor the error handling in ext4_setattr() for better clarity:
> 
>  - Return directly on ext4_break_layouts() failure.
>  - Propagate ext4_truncate() errors using the existing error variable
>    and jump to the common 'err_out' label.
>  - Propagate posix_acl_chmod() errors also through the error variable,
>    as it theoretically does not return a non-fatal error.
> 
> With these changes, every error path either returns immediately or jumps
> to err_out. Consequently, the "if (!error)" condition guarding
> setattr_copy() and mark_inode_dirty() becomes unreachable for error
> cases. Remove this redundant check and the unused rc variable can be
> removed as well.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 35e958f89bd5..b1ef706987c3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5989,7 +5989,7 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> -	int error, rc = 0;
> +	int error;
>  	int orphan = 0;
>  	const unsigned int ia_valid = attr->ia_valid;
>  	bool inc_ivers = true;
> @@ -6102,10 +6102,10 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  
>  		filemap_invalidate_lock(inode->i_mapping);
>  
> -		rc = ext4_break_layouts(inode);
> -		if (rc) {
> +		error = ext4_break_layouts(inode);
> +		if (error) {
>  			filemap_invalidate_unlock(inode->i_mapping);
> -			goto err_out;
> +			return error;
>  		}
>  
>  		if (attr->ia_size > oldsize)
> @@ -6117,15 +6117,19 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		}
>  
>  		filemap_invalidate_unlock(inode->i_mapping);
> +		if (error)
> +			goto err_out;
>  	}
>  
> -	if (!error) {
> -		if (inc_ivers)
> -			inode_inc_iversion(inode);
> -		setattr_copy(idmap, inode, attr);
> -		mark_inode_dirty(inode);
> -	}
> +	if (inc_ivers)
> +		inode_inc_iversion(inode);
> +	setattr_copy(idmap, inode, attr);
> +	mark_inode_dirty(inode);
>  
> +	if (ia_valid & ATTR_MODE)
> +		error = posix_acl_chmod(idmap, dentry, inode->i_mode);
> +
> +err_out:
>  	/*
>  	 * If the call to ext4_truncate failed to get a transaction handle at
>  	 * all, we need to clean up the in-core orphan list manually.
> @@ -6133,14 +6137,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	if (orphan && inode->i_nlink)
>  		ext4_orphan_del(NULL, inode);
>  
> -	if (!error && (ia_valid & ATTR_MODE))
> -		rc = posix_acl_chmod(idmap, dentry, inode->i_mode);
> -
> -err_out:
> -	if  (error)
> +	if (error)
>  		ext4_std_error(inode->i_sb, error);
> -	if (!error)
> -		error = rc;
>  	return error;
>  }
>  
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
