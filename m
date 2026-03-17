Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA56D35F5E9
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2026 11:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747502; cv=none; b=c2l2X6gEVa1gJdPEzP/5oHCwhP+Sg6PGjA8cvJ6p1oT69k8e6RC4RG5K5M4wr654Uk/0meO3xZN2AunpWanmLf70DRqzEm5q1TcDlszTNWzaBM3Tx3tCJMAu3sUthGCmobTO5DCFG6/3NwjDx1uaTv83dmo/RQvIHhNNzqkTkdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747502; c=relaxed/simple;
	bh=zNvy87fFl+UspgZY6MExzT3xh8s0xUYsTvMO8pX0MhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IjnE4tgjt9IuLgA4slkKWdF+tu4FVhV0lvBSgUVpppoledN58Ki6AUD53U2Atw7bXmAifmPgCt44IsCABpYUnSJAIEDB+eDRe6fIRxR2GHY9zm8asdIcR+/EFewi8AMM32x0CWnGH25Uui9xMXD6I1tWJUg7sZxJr6YMA1VEZfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=R2crY7Le; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BZF4nB/u; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ClAd5CLh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rddbcf1w; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="R2crY7Le";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BZF4nB/u";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ClAd5CLh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rddbcf1w"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EBE255BDCA;
	Tue, 17 Mar 2026 11:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773747499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O8vRdtZsMJ69a09vaD87+wz8FRMGURu6URN/YeVhfTo=;
	b=R2crY7LeypmFV2r/Ttg/CFmjC4ywemwQmd2CIAgepqiO/ZiBSMGjGa+N2v6fYjwtB46n+t
	BDJD+iBeIgDqp7oSx1KqmNmK8vwzKjJ0eh2RiE3I6TqpAZkUUr23ZOG/XmJ3NRZUz3qAoE
	jT7+OuOCJf/AOvbYriA05Lc+zGXH9kY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773747499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O8vRdtZsMJ69a09vaD87+wz8FRMGURu6URN/YeVhfTo=;
	b=BZF4nB/unYA/owbNsME19E0T0uJpHBinv99jvtNGjPa7w1WE5VkPnTd64Z3h+cIQte8nqH
	ohjF+vd5J4GG+lCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773747498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O8vRdtZsMJ69a09vaD87+wz8FRMGURu6URN/YeVhfTo=;
	b=ClAd5CLhnT5LWxjMDIwN5+qG24C6aX6xjdIP2e/RWm3E5D0i9c/inWsC+RYF2EVkNN95pf
	t6dBEddRgVKjrmc5ByIT6AO8fuEZ3ZKpLlKZBL4GfvjjFkalVq0xWdUP+4x/uXVwLGShfT
	h/vmWgaDIBbLc8BhQdpEQK8/bad3D/4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773747498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O8vRdtZsMJ69a09vaD87+wz8FRMGURu6URN/YeVhfTo=;
	b=Rddbcf1wTiCkhyIXMe4z7bHxr5In71jSY5WvebzetUdK6anPRp9AmwFqmvPhTNLWdlZYBa
	c5Z5NVKEk7EJWhBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC2C94273B;
	Tue, 17 Mar 2026 11:38:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oPy9NSo9uWkyPAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 17 Mar 2026 11:38:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8B2E3A0A5B; Tue, 17 Mar 2026 12:38:18 +0100 (CET)
Date: Tue, 17 Mar 2026 12:38:18 +0100
From: Jan Kara <jack@suse.cz>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ritesh Harjani <riteshh@linux.ibm.com>, 
	Ye Bin <yebin10@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] ext4: fix use-after-free in update_super_work when
 racing with umount
