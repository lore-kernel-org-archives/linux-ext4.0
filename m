Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B969437F73C
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782494618; cv=none; b=uCV8QpuyuWDeyvtJi6Vf9ZMvJIMtxnrGcbAVWryvPs6gFSj/niNxlOZgoXaNJiWdKcjSv54svPwPa1bT73AylNTeStGUphgEi6QOsxfVvJmfv+zMZ0aavhIKcFVqYYJWkHj/1tWtC4W1MOedGkQ2u32W0DaI5y0Foz8DOGbb63U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782494618; c=relaxed/simple;
	bh=XBT9IkUwcz6HnOo25nh7QCJx/jMDplwidRI/hFYjKk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksX2ULjqDLfjbM1bqTBZrsqIfbBLvOMdYi1DKHaE8NImXRNHu4xGqzQCa5MlU4CAcjxj1yaNsTUK13WMuqdaJ3mRuEi6GU864krtYi5fQTdXtoV8XPKZiWzBSInksD+shD4N0DftMNPBx7M/z5Ysw1WPJAubSHn9Hug/uroaTbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Xim93x3n; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rgtg6Mdy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UUmLvL3y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jAKetOZ7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Xim93x3n";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rgtg6Mdy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UUmLvL3y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jAKetOZ7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E4478722C1;
	Fri, 26 Jun 2026 17:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782494615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kJZtYRwmfpffS3pqCD8JnQyCJ50o6n9FDKI9M+Kok0Q=;
	b=Xim93x3n+AOTMLrw9v8WTSuWOQygfoiQFaWDwEKu8oUJYMiSUakvcs3L/aE45fjZLYosB+
	9TLvzbnrhRpE5gUBiuQzAt9nUmoDp7GiHhdsh67wYOVwz8Y0FJnHQ6FxSXvK7NJEU2zDYx
	vGXklFjux+zCFSqq4Eq2aMm0CW5aIb0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782494615;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kJZtYRwmfpffS3pqCD8JnQyCJ50o6n9FDKI9M+Kok0Q=;
	b=rgtg6MdyrGpdwil+ya29pL0JprwElmOBXJpMxwq8IcMjRrEoDgSa0g7Y1PjxTz9P7A9ZAz
	UpkGZw++9Hkh3JCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782494613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kJZtYRwmfpffS3pqCD8JnQyCJ50o6n9FDKI9M+Kok0Q=;
	b=UUmLvL3yfLSPJfMJ2gaiASdtygw1YJ8SiIy+y+TIka5J1H0xjIPJE1lOqGRckgYY3HkTIu
	gl8vFolzch0Xc6j2v46NYhE+lONSjZp4tnOd0QBj5gMRig4e/cXbmtsGYirulJeQWVtK14
	lJC6wRHncWWI/aAxpsYDxOmrdqyZL5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782494613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kJZtYRwmfpffS3pqCD8JnQyCJ50o6n9FDKI9M+Kok0Q=;
	b=jAKetOZ7zq7KuqaU8Z5lChMsYuWoAw9Y4qpTzAWHBNOLlK3rWWdTwaA+St3ETspmwwTau0
	j+wC3Rq3Lw8OjLBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CDC63779A8;
	Fri, 26 Jun 2026 17:23:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WrfPMZW1PmqmEAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 26 Jun 2026 17:23:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6D086A10A3; Fri, 26 Jun 2026 19:23:29 +0200 (CEST)
Date: Fri, 26 Jun 2026 19:23:29 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v10 5/5] ext4: prevent deadlock from duplicate EA inode
 references on corrupted fs
