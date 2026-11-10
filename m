Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317757;
	b=VDHR8KZV9AljekRl1Wt44ZUOpOm5I/H+ohX3WMCgFX7RHraTgsPYNpQyO2ypcP6bIWaH
	 +qCiY8REC5HN6sQ+mlGP6zRuXsFbkhmB285MeQpHMmmV2IUm3/3EI8uT6wh/Aj8r7aCSg
	 196d2sv+ROTf6/wtpwfuytR9oEJQEdheytTuP0KFArQVLIEjJoTG5Kua6aOvc3tYC2TAF
	 GDR+qeCA3subwxkpm0YtInT6ztsLGNaoo345xaP0Xc7+zjE19pVEUdS5BMByNOdhFg05L
	 o4hdPcf214ygkbeP8klPjmc/+bwyMwnTWoWU6LxLhtIOq00x8GzK/zyyWyAFKY2lX9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317757;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=WdgTo0DmAZriHLdP6ECWKUPVNHILRnpqF66x/M+j/kI=;
	b=Wyo+eazXEvvALKqocfRyL0YeHHH7AtBZPTKV+xJDWal309F4Vegrw5l3ffNlCKhZRu1g
	 fKZC3g9Y2MC/5Iw+X4dfdg5LQ/2+ytRGCfmli/Nd8tKbn3hpns92HSDVE9DcCviRdjy2D
	 OjxdkXLeE2AKt80o95dJJyQRNbBO0RiXfTVdz32O3yJxdVM+3yN6xHE2QQBcnydrYSd0o
	 GnKR8LZfTUyFP9le53hhVvKN9zIWwuPIeYJPpxjLZwqaac/b46LbbIrkx5jMiImYzd6QW
	 ZOHilm90NjAFZ6/48s35yNpKoAer/Hv+s5QnqVvgeuz+Q6uEsTT5vznOoUCrmtbpK3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zG+gyFn+;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JPvTLr2r;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=LdDcPfwz;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Cv6FTP4r;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D7A606A325;
	Tue, 10 Nov 2026 13:35:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11D7A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zG+gyFn+;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JPvTLr2r;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=LdDcPfwz;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Cv6FTP4r
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BFC441F7DD;
	Tue, 10 Nov 2026 13:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794317755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WdgTo0DmAZriHLdP6ECWKUPVNHILRnpqF66x/M+j/kI=;
	b=zG+gyFn+K1cX+7+w1/vnlXJkz4dHDsSo735k9IXjBh+26NUQeyxYH7mjBdrAf/MfAERyB7
	5xviDE4Cm7PTdYWqmEJURfIoU2tn+fitQhaqBSbzxs07A75tCNBWb1xql8mLkWzPAPkfvY
	JFkcnTycpfPVxi64n9Icra9o4d8Y1s4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794317755;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WdgTo0DmAZriHLdP6ECWKUPVNHILRnpqF66x/M+j/kI=;
	b=JPvTLr2rkhrwyLS85l75jVU3oD4c6/Wx1s6uevvpWVEhRsThq14lJ9oCc/XdBPZ8Wg4tT5
	a22u+5Lv2StfZhDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LdDcPfwz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Cv6FTP4r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794317754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WdgTo0DmAZriHLdP6ECWKUPVNHILRnpqF66x/M+j/kI=;
	b=LdDcPfwzcKU/WX7WGCGnRpJDeQ3RVVFt4feUJBu6OYiNQDmc7NlIIBYTBiQnbPTE1wkOqh
	Dt1Ml6C2F+RW2qs4HD7ENWB4GQup28c1obqiO6PDIFCHsEPV2E/okGm1bRPkPGmc+kCRFc
	IY1UN6/EfEhGLXpNb9hY9tgr/TctrC8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794317754;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WdgTo0DmAZriHLdP6ECWKUPVNHILRnpqF66x/M+j/kI=;
	b=Cv6FTP4r+KSAat4hvQZnO2J+R4d25/ixD6AkMzZbTY8nXacX205WX9IVijlwr5Y+TSGy89
	iJnDYjDo988xCxCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9411E13479;
	Tue, 10 Nov 2026 13:35:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AaTHHbod82p2bAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 13:35:54 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 2E15922510; Tue, 10 Nov 2026 14:35:54 +0100 (CET)
