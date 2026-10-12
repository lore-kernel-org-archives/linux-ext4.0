Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149C93ED11B;
	Mon, 12 Oct 2026 10:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801384; cv=none; b=t6VluJYcSh5goi5M2MnP4PEl6arNspvdzHJeEt+FeWOjptVxIis2A2MC3XJ3gXG5g1uTmK574E9IPLG5J3ysARBQBJ4Nb2c7uKsd4+/8aTeSOC/o7lKPcLyD9yF5ACliezW+AkzCWFSQ9Ra+e313LU4V969heCksLqbgCEniz1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801384; c=relaxed/simple;
	bh=LR1jPtqkg9jW/G0Y91UfipnCztpFiDR6LFNaOSkvH30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EdDM0zlum8jMEGlHltRlS6W9Uynj1nOAp1GuxkToXKqIJawnunN7k4JXMH8Ugz76Rpf2vyNLq/P6UzN8gkD9tOyC2Uv7oU+h7rZBqRo5UHxlGh6yoCvwfVp1C6F8eLdTDFrCahH274jc67NeYcivVas902/1auUc8o4/gZkkVLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RbRYAb+q; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AVKrPIfk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GiinLOx9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1e/O+mIO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RbRYAb+q";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AVKrPIfk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GiinLOx9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1e/O+mIO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C7B2321E8A;
	Mon, 12 Oct 2026 10:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791801380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KREL/caDlw8KygqYKHSXUfDNV/PSdIiEqTWyohX+v7o=;
	b=RbRYAb+qOnCDXgiW5whf11bdt8zB3m8YNeqauwZVv+XNa9xWE18KEdGXzKhd996DOT489Q
	KTnZYsdduHVLbSntzjiK1mEAbBFwt+R7r7CRqck8SXnuAenZhwOK0v0Xf6NNBRbJ0y05K2
	tWHQfaL7+BB+wKNLjr4UVAg8/1EWlOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791801380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KREL/caDlw8KygqYKHSXUfDNV/PSdIiEqTWyohX+v7o=;
	b=AVKrPIfkY8Mk4bxTadBA/ZQztv/JGhYarrA7/3zt4iqYUmQA6gBcxPbspUN6VH3NpYzoBZ
	bPC61Y5lRvNcEwDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GiinLOx9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="1e/O+mIO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791801379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KREL/caDlw8KygqYKHSXUfDNV/PSdIiEqTWyohX+v7o=;
	b=GiinLOx9IRkGEYB++4djJHc2CrQlM8Xdvu2IaeB0nQsdW0vZ0d2zVpo69/DYjG8TwcQf3P
	I+iLN+U0hogM6b0BqnfXbpE7JPFIcZkA29AJk17KD2hkn4NVcZuWbzIEsJXpLYkVI5+ndm
	sAgdjSliAT1ni1R0iPwBnuU+30C+Ask=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791801379;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KREL/caDlw8KygqYKHSXUfDNV/PSdIiEqTWyohX+v7o=;
	b=1e/O+mIOnXJoGxIzCBdKYdqRmnkP0cqqpJpXNOO3+5IyRf7wRzEYdqbRSDheByXyWFPrz9
	tDKwObrnHZLpUhAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9CC4913408;
	Mon, 12 Oct 2026 10:36:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UWlcHiO4zGrtMgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 10:36:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 24B05A1403; Mon, 12 Oct 2026 12:36:15 +0200 (CEST)
Date: Mon, 12 Oct 2026 12:36:15 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-afs@lists.infradead.org, v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
	ntfs3@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 0/8] fs: fix a range of UAFs during rcu pathwalk caused
 by non-rcu frees
Message-ID: <r72foycb4ol4hywl5m2sj6h6yxee3nladaw7g2zdxhejmhrkgc@v24cfppcak2h>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C7B2321E8A
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Fri 09-10-26 23:51:50, Christian Brauner wrote:
> While working on eliding the grace period in namespace_unlock() I went
> through what filesystems free when they're shut down and what a pathwalk
> in rcu mode can still read at that point. Since 66a97c2ec953's rcu
> pathwalk fixes that's the filesystem's job. Whatever ->permission(),
> ->d_revalidate(), ->get_link(), ->d_hash() and ->d_compare() look at in
> rcu mode has to be freed after a grace period. A few filesystems don't
> do that.
> 
> Most of it is hidden by umount(2). namespace_unlock() waits for a grace
> period before it drops the mounts, so a walker that was inside the
> filesystem is gone by the time the filesystem is shut down.
> 
> But the last reference to a mount doesn't have to go away in umount(2).
> A chdir() out of a lazily unmounted directory or the close() of the last
> file on it drops it without a grace period. A walker can then still be
> in the filesystem while ->put_super() and ->kill_sb() free what it
> reads.

