Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FB147798A
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 13:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790170190; cv=none; b=niEFRuloLeVYughv2xXk9sSdSEbkABurwo4+N5ta+y/IgYvyqmFuqQckR9YF4nk4X7+BZtAYv6K65oDRiiQ0/4dryiiUBQhjmh1TmHZcvg+8wRZWbXVTCjqfMKvSoVhFzlKn105yxCmHjwqSh2Ki6ULKCsyCPBpprt2olwvjhvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790170190; c=relaxed/simple;
	bh=uEow8yuP7huxcupBjaUCxlzkCKH6Gz7RpoLScp87X9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGBiZrJfDBkOSspyKhZip9ISaH9R7PM4HygheYaE5Wk5jhWByaBA2I2lNZQlsLkZYy4xUJ+bVW9d9HTUpAueufBSM0GHn2JTJ9CJgN/KIqaYFICvIiNKN6wQanGzFJyp0iTFx67lgNgi52Z8/WvhHsB56VJ5s5jylxTMpz5jJhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2BJ11S5D; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=24il2hIw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jDpD4afQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Po+kP7c4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2BJ11S5D";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="24il2hIw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jDpD4afQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Po+kP7c4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7A8F11FFC1;
	Wed, 23 Sep 2026 13:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790170182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9abBsfktjbpHPYArOB/vZVpfam57fsZqVljSmsLbP0=;
	b=2BJ11S5DqOz7Zl/RcFHcTi3G/5f7t9QqwYywH+lHvqDQncApe2YWNoO7/lKc23YY7pS9Hu
	QRS0hUjhDsSseJORHjEH2XdVCd98fxcFp2bFUNbk5nnAq40x/a7ut1u88V1U2AIoiqAzQa
	vlo4XwXe7appUYo/wadw14jsWyuNn+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790170182;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9abBsfktjbpHPYArOB/vZVpfam57fsZqVljSmsLbP0=;
	b=24il2hIwB1JwXAiaTwHbXA0oiZ2gIpt00r63bu3Oby6LqzLL82tbgKTYOXnurwezj8BKXz
	zAHdaKTV45f0WLDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jDpD4afQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Po+kP7c4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790170178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9abBsfktjbpHPYArOB/vZVpfam57fsZqVljSmsLbP0=;
	b=jDpD4afQ1XLm17qk2t8snU/7405vqDdgMRnNctCvUoyksLpIuko4keIcoB3LsfX8cBWBch
	azB7Htb4gwKePkISmwOpiBT/N0OmHuU1u3FkvIUqL1ebIr0WvmhIw636jRYBVxTPRymm0l
	C2nX7qChRu4tzOGNjuMoiY65/e4IxqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790170178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9abBsfktjbpHPYArOB/vZVpfam57fsZqVljSmsLbP0=;
	b=Po+kP7c4ysvHLkh42nOF3yuSEqbBZXgSnNPdt92PwGLpPBk03J2yygmxnV1o5mbciUWFSP
	sDpClBQdgMjk3nDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 510E8134E8;
	Wed, 23 Sep 2026 13:29:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uMeNDULUs2rNJwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 23 Sep 2026 13:29:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DF6EBA13D4; Wed, 23 Sep 2026 15:29:37 +0200 (CEST)
Date: Wed, 23 Sep 2026 15:29:37 +0200
From: Jan Kara <jack@suse.cz>
To: Alberto Garcia <berto@igalia.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Message-ID: <wb7tva6sfgioa64dqe3dqi6ql7rrnlfze75d67vujslmtk4w4f@iz2ju3a36t4c>
References: <arO0KE9_Jf8rNRwN@igalia.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arO0KE9_Jf8rNRwN@igalia.com>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: 7A8F11FFC1
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,kernel.org];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email]
X-Spam-Flag: NO

Hi!

On Wed 23-09-26 13:12:40, Alberto Garcia wrote:
> I'd like to report a bug in the ext4 code. I confirm that it happens
> with the latest stable kernel (7.2.7), but mainline (7.3-rc4) does not
> seem to be affected.

Hum, so 709f0f1f1bf5c was merged to 6.19. So did you have a look what has
fixed the problem in 7.3-rc4? Because I'm not aware of any ext4 change that
should fix this.

								Honza

