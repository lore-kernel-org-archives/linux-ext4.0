Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B34F48C8CE;
	Tue, 13 Oct 2026 17:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791912925; cv=none; b=J2raOfNd1A2s/o62OA7XeZKqllIRqPFDyjROu9nVDfTQIbzQMjShlJPjIAfe3F+aRLva8mgC4lCeuzc8wcajVER3fB6Xj3R5ZLEZ5snlGnYpkX7OlYz4W2k5yP0u/2B2yEvNQo7ptczhnD+32SjXQx4tg0AljujHuEN7AXfaSAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791912925; c=relaxed/simple;
	bh=7mHVByUea5c34s1NdGTzuGVOx5szBHaF6Eyje3OS6lA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mqeDrih3u6C+5jrJOYOYIc64D8BBYoWrrkSBFfNR/g1ulzlVgbP6Q1+4YuZbjvEteSw/5gYRE0MGDspaHR2B2LlaCi7EwTW5zfb+t0fzczlxlH+2f1BVF5agY/8f+FhUfnYe6j5Q98rKPnse4/lgLwFUSjvxskgyh8pPVE1dsIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SycErfN/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WJhL9YZk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SycErfN/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WJhL9YZk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SycErfN/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WJhL9YZk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SycErfN/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WJhL9YZk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0B09921E04;
	Tue, 13 Oct 2026 17:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791912921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KbklspijRvdlfU7/CwOImEurfZ5evV9eiAhvXxXmFEI=;
	b=SycErfN/kedLAEUrpRmu0MQs2Ez1OEGEx8n7xMmjBqmKiOk8fLWyJykziHxIFCFPyeUXos
	v5IOMXc9Ewn9nkXJBptRD/OYd5/6gdyXen/slnD/ExRLhSHJjjflbXCym6PUSltcLGi/a+
	K0Fot23xOvp9ose/nzomPXvnAkXpSTk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791912921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KbklspijRvdlfU7/CwOImEurfZ5evV9eiAhvXxXmFEI=;
	b=WJhL9YZkZp+aP6AUjVEWnoI8uJKmcpSB5i6053VoEt2tgDOPq6vE5GhueJzG189k/RXpTn
	hoxiAtCbRDYEh3Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="SycErfN/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WJhL9YZk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791912921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KbklspijRvdlfU7/CwOImEurfZ5evV9eiAhvXxXmFEI=;
	b=SycErfN/kedLAEUrpRmu0MQs2Ez1OEGEx8n7xMmjBqmKiOk8fLWyJykziHxIFCFPyeUXos
	v5IOMXc9Ewn9nkXJBptRD/OYd5/6gdyXen/slnD/ExRLhSHJjjflbXCym6PUSltcLGi/a+
	K0Fot23xOvp9ose/nzomPXvnAkXpSTk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791912921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KbklspijRvdlfU7/CwOImEurfZ5evV9eiAhvXxXmFEI=;
	b=WJhL9YZkZp+aP6AUjVEWnoI8uJKmcpSB5i6053VoEt2tgDOPq6vE5GhueJzG189k/RXpTn
	hoxiAtCbRDYEh3Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32ACA134B8;
	Tue, 13 Oct 2026 17:35:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7DKDLNdrzmqwDAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 13 Oct 2026 17:35:20 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org,
 v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
 ntfs3@lists.linux.dev, "Christian Brauner (Amutable)"
 <brauner@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 6/8] unicode: free the map after a grace period
In-Reply-To: <20261009-work-fixes-rcu-v1-6-7446d2d335e6@kernel.org>
Organization: SUSE
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-6-7446d2d335e6@kernel.org>
Date: Tue, 13 Oct 2026 13:35:18 -0400
Message-ID: <87qzhtbj1l.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0B09921E04
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

Christian Brauner <brauner@kernel.org> writes:

> generic_ci_d_hash() and generic_ci_d_compare() read sb->s_encoding and
> dereference the unicode map while a pathwalk in rcu mode holds nothing
> but rcu_read_lock(). The filesystems that use them, ext4, f2fs and
> tmpfs, drop the map with utf8_unload() from ->put_super(), which runs
> when the last reference to the mount goes away. A lookup that is still
> inside such a filesystem at that point reads a freed map.
>
> With a pathwalk held up in utf8_casefold_hash() while the last reference
> to a casefolded tmpfs goes away:
>
>   BUG: KASAN: slab-use-after-free in utf8nlookup+0x74c/0x950
>   Read of size 8 at addr ff110001030fe658 by task walker/98
>   Call Trace:
>    <TASK>
>    utf8nlookup+0x74c/0x950
>    utf8byte+0x160/0x1560
>    utf8_casefold_hash+0x167/0x230
>    generic_ci_d_hash+0xdd/0x1c0
>    link_path_walk+0x11ad/0x1d30
>    path_lookupat+0x63/0xb00
>    filename_lookup+0x1f1/0x5b0
>    vfs_statx+0xd7/0x3b0
>   [...]
>   Allocated by task 94:
>    __kmalloc_cache_noprof+0x249/0x560
>    utf8_load+0x4e/0x570
>    shmem_parse_opt_casefold.isra.0+0x92/0x270
>   [...]
>   Freed by task 97:
>    kfree+0x1db/0x5b0
>    shmem_put_super+0x72/0x170
>    generic_shutdown_super+0x14c/0x530
>    kill_anon_super+0x3a/0x60
>    deactivate_locked_super+0x9c/0xf0
>    cleanup_mnt+0x9f/0x130
>
> So far that has been hard to hit. umount(2) waits for a grace period
> in namespace_unlock() before it drops the mount, so only a mount whose
> last reference goes away elsewhere, like the close of a file or a chdir
> out of a lazily unmounted directory, can race a walker. So it is
> reachable.
>
> Delay the free until a grace period has passed. The map and the data
> table it holds a reference to then outlive any pathwalk that found the
> superblock before the mount went away. The reference on the data table
> module is dropped from the rcu callback as well. utf8-core is built in
> whenever CONFIG_UNICODE is set, so there is no module exit that would
> have to wait for the callbacks.
>
> Overlayfs points the s_encoding of an overlay at the map of its first
> layer without taking a reference of its own. That stays correct. The
> layer is held by the overlay, so its map is dropped only after the
> overlay is gone.
>
> Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Hey, Christian!

Interesting find and looks good to me.  Feel free to add:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

thanks,

-- 
Gabriel Krisman Bertazi
