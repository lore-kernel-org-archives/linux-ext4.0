Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAEF30F815
	for <linux-ext4@vger.kernel.org>; Tue,  2 Jun 2026 11:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780399229; cv=none; b=R2S2v+YO5jrAVew5j4stNwfBtO7cwmXCBc5Ah75ZGFXwvw0ODvF+57QMtFxrdYVZeEMKVUZ4emxE+JLtqAbwV9m45ECvcE8KlHK02PVX5eA5Ud7mTqugQ1xleOMnmOrDIpss8GmhIclGL5rZal/wwS9Yu1D16c3PiNIEKS763W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780399229; c=relaxed/simple;
	bh=IyMHoAZbPPag4lfUP9uNWmdJZitaczEmpngB7lEFZOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGxthIpwfRAGYKMIG6EdDzvjHImc7mwUhZuW9jbcstCEAiX+GBdKjtzuHhyso6bXcTs48McgUWi/L7kWiCantwqjaD9PIQmvxdxsC5grnzW1g9qWk9qIyt8WmC3M4LKTP/4JUf/XvwXcgFcc/D/C2qjz+YeK6xceCfppd72mgcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mbYG1QPo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7suFEa+E; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mbYG1QPo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7suFEa+E; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mbYG1QPo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7suFEa+E";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mbYG1QPo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7suFEa+E"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B7D3E758D8;
	Tue,  2 Jun 2026 11:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780399226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+acDEyGozKj6T7QiZ48ofcK73obei9g+W/7IT5GjEw=;
	b=mbYG1QPoKe8JSHLLondGNPRcJzVsz88zWf2DMcZlO5tTJomAfiRaPQ+/7RQAhW6mrAAxAZ
	3JXvfwwtpoeNGg4xZtHVCKljDgDByP5u+IbYNcHGyDplwRl1T9YpQ1M147ZNehIgyp8n8W
	MNzuFzILcvL9Y1YRfO+MqngJWO8fn+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780399226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+acDEyGozKj6T7QiZ48ofcK73obei9g+W/7IT5GjEw=;
	b=7suFEa+EVSb7jlkmZG2S2E1QXdZ2K0OB+nWnC1nxXRyPtmm7r4U651J8HelCmQxO0BEZip
	EZIK6TfcZXc2IDDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780399226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+acDEyGozKj6T7QiZ48ofcK73obei9g+W/7IT5GjEw=;
	b=mbYG1QPoKe8JSHLLondGNPRcJzVsz88zWf2DMcZlO5tTJomAfiRaPQ+/7RQAhW6mrAAxAZ
	3JXvfwwtpoeNGg4xZtHVCKljDgDByP5u+IbYNcHGyDplwRl1T9YpQ1M147ZNehIgyp8n8W
	MNzuFzILcvL9Y1YRfO+MqngJWO8fn+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780399226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+acDEyGozKj6T7QiZ48ofcK73obei9g+W/7IT5GjEw=;
	b=7suFEa+EVSb7jlkmZG2S2E1QXdZ2K0OB+nWnC1nxXRyPtmm7r4U651J8HelCmQxO0BEZip
	EZIK6TfcZXc2IDDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AAE13779A7;
	Tue,  2 Jun 2026 11:20:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Mf62KXq8HmrlOwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 02 Jun 2026 11:20:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 67BC3A0EC1; Tue, 02 Jun 2026 13:20:22 +0200 (CEST)
Date: Tue, 2 Jun 2026 13:20:22 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 4/4] fs: retire sget()
Message-ID: <c3ouabc7iiejbgalzclpsg43dnowixi6z5hjox5ibeiig3t4it@dxmx4fwg2jek>
References: <20260529-work-sget-v2-0-57bbe08604e4@kernel.org>
 <20260529-work-sget-v2-4-57bbe08604e4@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529-work-sget-v2-4-57bbe08604e4@kernel.org>
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
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,gmail.com,zeniv.linux.org.uk];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Level: 