Date: Tue, 10 Nov 2026 14:35:54 +0100
From: Jan Kara <jack@suse.cz>
To: diasyzhangqing@gmail.com
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, Qing Zhang <diasyzhang@tencent.com>
Subject: Re: [PATCH] ext4: make concurrent DEFAULT shutdown waits killable
Message-ID: <glup36pqwuh2wsxjozp3x4kne2spsud65ftlw744p72hmh54mx@hi2s256gr3iy>
References: <6af1e75f.3e87765f.91969.0010.GAE@google.com>
 <20261110132118.11265-1-diasyzhangqing@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110132118.11265-1-diasyzhangqing@gmail.com>
X-Rspamd-Queue-Id: BFC441F7DD
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
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
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[d4ecb9a1e5b3dcf8baec];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,vger.kernel.org,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,syzkaller.appspotmail.com,tencent.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.com:email,tencent.com:email,appspotmail.com:email,syzkaller.appspot.com:url]
X-Spam-Score: -11.51

On Tue 10-11-26 21:21:18, diasyzhangqing@gmail.com wrote:
> From: Qing Zhang <diasyzhang@tencent.com>
> 
> Concurrent DEFAULT shutdown callers can all pass the shutdown flag
> check before the first caller finishes bdev_freeze().  They then wait
> uninterruptibly on bd_fsfreeze_mutex and may perform redundant
> freeze/thaw operations, triggering hung-task reports if the initial
> freeze takes long enough.
> 
> Serialize DEFAULT shutdown attempts with a per-superblock mutex
> acquired killably.  Re-check the shutdown flag after acquiring it to
> skip the freeze after a successful attempt, or retry if the previous
> attempt failed.
> 
> Leave LOGFLUSH and NOLOGFLUSH unchanged.  The ->shutdown callback uses
> NOLOGFLUSH with s_umount held, so it must not acquire a mutex held
> across a freeze.  This does not shorten the initial freeze or prevent
> hung-task reports for the active freezer and other freeze-blocked
> tasks.
> 
> Fixes: 783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
> Reported-by: syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d4ecb9a1e5b3dcf8baec
> Signed-off-by: Qing Zhang <diasyzhang@tencent.com>

Err, no. This is really syzkaller self-inflicted damage we aren't going to
work around. If anything you could make the wait on bd_fsfreeze_mutex
in bdev_freeze() killable. That will actually be a sensible change and
should address syzbot warning as well.

								Honza

> ---
> 
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>  fs/ext4/ext4.h  |  1 +
>  fs/ext4/ioctl.c | 14 +++++++++++++-
>  fs/ext4/super.c |  1 +
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index f38fec3167fb..c4e44e3d58cc 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1647,6 +1647,7 @@ struct ext4_sb_info {
>  	/* Journaling */
>  	struct journal_s *s_journal;
>  	unsigned long s_ext4_flags;		/* Ext4 superblock flags */
> +	struct mutex s_shutdown_lock;	/* Serializes DEFAULT shutdown requests */
>  	struct mutex s_orphan_lock;	/* Protects on disk list changes */
>  	struct list_head s_orphan;	/* List of orphaned inodes in on disk
>  					   list */
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index e8e579498c99..3019b16320a0 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -818,16 +818,28 @@ int ext4_force_shutdown(struct super_block *sb, u32 flags)
>  	if (ext4_forced_shutdown(sb))
>  		return 0;
>  
> +	if (flags == EXT4_GOING_FLAGS_DEFAULT) {
> +		if (mutex_lock_killable(&sbi->s_shutdown_lock))
> +			return -EINTR;
> +		if (ext4_forced_shutdown(sb)) {
> +			mutex_unlock(&sbi->s_shutdown_lock);
> +			return 0;
> +		}
> +	}
> +
>  	ext4_msg(sb, KERN_ALERT, "shut down requested (%d)", flags);
>  	trace_ext4_shutdown(sb, flags);
>  
>  	switch (flags) {
>  	case EXT4_GOING_FLAGS_DEFAULT:
>  		ret = bdev_freeze(sb->s_bdev);
> -		if (ret)
> +		if (ret) {
> +			mutex_unlock(&sbi->s_shutdown_lock);
>  			return ret;
> +		}
>  		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
>  		bdev_thaw(sb->s_bdev);
> +		mutex_unlock(&sbi->s_shutdown_lock);
>  		break;
>  	case EXT4_GOING_FLAGS_LOGFLUSH:
>  		/*
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9cae52471dee..a1d4fc5c0a68 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5547,6 +5547,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  
>  	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
>  	mutex_init(&sbi->s_orphan_lock);
> +	mutex_init(&sbi->s_shutdown_lock);
>  
>  	spin_lock_init(&sbi->s_bdev_wb_lock);
>  
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
