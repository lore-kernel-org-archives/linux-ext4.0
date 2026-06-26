Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C8C39A063
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 16:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782492838; cv=none; b=JzfRff38Tyfxxj8XhIqlQmLZNNM7L+g++2AvPA2ElHDd1BiwE1aAUSTAPyKVYrwSL5jhOwmXT4kT9wa3Tqd9DrLOZoS3u4ALTGn7GPEx+/rWoI0uuPI1fdb/TycgkvG9rp3ieSUIK9Oo4hXLH38rKS+wMbRtuuLCuKPcrKCI8WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782492838; c=relaxed/simple;
	bh=o2NBfUp9XlYrYkQyIDamxEP/VjADoC0B95V/BYst9js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyH/0hEvJjOEyFaqSZZ9edE9nJuyhD10X+clGcI03LEnTeCMx/oD428Wtro6+vcKwggA0hI9cp+s6C8+a+8b7KUOrxreHK9lnp8Ow6ZDB5WYdfG+s82spqVvz++kMhe3ap46+ZE7ixshT3fYpviE/S7jBxuSSN4eHXH7StLCHt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Q7buJFrC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=A70O9a3L; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JGxL7qTL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IUOYRkPI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q7buJFrC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="A70O9a3L";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JGxL7qTL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IUOYRkPI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E495172297;
	Fri, 26 Jun 2026 16:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782492835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cr9Yol568SvTJJ5NBrGRZSW3nkBrf06dAXYageyYbO4=;
	b=Q7buJFrCcWDo1c9r22amDIDoy72uQz4dTaTu+Lioli9SpRUmCl1PlXeaARwkg5f7svGcwb
	PIKLh3lpuOqyqaQfo5QTDygfOV++6llEhK0QjEgKtvgasXQbJIItOkt2Pu0ogwhqA/vixd
	BFyUjbbZGFzdmFYSxTEK1r4m1DoZqw0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782492835;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cr9Yol568SvTJJ5NBrGRZSW3nkBrf06dAXYageyYbO4=;
	b=A70O9a3Lt+pT/m3Yae+rioXJfmTfxuEECsL6T8zVWS1OySQjlWlVcd/0JbYhURk0Xqk57n
	fH7WLw0SD+G6kiAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782492834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cr9Yol568SvTJJ5NBrGRZSW3nkBrf06dAXYageyYbO4=;
	b=JGxL7qTLt8hTfCeoYN/drLFpz6LTxRcK0R2XH8hjNXlFENQY98KwbYEqLFxAUa4DeLN7M3
	Ceu00k9Ca3KDBRMR3G75wLYelLiuP0krJcQourkTaxnykYAPdO07mGYr7y4s4Aq7WyuH5Z
	HRIjIejWNy9YofjEPgMij6AFXooWpWQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782492834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cr9Yol568SvTJJ5NBrGRZSW3nkBrf06dAXYageyYbO4=;
	b=IUOYRkPIPhcYu0I6cXrr8I7lowUX6tib83Huf2TLatjD3NRkKTtpie6xUvi9NQHN9O4Yr7
	0te3gXqoIp6iRtBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC6B3779A8;
	Fri, 26 Jun 2026 16:53:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u+swMaKuPmr4cwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 26 Jun 2026 16:53:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 66888A10A3; Fri, 26 Jun 2026 18:53:50 +0200 (CEST)
Date: Fri, 26 Jun 2026 18:53:50 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v10 2/5] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
Message-ID: <t7ewb5or7ybrt3mwbnjxjddo7ok75dopf5czoib7nyou4zwdmd@plj4clfhoybl>
References: <20260625152941.24788-1-yun.zhou@windriver.com>
 <20260625152941.24788-3-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625152941.24788-3-yun.zhou@windriver.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[windriver.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Thu 25-06-26 23:29:38, Yun Zhou wrote:
> Calling iput() on EA inodes while holding xattr_sem or a jbd2 handle
> can trigger write_inode_now() -> ext4_writepages() -> s_writepages_rwsem,
> creating a lock ordering issue during mount (!SB_ACTIVE).
> 
> Add ext4_put_ea_inode() which uses iput_if_not_last() as a fast path.
> If this is not the last reference, it is dropped immediately.  If this
> is the last reference, the inode is linked onto a per-sb lock-free llist
> via i_ea_iput_node (embedded in ext4_inode_info, sharing space with the
> unused xattr_sem of EA inodes via a union) and a delayed worker
> (1 jiffie) performs the final iput() in a clean context.  This avoids
> per-iput memory allocation.
> 
> Convert the first call site: ext4_xattr_block_set()'s "Drop the
> previous xattr block" path, which previously called
> ext4_xattr_inode_array_free() under xattr_sem + jbd2 handle.
> 
> The worker is drained in ext4_put_super() before quota shutdown using
> a loop to handle re-arming (evicting an EA inode may queue further EA
> inodes).  Initialization is placed before journal loading since fast
> commit replay may trigger evictions that call ext4_put_ea_inode().
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Suggested-by: Jan Kara <jack@suse.cz>

Thanks for the patch. It looks mostly good. Some comments below.

> @@ -5497,6 +5505,8 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  			  ext4_has_feature_orphan_present(sb) ||
>  			  ext4_has_feature_journal_needs_recovery(sb));
>  
> +	ext4_init_ea_inode_work(sbi);
> +
>  	if (ext4_has_feature_mmp(sb) && !sb_rdonly(sb)) {
>  		err = ext4_multi_mount_protect(sb, le64_to_cpu(es->s_mmp_block));
>  		if (err)
> @@ -5508,6 +5518,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  	 * The first inode we look at is the journal inode.  Don't try
>  	 * root first: it may be modified in the journal!
>  	 */
> +

Stray addition of empty line.

>  	if (!test_opt(sb, NOLOAD) && ext4_has_feature_journal(sb)) {
>  		err = ext4_load_and_init_journal(sb, es, ctx);
>  		if (err)


> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 982a1f831e22..ecdad5920b14 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -117,6 +117,8 @@ const struct xattr_handler * const ext4_xattr_handlers[] = {
>  static int
>  ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
>  			struct inode *inode);
> +static void ext4_xattr_inode_array_free_deferred(struct super_block *sb,
> +				struct ext4_xattr_inode_array *array);
>  
>  #ifdef CONFIG_LOCKDEP
>  void ext4_xattr_inode_set_class(struct inode *ea_inode)
> @@ -2187,7 +2189,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  		ext4_xattr_release_block(handle, inode, bs->bh,
>  					 &ea_inode_array,
>  					 0 /* extra_credits */);
> -		ext4_xattr_inode_array_free(ea_inode_array);
> +		ext4_xattr_inode_array_free_deferred(inode->i_sb,
> +						     ea_inode_array);
>  	}
>  	error = 0;
>  
> @@ -3025,6 +3028,74 @@ void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *ea_inode_array)
>  	kfree(ea_inode_array);
>  }
>  
> +static void ext4_xattr_inode_array_free_deferred(struct super_block *sb,
> +				struct ext4_xattr_inode_array *array)
> +{
> +	int idx;
> +
> +	if (array == NULL)
> +		return;
> +
> +	for (idx = 0; idx < array->count; ++idx)
> +		ext4_put_ea_inode(sb, array->inodes[idx]);
> +	kfree(array);
> +}

