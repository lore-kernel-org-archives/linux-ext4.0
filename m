Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089B1380FC0
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 20:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781727919; cv=none; b=nThcny9iWWTP0NfAlAyLFr/it3P52mN0631kZ7b7M+z6qzvn2lMAXKsAAd0Gh2CfMbbv/3VCGeOIOWM/hvSET/z4QC9g4UC359z1gLRp/GzQKJcXHvja/xqjBfPwXIrh/pT0IqBrm13/HtEYIML0altoK26GcQEsZ4/c/RCgsUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781727919; c=relaxed/simple;
	bh=ma7Shb/hJSPVWrfb0ifzKExKJM6Jo1JWYgvasNwhono=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FodjKqOW2RzN12krZTLxtUNIHRI0p5PgEuW7f3A5chUaxBT1Gvl0JAFRTB10btYfTeXPYqUKy275qsiHU6tkb1JbKZL9uX6X0yBR91zGhavgdf+xGWf/ob6CFGR+IZAK9jFpYhlhdgLEfjVXZRuiq34QgGKdBaExqXDwGYvlJj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ujDlJnoA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+zebtCfX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ujDlJnoA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+zebtCfX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ujDlJnoA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+zebtCfX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ujDlJnoA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+zebtCfX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 16E736C4D9;
	Wed, 17 Jun 2026 20:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781727916; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jRxKUjhNqeaHv3xEGFOu0gtLKQA0boyL6RFySccY7Pc=;
	b=ujDlJnoA1P1NMJzhZhDSh9lrQsK3bfh8ecYHjq8pJsYI/nua7puwwu2NgsuZ35CIjPxGpC
	NF9luA1OABe51eHICBkZAHkIkxA5SAOiC/Oas01y/ThUUrY+uuz77fFVh/z7OBXWgJQXq3
	aOwQjlbhZklQszJ+VSYfRtnH3I2d5Qo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781727916;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jRxKUjhNqeaHv3xEGFOu0gtLKQA0boyL6RFySccY7Pc=;
	b=+zebtCfXxv4uU2Sj2DKUYTs6JznxDzODODHccV22Sbzm02vg+mEscJbaU1QzwWEbvhJoFb
	sgYQNJE8qHTrvNBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ujDlJnoA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+zebtCfX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781727916; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jRxKUjhNqeaHv3xEGFOu0gtLKQA0boyL6RFySccY7Pc=;
	b=ujDlJnoA1P1NMJzhZhDSh9lrQsK3bfh8ecYHjq8pJsYI/nua7puwwu2NgsuZ35CIjPxGpC
	NF9luA1OABe51eHICBkZAHkIkxA5SAOiC/Oas01y/ThUUrY+uuz77fFVh/z7OBXWgJQXq3
	aOwQjlbhZklQszJ+VSYfRtnH3I2d5Qo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781727916;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jRxKUjhNqeaHv3xEGFOu0gtLKQA0boyL6RFySccY7Pc=;
	b=+zebtCfXxv4uU2Sj2DKUYTs6JznxDzODODHccV22Sbzm02vg+mEscJbaU1QzwWEbvhJoFb
	sgYQNJE8qHTrvNBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C7E0779A8;
	Wed, 17 Jun 2026 20:25:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ie8JA6wCM2q3fwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Jun 2026 20:25:16 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A2472A0EC0; Wed, 17 Jun 2026 22:25:15 +0200 (CEST)
Date: Wed, 17 Jun 2026 22:25:15 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, ebiggers@google.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ext4: validate EA inode i_nlink in
 ext4_xattr_inode_iget
Message-ID: <xzd6pbxhxxwf3ngj5v5pz2ilhykh7vsegohe6iwfkfytfuuv4o@5obqeoc5wocr>
References: <20260615053512.1315992-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615053512.1315992-1-yun.zhou@windriver.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 16E736C4D9
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
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,google.com,vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon 15-06-26 13:35:12, Yun Zhou wrote:
> Validate EA inode state in ext4_xattr_inode_iget() to prevent
> WARN_ONCE triggers in ext4_xattr_inode_update_ref() and reject
> corrupted EA inodes before they can cause further damage.
> 
> When a corrupted ext4 image has an EA inode with inconsistent i_nlink
> and ref_count values, the code currently allows it through and later
> hits WARN_ONCE when ref_count transitions cross the 0/1 boundary.
> While this is not a security or stability issue -- it only fires on
> crafted filesystem images and merely prints a call trace -- it is
> better handled as an early sanity check that returns -EFSCORRUPTED,
> consistent with how ext4 treats other on-disk corruption.
> 
> Since ext4_xattr_inode_iget() resolves references from active xattr
> entries, the target EA inode must be in active state (i_nlink=1,
> ref_count>0).  Reject any inode that does not satisfy this.
> 
> Reported-by: syzbot+76916a45d2294b551fd9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=76916a45d2294b551fd9
> Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
> v4:
>  - Take I_MUTEX_XATTR before checking orphan state to safely decide
>    whether to call make_bad_inode(), avoiding orphan list corruption
>    if another thread is concurrently freeing the EA inode
> 
> v3:
>  - Move check after Lustre branch to avoid false positives on Lustre EA inodes
>  - Merge into single condition: i_nlink != 1 || !ref_count
>  - Add make_bad_inode() before iput() to avoid truncation in active txn
> 
> v2:
>  - Add ref_count validation to also catch i_nlink=1, ref_count=0 case
> 
>  fs/ext4/xattr.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 982a1f831e22..8efd6368f956 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -464,6 +464,33 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
>  		inode_unlock(inode);
>  	}
>  
> +	/*
> +	 * Since this function resolves references from active xattr entries,
> +	 * the EA inode must be in active state (i_nlink=1, ref_count>0).
> +	 * i_nlink > 1, i_nlink == 0 (dangling reference), or ref_count == 0
> +	 * (inconsistent with an active entry) all indicate corruption or
> +	 * a concurrent last-reference drop.
> +	 */
> +	if (inode->i_nlink != 1 || !ext4_xattr_inode_get_ref(inode)) {
> +		ext4_error(parent->i_sb,
> +			   "EA inode %lu has unexpected i_nlink=%u ref_count=%llu",
> +			   ea_ino, inode->i_nlink,
> +			   ext4_xattr_inode_get_ref(inode));

Hum, given motivation of this is syzbot corrupted fs image, I'd just put
check in ext4_iget() verifying ext4_xattr_inode_get_ref() is > 0 and be
done with it. Much simpler and catches at least the obvious cases. The
consistency of xattr refcount and i_nlink is otherwise guarded by
ext4_xattr_inode_update_ref() and it can never be perfect as in the kernel
we don't have the full view of the filesystem and so cannot ascertain that
xattr ref count matches reality...

								Honza

> +		/*
> +		 * Mark rejected inode to prevent ext4_evict_inode() from
> +		 * attempting truncation on a corrupted inode within an active
> +		 * transaction, which could exhaust journal credits. The lock
> +		 * serializes against ext4_xattr_inode_update_ref() which
> +		 * does clear_nlink() + ext4_orphan_add() under the same lock.
> +		 */
> +		inode_lock_nested(inode, I_MUTEX_XATTR);
> +		if (!ext4_inode_orphan_tracked(inode))
> +			make_bad_inode(inode);
> +		inode_unlock(inode);
> +		iput(inode);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	*ea_inode = inode;
>  	return 0;
>  }
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
