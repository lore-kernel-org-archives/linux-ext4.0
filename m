Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D80406803
	for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2026 11:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782820156; cv=none; b=to3aQUawFmlhOViKf3TBr+lkFiCCyp2QeaFegi/B8ITEcjbhM6mer0JLR1UXLWe+wNxxd+tr56ZcEgMl33/ZzMLUoF/BxHBJ2/bhtdC9hC3F7Jk4MAzdy7uuJe/eHb/d3EWwPX/iTV/SBUeSY2YDHI1VYLXKtlozgxeJMIDeesw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782820156; c=relaxed/simple;
	bh=wULC1sAyWDhuOeXmdjv9FE7sA2HQer4YiakKpxA+/CA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ayHO4j2Om6mzWiIDLZa62bmdSoH9qKlQkBGGcXclwOV2+xqa1opB573CP83GqgZicspZZqkORxQJHLEBzrFIP77SF3wkFyWNSB93/m3/qRsjhJkEE3nGMwvt4LCIV2Vxs71mJeBEhKyt5rkSt8Qx12+S/YJv8VlPlqnJ735rVP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=O31PccuW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=61s9O1Yj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=P7EphrIR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yigm5euv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="O31PccuW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="61s9O1Yj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="P7EphrIR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yigm5euv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EBC8575D18;
	Tue, 30 Jun 2026 11:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782820153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oIi5oBbXEmpG5BdJMGT/hNBWP9kD8e9wo7NfU/OGTlU=;
	b=O31PccuWEEWVCS2K1u5a13F8wsRojnVMcTSkmPMeAjqf8pq+L2XFiEu9Qjz8OifCI+kUE8
	NEkAhL+LtcKjnIBxTExqDmiMuLsbmGsc5yy2SgzEDmifjmMXvc8B+oYIz4LVpLCjG06Rp6
	/aoHGEK8i505oJiwQakIPKCtAH1oRmk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782820153;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oIi5oBbXEmpG5BdJMGT/hNBWP9kD8e9wo7NfU/OGTlU=;
	b=61s9O1Yjn1GHT/0LgI/rAORfveUGJHAgKO8OkKD2/9moE1r4X6hozNPs/0jeY4/LhiQY7E
	XhxLxlcj3Sa2hEAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782820152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oIi5oBbXEmpG5BdJMGT/hNBWP9kD8e9wo7NfU/OGTlU=;
	b=P7EphrIRonGbkNOU1EaxsWdZoUlmFusvfp1sdMoPIUA/8cRQmTZKj8r/BfzrRRyWS8bydT
	4KaPMIUWgGDAuC5e/ixTnf3zBGIyu3oWkB6/aq8s3kXaq9fernaHDZ/Txl18XOKHi4ergU
	ndi2hhc10pks+5Ght5vuXp4gIJBCpo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782820152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oIi5oBbXEmpG5BdJMGT/hNBWP9kD8e9wo7NfU/OGTlU=;
	b=yigm5euvousxSGCCBzXczpYIbdxR7HhB5JKWI2ylUU1s9yEfAWt+M18fKxW5ovjroqIBD/
	3YHHodKKGr1dOBBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C2BB779A8;
	Tue, 30 Jun 2026 11:49:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fdkoIjitQ2rzXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 30 Jun 2026 11:49:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F0986A10B7; Tue, 30 Jun 2026 13:49:11 +0200 (CEST)