It's strange to introduce this only to delete it two patches later. I'd
just introduce the mechanism in patch 1. Convert callsites in patch 2,
replace ext4_xattr_inode_array_free() mechanism in patch 3.

> +
> +/*
> + * Worker function for deferred EA inode iput.  Processes all inodes queued
> + * on s_ea_inode_to_free in a context free of xattr_sem/jbd2 handle locks.
> + */
> +static void ext4_ea_inode_work(struct work_struct *work)
> +{
> +	struct ext4_sb_info *sbi = container_of(to_delayed_work(work),
> +						struct ext4_sb_info,
> +						s_ea_inode_work);
> +	struct llist_node *node = llist_del_all(&sbi->s_ea_inode_to_free);
> +	struct llist_node *next;
> +
> +	while (node) {
> +		struct ext4_inode_info *ei = container_of(node,
> +					struct ext4_inode_info, i_ea_iput_node);
> +		next = node->next;
> +		iput(&ei->vfs_inode);
> +		node = next;

'next' is actually not needed in this function. You can directly do:
  node = node->next;

> +/*
> + * Release a VFS reference on an EA inode.  Must be used instead of iput()
> + * in any context where xattr_sem or a jbd2 handle is held.
> + *
> + * If this is not the last reference, drops it immediately via
> + * iput_if_not_last() with no further action needed.
> + *
> + * If this is the last reference, the inode is linked onto a per-sb
> + * llist via i_ea_iput_node (embedded in ext4_inode_info, sharing space
> + * with the unused xattr_sem) and a delayed worker performs the final
> + * iput() in a clean context.

I'd add here: Note that if an inode is in s_ea_inode_to_free list, the
inode reference implicitely associated with that prevents
any future iput_if_not_last() from failing and so nobody will try to add
the inode to s_ea_inode_to_free for the second time until iput() in
ext4_ea_inode_work drops that reference.

> + */
> +void ext4_put_ea_inode(struct super_block *sb, struct inode *inode)
> +{
> +	if (!inode)
> +		return;
> +	WARN_ON_ONCE(!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL));
> +	if (iput_if_not_last(inode))
> +		return;
> +	llist_add(&EXT4_I(inode)->i_ea_iput_node,
> +		  &EXT4_SB(sb)->s_ea_inode_to_free);
> +	/*
> +	 * Use a short delay to allow multiple EA inodes to accumulate,
> +	 * reducing workqueue wakeups when several are released together.
> +	 */
> +	schedule_delayed_work(&EXT4_SB(sb)->s_ea_inode_work, 1);
> +}
> +
> +void ext4_init_ea_inode_work(struct ext4_sb_info *sbi)
> +{
> +	init_llist_head(&sbi->s_ea_inode_to_free);
> +	INIT_DELAYED_WORK(&sbi->s_ea_inode_work, ext4_ea_inode_work);
> +}
> +
>  /*
>   * ext4_xattr_block_cache_insert()
>   *
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index 1fedf44d4fb6..9883ba5569a1 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -190,6 +190,20 @@ extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  				   struct ext4_xattr_inode_array **array,
>  				   int extra_credits);
>  extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
> +extern void ext4_init_ea_inode_work(struct ext4_sb_info *sbi);
> +extern void ext4_put_ea_inode(struct super_block *sb, struct inode *inode);
> +
> +/*
> + * Drain all pending deferred EA inode iputs.  Must be called before
> + * freeing resources that eviction depends on (quota, block allocator).
> + * Loops because worker iput may trigger eviction that re-queues.
> + */

Can you please explain how iput of EA inode can trigger iput of another EA
inode? So far I don't think that's possible but perhaps I'm missing
something.

> +static inline void ext4_drain_ea_inode_work(struct ext4_sb_info *sbi)
> +{
> +	while (flush_delayed_work(&sbi->s_ea_inode_work) ||
> +	       !llist_empty(&sbi->s_ea_inode_to_free))
> +		;
> +}
>  
>  extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
>  			    struct ext4_inode *raw_inode, handle_t *handle);

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
