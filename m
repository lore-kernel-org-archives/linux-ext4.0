Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5622472AA
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 16:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773852969; cv=none; b=CRq3iGyUj1b7hLKeH+5X4ejywy/lu4ac+DF9JZVfMxEJFYTV7f/dB98T9iVg3j3mUERw5M+BSj0xMEW+OB71B9WhvyYgAPveJGXamTyoLQ/jKr/kg4BIy8MKs81taNrGWx69CVJaCTXDKOWysuqjjJ5B972P9YGt0u0R9818Eyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773852969; c=relaxed/simple;
	bh=Zm+9h6PZKL6TY6Iuf4KW53YDv7oRAMQZtM8Q7ZsVyTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/tVgXWOcFW10PdPAzKAAL8UIWenlE6dKcURb9KOPjdwaBk1qQlRmEXee69SIUs3q31b42fOgkFXgjBZAX8q8K4TlfJpIsVwKXE0rBa1ugNYGJ+5Mz0jsfdmQtMBZipDw2GJlBiYkVpQGPqnPX2L/xKCGmackomizeZy/jcMPhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YxZJNMqv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Pc0xH9YY; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YxZJNMqv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Pc0xH9YY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YxZJNMqv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Pc0xH9YY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YxZJNMqv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Pc0xH9YY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1DA2C4D3F5;
	Wed, 18 Mar 2026 16:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773852966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjuPkVwHKIBoYrFOm9to6T1QaaqVDwDVlmIxosyXviI=;
	b=YxZJNMqvHiZraSzAIyU4b5dLKOdS8dLikogOvog70uAqpVE+GNSQFYM/vp2M3gUEDq0dH/
	zKJtxUS4sYadjK2O/PV1/R+WjF23RFF98o6HoPDAgKukqdKWz4bV4JTurxV7j2ShrYElJG
	1UI4jXQP3MuduKIUQGDjgEUOnLXuJso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773852966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjuPkVwHKIBoYrFOm9to6T1QaaqVDwDVlmIxosyXviI=;
	b=Pc0xH9YY8K5u2Ywh63E/2rBqnVNH8FqH+F8o7rm3ourhSgad3AGvXQ9wFpmzNCYWIX/9MF
	BL/Q6Jw1xmjsUCCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YxZJNMqv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pc0xH9YY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773852966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjuPkVwHKIBoYrFOm9to6T1QaaqVDwDVlmIxosyXviI=;
	b=YxZJNMqvHiZraSzAIyU4b5dLKOdS8dLikogOvog70uAqpVE+GNSQFYM/vp2M3gUEDq0dH/
	zKJtxUS4sYadjK2O/PV1/R+WjF23RFF98o6HoPDAgKukqdKWz4bV4JTurxV7j2ShrYElJG
	1UI4jXQP3MuduKIUQGDjgEUOnLXuJso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773852966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjuPkVwHKIBoYrFOm9to6T1QaaqVDwDVlmIxosyXviI=;
	b=Pc0xH9YY8K5u2Ywh63E/2rBqnVNH8FqH+F8o7rm3ourhSgad3AGvXQ9wFpmzNCYWIX/9MF
	BL/Q6Jw1xmjsUCCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0FFFE4273B;
	Wed, 18 Mar 2026 16:56:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CbjhAybZumkefwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Mar 2026 16:56:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D0604A0AFF; Wed, 18 Mar 2026 17:56:05 +0100 (CET)
Date: Wed, 18 Mar 2026 17:56:05 +0100
From: Jan Kara <jack@suse.cz>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Ritesh Harjani <riteshh@linux.ibm.com>, Ye Bin <yebin10@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] ext4: fix use-after-free in update_super_work when
 racing with umount