Date: Tue, 30 Jun 2026 13:49:11 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v12 2/4] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
Message-ID: <4ikaxj56aewrknjojqg3t4lf7xhquei5puhwwqqzgqppaqocaj@jponnzx3nicq>
References: <20260630100829.1257618-1-yun.zhou@windriver.com>
 <20260630100829.1257618-3-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630100829.1257618-3-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo,windriver.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Tue 30-06-26 18:08:27, Yun Zhou wrote:
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
> Flush points are placed before quota shutdown (ext4_put_super and
> failed_mount9) and before freeing structures that eviction depends on
> (failed_mount_wq and failed_mount3a).  Initialization is placed before
> journal loading since fast commit replay may trigger evictions that call
> ext4_put_ea_inode().
> 
> Also moves init_rwsem(xattr_sem) from init_once to ext4_alloc_inode to
> handle slab object reuse after the union field has been overwritten.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Suggested-by: Jan Kara <jack@suse.cz>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h  | 13 ++++++++++-
>  fs/ext4/super.c | 18 ++++++++++++++-
>  fs/ext4/xattr.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/xattr.h |  2 ++
>  4 files changed, 91 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..b9b0ada7774b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1070,8 +1070,14 @@ struct ext4_inode_info {
>  	 * between readers of EAs and writers of regular file data, so
>  	 * instead we synchronize on xattr_sem when reading or changing
>  	 * EAs.
> +	 *
> +	 * EA inodes (EXT4_EA_INODE_FL) do not use xattr_sem; they reuse
> +	 * the space for deferred iput linkage.
>  	 */
> -	struct rw_semaphore xattr_sem;
> +	union {
> +		struct rw_semaphore xattr_sem;
> +		struct llist_node i_ea_iput_node;
> +	};
>  
>  	/*
>  	 * Inodes with EXT4_STATE_ORPHAN_FILE use i_orphan_idx. Otherwise
> @@ -1770,6 +1776,11 @@ struct ext4_sb_info {
>  	struct ext4_es_stats s_es_stats;
>  	struct mb_cache *s_ea_block_cache;
>  	struct mb_cache *s_ea_inode_cache;
> +
> +	/* Deferred iput for EA inodes to avoid lock ordering issues */
> +	struct llist_head s_ea_inode_to_free;
> +	struct delayed_work s_ea_inode_work;
> +
>  	spinlock_t s_es_lock ____cacheline_aligned_in_smp;
>  
>  	/* Journal triggers for checksum computation */
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 245f67d10ded..3efa5a817bef 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1303,6 +1303,8 @@ static void ext4_put_super(struct super_block *sb)
>  			 &sb->s_uuid);
>  
>  	ext4_unregister_li_request(sb);
> +	/* Drain deferred EA inode iputs while quota is still active. */
> +	flush_delayed_work(&sbi->s_ea_inode_work);
>  	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
>  
>  	destroy_workqueue(sbi->rsv_conversion_wq);
> @@ -1423,6 +1425,13 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
>  #endif
>  	ei->jinode = NULL;
> +	/*
> +	 * Reinitialize xattr_sem every allocation because EA inodes
> +	 * share this space with i_ea_iput_node (via union) which may
> +	 * have overwritten the semaphore when the slab object was
> +	 * previously used as an EA inode.
> +	 */
> +	init_rwsem(&ei->xattr_sem);
>  	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
>  	spin_lock_init(&ei->i_completed_io_lock);
>  	ei->i_sync_tid = 0;
> @@ -1488,7 +1497,6 @@ static void init_once(void *foo)
>  	struct ext4_inode_info *ei = foo;
>  
>  	INIT_LIST_HEAD(&ei->i_orphan);
> -	init_rwsem(&ei->xattr_sem);
>  	init_rwsem(&ei->i_data_sem);
>  	inode_init_once(&ei->vfs_inode);
>  	ext4_fc_init_inode(&ei->vfs_inode);
> @@ -5497,6 +5505,8 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  			  ext4_has_feature_orphan_present(sb) ||
>  			  ext4_has_feature_journal_needs_recovery(sb));
>  
> +	ext4_init_ea_inode_work(sbi);
> +
>  	if (ext4_has_feature_mmp(sb) && !sb_rdonly(sb)) {
>  		err = ext4_multi_mount_protect(sb, le64_to_cpu(es->s_mmp_block));
>  		if (err)
> @@ -5747,6 +5757,8 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  	return 0;
>  
>  failed_mount9:
> +	/* Drain deferred EA inode iputs before quota shutdown */
> +	flush_delayed_work(&sbi->s_ea_inode_work);
>  	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
>  failed_mount8: __maybe_unused
>  	ext4_release_orphan_info(sb);
> @@ -5767,6 +5779,8 @@ failed_mount8: __maybe_unused
>  	if (EXT4_SB(sb)->rsv_conversion_wq)
>  		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
>  failed_mount_wq:
> +	/* Drain deferred EA inode iputs before freeing structures */
> +	flush_delayed_work(&sbi->s_ea_inode_work);
>  	ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
>  	sbi->s_ea_inode_cache = NULL;
>  
> @@ -5777,6 +5791,8 @@ failed_mount8: __maybe_unused
>  		ext4_journal_destroy(sbi, sbi->s_journal);
>  	}
>  failed_mount3a:
> +	/* Drain deferred EA inode iputs from journal replay */
> +	flush_delayed_work(&sbi->s_ea_inode_work);
>  	ext4_es_unregister_shrinker(sbi);
>  failed_mount3:
>  	/* flush s_sb_upd_work before sbi destroy */
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 982a1f831e22..d5bccc64b032 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -3025,6 +3025,66 @@ void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *ea_inode_array)
>  	kfree(ea_inode_array);
>  }
>  
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
> +
> +	while (node) {
> +		struct ext4_inode_info *ei = container_of(node,
> +					struct ext4_inode_info, i_ea_iput_node);
> +		node = node->next;
> +		iput(&ei->vfs_inode);
> +	}
> +}
> +
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
> + *
> + * Note: while an inode is on s_ea_inode_to_free, the unconsumed i_count
> + * reference (still 1) keeps it in the inode cache, so any concurrent
> + * iget() bumps i_count to >= 2 and iput_if_not_last() will succeed.
> + * Nobody will add the inode a second time until ext4_ea_inode_work()
> + * drops that reference via iput().
> + */
> +void ext4_put_ea_inode(struct inode *inode)
> +{
> +	if (!inode)
> +		return;
> +	WARN_ON_ONCE(!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL));
> +	if (iput_if_not_last(inode))
> +		return;
> +	llist_add(&EXT4_I(inode)->i_ea_iput_node,
> +		  &EXT4_SB(inode->i_sb)->s_ea_inode_to_free);
> +	/*
> +	 * Use a short delay to allow multiple EA inodes to accumulate,
> +	 * reducing workqueue wakeups when several are released together.
> +	 */
> +	schedule_delayed_work(&EXT4_SB(inode->i_sb)->s_ea_inode_work, 1);
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
> index 1fedf44d4fb6..2ff4b6eccd40 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -190,6 +190,8 @@ extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  				   struct ext4_xattr_inode_array **array,
>  				   int extra_credits);
>  extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
> +extern void ext4_init_ea_inode_work(struct ext4_sb_info *sbi);
> +extern void ext4_put_ea_inode(struct inode *inode);
>  
>  extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
>  			    struct ext4_inode *raw_inode, handle_t *handle);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
