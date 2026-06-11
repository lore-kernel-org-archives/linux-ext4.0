Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C25E349AF5
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 14:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186447; cv=none; b=GApa05rfOzMTQ5RsFQpeJ5r7IKunXeK7Fd+XzOF0bd3vbFt2c2HybUy9tYco6rz8H+wTHWIIS9C2Q7cBX0QrAfCk9tz/OCc711CwbJ5GFn09tN6wPAbGn+5O5Wxsc/JqfJDFxvnsYesH8zzGSlo/Ucua8BoNesCQ8/ixKOuZovM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186447; c=relaxed/simple;
	bh=iw9SC6V+7Yz7N7KBE23m3KU+raydMFE6hhUPzxhZsRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OvGkvo4cuMKOyq/k3gwAE/mo+fFNxMZWAYoUc+Y+5YePpOc7pAl0UevboE/dsBeG5be52poqwrBMWZ4Oou7XhJd8WoPhHka6PTnQqVkWcF8DvG2J9uRDzXaDVLyXD0CDE2kdv+15AFD5ZnXJJS+89vvkbInymHycPIEkwsfovEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DLDreELY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jZqe51xn; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MT/nL814; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=n8qit331; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DLDreELY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jZqe51xn";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MT/nL814";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="n8qit331"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CBAB975A0A;
	Thu, 11 Jun 2026 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781186443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4/SuR58P3q0Yvz8xrjXc6gS/6A8rqTjf1sih/Xxn60=;
	b=DLDreELY2WryETpPPIj/kzHctRukDTxC8x086nLsR+Q2OhPlv9oiFVfs38IL2bzw0fW3WC
	veVvVdzneuHWDMV3bQuINZR4ShilRo+R5fSm14adNsqgH8IOKCCJAB0w6tQB6vvOsTfjwv
	y7WGakUeWvZHfBthfA/g3j5GuOMj4h0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781186443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4/SuR58P3q0Yvz8xrjXc6gS/6A8rqTjf1sih/Xxn60=;
	b=jZqe51xnZx4Tl9Fj9WVwMx7ShDa9Trii0h+fFVd06WpAn9Z6orcNBvL0ehiMgfMfw3CVkq
	bSlVHmOlpl17L8CQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781186438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4/SuR58P3q0Yvz8xrjXc6gS/6A8rqTjf1sih/Xxn60=;
	b=MT/nL814w1lncImiUBFxmynQXO2QTOhUgs/6V8kZ4TwhdaWmAEuQJjtBMZx8rJLm6Yrj4i
	xGacXeTrp+PEWylPZTHgiFcAwwZB7MZKn72Tkxo+EqdUIFLfnAhGXVytTHoryDruKUCCl3
	FaG4LocMmzV8o0TeqshUa2wkPtjLT8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781186438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4/SuR58P3q0Yvz8xrjXc6gS/6A8rqTjf1sih/Xxn60=;
	b=n8qit331XVrGIJRqABb22D+oIH+CAuFq8v/FlK07JLckGcEz8q9D+Ga+8CBnqYP10SEUTf
	IwhM2pLoLm1iktCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF56B779A7;
	Thu, 11 Jun 2026 14:00:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WT20Loa/KmroNAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 11 Jun 2026 14:00:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 58692A10CE; Thu, 11 Jun 2026 16:00:38 +0200 (CEST)
Date: Thu, 11 Jun 2026 16:00:38 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, ebiggers@google.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: skip extra isize expansion on inode eviction to
 avoid deadlock
Message-ID: <mbd5snu2qbgh662fpzfns6rw2knaixfzzwyv3tqtxw7zikazuh@455h5nfbdfcl>
References: <20260611124555.1541195-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611124555.1541195-1-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,google.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,suse.com:email,imap1.dmz-prg2.suse.org:helo,windriver.com:email,appspotmail.com:email]
X-Spam-Level: 

On Thu 11-06-26 20:45:55, Yun Zhou wrote:
> Expanding extra isize on an inode that is being evicted is pointless
> since the inode is about to be deleted.  Skip it by setting
> EXT4_STATE_NO_EXPAND before calling ext4_mark_inode_dirty() in the
> eviction path.
> 
> This also breaks a circular lock dependency reported by lockdep during
> orphan cleanup at mount time:
> 
>   CPU0 (writeback worker)            CPU1 (open)
>   ----                               ----
>   ext4_writepages()
>     s_writepages_rwsem (read)        ext4_create()
>     ext4_do_writepages()               __ext4_new_inode()
>       ext4_journal_start()               [holds jbd2 handle]
>         wait_transaction_locked()        ext4_xattr_set_handle()
>         [WAIT for jbd2_handle]             xattr_sem (write)
> 
>   CPU2 (mount / orphan cleanup)
>   ----
>   ext4_evict_inode()
>     __ext4_mark_inode_dirty()
>       ext4_try_to_expand_extra_isize()
>         xattr_sem (write)
>         ext4_expand_extra_isize_ea()
>           ext4_xattr_block_set()
>             iput(ea_inode)
>               write_inode_now()
>                 ext4_writepages()
>                   s_writepages_rwsem (read)
>                   [WAIT for s_writepages_rwsem -- if blocked by write lock holder]
> 
> This forms a circular dependency on lock classes:
> 
>   s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem
> 
> The iput() inside ext4_xattr_block_set() triggers write_inode_now()
> because SB_ACTIVE is not yet set during mount, so iput_final() cannot
> cache the inode in the LRU and must flush it synchronously.
> 
> Setting EXT4_STATE_NO_EXPAND prevents ext4_try_to_expand_extra_isize()
> from executing, which eliminates the xattr_sem --> s_writepages_rwsem
> edge and breaks the cycle.
> 
> Reported-by: syzbot+5d19358d7eb30ffb0cc5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5
> Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Thanks for the patch! So I have no problem with setting EXT4_STATE_NO_EXPAND
in ext4_evict_inode() as you correctly point out expansion is pointless in
that case. But your patch actually doesn't fix the real problem, it only
deals with the particular syzbot reproducer. The real problem is that
ext4_xattr_block_set() which is run inside a transaction can end up
acquiring s_writepages_rwsem which violates the lock ordering rules. So
this is the problem that really needs to be fixed.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
