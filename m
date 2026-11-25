Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795603385;
	b=EHz+ZREkrEmDtxovg7o4n31YsG1+9rY8k3wfQE3vXf7CSjy2FrKABnaafkNX0SK7FQoI
	 dbLzD1isfdfDTFUgdIR6ZUa6zkm2ukO0a+gqs7y/LEHT67H0ZyzZpqXqWyyn52fzlxZVP
	 GoCKalIKjW3i/UsTz9f4VoTNNQnJRNrD25SdNfgAwowGCkaooy819q7+ErWNBOnm3C73T
	 1uJkGq0lBYd5Ed9DbQyXU8A58nei6VT9n77qBCUxZCwyaeWoNCXeMJ8iyNFoqQ9s0aDMi
	 cOCiLA/0ioMrgXvEdxoGfbpAhYV4TVjl9YnAAzcAA14khORCbAOCLHxXfTqAPkAXqRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795603385;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=QY3MdAHHrsofuOk2K0ngXRqyljIkED8C7QX6KAQBJV4=;
	b=ZgfMjOztQHTjn+uUHuencrT10xvp5++Jp5J47lAdeSpePoYS7/kbq/10ZeNm5ZHvHqau
	 0UtKoVCUoM9D+TwK74i2UWxNug9CFgQUIBbWGW7QbY+HP9MlkLlcQKMYD1abVCixenWz8
	 HVSc58dSL7YSJ9PoZUa4JXTSj3LbE6s02604RAbS2AHNq3ar+4C7gPenjggM/tp6YGsT8
	 7lUJ4xf0C56FKJY96aPt78OaQq7if3J1pWz9dwz/vX5CkD22HV4b7+HYAaLgk3lvxb70t
	 iBrxQrZQki2NzAHAcHy3px/JmO9hCxoOcKc2HtG5gJccygRCbVUuLOeokJDlSp//0sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=pDilopwQ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wkiFUOOX;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=WiVz8Khn;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=NiTNrKGo;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CAE606A31E;
	Wed, 25 Nov 2026 10:43:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4CAE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=pDilopwQ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wkiFUOOX;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=WiVz8Khn;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=NiTNrKGo
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 961231F444;
	Wed, 25 Nov 2026 10:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795603382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QY3MdAHHrsofuOk2K0ngXRqyljIkED8C7QX6KAQBJV4=;
	b=pDilopwQIkj3eCC1/MFPIDUGgNUVuno9UzXB9u1vZPlmGKr2AbBQrVjc40ksXme3A3dLHG
	ocoe5bgdr+sdLxne6mFWnum70r3dyKyQ4g9Sj1YXRHxOe8F9gLfJ56g91QiADNDj9auKJP
	ZIxxtUJhIW0+umsevqovMZZvJpFIR3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795603382;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QY3MdAHHrsofuOk2K0ngXRqyljIkED8C7QX6KAQBJV4=;
	b=wkiFUOOXspxHTg0PlmaIs/j+jBhnFRKudJh+p7Lcvj+3VwK+dQsLePK+nwfkpVyvS0Kuvr
	L0TKWU9mWF3oRTDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WiVz8Khn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NiTNrKGo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795603381; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QY3MdAHHrsofuOk2K0ngXRqyljIkED8C7QX6KAQBJV4=;
	b=WiVz8Khnc2nonV4Bu3ka1X5+dr+Njev0BksyTC0psFuU02OJ8Gjn5TJxblQPHHqTR25WJ1
	IOh406qbMN01kn6cfviRBeRvRNFVMDCb70tj4wHctF7yk9+LDHcLdbpjCCgVXvJq9zKvKH
	zazAB2n+VUpKPEiHkxRav/02wVa1boU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795603381;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QY3MdAHHrsofuOk2K0ngXRqyljIkED8C7QX6KAQBJV4=;
	b=NiTNrKGo2A5V9mQPqSl9ZoSBw55FWDyI6CijO7VUm8KJrtKNTknJcsX9ApdXsAuFLeF495
	gNCcNc0LAiyfmYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6735F134CA;
	Wed, 25 Nov 2026 10:43:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JzxkEbW7BmtFdgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Nov 2026 10:43:01 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E784327C0B; Wed, 25 Nov 2026 11:42:56 +0100 (CET)
