Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5343783C3;
	Thu, 27 Aug 2026 13:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787838093; cv=none; b=EpJkaov489mP2S/u9z+HtemOltU+GFMuHXXs/UVF5Sj/K72yS/VkMyiEAEgWu2CL1CBo2PPKhWnbyrcQ8MXd7X/Ysavh55U4lmVc7GpcGNu/tfJ1G2EF1j6g6J5Ii5vPAyiT06NKhbaBiO7uY2e0IxzYugAUKKEkiUXtYixC4B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787838093; c=relaxed/simple;
	bh=/ZFpUHtn9MNiEU8x+uXf7nZYu7gx2z63M+fGLsE1UdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IA5VZS4tcwzppV4V9R7FwUlsdZSYWSRUGuGIKj4p7JgMC0Z7+YuetYx4LL3M3jxwMdJ8MEAqtyeTXIXhecS0ywDOkSVE7Ewz+JWuwkW6KeGeK95jKVePFaGFQAkrlCFHUlVMJpAt3CW3OvHI+X+3blpDjTPRaUTeLSFBKOWYwxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nU+MbbRG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DhYm44n2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DcR9+AsK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=f8Xm3vX6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nU+MbbRG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DhYm44n2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DcR9+AsK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="f8Xm3vX6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C91DF21AFF;
	Thu, 27 Aug 2026 13:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787838079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+wBdJGZDcWQy9r4ySz5XiZao02jjmFLlyC+OVm2nHaQ=;
	b=nU+MbbRGpZd9x/uE403wcYLTQwMn6bZ0phxAxcgL2t76MhLujNqPSUeo2WtSGo0gBiZMeE
	eLLW2uRJCBlHUAW8J2JESySk+C8I88FKxdqxWwcR6njfF7fooHb3uXt7bzkuxpuDF6X7cJ
	lWljHvELLpp1K/Jdf/zGWeV8smt0WhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787838079;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+wBdJGZDcWQy9r4ySz5XiZao02jjmFLlyC+OVm2nHaQ=;
	b=DhYm44n2eHyZJMoJrzfiZ2JwT0LPgzbZtP1K5FSnCAGPq7Ss754d992tAQl7SmClocagER
	+/dB7iBkR5904YAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DcR9+AsK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f8Xm3vX6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787838074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+wBdJGZDcWQy9r4ySz5XiZao02jjmFLlyC+OVm2nHaQ=;
	b=DcR9+AsKwjegfOwrtzYC/SHLtKaC4k1btWYc+E/PJM4gxhyv2DMkFS0YVKGE5Ip9C3v1Ow
	FEFhJJ/ZsH2MEkoa80xW/QD2o80BopfipxY4vLz3WZmCSzJB0yFB9ZC5Ayjc7/EqT1896t
	DCePfATUs37HeJ0ZfcwesUJjuk1W5dw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787838074;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+wBdJGZDcWQy9r4ySz5XiZao02jjmFLlyC+OVm2nHaQ=;
	b=f8Xm3vX6WDn1pDr/Tgb5+xVNjRS+Bu8QunO4Ly8ms3/1R4aVXdq0ghV8Mirjx8vOIf/wPQ
	Mv8BfHyiJ81slNAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE9CB1352C;
	Thu, 27 Aug 2026 13:41:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DviALno+kGrTeQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 27 Aug 2026 13:41:14 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 61D80A1324; Thu, 27 Aug 2026 15:41:10 +0200 (CEST)
Date: Thu, 27 Aug 2026 15:41:10 +0200
From: Jan Kara <jack@suse.cz>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sarthak Kukreti <sarthakkukreti@google.com>
Subject: Re: [PATCH] fs/ext4: fix ABBA deadlock in ext4_rmdir()
Message-ID: <a5zm7znmyelavclrssrhtxcksozgkgjadefvdojpeabck7hstr@tn7yhv2dey63>
References: <20260827125158.4030598-1-senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827125158.4030598-1-senozhatsky@chromium.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C91DF21AFF
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,google.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email,chromium.org:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.51

