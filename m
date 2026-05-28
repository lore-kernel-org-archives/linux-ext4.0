Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33D73ABD8E
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 11:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779967138; cv=none; b=c8NQWsmv50jpxKKPK8toKvkbUxn8JPkiMVyhyBjiY+zq74JQToIh+eUb5omEaT5m7ABl1H0gSafgGVMOVpmPsvorDW+Pns2zn41AVao0geDlBlecfSTun5pSvSLbTOToi02kvV6X/aiyy1wxgxmo+n/iBOzTP56/6dECkZDyVOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779967138; c=relaxed/simple;
	bh=C5AS4mdgINDYGvHYOWAbFX8fFnzLIoAn8Z9u4Jez+Is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mR2K4YN4y9QlYUbXJnYwKTbIpTI6NoHBdRDrQH+iXH4Aj3ZNXNJ90jAG362BXClb5l3fF/c5lBrLTbWEiyCAqEUGNt4a0f/BzMrccvft3Dd5ZxUJrlRW/CIVRdrgBIWJrMFG6Xuwgd4SwiCQo1W469RC9LS351m2p7NyYiD05uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T0K51g4m; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vEv0nhTM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T0K51g4m; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vEv0nhTM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T0K51g4m";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vEv0nhTM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T0K51g4m";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vEv0nhTM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E2E756AFFC;
	Thu, 28 May 2026 11:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779967134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=96XZQn4AoQGDQzzwQ6wrbPqGeiwBjDvlhAqms1kFv+g=;
	b=T0K51g4m3YO1m1lSWQAESVkTCi4YjL+D13SHtddnjeElsfVRRRrG8UzGyeb5P2DAuw5nPp
	YBCXpLCXu4F+sfTpapDmLl4D6u1yvDHX0BjgeJy+0G9md2xha5AoqZf/6UPWx9MdzOAUM3
	pJm2uHUuAMG4uwQIQ9a6L3ZgfvWm0Yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779967134;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=96XZQn4AoQGDQzzwQ6wrbPqGeiwBjDvlhAqms1kFv+g=;
	b=vEv0nhTMypZDQvcUswoHP9I8Mmgxn0/dOouNDyDWIP7wiWdOx3nti1vy3hqqZ2lWdlwWU/
	XIDsYVi2BjK+CHDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T0K51g4m;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vEv0nhTM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779967134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=96XZQn4AoQGDQzzwQ6wrbPqGeiwBjDvlhAqms1kFv+g=;
	b=T0K51g4m3YO1m1lSWQAESVkTCi4YjL+D13SHtddnjeElsfVRRRrG8UzGyeb5P2DAuw5nPp
	YBCXpLCXu4F+sfTpapDmLl4D6u1yvDHX0BjgeJy+0G9md2xha5AoqZf/6UPWx9MdzOAUM3
	pJm2uHUuAMG4uwQIQ9a6L3ZgfvWm0Yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779967134;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=96XZQn4AoQGDQzzwQ6wrbPqGeiwBjDvlhAqms1kFv+g=;
	b=vEv0nhTMypZDQvcUswoHP9I8Mmgxn0/dOouNDyDWIP7wiWdOx3nti1vy3hqqZ2lWdlwWU/
	XIDsYVi2BjK+CHDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D5B185AD66;
	Thu, 28 May 2026 11:18:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gWcmNJ4kGGo0OAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 28 May 2026 11:18:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5A547A0905; Thu, 28 May 2026 13:18:54 +0200 (CEST)
Date: Thu, 28 May 2026 13:18:54 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/8] super: retire sget(), convert iterators to RCU
Message-ID: <4aw6h2zvj2fe7ezjncs2u34ydshx7sbh4r3tupg43owmq4qo2b@uhp7jtx6b74l>
References: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E2E756AFFC
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
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,gmail.com,zeniv.linux.org.uk];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim]

On Tue 26-05-26 17:09:02, Christian Brauner wrote:
> * retire sget(): CIFS plus the two ext4 KUnit tests (extents-test,
>   mballoc-test) were the last in-tree callers, and all three convert
>   cleanly to sget_fc(). That lets sget() and its prototype come out,
>   taking ~60 lines that only existed to be kept in lockstep with
>   sget_fc() on every publish-path change.

This is definitely a good cleanup!

> * Walk @super_blocks and @type->fs_supers under RCU, pinned by
>   refcount_inc_not_zero(&sb->s_count). iterate_supers(),
>   iterate_supers_type(), user_get_super(), do_emergency_remount(),
>   filesystems_freeze() and filesystems_thaw() no longer hold sb_lock
>   across the cursor advance.
> 
>   The conversion goes in four small steps. Drop sb_lock from
>   setup_bdev_super(): the {s_bdev_file, s_bdev, s_bdi,
>   SB_I_STABLE_WRITES} tuple is publication of immutable state, and
>   SB_BORN already gates every reader via super_wake()'s
>   smp_store_release paired with super_flags()'s smp_load_acquire. Then
>   convert sb->s_count to refcount_t -- mechanical, every increment is
>   still under sb_lock. Then switch the write-side list/hlist ops to
>   their _rcu variants; @super_blocks gets list_bidir_del_rcu() so the
>   reverse-walking iterators (filesystems_freeze, do_emergency_remount)
>   keep a valid ->prev on the unlinked entry, matching the canonical
>   pattern in kernel/nstree.c. Finally, convert the iterators themselves:
>   cursor advance via READ_ONCE / rcu_dereference, with the previous
>   entry kept pinned via its s_count across the rcu_read_unlock ->
>   callback -> rcu_read_lock cycle.

So I guess the motivation for getting rid of sb_lock is some contention on
it you can observe? When exactly? It would be nice to mention the
motivation as a justification for the additional complexity...

								Honza

> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> Christian Brauner (8):
>       ext4: convert extents KUnit test to sget_fc()
>       ext4: convert mballoc KUnit test to sget_fc()
>       smb: client: convert cifs_smb3_do_mount() to sget_fc()
>       fs: retire sget()
>       super: drop sb_lock from setup_bdev_super() tuple publication
>       super: convert sb->s_count to refcount_t
>       super: switch list manipulation to _rcu primitives
>       super: convert iterators to RCU readers + refcount_inc_not_zero
> 
>  fs/btrfs/super.c               |   2 +-
>  fs/ext4/extents-test.c         |  22 +++++-
>  fs/ext4/mballoc-test.c         |  17 ++++-
>  fs/smb/client/cifsfs.c         |  43 ++++++-----
>  fs/smb/client/cifsfs.h         |   3 +-
>  fs/smb/client/cifsproto.h      |   3 +-
>  fs/smb/client/connect.c        |   5 +-
>  fs/smb/client/fs_context.c     |   2 +-
>  fs/super.c                     | 167 ++++++++++++++---------------------------
>  include/linux/fs.h             |   4 -
>  include/linux/fs/super_types.h |   3 +-
>  11 files changed, 127 insertions(+), 144 deletions(-)
> ---
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> change-id: 20260526-work-sget-6bc80b96cba5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