Message-ID: <ipqfj2abofanrrcapw2qp4wx6x6m647nqjrhqpuynpxxlh5ugr@utgka6gkeufw>
References: <20260625152941.24788-1-yun.zhou@windriver.com>
 <20260625152941.24788-6-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625152941.24788-6-yun.zhou@windriver.com>
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
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[windriver.com:email,iloc.bh:url,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Thu 25-06-26 23:29:41, Yun Zhou wrote:
> On a corrupted filesystem, multiple xattr entries may reference the same
> EA inode.  When ext4_xattr_inode_dec_ref_all() processes such entries, it
> can dec_ref the EA inode (setting nlink=0) and queue it for deferred iput.
> If the deferred worker runs before the loop processes the duplicate entry,
> the second iget() may block on I_FREEING while the worker's eviction waits
> for the caller's transaction to commit -- classic ABBA deadlock.

Hum, this looks possible but it isn't a new thing this patch set
introduces. Even before if you had corrupted filesystem,
ext4_xattr_inode_array_free() from ext4_evict_inode() could deadlock in a
similar way against say ext4_xattr_inode_dec_ref_all() (but practially
anything calling ext4_xattr_inode_iget() while holding a transaction
handle). So please leave this alone for now. We can look into that once
other EA inode settle.

								Honza

> 
> Fix by tracking successfully processed EA inodes on a per-call llist
> (reusing i_ea_iput_node) and skipping any ea_ino already in the list.
> This covers both intra-block duplicates and cross ibody/block duplicates
> in ext4_xattr_delete_inode().
> 
> The actual ext4_put_ea_inode() is deferred until after the processing
> loop completes (ext4_put_ea_inode_llist), ensuring no EA inode is queued
> for eviction while the loop is still iterating.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
>  fs/ext4/xattr.c | 68 ++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 61 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 7f334349bd4f..5c929043e44a 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1152,11 +1152,41 @@ static int ext4_xattr_restart_fn(handle_t *handle, struct inode *inode,
>  	return 0;
>  }
>  
> +/* Check if an EA inode number is already in the processed llist. */
> +static bool ext4_ea_ino_in_llist(unsigned int ea_ino,
> +				 struct llist_head *processed)
> +{
> +	struct ext4_inode_info *ei;
> +
> +	llist_for_each_entry(ei, processed->first, i_ea_iput_node) {
> +		if (ei->vfs_inode.i_ino == ea_ino)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +/* Put all EA inodes on a processed llist via ext4_put_ea_inode. */
> +static void ext4_put_ea_inode_llist(struct super_block *sb,
> +				    struct llist_head *processed)
> +{
> +	struct llist_node *node = llist_del_all(processed);
> +	struct llist_node *next;
> +
> +	while (node) {
> +		struct ext4_inode_info *ei = container_of(node,
> +				struct ext4_inode_info, i_ea_iput_node);
> +		next = node->next;
> +		ext4_put_ea_inode(sb, &ei->vfs_inode);
> +		node = next;
> +	}
> +}
> +
>  static void
>  ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  			     struct buffer_head *bh,
>  			     struct ext4_xattr_entry *first, bool block_csum,
> -			     int extra_credits, bool skip_quota)
> +			     int extra_credits, bool skip_quota,
> +			     struct llist_head *processed)
>  {
>  	struct inode *ea_inode;
>  	struct ext4_xattr_entry *entry;
> @@ -1186,6 +1216,11 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  		if (!entry->e_value_inum)
>  			continue;
>  		ea_ino = le32_to_cpu(entry->e_value_inum);
> +
> +		/* Skip if already processed (duplicate on corrupted fs) */
> +		if (ext4_ea_ino_in_llist(ea_ino, processed))
> +			continue;
> +
>  		err = ext4_xattr_inode_iget(parent, ea_ino,
>  					    le32_to_cpu(entry->e_hash),
>  					    &ea_inode);
> @@ -1235,7 +1270,12 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  		entry->e_value_inum = 0;
>  		entry->e_value_size = 0;
>  
> -		ext4_put_ea_inode(parent->i_sb, ea_inode);
> +		/*
> +		 * Collect processed EA inodes for dedup and deferred iput.
> +		 * ext4_put_ea_inode_llist() handles the actual release
> +		 * after the loop, preventing iget deadlocks on duplicates.
> +		 */
> +		llist_add(&EXT4_I(ea_inode)->i_ea_iput_node, processed);
>  		dirty = true;
>  	}
>  
> @@ -1262,7 +1302,8 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  static void
>  ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  			 struct buffer_head *bh,
> -			 int extra_credits)
> +			 int extra_credits,
> +			 struct llist_head *processed)
>  {
>  	struct mb_cache *ea_block_cache = EA_BLOCK_CACHE(inode);
>  	u32 hash, ref;
> @@ -1304,7 +1345,8 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  						     BFIRST(bh),
>  						     true /* block_csum */,
>  						     extra_credits,
> -						     true /* skip_quota */);
> +						     true /* skip_quota */,
> +						     processed);
>  		ext4_free_blocks(handle, inode, bh, 0, 1,
>  				 EXT4_FREE_BLOCKS_METADATA |
>  				 EXT4_FREE_BLOCKS_FORGET);
> @@ -2171,8 +2213,12 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  
>  	/* Drop the previous xattr block. */
>  	if (bs->bh && bs->bh != new_bh) {
> +		LLIST_HEAD(processed);
> +
>  		ext4_xattr_release_block(handle, inode, bs->bh,
> -					 0 /* extra_credits */);
> +					 0 /* extra_credits */,
> +					 &processed);
> +		ext4_put_ea_inode_llist(inode->i_sb, &processed);
>  	}
>  	error = 0;
>  
> @@ -2866,6 +2912,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  	struct ext4_xattr_entry *entry;
>  	struct inode *ea_inode;
>  	int error;
> +	LLIST_HEAD(processed);
>  
>  	error = ext4_journal_ensure_credits(handle, extra_credits,
>  			ext4_free_metadata_revoke_credits(inode->i_sb, 1));
> @@ -2897,7 +2944,8 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  						     IFIRST(header),
>  						     false /* block_csum */,
>  						     extra_credits,
> -						     false /* skip_quota */);
> +						     false /* skip_quota */,
> +						     &processed);
>  	}
>  
>  	if (EXT4_I(inode)->i_file_acl) {
> @@ -2921,6 +2969,11 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  			     entry = EXT4_XATTR_NEXT(entry)) {
>  				if (!entry->e_value_inum)
>  					continue;
> +				/* Skip EA inodes already dec_ref'd from ibody */
> +				if (ext4_ea_ino_in_llist(
> +					    le32_to_cpu(entry->e_value_inum),
> +					    &processed))
> +					continue;
>  				error = ext4_xattr_inode_iget(inode,
>  					      le32_to_cpu(entry->e_value_inum),
>  					      le32_to_cpu(entry->e_hash),
> @@ -2935,7 +2988,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  		}
>  
>  		ext4_xattr_release_block(handle, inode, bh,
> -					 extra_credits);
> +					 extra_credits, &processed);
>  		/*
>  		 * Update i_file_acl value in the same transaction that releases
>  		 * block.
> @@ -2951,6 +3004,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  	}
>  	error = 0;
>  cleanup:
> +	ext4_put_ea_inode_llist(inode->i_sb, &processed);
>  	brelse(iloc.bh);
>  	brelse(bh);
>  	return error;
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