Message-ID: <jn23562fj73siqgtlzqknce34eqiazitghu55pyvczustuey32@zhx3wpu5eciy>
References: <20260313065206.152645-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313065206.152645-1-jiayuan.chen@linux.dev>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,linux.dev:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Fri 13-03-26 14:52:04, Jiayuan Chen wrote:
> Commit b98535d09179 ("ext4: fix bug_on in start_this_handle during umount filesystem")
> moved ext4_unregister_sysfs() before flushing s_sb_upd_work to prevent new
> error work from being queued via /proc/fs/ext4/xx/mb_groups reads during
> unmount. However, this introduced a use-after-free because
> update_super_work calls ext4_notify_error_sysfs() -> sysfs_notify() which
> accesses the kobject's kernfs_node after it has been freed:
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
> The original blamed commit needed procfs removal before the work
> flush to prevent /proc/fs/ext4/xx/mb_groups reads from queuing new error
> work. But it bundled procfs removal and kobject_del together in
> ext4_unregister_sysfs(), causing the sysfs kobject to be torn down too
> early.
> 
> The correct teardown ordering has three constraints:
> 
>   1. procfs removal must happen before flushing s_sb_upd_work, to prevent
>      /proc reads from queuing new error work that would BUG_ON.
>   2. sysfs kobject removal must happen after flushing s_sb_upd_work, since
>      the work calls sysfs_notify() which accesses the kernfs_node.
>   3. sysfs kobject removal must happen before jbd2_journal_destroy(), since
>      userspace could read the journal_task sysfs attribute and dereference
>      j_task after the journal thread has been killed.
> 
> Fix this by:
>   - Adding ext4_sb_release_proc() to remove procfs entries early.
>   - Splitting ext4_journal_destroy() into ext4_journal_stop_work() and
>     ext4_journal_finish(), so that ext4_unregister_sysfs() can be placed
>     between them to satisfy all three ordering constraints.
> 
> Fixes: b98535d09179 ("ext4: fix bug_on in start_this_handle during umount filesystem")
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Thanks for the analysis and the patch! I fully agree with your analysis but
I think your solution shows that the teardown sequence is just too subtle
(too many different dependencies). Ideally, we'd instead modify
ext4_notify_error_sysfs() to detect sysfs is already torn down by
ext4_unregister_sysfs() and do nothing. We can check
sbi->s_kobj.state_in_sysfs for that. The only trouble with this is that
sysfs_notify() could still race with kobject_del() so we also need some
locking in ext4_unregister_sysfs() locking out parallel
ext4_notify_error_sysfs() and we probably need to introduce a separate
mutex for that. What do you think?

								Honza
