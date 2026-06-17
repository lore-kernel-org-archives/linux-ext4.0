Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59157367B61
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 18:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781720002; cv=none; b=BJAMqdlL+f5E3lrS//jnNy4smCy/8R16nW7HBVEyo66ZXHgdZmPdP5KC/pwm9ed9YdkbNqzLvr7Or4PrshwWJEuQ7lVbdMQNauaywAsayAEwOly7EaUxs/DnPfsICt3ScaUxcDOihzEouxb+jUidvVtFscE0oF9+RtXuNC1xKL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781720002; c=relaxed/simple;
	bh=4NlvvutN4M6ymuCO3RLZ4PPy9sVzCOohDdnu+UbhEE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHPWjnYlI8DBLLZABqrZi4Xv4kbmi+puFXpqL7/WmMAXD/gck9RECWosxgxA/zxwIoScqQPsGXynz+fdBVulNKNUDZoLf4hbWITKTN03yntpdER+xzQ840oOgzStojrNfKlgklNSuiFlPM9CIdY7ndM/kN4jEMS3vFhOKMnSRU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rumZMqZW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=o/+OG6u4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rumZMqZW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=o/+OG6u4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rumZMqZW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="o/+OG6u4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rumZMqZW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="o/+OG6u4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5FB556C198;
	Wed, 17 Jun 2026 18:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781719998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lt2uvuQza1nPpqeCcr9Dxk84JcYzwxH5ioocpOEzCA8=;
	b=rumZMqZWbOABbUXvEb8UKfiUOFne7VJBt10MBbBZGyiSpgeZLXrX7QtT9C6HfQZSTHGppg
	tk25pcgMSJRDQueLPR9GYGbt8u31ENCSid3AbLEXPrhOdVgR3H2Y8eNfhsDK6xlB900mLk
	AoK2ZLIXkuujJsB4ELg5uWLAn7JHUv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781719998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lt2uvuQza1nPpqeCcr9Dxk84JcYzwxH5ioocpOEzCA8=;
	b=o/+OG6u4tDGTLLcYlR7HftpUPnF/Ahq0I+JnZtFvhtrmxhdPI5XupGj4r2srvwI0f63AW4
	giFUyVGx9p8DTQAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rumZMqZW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="o/+OG6u4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781719998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lt2uvuQza1nPpqeCcr9Dxk84JcYzwxH5ioocpOEzCA8=;
	b=rumZMqZWbOABbUXvEb8UKfiUOFne7VJBt10MBbBZGyiSpgeZLXrX7QtT9C6HfQZSTHGppg
	tk25pcgMSJRDQueLPR9GYGbt8u31ENCSid3AbLEXPrhOdVgR3H2Y8eNfhsDK6xlB900mLk
	AoK2ZLIXkuujJsB4ELg5uWLAn7JHUv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781719998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lt2uvuQza1nPpqeCcr9Dxk84JcYzwxH5ioocpOEzCA8=;
	b=o/+OG6u4tDGTLLcYlR7HftpUPnF/Ahq0I+JnZtFvhtrmxhdPI5XupGj4r2srvwI0f63AW4
	giFUyVGx9p8DTQAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 210F5779A8;
	Wed, 17 Jun 2026 18:13:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AfUHCL7jMmptfwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Jun 2026 18:13:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 97A12A0EC0; Wed, 17 Jun 2026 20:13:14 +0200 (CEST)
Date: Wed, 17 Jun 2026 20:13:14 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/4] ext4: fix xattr iput deadlock with
 s_writepages_rwsem
Message-ID: <o63nwdmeoqscllaitti32enjhet4fcvstv5eh4wooviwxmsosl@mooyvfa5dfqm>
References: <20260616151558.1728881-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616151558.1728881-1-yun.zhou@windriver.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5FB556C198
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Tue 16-06-26 23:15:54, Yun Zhou wrote:
> This series fixes a circular lock dependency reported by syzbot:
> 
>   s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem
> 
> The deadlock occurs when iput() on an EA inode triggers write_inode_now()
> while xattr_sem and a jbd2 handle are held.  The triggering path is
> during mount-time orphan cleanup (!SB_ACTIVE) where iput_final() calls
> write_inode_now() synchronously.
> 
> Patch 1 blocks the deadlock by skipping extra isize expansion when
> !SB_ACTIVE -- this prevents the xattr manipulation path from being
> entered during mount.
> 
> Patch 2 is a belt-and-suspenders semantic improvement: an inode under
> eviction never needs extra isize expansion.
> 
> Patches 3-4 are a structural improvement using a per-sb workqueue:
> 
>   Patch 3 introduces ext4_put_ea_inode(), which does direct iput() when
>   SB_ACTIVE (zero overhead) and defers to a workqueue when !SB_ACTIVE.
>   It also converts the first call site (ext4_xattr_block_set release
>   path) which previously called iput under xattr_sem + jbd2 handle.
> 
>   Patch 4 converts the remaining EA inode iput() calls that execute
>   under locks.  Sites where direct iput() is provably safe (i_nlink=0
>   after dec_ref, or lookup-only paths) are left unchanged with comments.
> 
> Link: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5

