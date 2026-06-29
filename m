Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA10234A773
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 11:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733074; cv=none; b=mkXlfCrf8z4g+FV+EhIGZozsM70OnwBudtAs0fHOdYIFvoMTtzSuipwzqLKIlh49NQqXllD0ayuSoh2v+BiNs3Roc+jLBViGKf40ibNYqhJ6w46g40Dr88yWpkTG2Xw6luE4Rj7CQO/fvVSZURn5XzRWp1/z2D4EPTKRbOgaq0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733074; c=relaxed/simple;
	bh=jWN2p9ror6Y86hZXk/tLl8y2DxtoBCUT4hQLpTZrn70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDN4kt/rzduD5TfAYOsZXPnNBi40E9QC9+HYz8FcAWfuFJNVkGPCKSvjHciS8oEJT5t7nYtiEQoHV4Z2YfSeO/hQArYn0h4k2nG+yWuEAR8zk+rlIHF3I1lat5kpEpz/vzyIBrrGfbnsqAFljjhIOV9q7aZPEeQTeBb27aQJTwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AcdymO3A; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7K8hjG7I; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AcdymO3A; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7K8hjG7I; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AcdymO3A";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7K8hjG7I";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AcdymO3A";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7K8hjG7I"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 051157304B;
	Mon, 29 Jun 2026 11:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782733071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bLC3qw/vmbZxhW2/s5UndiO5IYcBI53VNN28GArFeLs=;
	b=AcdymO3Ac2jhNQABuakDiOrYdbtxYrGH/wKpEgcaVYmJWReRp6nSQ2GQmuT02vESCnZgku
	hlYK55NVEww3erlMc/9439j+rtVGhg66W215fwdFq14tqD9dHUAy3GLdMSavVl5lAkqjHu
	PjvxJZP2CCFg2sHgLokqL7bPRr1cxVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782733071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bLC3qw/vmbZxhW2/s5UndiO5IYcBI53VNN28GArFeLs=;
	b=7K8hjG7IZbLv7d4LRb93ZrN0x60DxdhXYoqr/P0alkhYp2DR2er39UzW2/LiZY6SqydTYZ
	lESB3G7TjaJfHeBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782733071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bLC3qw/vmbZxhW2/s5UndiO5IYcBI53VNN28GArFeLs=;
	b=AcdymO3Ac2jhNQABuakDiOrYdbtxYrGH/wKpEgcaVYmJWReRp6nSQ2GQmuT02vESCnZgku
	hlYK55NVEww3erlMc/9439j+rtVGhg66W215fwdFq14tqD9dHUAy3GLdMSavVl5lAkqjHu
	PjvxJZP2CCFg2sHgLokqL7bPRr1cxVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782733071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bLC3qw/vmbZxhW2/s5UndiO5IYcBI53VNN28GArFeLs=;
	b=7K8hjG7IZbLv7d4LRb93ZrN0x60DxdhXYoqr/P0alkhYp2DR2er39UzW2/LiZY6SqydTYZ
	lESB3G7TjaJfHeBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5BFF779A8;
	Mon, 29 Jun 2026 11:37:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nmegNw5ZQmqqYgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 29 Jun 2026 11:37:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 88C19A10B5; Mon, 29 Jun 2026 13:37:46 +0200 (CEST)
Date: Mon, 29 Jun 2026 13:37:46 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	xiaowu.417@qq.com
Subject: Re: [PATCH v11 2/5] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
Message-ID: <gyrelvt577bxfhq5e5k4rwdr5r2m455c3dn44hx7jgrgnvoqqn@bfc43qrask7g>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-3-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629110848.3085662-3-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.com:email,windriver.com:email,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org,qq.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,windriver.com:email,suse.cz:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 29-06-26 19:08:45, Yun Zhou wrote:
> Calling iput() on EA inodes while holding xattr_sem or a jbd2 handle
> can trigger write_inode_now() -> ext4_writepages() -> s_writepages_rwsem,
> creating a lock ordering issue during mount (!SB_ACTIVE).
> 
> Add ext4_put_ea_inode() which uses iput_if_not_last() as a fast path.
> If this is not the last reference, it is dropped immediately.  If this
> is the last reference, the inode is linked onto a per-sb lock-free llist
> via i_ea_iput_node (embedded in ext4_inode_info, sharing space with the
> unused xattr_sem of EA inodes via a union) and a delayed worker
> (1 jiffie) performs the final iput() in a clean context.  This avoids
> per-iput memory allocation.
> 
> Flush points are placed before quota shutdown (ext4_put_super and
> failed_mount9) and before freeing structures that eviction depends on
> (failed_mount_wq and failed_mount3a).  Initialization is placed before
> journal loading since fast commit replay may trigger evictions that call
> ext4_put_ea_inode().
> 
> Also moves init_rwsem(xattr_sem) from init_once to ext4_alloc_inode to
> handle slab object reuse after the union field has been overwritten.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Suggested-by: Jan Kara <jack@suse.cz>

...

> +/*
> + * Release a VFS reference on an EA inode.  Must be used instead of iput()
> + * in any context where xattr_sem or a jbd2 handle is held.
> + *
> + * If this is not the last reference, drops it immediately via
> + * iput_if_not_last() with no further action needed.
> + *
> + * If this is the last reference, the inode is linked onto a per-sb
> + * llist via i_ea_iput_node (embedded in ext4_inode_info, sharing space
> + * with the unused xattr_sem) and a delayed worker performs the final
> + * iput() in a clean context.
> + *
> + * Note: while an inode is on s_ea_inode_to_free, the unconsumed i_count
> + * reference (still 1) keeps it in the inode cache, so any concurrent
> + * iget() bumps i_count to >= 2 and iput_if_not_last() will succeed.
> + * Nobody will add the inode a second time until ext4_ea_inode_work()
> + * drops that reference via iput().
> + */
> +void ext4_put_ea_inode(struct super_block *sb, struct inode *inode)

One small question here: Any reason why you explicitely pass sb here
instead of using inode->i_sb? EA inodes are guaranteed to be from the same
superblock... It would somewhat simplify the callers.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
