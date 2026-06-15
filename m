Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7D040961E
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 16:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781540434; cv=none; b=N+tclq+Up223uNjdhbLy0TfUI697fkkRIq0Fmpv5TWAwcDi3DanmivD2b3DJWg4owMLVneo3+UOmF42vYXpzu563ojhQmT6dpgqu4FJBVe8E1Z1kWpm5Me3rFmzJ1C1IgoiforO1uQH94NnwEmspnQPLKq+W9fG4iBolM+9uBaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781540434; c=relaxed/simple;
	bh=w829G9ZtNLv8CLwcPi0BFD2HCjJBio2k2rlJ+6Hp/aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fEJ5PBcJmyFeGkbJYRgqqOLKO0vK2pN4u+vn9E5T4p0YlURwBIU4BnlrR07M6kmbeYWcLkFivIoB6rGG1Jxc22yy+HBbu3xwqbW3bIyom/+1rKWN9UMct+JU/QjQIPFTxLcJH3GmA1DzIev1flCWubSpsudNnuapVJlVwJW+Rk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T6R4M/vs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=k3gNyh2j; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mzRkHC49; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dpUewy1C; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T6R4M/vs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="k3gNyh2j";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mzRkHC49";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dpUewy1C"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EEC6A6AEB3;
	Mon, 15 Jun 2026 16:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781540431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q3rNmniTYFkazg1z2QP5EXG9iTFuX+VZ0gznfrn7Xxo=;
	b=T6R4M/vsRTNTKoWj/cDppBn0Wz9JTjX17+adczB90s2aUY9AAjJLtqyA6p1/7EfJEbswZu
	5Bk58vQ710Lm1QuIFaSdrb2KMAl5u2tCAmPRBjxrsU9kBgQ7mQNa4DerRjPu5zGasG6Gf+
	oEMSgq57RTInILaISwZWIdKfvn6UNEw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781540431;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q3rNmniTYFkazg1z2QP5EXG9iTFuX+VZ0gznfrn7Xxo=;
	b=k3gNyh2jAhMZMPnAOvdYYt5aee+44wLxAPPZHpmOTBJZ5Ss1mYR/j0Mv+BG/sC9zA3pp2+
	8zKMJK1vdrh0WrDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mzRkHC49;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dpUewy1C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781540429; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q3rNmniTYFkazg1z2QP5EXG9iTFuX+VZ0gznfrn7Xxo=;
	b=mzRkHC49bm3SfjR3SaTWYCgQtGxqIxVUoPXd6dEaElEssJfgiuudZssU+ZXjOjobuGj3DV
	WOCje7ETUydBm7+cy+5aD8sXdo2nKxzwrIT4ejhKkLxYgbEhI1GOw+RaASVrSDm1mBv6eW
	XtSjjbjLO2EKqWLvr1G5BP3lXs9HW9Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781540429;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q3rNmniTYFkazg1z2QP5EXG9iTFuX+VZ0gznfrn7Xxo=;
	b=dpUewy1CPzHpe7uBgLfRfU2Rp/xE9l1Z5HF5wN8Qg6Lm1asflW9OTaczAqyOmG8bvXfzMZ
	IODSmZOS0linahBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1A7F779A7;
	Mon, 15 Jun 2026 16:20:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zIARN00mMGqsXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 15 Jun 2026 16:20:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 593F5A12D2; Mon, 15 Jun 2026 18:20:25 +0200 (CEST)
Date: Mon, 15 Jun 2026 18:20:25 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, ebiggers@google.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] ext4: skip extra isize expansion during mount to
 prevent deadlock
Message-ID: <qlhnykh2gpks7z5xoeat57birw4t3mdnlb6bkyra5j365ngy4w@vdlu4thujuwu>
References: <20260615115317.3549469-1-yun.zhou@windriver.com>
 <20260615115317.3549469-2-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615115317.3549469-2-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
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
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,google.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[windriver.com:email,syzkaller.appspot.com:url,appspotmail.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EEC6A6AEB3
X-Spam-Score: -2.51

On Mon 15-06-26 19:53:15, Yun Zhou wrote:
> ext4_try_to_expand_extra_isize() is called from __ext4_mark_inode_dirty()
> while holding an active jbd2 handle.  During mount (!SB_ACTIVE), the
> expand path may move xattrs to external blocks and release ea_inodes via
> iput().  When !SB_ACTIVE, iput() calls write_inode_now() which acquires
> s_writepages_rwsem, creating a circular lock dependency:
> 
>   s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem
> 
> This can be triggered via:
> 
>   ext4_process_orphan() -> ext4_truncate() -> ext4_mark_inode_dirty()
>     -> ext4_try_to_expand_extra_isize()
> 
> or:
> 
>   ext4_evict_inode() -> ext4_mark_inode_dirty()
>     -> ext4_try_to_expand_extra_isize()
> 
> Skip expansion when !SB_ACTIVE.  This is a minor loss of functionality
> (extra isize won't grow for these inodes during mount), which e2fsck
> can resolve later if needed.
> 
> Reported-by: syzbot+5d19358d7eb30ffb0cc5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5
> Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Yeah, looks as a sensible compromise. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cd7588a3fa45..be1e3eaa4f23 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6479,6 +6479,16 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
>  	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND))
>  		return -EOVERFLOW;
>  
> +	/*
> +	 * Skip expansion during mount (!SB_ACTIVE).  Expanding extra isize
> +	 * may move xattrs to external blocks and release ea_inodes via iput.
> +	 * When !SB_ACTIVE, iput triggers write_inode_now() which acquires
> +	 * s_writepages_rwsem, causing a deadlock with the caller's active
> +	 * jbd2 handle (lock order: s_writepages_rwsem -> jbd2_handle).
> +	 */
> +	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE)))
> +		return -EBUSY;
> +
>  	/*
>  	 * In nojournal mode, we can immediately attempt to expand
>  	 * the inode.  When journaled, we first need to obtain extra
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