Please don't send the series so quickly. I'd say twice per week is about
maximum sensible cadence. It takes time (easily several days) for people to
get to look at your patches and sending your patches sometimes even several
times per day just creates a mess in the mailbox.

Also in some previous version, I gave my Reviewed-by tag for patch 1 and
some comment and Reviewed-by tag for patch 2. So please reflect that in the
next posting.

								Honza

> v7:
>  - Replaced the deferred-iput array threading approach (v4-v6) with a
>    simpler per-sb workqueue + lock-free llist design.  No function
>    signature changes needed.  ext4_put_ea_inode() does direct iput when
>    SB_ACTIVE (zero overhead in normal operation) and defers to the
>    workqueue only during mount (!SB_ACTIVE).
>  - Converted the iput in ext4_xattr_delete_inode()'s quota accounting
>    loop to ext4_put_ea_inode() to eliminate a lockdep-reportable lock
>    ordering violation (jbd2_handle -> iput -> s_writepages_rwsem).
>  - Moved flush_work() before the if (sbi->s_journal) check in
>    ext4_put_super() to cover nojournal mode.
> 
> v6:
>  - ext4_inline_data_truncate(): use local ea_inode_array instead of
>    passing NULL, freed after ext4_journal_stop().  Fixes a deadlock
>    reachable via crafted filesystem where inline data xattr entry has
>    e_value_inum set: orphan cleanup -> ext4_truncate ->
>    ext4_inline_data_truncate -> iput under !SB_ACTIVE.
> 
> v5:
>  - Split into 3 patches for easier review.
>  - Add explicit !SB_ACTIVE early-return in ext4_try_to_expand_extra_isize()
>    to block ALL mount-time paths (ext4_process_orphan -> ext4_truncate ->
>    ext4_mark_inode_dirty), not just the eviction path. v4 only relied on
>    EXT4_STATE_NO_EXPAND which doesn't cover orphan truncation.
> 
> v4:
>  - Comprehensive rewrite of the deferred iput mechanism.
>  - Thread ea_inode_array through ext4_expand_extra_isize_ea() and
>    ext4_xattr_move_to_block() so ALL ea_inode iputs in the expand
>    path are deferred, not just those in ext4_xattr_block_set().
>  - Add NULL safety to ext4_expand_inode_array(): when ea_inode_array
>    pointer is NULL, fall back to synchronous iput (for callers like
>    ext4_initxattrs that only run with SB_ACTIVE).
>  - Use __GFP_NOFAIL to guarantee deferred array growth, eliminating
>    fallback to synchronous iput under locks.
>  - Update ext4_xattr_ibody_set() and ext4_xattr_set_entry() signatures
>    to accept ea_inode_array, converting ALL iput(ea_inode) calls.
>  - Set EXT4_STATE_NO_EXPAND in ext4_evict_inode() before
>    ext4_mark_inode_dirty().
> 
> v3:
>  - Check ext4_expand_inode_array() return value; fallback to
>    direct iput() on ENOMEM to prevent inode leak.
>  - Make ext4_xattr_set_handle() take an optional ea_inode_array
>    output parameter so callers can free after ext4_journal_stop(),
>    avoiding the jbd2_handle vs s_writepages_rwsem AB-BA.
>  - Pass ea_inode_array directly to ext4_xattr_release_block()
>    instead of using a local array freed under xattr_sem.
>  - Move ext4_xattr_inode_array_free() after ext4_journal_stop()
> 
> v2:
>  - Defer iput() in ext4_xattr_block_set() via ea_inode_array,
>    freed after xattr_sem is released. Fixes the root cause.
> 
> v1:
>  - Set EXT4_STATE_NO_EXPAND in ext4_evict_inode() to skip expand
>    on inodes being deleted. Only fixes the syzbot reproducer, not
>    the underlying lock ordering violation.
> 
> Yun Zhou (4):
>   ext4: skip extra isize expansion during mount to prevent deadlock
>   ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
>   ext4: introduce ext4_put_ea_inode() for safe deferred iput
>   ext4: convert remaining EA inode iput() calls to ext4_put_ea_inode()
> 
>  fs/ext4/ext4.h  |   5 +++
>  fs/ext4/inode.c |  11 +++++
>  fs/ext4/super.c |   6 +++
>  fs/ext4/xattr.c | 105 +++++++++++++++++++++++++++++++++++++++++++-----
>  fs/ext4/xattr.h |   2 +
>  5 files changed, 120 insertions(+), 9 deletions(-)
> 
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