On Thu 27-08-26 21:50:20, Sergey Senozhatsky wrote:
> We observe the following ABBA deadlock (casefolding enabled):
> 
>  INFO: task jbd2/dm-13-8:447 blocked for more than 720 seconds.
>  task:jbd2/dm-13-8    state:D stack:0     pid:447   tgid:447   ppid:2
>  Call Trace:
>   <TASK>
>   __schedule+0xc2c/0xe60
>   schedule+0x40/0xe0
>   jbd2_journal_wait_updates+0x8f/0xf0
>   jbd2_journal_commit_transaction+0x321/0x1850
>   kjournald2+0xa9/0x230
>   kthread+0x226/0x2a0
>   ret_from_fork+0x101/0x1e0
>   ret_from_fork_asm+0x1a/0x30
> 
>  INFO: task Thread-10:4161 blocked for more than 720 seconds.
>  task:Thread-10       state:D stack:0     pid:4161  tgid:3848  ppid:540
>  Call Trace:
>   <TASK>
>   __schedule+0xc2c/0xe60
>   schedule+0x40/0xe0
>   wait_transaction_locked+0x8c/0xd0
>   start_this_handle+0x252/0x870
>   jbd2__journal_start+0x120/0x280
>   __ext4_journal_start_sb+0x11a/0x250
>   ext4_evict_inode+0x208/0x760
>   iput+0x222/0x5c0
>   dput+0x293/0x690
>   ____fput+0x145/0x2b0
>   task_work_run+0x7a/0xb0
>   exit_to_user_mode_loop+0xc0/0xd0
>   do_syscall_64+0x14b/0xf10
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
>  NMI backtrace for cpu 0
>  CPU: 0 UID: 1010216 PID: 4160 Comm: Thread-7
>  RIP: 0010:d_walk+0x0/0x290
> [..]
>  Call Trace:
>  <TASK>
>   shrink_dcache_parent+0xb2/0x100
>   d_invalidate+0x50/0x110
>   ext4_rmdir+0x3a2/0x3d0
>   vfs_rmdir+0x9d/0x1d0
>   do_rmdir+0xf0/0x330
>   __x64_sys_unlinkat+0x34/0x50
>   do_syscall_64+0x61/0xf10
> 
> The problem is that ext4_rmdir() calls d_invalidate() before stopping
> the jbd2 transaction handle.  Because d_invalidate() traverses child
> dentries it can encounter dying or in-use dentries.  If a concurrent
> thread executing __dentry_kill() on a child dentry invokes ext4_evict_inode(),
> it requests a new transaction handle via ext4_journal_start(), which
> waits for all running handles to close.  However, the thread executing
> ext4_rmdir() still holds its active transaction handle while looping
> in shrink_dcache_parent() waiting for the dying child dentry to complete
> eviction.
> 
> Stop transaction handle in ext4_rmdir() before calling d_invalidate().
> 
> Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> Co-developed-by: Sarthak Kukreti <sarthakkukreti@google.com>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Good catch! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/namei.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a6386c1d237f..231a274b814e 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3209,19 +3209,20 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  	ext4_fc_track_unlink(handle, dentry);
>  	retval = ext4_mark_inode_dirty(handle, dir);
>  
> +end_rmdir:
> +	brelse(bh);
> +	if (handle)
> +		ext4_journal_stop(handle);
> +
>  	/* VFS negative dentries are incompatible with Encoding and
>  	 * Case-insensitiveness. Eventually we'll want avoid
>  	 * invalidating the dentries here, alongside with returning the
>  	 * negative dentries at ext4_lookup(), when it is better
>  	 * supported by the VFS for the CI case.
>  	 */
> -	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
> +	if (!retval && IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
>  		d_invalidate(dentry);
>  
> -end_rmdir:
> -	brelse(bh);
> -	if (handle)
> -		ext4_journal_stop(handle);
>  	return retval;
>  }
>  
> -- 
> 2.55.0.897.gb25b4bd76c-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
