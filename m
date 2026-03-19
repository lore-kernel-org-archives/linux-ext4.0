Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8191386C9
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 12:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773924532; cv=none; b=ggSMitVuQe+oehhlfQt4Dw3arpYgUJE9CalWUVurOcrzvMf7HZM6WI9Zpcl7nJ2IvpXaCIgQLGhHxWmG1J5PirYDFhxSabgMnQHG95aCKm8OvVhqYSJBeq62BfjTAg9EBH5mMTIfVgCBiuEYwRfJvDh/ZceFP/G64Iu9VdtPOVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773924532; c=relaxed/simple;
	bh=vZcD2uqP8IRF1okTI/CMQOhHC0e2gwJjgJstvw67Rko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tw8DPw5cWRDgbtlZjFWCs4SDr6hqpfENbJJf6Q2Hb0m+LxlgEowdxkuGSz7qJkn/aqPE7+gsQFCUDi6IYLJ8YsnlLjB4vQ7O8CmG1vt+dml1804NmY5E5vN+RuEry6ivqAmeb4Aye0EvReTaqWaZBfcrWqSGkD/Oag7SJgPFX8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fONrCysY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=a07UtE5K; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fONrCysY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=a07UtE5K; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fONrCysY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="a07UtE5K";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fONrCysY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="a07UtE5K"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 19F325BD4A;
	Thu, 19 Mar 2026 12:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773924529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7+JpBjoftyzRzliZ7oAyCM8ow4nhhauGNv8v+WkIUuM=;
	b=fONrCysYpxCfNzeXNDz2u8WAX5/p/boaSQQxP/RA1qpkta2DkJdW+JfhJcHDKCchaq9dXu
	67tmyXXHkWcSbNFWc00gmg1j5HE4EVxzNM6nBw0XXb5XIaQiwo3FgtfNUMjp0B78Lduw9C
	bTJXSEPGm7zWUiS0wDTX6wGVO0eT17I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773924529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7+JpBjoftyzRzliZ7oAyCM8ow4nhhauGNv8v+WkIUuM=;
	b=a07UtE5K1AoUwQ4QQJdAEn9eIf3eDQ7zAsEpjro6sBkUN9YJVyIMElKgWkDYVP9lyFCfII
	RMlUwZ4M/jFCYrDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fONrCysY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a07UtE5K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773924529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7+JpBjoftyzRzliZ7oAyCM8ow4nhhauGNv8v+WkIUuM=;
	b=fONrCysYpxCfNzeXNDz2u8WAX5/p/boaSQQxP/RA1qpkta2DkJdW+JfhJcHDKCchaq9dXu
	67tmyXXHkWcSbNFWc00gmg1j5HE4EVxzNM6nBw0XXb5XIaQiwo3FgtfNUMjp0B78Lduw9C
	bTJXSEPGm7zWUiS0wDTX6wGVO0eT17I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773924529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7+JpBjoftyzRzliZ7oAyCM8ow4nhhauGNv8v+WkIUuM=;
	b=a07UtE5K1AoUwQ4QQJdAEn9eIf3eDQ7zAsEpjro6sBkUN9YJVyIMElKgWkDYVP9lyFCfII
	RMlUwZ4M/jFCYrDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0376A4273B;
	Thu, 19 Mar 2026 12:48:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OXLOALHwu2k6DQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Mar 2026 12:48:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B39BFA0B32; Thu, 19 Mar 2026 13:48:44 +0100 (CET)
Date: Thu, 19 Mar 2026 13:48:44 +0100
From: Jan Kara <jack@suse.cz>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, 
	Jiayuan Chen <jiayuan.chen@shopee.com>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Ritesh Harjani <riteshh@linux.ibm.com>, 
	Ye Bin <yebin10@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ext4: fix use-after-free in update_super_work when
 racing with umount