On Fri 29-05-26 10:43:43, Christian Brauner wrote:
> sget() and sget_fc() have lived side by side as near-duplicate
> find-or-create-and-publish helpers for the legacy and fs_context mount
> APIs. The three remaining in-tree callers (CIFS plus the ext4 extents
> and mballoc KUnit tests) have all been moved to sget_fc(). Nothing
> calls sget() anymore.
> 
> Delete sget() from fs/super.c and the prototype in <linux/fs.h>.
> Update the two comments that referred to "sget()" or "sget{_fc}()" to
> just say "sget_fc()".
> 
> This removes ~60 lines of code that only existed to be kept in
> lockstep with sget_fc() on every superblock publish-path change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/btrfs/super.c   |  2 +-
>  fs/super.c         | 71 ++++--------------------------------------------------
>  include/linux/fs.h |  4 ---
>  3 files changed, 6 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b26aa9169e83..636154861d7c 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2052,7 +2052,7 @@ static int btrfs_get_tree_subvol(struct fs_context *fc)
>  	 * then open_ctree will properly initialize the file system specific
>  	 * settings later.  btrfs_init_fs_info initializes the static elements
>  	 * of the fs_info (locks and such) to make cleanup easier if we find a
> -	 * superblock with our given fs_devices later on at sget() time.
> +	 * superblock with our given fs_devices later on at sget_fc() time.
>  	 */
>  	fs_info = kvzalloc_obj(struct btrfs_fs_info);
>  	if (!fs_info)
> diff --git a/fs/super.c b/fs/super.c
> index 378e81efe643..5fe8cea9f8fe 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -328,7 +328,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>  	init_rwsem(&s->s_umount);
>  	lockdep_set_class(&s->s_umount, &type->s_umount_key);
>  	/*
> -	 * sget() can have s_umount recursion.
> +	 * sget_fc() can have s_umount recursion.
>  	 *
>  	 * When it cannot find a suitable sb, it allocates a new
>  	 * one (this one), and tries again to find a suitable old
> @@ -439,7 +439,7 @@ static void kill_super_notify(struct super_block *sb)
>  
>  	/*
>  	 * Remove it from @fs_supers so it isn't found by new
> -	 * sget{_fc}() walkers anymore. Any concurrent mounter still
> +	 * sget_fc() walkers anymore. Any concurrent mounter still
>  	 * managing to grab a temporary reference is guaranteed to
>  	 * already see SB_DYING and will wait until we notify them about
>  	 * SB_DEAD.
> @@ -517,7 +517,7 @@ EXPORT_SYMBOL(deactivate_super);
>   * @sb: superblock to acquire
>   *
>   * Acquire a temporary reference on a superblock and try to trade it for
> - * an active reference. This is used in sget{_fc}() to wait for a
> + * an active reference. This is used in sget_fc() to wait for a
>   * superblock to either become SB_BORN or for it to pass through
>   * sb->kill() and be marked as SB_DEAD.
>   *
> @@ -673,11 +673,11 @@ void generic_shutdown_super(struct super_block *sb)
>  	/*
>  	 * Broadcast to everyone that grabbed a temporary reference to this
>  	 * superblock before we removed it from @fs_supers that the superblock
> -	 * is dying. Every walker of @fs_supers outside of sget{_fc}() will now
> +	 * is dying. Every walker of @fs_supers outside of sget_fc() will now
>  	 * discard this superblock and treat it as dead.
>  	 *
>  	 * We leave the superblock on @fs_supers so it can be found by
> -	 * sget{_fc}() until we passed sb->kill_sb().
> +	 * sget_fc() until we passed sb->kill_sb().
>  	 */
>  	super_wake(sb, SB_DYING);
>  	super_unlock_excl(sb);
> @@ -808,67 +808,6 @@ struct super_block *sget_fc(struct fs_context *fc,
>  }
>  EXPORT_SYMBOL(sget_fc);
>  
> -/**
> - *	sget	-	find or create a superblock
> - *	@type:	  filesystem type superblock should belong to
> - *	@test:	  comparison callback
> - *	@set:	  setup callback
> - *	@flags:	  mount flags
> - *	@data:	  argument to each of them
> - */
> -struct super_block *sget(struct file_system_type *type,
> -			int (*test)(struct super_block *,void *),
> -			int (*set)(struct super_block *,void *),
> -			int flags,
> -			void *data)
> -{
> -	struct user_namespace *user_ns = current_user_ns();
> -	struct super_block *s = NULL;
> -	struct super_block *old;
> -	int err;
> -
> -retry:
> -	spin_lock(&sb_lock);
> -	if (test) {
> -		hlist_for_each_entry(old, &type->fs_supers, s_instances) {
> -			if (!test(old, data))
> -				continue;
> -			if (user_ns != old->s_user_ns) {
> -				spin_unlock(&sb_lock);
> -				destroy_unused_super(s);
> -				return ERR_PTR(-EBUSY);
> -			}
> -			if (!grab_super(old))
> -				goto retry;
> -			destroy_unused_super(s);
> -			return old;
> -		}
> -	}
> -	if (!s) {
> -		spin_unlock(&sb_lock);
> -		s = alloc_super(type, flags, user_ns);
> -		if (!s)
> -			return ERR_PTR(-ENOMEM);
> -		goto retry;
> -	}
> -
> -	err = set(s, data);
> -	if (err) {
> -		spin_unlock(&sb_lock);
> -		destroy_unused_super(s);
> -		return ERR_PTR(err);
> -	}
> -	s->s_type = type;
> -	strscpy(s->s_id, type->name, sizeof(s->s_id));
> -	list_add_tail(&s->s_list, &super_blocks);
> -	hlist_add_head(&s->s_instances, &type->fs_supers);
> -	spin_unlock(&sb_lock);
> -	get_filesystem(type);
> -	shrinker_register(s->s_shrink);
> -	return s;
> -}
> -EXPORT_SYMBOL(sget);
> -
>  void drop_super(struct super_block *sb)
>  {
>  	super_unlock_shared(sb);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 11559c513dfb..6dbe3218dc1e 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2327,10 +2327,6 @@ void free_anon_bdev(dev_t);
>  struct super_block *sget_fc(struct fs_context *fc,
>  			    int (*test)(struct super_block *, struct fs_context *),
>  			    int (*set)(struct super_block *, struct fs_context *));
> -struct super_block *sget(struct file_system_type *type,
> -			int (*test)(struct super_block *,void *),
> -			int (*set)(struct super_block *,void *),
> -			int flags, void *data);
>  struct super_block *sget_dev(struct fs_context *fc, dev_t dev);
>  
>  /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
