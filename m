Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BB23C3C01
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 10:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773917419; cv=none; b=nmjRVBPJNSrXITLNA8BCHUXXT9BaDGhXzedxtuUYbczM/V0HJ56Lh88mDCO4+jgGFzYaUwHJaa+KwfJFqOFaE1piIMbV6nHP+Eh9tUvUpgDUFtm0J+XezW2bXwNCNYAibB4qqpju4haOWMoAhpOz6xEurcqjxlYfWH/B01kNIFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773917419; c=relaxed/simple;
	bh=IZG4ndwqbyTnWLAtCJYTDLhsxJK2ua+GCh+g1Zh88VI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBL8HPWhBOHYnnVoy1gKIYyEpaeBJuJO8dy9ofjQhxDj7O8mhx4vZiVZOFEJ/70/84BTYgr3UzYVdS9qu3bM+PkLFpBjxfGEDVU9qsN4A0EDHxLx16l5RsQ48j9AlefgI3d+/ypTqHlioX+JOIRxNcX//C8bqhx3/GRVi2H2AmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=n6k4qkBh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Jiyk+XXo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=n6k4qkBh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Jiyk+XXo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="n6k4qkBh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jiyk+XXo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="n6k4qkBh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jiyk+XXo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 29E765BFD6;
	Thu, 19 Mar 2026 10:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773917410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDnv8G3yVjDtj/s5l6wUyoVanSVYzV3HIjKNqvcwBQA=;
	b=n6k4qkBhdq4pPNRJpiHcj96vHgwNRqI3a7bSvspQAvuwqjMxnDINJpDqMLIeMX06wTNo8k
	XsvgWaK2TEZtUPmeYoa7VOw6jdSZyFgeQ2Hu5rEa+4a0pLseC0NjTiHRKASm5FtcFa0p20
	IHspEGzMFIluy9z5Yqq//tjuk/Hm26I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773917410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDnv8G3yVjDtj/s5l6wUyoVanSVYzV3HIjKNqvcwBQA=;
	b=Jiyk+XXo7okp1GU8IpXcyEPA1xLp43x/FM9s4zXQah5zXCW2S/062fvF/pdN60LvKQ5+4V
	TMXlvUetyDnTIABA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773917410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDnv8G3yVjDtj/s5l6wUyoVanSVYzV3HIjKNqvcwBQA=;
	b=n6k4qkBhdq4pPNRJpiHcj96vHgwNRqI3a7bSvspQAvuwqjMxnDINJpDqMLIeMX06wTNo8k
	XsvgWaK2TEZtUPmeYoa7VOw6jdSZyFgeQ2Hu5rEa+4a0pLseC0NjTiHRKASm5FtcFa0p20
	IHspEGzMFIluy9z5Yqq//tjuk/Hm26I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773917410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDnv8G3yVjDtj/s5l6wUyoVanSVYzV3HIjKNqvcwBQA=;
	b=Jiyk+XXo7okp1GU8IpXcyEPA1xLp43x/FM9s4zXQah5zXCW2S/062fvF/pdN60LvKQ5+4V
	TMXlvUetyDnTIABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F92A4273B;
	Thu, 19 Mar 2026 10:50:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PzGyB+LUu2l8DQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Mar 2026 10:50:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B6F18A0B32; Thu, 19 Mar 2026 11:50:09 +0100 (CET)
Date: Thu, 19 Mar 2026 11:50:09 +0100
From: Jan Kara <jack@suse.cz>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, 
	Jiayuan Chen <jiayuan.chen@shopee.com>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Ye Bin <yebin10@huawei.com>, 
	Ritesh Harjani <riteshh@linux.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix use-after-free in update_super_work when
 racing with umount
Message-ID: <h4afxbv3sivvopwqfnccd235wywla6bvwk6a5qp5yuwg5pnr2e@s7jlvfxjgxgq>
References: <20260319073651.79209-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319073651.79209-1-jiayuan.chen@linux.dev>
X-Spam-Score: -3.80
X-Spam-Level: 
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
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO

On Thu 19-03-26 15:36:50, Jiayuan Chen wrote:
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

Thanks for the patch! Automated AI review
(https://sashiko.dev/#/patchset/20260319073651.79209-1-jiayuan.chen%40linux.dev)

has noticed two small issues with this:

> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index d2ecc1026c0c..f2505988e010 100644
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
> @@ -610,6 +613,7 @@ int ext4_register_sysfs(struct super_block *sb)
>  	int err;
>  
>  	init_completion(&sbi->s_kobj_unregister);
> +	mutex_init(&sbi->s_error_notify_mutex);
>  	err = kobject_init_and_add(&sbi->s_kobj, &ext4_sb_ktype, ext4_root,
>  				   "%s", sb->s_id);
>  	if (err) {

The initialization of s_error_notify_mutex should happen early in
ext4_fill_super() as ext4_notify_error_sysfs() can be called rather early
before ext4_register_sysfs() is called.

Also we should protect kobject_init_and_add() with s_error_notify_mutex to
handle the case where ext4_notify_error_sysfs() is racing with
ext4_register_sysfs().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