Message-ID: <ggk7pumqoedryggnneuwyfjsv5jrjsfn3pcbghaqfjhpyu44gm@szbrjbv7spfr>
References: <20260313065206.152645-1-jiayuan.chen@linux.dev>
 <jn23562fj73siqgtlzqknce34eqiazitghu55pyvczustuey32@zhx3wpu5eciy>
 <4a102211-2039-46ac-bc54-81f1c5eda42a@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a102211-2039-46ac-bc54-81f1c5eda42a@linux.dev>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,linux.dev:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: 1DA2C4D3F5
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Wed 18-03-26 13:04:03, Jiayuan Chen wrote:
> 
> On 3/17/26 7:38 PM, Jan Kara wrote:
> > On Fri 13-03-26 14:52:04, Jiayuan Chen wrote:
> > > Commit b98535d09179 ("ext4: fix bug_on in start_this_handle during umount filesystem")
> > > moved ext4_unregister_sysfs() before flushing s_sb_upd_work to prevent new
> > > error work from being queued via /proc/fs/ext4/xx/mb_groups reads during
> > > unmount. However, this introduced a use-after-free because
> > > update_super_work calls ext4_notify_error_sysfs() -> sysfs_notify() which
> > > accesses the kobject's kernfs_node after it has been freed:
> > > 
> > >    update_super_work                ext4_put_super
> > >    -----------------                --------------
> > >                                     ext4_unregister_sysfs(sb)
> > >                                       kobject_del(&sbi->s_kobj)
> > >                                         __kobject_del()
> > >                                           sysfs_remove_dir()
> > >                                             kobj->sd = NULL
> > >                                           sysfs_put(sd)
> > >                                             kernfs_put()  // RCU free
> > >    ext4_notify_error_sysfs(sbi)
> > >      sysfs_notify(&sbi->s_kobj)
> > >        kn = kobj->sd              // stale pointer
> > >        kernfs_get(kn)             // UAF on freed kernfs_node
> > >                                     ext4_journal_destroy()
> > >                                       flush_work(&sbi->s_sb_upd_work)
> > > 
> > > The original blamed commit needed procfs removal before the work
> > > flush to prevent /proc/fs/ext4/xx/mb_groups reads from queuing new error
> > > work. But it bundled procfs removal and kobject_del together in
> > > ext4_unregister_sysfs(), causing the sysfs kobject to be torn down too
> > > early.
> > > 
> > > The correct teardown ordering has three constraints:
> > > 
> > >    1. procfs removal must happen before flushing s_sb_upd_work, to prevent
> > >       /proc reads from queuing new error work that would BUG_ON.
> > >    2. sysfs kobject removal must happen after flushing s_sb_upd_work, since
> > >       the work calls sysfs_notify() which accesses the kernfs_node.
> > >    3. sysfs kobject removal must happen before jbd2_journal_destroy(), since
> > >       userspace could read the journal_task sysfs attribute and dereference
> > >       j_task after the journal thread has been killed.
> > > 
> > > Fix this by:
> > >    - Adding ext4_sb_release_proc() to remove procfs entries early.
> > >    - Splitting ext4_journal_destroy() into ext4_journal_stop_work() and
> > >      ext4_journal_finish(), so that ext4_unregister_sysfs() can be placed
> > >      between them to satisfy all three ordering constraints.
> > > 
> > > Fixes: b98535d09179 ("ext4: fix bug_on in start_this_handle during umount filesystem")
> > > Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> > > Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> > Thanks for the analysis and the patch! I fully agree with your analysis but
> > I think your solution shows that the teardown sequence is just too subtle
> > (too many different dependencies). Ideally, we'd instead modify
> > ext4_notify_error_sysfs() to detect sysfs is already torn down by
> > ext4_unregister_sysfs() and do nothing. We can check
> > sbi->s_kobj.state_in_sysfs for that. The only trouble with this is that
> > sysfs_notify() could still race with kobject_del() so we also need some
> > locking in ext4_unregister_sysfs() locking out parallel
> > ext4_notify_error_sysfs() and we probably need to introduce a separate
> > mutex for that. What do you think?
> > 
> > 								Honza
> > 
> 
> 
> Hi Honza,
> 
> Thanks for the suggestion !
> 
> I tried the approach you described — having ext4_notify_error_sysfs() check
> s_kobj.state_in_sysfs and using a
> dedicated mutex to serialize against kobject_del() in
> ext4_unregister_sysfs(). It is indeed much simpler than my original
> approach of reordering the teardown sequence.

Yes, the patch looks good to me. Please create a proper patch submission
with changelog etc. and I can give you my reviewed-by tag :).

								Honza
 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b76966dc06c0..c012e85d2515 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1574,6 +1574,7 @@ struct ext4_sb_info {
>         struct proc_dir_entry *s_proc;
>         struct kobject s_kobj;
>         struct completion s_kobj_unregister;
> +       struct mutex s_error_notify_mutex; /* protects sysfs_notify vs
> kobject_del */
>         struct super_block *s_sb;
>         struct buffer_head *s_mmp_bh;
> 
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index d2ecc1026c0c..f2505988e010 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -597,7 +597,10 @@ static const struct kobj_type ext4_feat_ktype = {
> 
>  void ext4_notify_error_sysfs(struct ext4_sb_info *sbi)
>  {
> -       sysfs_notify(&sbi->s_kobj, NULL, "errors_count");
> +       mutex_lock(&sbi->s_error_notify_mutex);
> +       if (sbi->s_kobj.state_in_sysfs)
> +               sysfs_notify(&sbi->s_kobj, NULL, "errors_count");
> +       mutex_unlock(&sbi->s_error_notify_mutex);
>  }
> 
>  static struct kobject *ext4_root;
> @@ -610,6 +613,7 @@ int ext4_register_sysfs(struct super_block *sb)
>         int err;
> 
>         init_completion(&sbi->s_kobj_unregister);
> +       mutex_init(&sbi->s_error_notify_mutex);
>         err = kobject_init_and_add(&sbi->s_kobj, &ext4_sb_ktype, ext4_root,
>                                    "%s", sb->s_id);
>         if (err) {
> @@ -644,7 +648,10 @@ void ext4_unregister_sysfs(struct super_block *sb)
> 
>         if (sbi->s_proc)
>                 remove_proc_subtree(sb->s_id, ext4_proc_root);
> +
> +       mutex_lock(&sbi->s_error_notify_mutex);
>         kobject_del(&sbi->s_kobj);
> +       mutex_unlock(&sbi->s_error_notify_mutex);
>  }
> 
>  int __init ext4_init_sysfs(void)
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