Date: Wed, 25 Nov 2026 11:42:56 +0100
From: Jan Kara <jack@suse.cz>
To: syzbot <syzbot+a04f55598145a622ba5e@syzkaller.appspotmail.com>
Cc: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, tytso@mit.edu, 
	wangjianchao@kuaishou.com, yi.zhang@huawei.com
Subject: Re: [syzbot] [ext4?] KASAN: slab-use-after-free Read in
 ext4_discard_work
Message-ID: <4nt26i3jje7fue5n6xanadhbf6ggc5g4ri6qetc7ypas5cgs6e@uqf7mqb2cgct>
References: <6b062cae.3f72aad1.34e135.0015.GAE@google.com>
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
In-Reply-To: <6b062cae.3f72aad1.34e135.0015.GAE@google.com>
X-Spamd-Result: default: False [-10.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=d44b06612b68f56];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,googlegroups.com:email];
	TAGGED_RCPT(0.00)[a04f55598145a622ba5e];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[dilger.ca,suse.cz,linux.alibaba.com,vger.kernel.org,linux.ibm.com,gmail.com,googlegroups.com,mit.edu,kuaishou.com,huawei.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -10.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 961231F444

On Tue 24-11-26 16:32:46, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8d7fe9885c62 Merge tag 'hid-for-linus-2026112301' of git:/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12db47be580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d44b06612b68f56
> dashboard link: https://syzkaller.appspot.com/bug?extid=a04f55598145a622ba5e
> compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7d5b5d17d504/disk-8d7fe988.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c43ff23e1a60/vmlinux-8d7fe988.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/4d8003ea794d/bzImage-8d7fe988.xz
> 
> The issue was bisected by AI to:
> 
> commit 55cdd0af2bc5ffc92a2deb745627755aecd5db33
> Author: Wang Jianchao <wangjianchao@kuaishou.com>
> Date:   Sat Jul 24 07:41:23 2021 +0000
> 
>     ext4: get discard out of jbd2 commit kthread contex
> 
> AI reasoning:   https://syzkaller.appspot.com/ai_job?id=40c391cc-8aa0-42ec-9936-2fef007242dc
> 
> AI-generated root cause summary:
> During a failed ext4 mount in `__ext4_fill_super()`, the error-cleanup path
> calls `ext4_mb_release()` (at `failed_mount6`) before calling
> `ext4_journal_destroy()` (at `failed_mount_wq`). Because
> `sbi->s_journal->j_commit_callback` (`ext4_journal_commit_callback`) remains
> active until `ext4_journal_destroy()` finishes, a transaction commit triggered
> during mount error handling or journal teardown invokes
> `ext4_process_freed_data()`, which queues `&sbi->s_discard_work` when the
> `DISCARD` mount option is set (even if `freed_data_list` is empty). Since
> `ext4_mb_release()` has already run and flushed `s_discard_work` earlier in the
> cleanup path, `s_discard_work` is never flushed again before `ext4_fill_super()`
> frees `sbi` via `ext4_free_sbi()`, resulting in a slab use-after-free when
> `ext4_discard_work()` subsequently reads `sbi->s_sb`.

Should be fixed by [1] in Ted's tree.

								Honza

[1] https://lore.kernel.org/all/20260909113703.698544-1-fanwu01@zju.edu.cn

> 
> full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=a04f55598145a622ba5e
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a04f55598145a622ba5e@syzkaller.appspotmail.com
> 
> The cause commit was identified by AI and may be wrong.
> If you agree with it, please also add:
> Fixes: 55cdd0af2bc5 ("ext4: get discard out of jbd2 commit kthread contex")
> 
> ==================================================================
> BUG: KASAN: slab-use-after-free in ext4_discard_work+0xa1/0x7f0 fs/ext4/mballoc.c:3645
> Read of size 8 at addr ffff88807bfec3f0 by task kworker/u8:12/1466
> 
> CPU: 1 UID: 0 PID: 1466 Comm: kworker/u8:12 Tainted: G             L      syzkaller #0 PREEMPT(full) 
> Tainted: [L]=SOFTLOCKUP
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
> Workqueue: events_unbound ext4_discard_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_discard_work+0xa1/0x7f0 fs/ext4/mballoc.c:3645
>  process_one_work kernel/workqueue.c:3495 [inline]
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> 
> Allocated by task 12861:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3f/0x90 mm/kasan/common.c:79
>  poison_kmalloc_redzone mm/kasan/common.c:412 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:429
>  kasan_kmalloc include/linux/kasan.h:267 [inline]
>  __kmalloc_cache_noprof+0x31c/0x600 mm/slub.c:5680
>  _kmalloc_noprof include/linux/slab.h:991 [inline]
>  _kzalloc_noprof include/linux/slab.h:1312 [inline]
>  ext4_alloc_sbi fs/ext4/super.c:4424 [inline]
>  ext4_fill_super+0x118/0x6630 fs/ext4/super.c:5886
>  get_tree_bdev_flags+0x436/0x500 fs/super.c:1821
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1881
>  fc_mount fs/namespace.c:1282 [inline]
>  do_new_mount_fc fs/namespace.c:3910 [inline]
>  do_new_mount+0x325/0xb00 fs/namespace.c:3986
>  do_mount fs/namespace.c:4350 [inline]
>  __do_sys_mount fs/namespace.c:4563 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4540
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Freed by task 12861:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3f/0x90 mm/kasan/common.c:79
>  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:599
>  poison_slab_object mm/kasan/common.c:267 [inline]
>  __kasan_slab_free+0x70/0x90 mm/kasan/common.c:299
>  kasan_slab_free include/linux/kasan.h:239 [inline]
>  slab_free_hook mm/slub.c:2780 [inline]
>  slab_free mm/slub.c:6637 [inline]
>  kfree+0x1c7/0x650 mm/slub.c:6930
>  ext4_free_sbi fs/ext4/super.c:4417 [inline]
>  ext4_fill_super+0x2962/0x6630 fs/ext4/super.c:5924
>  get_tree_bdev_flags+0x436/0x500 fs/super.c:1821
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1881
>  fc_mount fs/namespace.c:1282 [inline]
>  do_new_mount_fc fs/namespace.c:3910 [inline]
>  do_new_mount+0x325/0xb00 fs/namespace.c:3986
>  do_mount fs/namespace.c:4350 [inline]
>  __do_sys_mount fs/namespace.c:4563 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4540
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
>  __kasan_record_aux_stack+0xc5/0xe0 mm/kasan/generic.c:561
>  insert_work+0x3d/0x330 kernel/workqueue.c:2356
>  __queue_work+0xd3c/0x1360 kernel/workqueue.c:2546
>  queue_work_on+0x106/0x1d0 kernel/workqueue.c:2599
>  queue_work include/linux/workqueue.h:700 [inline]
>  ext4_process_freed_data+0xa15/0xab0 fs/ext4/mballoc.c:4037
>  ext4_journal_commit_callback+0x99/0x620 fs/ext4/super.c:526
>  jbd2_journal_commit_transaction+0x4902/0x5c60 fs/jbd2/commit.c:1147
>  jbd2_journal_destroy+0x25f/0x7e0 fs/jbd2/journal.c:2120
>  ext4_journal_destroy+0xfb/0x130 fs/ext4/ext4_jbd2.h:456
>  __ext4_fill_super fs/ext4/super.c:5845 [inline]
>  ext4_fill_super+0x546f/0x6630 fs/ext4/super.c:5899
>  get_tree_bdev_flags+0x436/0x500 fs/super.c:1821
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1881
>  fc_mount fs/namespace.c:1282 [inline]
>  do_new_mount_fc fs/namespace.c:3910 [inline]
>  do_new_mount+0x325/0xb00 fs/namespace.c:3986
>  do_mount fs/namespace.c:4350 [inline]
>  __do_sys_mount fs/namespace.c:4563 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4540
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Second to last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
>  __kasan_record_aux_stack+0xc5/0xe0 mm/kasan/generic.c:561
>  insert_work+0x3d/0x330 kernel/workqueue.c:2356
>  __queue_work+0xd3c/0x1360 kernel/workqueue.c:2546
>  queue_work_on+0x106/0x1d0 kernel/workqueue.c:2599
>  queue_work include/linux/workqueue.h:700 [inline]
>  schedule_work include/linux/workqueue.h:761 [inline]
>  ext4_handle_error+0x63b/0x940 fs/ext4/super.c:734
>  __ext4_error+0x24d/0x360 fs/ext4/super.c:848
>  ext4_init_orphan_info+0xb75/0xda0 fs/ext4/orphan.c:625
>  __ext4_fill_super fs/ext4/super.c:5750 [inline]
>  ext4_fill_super+0x5b11/0x6630 fs/ext4/super.c:5899
>  get_tree_bdev_flags+0x436/0x500 fs/super.c:1821
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1881
>  fc_mount fs/namespace.c:1282 [inline]
>  do_new_mount_fc fs/namespace.c:3910 [inline]
>  do_new_mount+0x325/0xb00 fs/namespace.c:3986
>  do_mount fs/namespace.c:4350 [inline]
>  __do_sys_mount fs/namespace.c:4563 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4540
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> The buggy address belongs to the object at ffff88807bfec000
>  which belongs to the cache kmalloc-8k of size 8192
> The buggy address is located 1008 bytes inside of
>  freed 8192-byte region [ffff88807bfec000, ffff88807bfee000)
> 
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7bfe8
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000040 ffff88813ff2c280 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000000020002 00000000f5000000 0000000000000000
> head: 00fff00000000040 ffff88813ff2c280 dead000000000100 dead000000000122
> head: 0000000000000000 0000000000020002 00000000f5000000 0000000000000000
> head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5338, tgid 5338 (dhcpcd-run-hook), ts 50822988154
>  set_page_owner include/linux/page_owner.h:33 [inline]
>  post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1873
>  prep_new_page+0x22/0xb0 mm/page_alloc.c:1881
>  get_page_from_freelist+0x22a1/0x22e0 mm/page_alloc.c:3963
>  __alloc_frozen_pages_noprof+0x211/0x450 mm/page_alloc.c:5505
>  alloc_slab_page mm/slub.c:3384 [inline]
>  allocate_slab+0x7d/0x5e0 mm/slub.c:3499
>  new_slab mm/slub.c:3550 [inline]
>  refill_objects+0x2d5/0x350 mm/slub.c:7546
>  refill_sheaf mm/slub.c:2917 [inline]
>  __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4811
>  alloc_from_pcs mm/slub.c:4887 [inline]
>  slab_alloc_node mm/slub.c:5021 [inline]
>  __kmalloc_cache_noprof+0x396/0x600 mm/slub.c:5676
>  _kmalloc_noprof include/linux/slab.h:991 [inline]
>  _kzalloc_noprof include/linux/slab.h:1312 [inline]
>  tomoyo_print_bprm security/tomoyo/audit.c:26 [inline]
>  tomoyo_init_log+0x10ef/0x1f60 security/tomoyo/audit.c:262
>  tomoyo_supervisor+0x35f/0x1550 security/tomoyo/common.c:2232
>  tomoyo_audit_env_log security/tomoyo/environ.c:37 [inline]
>  tomoyo_env_perm+0x151/0x1f0 security/tomoyo/environ.c:64
>  tomoyo_environ security/tomoyo/domain.c:673 [inline]
>  tomoyo_find_next_domain+0x1332/0x1a90 security/tomoyo/domain.c:889
>  tomoyo_bprm_check_security+0x11b/0x180 security/tomoyo/tomoyo.c:102
>  security_bprm_check+0x85/0x240 security/security.c:834
>  search_binary_handler fs/exec.c:1767 [inline]
>  exec_binprm fs/exec.c:1809 [inline]
>  bprm_execve+0x888/0x1590 fs/exec.c:1865
>  do_execveat_common+0x99f/0xbd0 fs/exec.c:1963
> page last free pid 30 tgid 30 ts 50814152040 stack trace:
>  reset_page_owner include/linux/page_owner.h:26 [inline]
>  __free_pages_prepare mm/page_alloc.c:1415 [inline]
>  free_pages_prepare+0x9eb/0xaf0 mm/page_alloc.c:1460
>  __free_contig_range_common+0x174/0x340 mm/page_alloc.c:7136
>  __free_contig_range mm/page_alloc.c:7181 [inline]
>  free_pages_bulk+0x48/0x120 mm/page_alloc.c:5389
>  vm_area_free_pages mm/vmalloc.c:3498 [inline]
>  vfree+0x22c/0x490 mm/vmalloc.c:3547
>  delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3451
>  process_one_work kernel/workqueue.c:3495 [inline]
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> Memory state around the buggy address:
>  ffff88807bfec280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88807bfec300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88807bfec380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                              ^
>  ffff88807bfec400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88807bfec480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about AI bisection see: https://goo.gl/tpsmEJ#ai-bisection
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
