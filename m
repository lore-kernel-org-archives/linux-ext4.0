Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0A2402457
	for <linux-ext4@vger.kernel.org>; Thu, 30 Apr 2026 12:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777553035; cv=none; b=NxuVq9B32q9xzAbximklMRBkjz1svdTIpjdJ9DdIue5LUUiHWT0dBJ96qcIs41ZvmfncJeW1/x7MqZ4phqiyW5g2r+boQjqwUt7Po2AYxEi/oBKE6EmzkZYGLKdHQkkPxs1vENdV+xfN+VqHoy2CKfnknC9LRRfLyIqNw/px/DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777553035; c=relaxed/simple;
	bh=opGZQyYq5SD59WG/xzGQuwl3zSzcyjDpSc5ir3tp6OU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edBZY2yj6myy3M1s0s0Ra4gLDS0eVyhOzwuUnXtd+Xa8uFPq/9emCBLdXVzzrsgQps9vO/Ep5HFaZt1HkUwNZwdSvxBwezPYS5plaFmCyiC+tqX5OSQg+bFu77R9bnw9UVVr1lfHIQQxCam80oAHqVnvSzTaFJLWScN7Dg7lMng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JJPsMm27; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9DTP8gq2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VO/TU3tN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0OA4Hn4T; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JJPsMm27";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9DTP8gq2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VO/TU3tN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0OA4Hn4T"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E163F5BD4D;
	Thu, 30 Apr 2026 12:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777553027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lg35J3/tMRCnVfrlvGauSSvOGCUZfHDZ4E2xyhvynOg=;
	b=JJPsMm276CRlgDG5tcegdSp6Ladq2tHjEZsQ7yAT63zmq1S8YxuRm3glDFyD8/pk2TN4sP
	iwpxSMdu7ksYHMx8M8EhT4afqOXAsIOkWjF9Dzv1dWRNxqnzQ3oQpZFBOq4pTA41AVQRNR
	oT43aQ0iTuNtsUaipn+/7C4GRyuVJGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777553027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lg35J3/tMRCnVfrlvGauSSvOGCUZfHDZ4E2xyhvynOg=;
	b=9DTP8gq2B0HJQugruLju9tiXrmzUKLCs5Oea3htdaAForvb5coT+P+AdWcYSxPExFDSjSH
	JazDA5H2ddDEZuCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="VO/TU3tN";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0OA4Hn4T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777553026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lg35J3/tMRCnVfrlvGauSSvOGCUZfHDZ4E2xyhvynOg=;
	b=VO/TU3tNnj3idvvqFGUXGlhI1Fup2hWg6pyIIndUIXhMqwoRDxfa0NaIGRGituTox4xsjt
	nHVZAPWWBo6Gvwi9FfwJn09YARZrlrRJkxiiK1uye89af5uodHk6ma5phlM0wivr74SOcR
	E4LwO9VvPrZO8c/fd6vCEYpBKUgG/mY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777553026;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lg35J3/tMRCnVfrlvGauSSvOGCUZfHDZ4E2xyhvynOg=;
	b=0OA4Hn4TvijLUqOJzDvTtdxg+RwMbywzs1pcs5hm2+ZfuFuT+LKsQzg/919rDM+IX0wAF7
	GSz40A7XLxO2/+Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D45F1593B0;
	Thu, 30 Apr 2026 12:43:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z7TMM4JO82nTCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Apr 2026 12:43:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7F55FA0640; Thu, 30 Apr 2026 14:43:42 +0200 (CEST)
Date: Thu, 30 Apr 2026 14:43:42 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 01/22] ext4: simplify size updating in ext4_setattr()
Message-ID: <qdsmshhvhqf4sfbcaytjgwa7hsd572cjmijf5zbxz6vtqllaij@wekm6hznuiz3>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
 <20260422021042.4157510-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422021042.4157510-2-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,huawei.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E163F5BD4D

On Wed 22-04-26 10:10:21, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The logic for updating the file size in ext4_setattr() is currently
> somewhat messy. By directly entering the error-handling path after
> failing to add an orphan inode, the unnecessary recovery process
> involving old_disksize and the file size can be avoided.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Indeed, that code looks confusing for no good reason. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..0751dc55e94f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5953,7 +5953,6 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	if (attr->ia_valid & ATTR_SIZE) {
>  		handle_t *handle;
>  		loff_t oldsize = inode->i_size;
> -		loff_t old_disksize;
>  		int shrink = (attr->ia_size < inode->i_size);
>  
>  		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
> @@ -6037,6 +6036,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  			if (ext4_handle_valid(handle) && shrink) {
>  				error = ext4_orphan_add(handle, inode);
>  				orphan = 1;
> +				if (error)
> +					goto out_handle;
>  			}
>  
>  			if (shrink)
> @@ -6052,23 +6053,18 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
>  					inode->i_sb->s_blocksize_bits);
>  
> -			down_write(&EXT4_I(inode)->i_data_sem);
> -			old_disksize = EXT4_I(inode)->i_disksize;
> -			EXT4_I(inode)->i_disksize = attr->ia_size;
> -
>  			/*
>  			 * We have to update i_size under i_data_sem together
>  			 * with i_disksize to avoid races with writeback code
> -			 * running ext4_wb_update_i_disksize().
> +			 * updating disksize in mpage_map_and_submit_extent().
>  			 */
> -			if (!error)
> -				i_size_write(inode, attr->ia_size);
> -			else
> -				EXT4_I(inode)->i_disksize = old_disksize;
> +			down_write(&EXT4_I(inode)->i_data_sem);
> +			i_size_write(inode, attr->ia_size);
> +			EXT4_I(inode)->i_disksize = attr->ia_size;
>  			up_write(&EXT4_I(inode)->i_data_sem);
> -			rc = ext4_mark_inode_dirty(handle, inode);
> -			if (!error)
> -				error = rc;
> +
> +			error = ext4_mark_inode_dirty(handle, inode);
> +out_handle:
>  			ext4_journal_stop(handle);
>  			if (error)
>  				goto out_mmap_sem;
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
