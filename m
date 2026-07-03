Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D0823815B
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 14:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783087382; cv=none; b=iU1KtWw+Xcg8o6lKpXwSUl6khUxqC9lsbKABEHo0+Pf1wwtA9GGAHTk4RHNMb+cSYQBQN/1CaqvJwNlOiS3rv6ZykEzL/N6BXwsAZy2WhtDBfG98PxsGh4OiHq7mYM7K+diZlTc9BcTsd2V4770Ldqie/dTbXOlVUqHJ6uLSt+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783087382; c=relaxed/simple;
	bh=r+1g86x5w1iz7AjRAKcvSu5Bt6QNB714Yq6uNdhjKmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlDoyB7t4zQaRzhZ/SFJP8DXV3Z13QzavDSxAJA5WYaK3R9x85m25ug5K8un4bSNkzkKsH2kQRFX79NqB77/2cBsRbhq84N3cRMuA3cFkJnKh2D5rIiZspao7YEZM1eLyNgJbvJ/CYk9JQoAapT+U9amhuP7LWfI3YQY2PAN9AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QEEyDsky; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vKQIxjvC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=22Czi7Oy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=onIX2XSn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QEEyDsky";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vKQIxjvC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="22Czi7Oy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="onIX2XSn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A8C97493D;
	Fri,  3 Jul 2026 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783087379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QmZwDvrRQTCnaJSp+eE3NA6vo/hUHvooFMtbTe+XW2U=;
	b=QEEyDskyHAhoPEe94NhP4sSKyqGLqb4IffL8urC3C6TMKu6RXLSHjsXAA/6CEbhz9q+McR
	45MozlkHv4rH11q8EhSEe+jctSg3D0j47ZZXKo+EpySVz1pe2WwMKB3xmMa8VAgvD+tyIf
	/dvmdqNn6Z2Pd3K2gJArfG0xuK/ba+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783087379;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QmZwDvrRQTCnaJSp+eE3NA6vo/hUHvooFMtbTe+XW2U=;
	b=vKQIxjvCMQD7btVXTLIITGCfefComxh/WKV0uEi2TDgVSTlBChK1FJnzkpemgIAfL3UHwK
	DDA//g3p0oIP0sBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=22Czi7Oy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=onIX2XSn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783087378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QmZwDvrRQTCnaJSp+eE3NA6vo/hUHvooFMtbTe+XW2U=;
	b=22Czi7Oy2ZSDZx0BVXGKjEV7faq3PcMU6pZK+KmMEnAviXp/xD93enV+x4fot2Qgt7siTR
	AD9PxuDxvhDHy+/87WCfq2ZQsifQJ5Z3xJmeQD6KUdUPgYFp0hP1x2ewh4+uE+xolU96IL
	DhQhaizsNZB3IxD+u98dDixoW+9lfOw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783087378;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QmZwDvrRQTCnaJSp+eE3NA6vo/hUHvooFMtbTe+XW2U=;
	b=onIX2XSn2kDueODlAlfEHM3yQeJUTV34nWNx6TWAftDZWMKyVSGoO1ULE7IBhZnshpzeiA
	LTsoFH+93fho3IBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08652779AA;
	Fri,  3 Jul 2026 14:02:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oLGTARLBR2pMAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 03 Jul 2026 14:02:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8B8FAA12D4; Fri, 03 Jul 2026 16:02:53 +0200 (CEST)
Date: Fri, 3 Jul 2026 16:02:53 +0200
From: Jan Kara <jack@suse.cz>
To: yun.zhou@windriver.com
Cc: adilger.kernel@dilger.ca, brauner@kernel.org, jack@suse.cz, 
	libaokun@linux.alibaba.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com, tytso@mit.edu, 
	viro@zeniv.linux.org.uk, yi.zhang@huawei.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, syzbot ci <syzbot+ciadd810ddf4701c1b@syzkaller.appspotmail.com>