> 
> The problem is very easy to reproduce:
> 
> 1) Enable encryption on an ext4 filesystem with tune2fs -O encrypt
> 2) Create an empty directory and encrypt it (fscrypt encrypt /foo or whatever).
> 3) Write some data to it (head -c head -c 10M /dev/urandom > /foo/file.bin)
> 4) sync
> 
> [   42.962615] BUG: kernel NULL pointer dereference, address: 0000000000000028
> [   42.965440] #PF: supervisor read access in kernel mode
> [   42.967480] #PF: error_code(0x0000) - not-present page
> [   42.969475] PGD 0 P4D 0 
> [   42.970460] Oops: Oops: 0000 [#1] SMP NOPTI
> [   42.972141] CPU: 0 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 7.2.7-vanilla #2 PREEMPT(lazy) 
> [   42.975502] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   42.977650] Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
> [   42.978499] RIP: 0010:ext4_finish_bio+0xf8/0x400
> [   42.979452] Code: 38 00 00 00 00 48 8b 44 24 08 4c 01 f8 48 89 04 24 48 83 7b 18 00 0f 84 d7 02 00 00 41 0f b6 7d 1a 40 84 ff 0f 85 7d 02 00 00 <4c> 8b 63 28 45 31 f6 49 8d 44 24 5c 48 89 c7 48 89 44 24 20 e8 6f
> [   42.982351] RSP: 0018:ffffd0290006bd40 EFLAGS: 00010246
> [   42.983090] RAX: 0000000000001000 RBX: 0000000000000000 RCX: 000fffffc0000201
> [   42.984204] RDX: fffff64a40226f00 RSI: fffff64a400afcc0 RDI: 0000000000000000
> [   42.985203] RBP: 0000000000001000 R08: 0000000000001000 R09: ffffffff8a49cb8a
> [   42.986203] R10: 0000000000001fff R11: ffff8b4f81926200 R12: ffff8b4f8521b540
> [   42.987213] R13: ffff8b4f81927f00 R14: 0000000000000001 R15: 0000000000000000
> [   42.988351] FS:  0000000000000000(0000) GS:ffff8b507105e000(0000) knlGS:0000000000000000
> [   42.989478] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   42.990292] CR2: 0000000000000028 CR3: 000000000bcb9000 CR4: 0000000000350ef0
> [   42.991291] Call Trace:
> [   42.991709]  <TASK>
> [   42.992042]  ext4_release_io_end+0x55/0x120
> [   42.992650]  ext4_end_io_end+0x4c/0xe0
> [   42.993194]  ext4_end_io_rsv_work+0xaa/0x100
> [   42.993807]  process_one_work+0x19e/0x370
> [   42.994382]  worker_thread+0x1a6/0x310
> [   42.994925]  ? __pfx_worker_thread+0x10/0x10
> [   42.995806]  kthread+0xe4/0x120
> [   42.996313]  ? __pfx_kthread+0x10/0x10
> [   42.996856]  ret_from_fork+0x2b1/0x340
> [   42.997397]  ? __pfx_kthread+0x10/0x10
> [   42.997941]  ret_from_fork_asm+0x1a/0x30
> [   42.998505]  </TASK>
> 
> The problem does not happen if you unmount the filesystem after
> setting the encryption feature, and then mount it again.
> 
> The cause seems to be that encryption does not support large folios,
> but after commit 709f0f1f1bf5c ("ext4: add checks for large folio
> incompatibilities when BS > PS") this is only checked at mount time,
> so enabling encryption on a mounted fs bypasses this check.
> 
> This solves the crash for me, but I suppose that it also needs an
> additional check to decide whether encryption can be enabled on a
> filesystem (i.e. if sb->s_blocksize > PAGE_SIZE).
> 
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5287,7 +5287,8 @@ void ext4_set_inode_mapping_order(struct inode *inode)
>  	if (!min_order && !S_ISREG(inode->i_mode))
>  		return;
>  
> -	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) ||
> +	    ext4_test_inode_flag(inode, EXT4_INODE_ENCRYPT))
>  		max_order = min_order;
>  
>  	mapping_set_folio_order_range(inode->i_mapping, min_order, max_order);
> 
> Regards,
> 
> Berto
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