Message-ID: <mihd356y6mux74fsvd7ixdsfhwu76nu22zmqugjv2ukdxfpaqr@l6brlq73rlqy>
References: <20260319120336.157873-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319120336.157873-1-jiayuan.chen@linux.dev>
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
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: 19F325BD4A
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Thu 19-03-26 20:03:35, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> Commit b98535d09179 ("ext4: fix bug_on in start_this_handle during umount
> filesystem") moved ext4_unregister_sysfs() before flushing s_sb_upd_work
> to prevent new error work from being queued via /proc/fs/ext4/xx/mb_groups
> reads during unmount. However, this introduced a use-after-free because
> update_super_work calls ext4_notify_error_sysfs() -> sysfs_notify() which
> accesses the kobject's kernfs_node after it has been freed by kobject_del()
> in ext4_unregister_sysfs():
> 
>   update_super_work                ext4_put_super
>   -----------------                --------------
>                                    ext4_unregister_sysfs(sb)
>                                      kobject_del(&sbi->s_kobj)
>                                        __kobject_del()
>                                          sysfs_remove_dir()
>                                            kobj->sd = NULL
>                                          sysfs_put(sd)
>                                            kernfs_put()  // RCU free
>   ext4_notify_error_sysfs(sbi)
>     sysfs_notify(&sbi->s_kobj)
>       kn = kobj->sd              // stale pointer
>       kernfs_get(kn)             // UAF on freed kernfs_node
>                                    ext4_journal_destroy()
>                                      flush_work(&sbi->s_sb_upd_work)
> 
> Instead of reordering the teardown sequence, fix this by making
> ext4_notify_error_sysfs() detect that sysfs has already been torn down
> by checking s_kobj.state_in_sysfs, and skipping the sysfs_notify() call
> in that case. A dedicated mutex (s_error_notify_mutex) serializes
> ext4_notify_error_sysfs() against kobject_del() in ext4_unregister_sysfs()
> to prevent TOCTOU races where the kobject could be deleted between the
> state_in_sysfs check and the sysfs_notify() call.
> 
> Fixes: b98535d09179 ("ext4: fix bug_on in start_this_handle during umount filesystem")
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Looks good to me! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v2 -> v3: Fix issues reported by AI.
> https://sashiko.dev/#/patchset/20260319073651.79209-1-jiayuan.chen%40linux.dev
> 
> v1 -> v2: Use state_in_sysfs instead of reordering the teardown
> sequence.
> https://lore.kernel.org/linux-ext4/20260313065206.152645-1-jiayuan.chen@linux.dev/
> ---
>  fs/ext4/ext4.h  |  1 +
>  fs/ext4/super.c |  1 +
>  fs/ext4/sysfs.c | 10 +++++++++-
>  3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b76966dc06c0..c012e85d2515 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1574,6 +1574,7 @@ struct ext4_sb_info {
>  	struct proc_dir_entry *s_proc;
>  	struct kobject s_kobj;
>  	struct completion s_kobj_unregister;
> +	struct mutex s_error_notify_mutex; /* protects sysfs_notify vs kobject_del */
>  	struct super_block *s_sb;
>  	struct buffer_head *s_mmp_bh;
>  
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 752f414aa06b..b2d58a9b0413 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5397,6 +5397,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  
>  	timer_setup(&sbi->s_err_report, print_daily_error_info, 0);
>  	spin_lock_init(&sbi->s_error_lock);
> +	mutex_init(&sbi->s_error_notify_mutex);
>  	INIT_WORK(&sbi->s_sb_upd_work, update_super_work);
>  
>  	err = ext4_group_desc_init(sb, es, logical_sb_block, &first_not_zeroed);
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index d2ecc1026c0c..0503bf02aea1 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -597,7 +597,10 @@ static const struct kobj_type ext4_feat_ktype = {
>  
>  void ext4_notify_error_sysfs(struct ext4_sb_info *sbi)
>  {
> -	sysfs_notify(&sbi->s_kobj, NULL, "errors_count");
> +	mutex_lock(&sbi->s_error_notify_mutex);
> +	if (sbi->s_kobj.state_in_sysfs)
> +		sysfs_notify(&sbi->s_kobj, NULL, "errors_count");
> +	mutex_unlock(&sbi->s_error_notify_mutex);
>  }
>  
>  static struct kobject *ext4_root;
> @@ -610,8 +613,10 @@ int ext4_register_sysfs(struct super_block *sb)
>  	int err;
>  
>  	init_completion(&sbi->s_kobj_unregister);
> +	mutex_lock(&sbi->s_error_notify_mutex);
>  	err = kobject_init_and_add(&sbi->s_kobj, &ext4_sb_ktype, ext4_root,
>  				   "%s", sb->s_id);
> +	mutex_unlock(&sbi->s_error_notify_mutex);
>  	if (err) {
>  		kobject_put(&sbi->s_kobj);
>  		wait_for_completion(&sbi->s_kobj_unregister);
> @@ -644,7 +649,10 @@ void ext4_unregister_sysfs(struct super_block *sb)
>  
>  	if (sbi->s_proc)
>  		remove_proc_subtree(sb->s_id, ext4_proc_root);
> +
> +	mutex_lock(&sbi->s_error_notify_mutex);
>  	kobject_del(&sbi->s_kobj);
> +	mutex_unlock(&sbi->s_error_notify_mutex);
>  }
>  
>  int __init ext4_init_sysfs(void)
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