Subject: Re: [syzbot ci] Re: ext4: deferred iput framework for EA inodes
Message-ID: <j6ftvy7a3w7js4whqps3fipbah452xhro37kxvkruoeobtlonb@zrp2pwoif3pc>
References: <20260702152225.4071746-1-yun.zhou@windriver.com>
 <6a46ecbd.52c20a74.1f8b39.000b.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a46ecbd.52c20a74.1f8b39.000b.GAE@google.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1A8C97493D
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[ciadd810ddf4701c1b];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[dilger.ca,kernel.org,suse.cz,linux.alibaba.com,vger.kernel.org,linux.ibm.com,gmail.com,mit.edu,zeniv.linux.org.uk,huawei.com,lists.linux.dev,googlegroups.com,syzkaller.appspotmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[googlegroups.com:email,syzbot.org:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,googlesource.com:url,suse.com:email,appspotmail.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Thu 02-07-26 15:57:01, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v13] ext4: deferred iput framework for EA inodes
> https://lore.kernel.org/all/20260702152225.4071746-1-yun.zhou@windriver.com
> * [PATCH v13 1/4] fs: add iput_if_not_last() helper
> * [PATCH v13 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
> * [PATCH v13 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
> * [PATCH v13 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()
> 
> and found the following issue:
> WARNING in ext4_journal_check_start

Good catch. We need to flush the pending work with iputs also in
ext4_sync_fs() which should also take care of this race with remount
read-only (and the same issue with filesystem freezing etc.).

								Honza

> 
> Full report is available here:
> https://ci.syzbot.org/series/ce304d7b-7f32-44b5-bf6f-e579abb42a5c
> 
> ***
> 
> WARNING in ext4_journal_check_start
> 
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> base:      4a50a141f05a8d1737661b19ee22ff8455b94409
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/e5413370-cf09-4540-b9d3-7d280f314ae0/config
> syz repro: https://ci.syzbot.org/findings/e7cd69b7-8bb9-4554-bd84-b5ebcd7a8089/syz_repro
> 
> ------------[ cut here ]------------
> sb_rdonly(sb)
> WARNING: fs/ext4/ext4_jbd2.c:75 at ext4_journal_check_start+0x24f/0x2b0 fs/ext4/ext4_jbd2.c:75, CPU#0: kworker/0:5/5860
> Modules linked in:
> CPU: 0 UID: 0 PID: 5860 Comm: kworker/0:5 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Workqueue: events ext4_ea_inode_work
> RIP: 0010:ext4_journal_check_start+0x24f/0x2b0 fs/ext4/ext4_jbd2.c:75
> Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 06 75 42 ff 41 bf fb ff ff ff eb e0 e8 f9 74 42 ff eb d3 e8 f2 74 42 ff 90 <0f> 0b 90 eb c8 e8 e7 74 42 ff 90 0f 0b 90 43 80 7c 25 00 00 0f 85
> RSP: 0018:ffffc900036bf888 EFLAGS: 00010293
> RAX: ffffffff8283ecce RBX: ffff888170078000 RCX: ffff888107390000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 00000000000000ef R08: ffff8881bb53440f R09: 1ffff110376a6881
> R10: dffffc0000000000 R11: ffffed10376a6882 R12: dffffc0000000000
> R13: 1ffff1102e00f0cd R14: ffff888170078668 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88818dc20000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055557b325a28 CR3: 0000000114bfe000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __ext4_journal_start_sb+0x147/0x5d0 fs/ext4/ext4_jbd2.c:107
>  __ext4_journal_start fs/ext4/ext4_jbd2.h:242 [inline]
>  ext4_evict_inode+0x7cb/0xf70 fs/ext4/inode.c:238
>  evict+0x624/0xb50 fs/inode.c:825
>  ext4_ea_inode_work+0x5c/0x90 fs/ext4/xattr.c:2974
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> 
> 
> ***
> 
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
> 
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
> 
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
> 
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