> ---
>  fs/ext4/ext4.h      |  1 +
>  fs/ext4/ext4_jbd2.h | 45 ++++++++++++++++++++++++++++-----------------
>  fs/ext4/super.c     | 34 +++++++++++++++++++++++-----------
>  fs/ext4/sysfs.c     | 10 ++++++++++
>  4 files changed, 62 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b76966dc06c0..a693365d224c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3757,6 +3757,7 @@ extern const struct inode_operations ext4_fast_symlink_inode_operations;
>  /* sysfs.c */
>  extern void ext4_notify_error_sysfs(struct ext4_sb_info *sbi);
>  extern int ext4_register_sysfs(struct super_block *sb);
> +extern void ext4_sb_release_proc(struct super_block *sb);
>  extern void ext4_unregister_sysfs(struct super_block *sb);
>  extern int __init ext4_init_sysfs(void);
>  extern void ext4_exit_sysfs(void);
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 63d17c5201b5..2b7d68b11578 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -430,32 +430,43 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
>  }
>  
>  /*
> - * Pass journal explicitly as it may not be cached in the sbi->s_journal in some
> - * cases
> + * Stop new s_sb_upd_work from being queued and flush any pending work.
> + *
> + * At this point only two things can be operating on the journal:
> + * JBD2 thread performing transaction commit and s_sb_upd_work
> + * issuing sb update through the journal. Once we set
> + * EXT4_MF_JOURNAL_DESTROY, new ext4_handle_error() calls will not
> + * queue s_sb_upd_work and ext4_force_commit() makes sure any
> + * ext4_handle_error() calls from the running transaction commit are
> + * finished. Hence no new s_sb_upd_work can be queued after we
> + * flush it here.
>   */
> -static inline int ext4_journal_destroy(struct ext4_sb_info *sbi, journal_t *journal)
> +static inline void ext4_journal_stop_work(struct ext4_sb_info *sbi)
>  {
> -	int err = 0;
> -
> -	/*
> -	 * At this point only two things can be operating on the journal.
> -	 * JBD2 thread performing transaction commit and s_sb_upd_work
> -	 * issuing sb update through the journal. Once we set
> -	 * EXT4_JOURNAL_DESTROY, new ext4_handle_error() calls will not
> -	 * queue s_sb_upd_work and ext4_force_commit() makes sure any
> -	 * ext4_handle_error() calls from the running transaction commit are
> -	 * finished. Hence no new s_sb_upd_work can be queued after we
> -	 * flush it here.
> -	 */
>  	ext4_set_mount_flag(sbi->s_sb, EXT4_MF_JOURNAL_DESTROY);
> -
>  	ext4_force_commit(sbi->s_sb);
>  	flush_work(&sbi->s_sb_upd_work);
> +}
> +
> +/*
> + * Destroy the journal. Must be called after ext4_journal_stop_work().
> + * Pass journal explicitly as it may not be cached in the sbi->s_journal
> + * in some cases.
> + */
> +static inline int ext4_journal_finish(struct ext4_sb_info *sbi,
> +				      journal_t *journal)
> +{
> +	int err;
>  
>  	err = jbd2_journal_destroy(journal);
>  	sbi->s_journal = NULL;
> -
>  	return err;
>  }
>  
> +static inline int ext4_journal_destroy(struct ext4_sb_info *sbi, journal_t *journal)
> +{
> +	ext4_journal_stop_work(sbi);
> +	return ext4_journal_finish(sbi, journal);
> +}
> +
>  #endif	/* _EXT4_JBD2_H */
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 752f414aa06b..9bba783f44e1 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1280,16 +1280,12 @@ static void ext4_put_super(struct super_block *sb)
>  	int err;
>  
>  	/*
> -	 * Unregister sysfs before destroying jbd2 journal.
> -	 * Since we could still access attr_journal_task attribute via sysfs
> -	 * path which could have sbi->s_journal->j_task as NULL
> -	 * Unregister sysfs before flush sbi->s_sb_upd_work.
> -	 * Since user may read /proc/fs/ext4/xx/mb_groups during umount, If
> -	 * read metadata verify failed then will queue error work.
> -	 * update_super_work will call start_this_handle may trigger
> -	 * BUG_ON.
> +	 * Remove procfs entries before flush s_sb_upd_work. Since user may
> +	 * read /proc/fs/ext4/xx/mb_groups during umount, if read metadata
> +	 * verify failed then will queue error work. update_super_work will
> +	 * call start_this_handle which may trigger BUG_ON.
>  	 */
> -	ext4_unregister_sysfs(sb);
> +	ext4_sb_release_proc(sb);
>  
>  	if (___ratelimit(&ext4_mount_msg_ratelimit, "EXT4-fs unmount"))
>  		ext4_msg(sb, KERN_INFO, "unmounting filesystem %pU.",
> @@ -1301,14 +1297,30 @@ static void ext4_put_super(struct super_block *sb)
>  	destroy_workqueue(sbi->rsv_conversion_wq);
>  	ext4_release_orphan_info(sb);
>  
> +	/*
> +	 * Flush s_sb_upd_work before unregistering sysfs, since
> +	 * update_super_work calls ext4_notify_error_sysfs() which accesses
> +	 * the kobject's kernfs_node via sysfs_notify(). Unregistering sysfs
> +	 * before the flush could lead to a use-after-free on the
> +	 * kernfs_node.
> +	 *
> +	 * Also unregister sysfs before destroying jbd2 journal, since
> +	 * userspace could read the journal_task sysfs attribute while
> +	 * jbd2_journal_destroy() is killing the journal thread, leading to
> +	 * a NULL pointer dereference of j_task in journal_task_show().
> +	 */
>  	if (sbi->s_journal) {
>  		aborted = is_journal_aborted(sbi->s_journal);
> -		err = ext4_journal_destroy(sbi, sbi->s_journal);
> +		ext4_journal_stop_work(sbi);
> +		ext4_unregister_sysfs(sb);
> +		err = ext4_journal_finish(sbi, sbi->s_journal);
>  		if ((err < 0) && !aborted) {
>  			ext4_abort(sb, -err, "Couldn't clean up the journal");
>  		}
> -	} else
> +	} else {
>  		flush_work(&sbi->s_sb_upd_work);
> +		ext4_unregister_sysfs(sb);
> +	}
>  
>  	ext4_es_unregister_shrinker(sbi);
>  	timer_shutdown_sync(&sbi->s_err_report);
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index d2ecc1026c0c..f6947416c1e7 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -638,6 +638,16 @@ int ext4_register_sysfs(struct super_block *sb)
>  	return 0;
>  }
>  
> +void ext4_sb_release_proc(struct super_block *sb)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +
> +	if (sbi->s_proc) {
> +		remove_proc_subtree(sb->s_id, ext4_proc_root);
> +		sbi->s_proc = NULL;
> +	}
> +}
> +
>  void ext4_unregister_sysfs(struct super_block *sb)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