Good catches! But I find it very counter-intuitive that pathname lookups
can still be running against a filesystem while its ->put_super is called.
People will keep forgetting about that and as a result these UAF bugs will
be introduced again. Isn't it feasible we'd guarantee to the filesystem
->put_super() gets called only after all lookups are done (i.e., after RCU
grace period expires)?

I understand this is a hairy bussiness because this has userspace visible
implications (like when filesystem's sysfs files disappear, when the bdev
really gets unused, etc.) but keeping all filesystems safe to run RCU
lookup after ->put_super() will be IMHO a headache.

								Honza


> 
> With KASAN on vfs.fixes:
> 
> - ext4_get_link() reads sb->s_fs_info and the extent status counters in
>   rcu mode for a symlink that keeps its target in a data block.
> 
>   ext4_put_super() destroys the counters, clears s_fs_info and frees the
>   sbi right away. That's a NULL dereference, a use-after-free of the sbi
>   or a fault on a destroyed percpu counter, depending on where the
>   walker sits.
> 
> - The unicode map of casefolded ext4, f2fs and tmpfs is freed from
>   ->put_super() while generic_ci_d_hash() and generic_ci_d_compare() use
>   it.
> 
> - ntfs3 with nocase frees its sbi and mount options under ntfs_d_hash()
>   and ntfs_d_compare(). A remount frees the old mount options right away
>   too, that one needs no unmount at all.
> 
> - eventfs frees an eventfs_inode after an SRCU grace period only, but
>   tracefs_d_revalidate() reads it under rcu_read_lock(). No unmount
>   needed either.
> 
> The ipc patch is a different kind of bug. create_ipc_ns() leaks the
> mqueue mount and its superblock when it fails after mq_init_ns(). I ran
> into it while looking at the kern_unmount() users.
> 
> afs and 9p look just as broken but nothing can reach it today. Both
> have a private bdi, and generic_shutdown_super() calls bdi_unregister(),
> which waits for a grace period before ->kill_sb() frees their private
> data. That grace period is there for the rcu readers of bdi_list and
> covers afs and 9p by accident. I don't want them to depend on that, so
> they free their private data after a grace period of their own as well.
> 
> I appended the reproducers. The race reproducers hold a pathwalk inside
> the filesystem's callback for two seconds with a kprobe while the other
> side frees what it reads. For the ntfs3 remount the window is a single
> load and its dereference, so that one needs an mdelay() in the kernel.
> ext4 with a journal needs a kernel without lockdep since
> jbd2_journal_destroy() calls lockdep_unregister_key(), which waits for a
> grace period too.
> 
> Clean this all up.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> Christian Brauner (8):
>       ext4: free the sbi after a grace period
>       afs: free the super info after a grace period
>       9p: free the session after a grace period
>       eventfs: free the eventfs_inode after an rcu grace period too
>       ipc: drop the mqueue mount with kern_unmount() on setup failure
>       unicode: free the map after a grace period
>       ntfs3: free the sbi after a grace period
>       ntfs3: free replaced mount options after a grace period
> 
>  fs/9p/v9fs.h             |  1 +
>  fs/9p/vfs_super.c        |  4 ++--
>  fs/afs/internal.h        |  2 ++
>  fs/afs/super.c           |  2 +-
>  fs/ext4/ext4.h           |  2 ++
>  fs/ext4/extents-test.c   |  2 ++
>  fs/ext4/extents.c        |  1 +
>  fs/ext4/extents_status.c |  7 ++++++-
>  fs/ext4/extents_status.h |  1 +
>  fs/ext4/super.c          | 13 +++++++++++--
>  fs/ntfs3/dir.c           | 13 +++++++++++--
>  fs/ntfs3/ntfs_fs.h       |  3 +++
>  fs/ntfs3/super.c         | 49 +++++++++++++++++++++++++++++++++++-------------
>  fs/tracefs/event_inode.c | 10 +++++++++-
>  fs/unicode/utf8-core.c   | 21 +++++++++++++++++----
>  include/linux/unicode.h  |  1 +
>  ipc/namespace.c          |  2 +-
>  17 files changed, 107 insertions(+), 27 deletions(-)
> ---
> base-commit: 3d399224425573875b6f6f1181bd8cf9a28cc7d1
> change-id: 20261009-work-fixes-rcu-cd9c1eec0769
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
