Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6579841930D
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 12:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781009176; cv=none; b=r3Zn/wGAhMDsETXh2xX3n3zuq/xMz4ytPL2qzUYU2UuAokisUDwHNmkNKZjYDSqQFEA6CvW7ueJdVFAj22Su93KvcbLZF5hEleSr98e+NLNryIe4W/yDoh2U8C63JT1VZRrmI6qVrBWaBnQvYaFKXYXbi/vkxhjbezCYlrahZr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781009176; c=relaxed/simple;
	bh=fE3eZVBnWeB9ahFjyWgxpCCLEo11IT0jOjnbajak6Wk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kkqmr552AkuXRAXtCpYq+MNf1H1zBgKSF33cmAgAzyy1eR+Wh2hvJUO3dwhaUf1HQ2/jS4LaQZ07PI0FDecln0wx4vglHB1vPCwN25291gX8/1QNU961Rp1ASTzm1d/ncsRoOXrKbCWhY4HdIy2S6pW1ww3sGsGlBz3yfqRTC4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MHOs6ZMS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=whSOL94V; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rYpANsnI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0Mys4V4/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MHOs6ZMS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="whSOL94V";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rYpANsnI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0Mys4V4/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A1CE96AC26;
	Tue,  9 Jun 2026 12:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781009172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lFjhoDkKfP9T+VfW5xMOmX7DwEy3VQJf66luBo3J/r0=;
	b=MHOs6ZMStkF9YaD+6v5hMc7TVsl+9XDddefDEVPLxHcQuDGGdCpzfJrP6jRSnljSieOgSt
	hj5HHHuBnHvBnFktBI/zPjVwSnzrCX3BUXXy6+Gdg1p/EX0AKJe96K1AUn3EaMuHhOGRgE
	TVe3AsoFIDgSA5YeTg5owY76TiZ42hk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781009172;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lFjhoDkKfP9T+VfW5xMOmX7DwEy3VQJf66luBo3J/r0=;
	b=whSOL94VCBdtHZEBt4Qni88O9OTtAFa6vEUTtYFUrityUui+YtM/NDeENa5iHuBilFu0UQ
	y9tDYi9uPw6YsjDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781009168; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lFjhoDkKfP9T+VfW5xMOmX7DwEy3VQJf66luBo3J/r0=;
	b=rYpANsnIJolYaU0YHWFyIgrzoma1o/or5n8MxgtYpjtbORTk1f77QSEd8VrQhEkB9Wg4O/
	xIy3p/tv2rUDN0EPuy3SJjme842Q6hp+NauOuOyKXb1aZ90TU//smgY+TNccM85mjMAveB
	2ehV3vPOHFH+52CTv9RXTDMmwz9PCVI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781009168;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lFjhoDkKfP9T+VfW5xMOmX7DwEy3VQJf66luBo3J/r0=;
	b=0Mys4V4/W7UTKRQiJr34LUrwsnzK5MAYXAZ23hZK35gU6ma0cahfMSIduTbzZWOKUk/Wky
	GT4BibokhKZV4DAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93AD2779A7;
	Tue,  9 Jun 2026 12:46:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v0sEJBALKGqAaQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 12:46:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 31E5EA0A90; Tue, 09 Jun 2026 14:46:04 +0200 (CEST)
Date: Tue, 9 Jun 2026 14:46:04 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, sashiko-reviews@lists.linux.dev, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] ext4: fix kernel BUG in ext4_write_inline_data_end
Message-ID: <o3k4wongcbuacu4rjsb7h2utzsrhpnun55vzdnp46imnlbn5x6@matvyu6j2xhc>
References: <20260609062005.1702-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609062005.1702-1-aditya.ansh182@gmail.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,iloc.bh:url];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[0c89d865531d053abb2d];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,lists.linux.dev,vger.kernel.org,syzkaller.appspotmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,iloc.bh:url,syzkaller.appspot.com:url,appspotmail.com:email,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Tue 09-06-26 06:20:05, Aditya Prakash Srivastava wrote:
> When the data=journal mount option is used, the ext4_journalled_write_end()
> function incorrectly calls ext4_write_inline_data_end() without checking
> if the EXT4_STATE_MAY_INLINE_DATA flag is still set on the inode.
> 
> If a previous attempt to convert the inline data to an extent failed (e.g.
> due to ENOSPC), the EXT4_STATE_MAY_INLINE_DATA flag is cleared, but
> the EXT4_INODE_INLINE_DATA flag remains set. In this scenario, the next
> call to ext4_write_begin() will not prepare the inline data xattr for
> writing, but ext4_journalled_write_end() will incorrectly attempt to write
> to it, triggering a BUG_ON(pos + len > EXT4_I(inode)->i_inline_size) in
> ext4_write_inline_data() since i_inline_size was not expanded.
> 
> Additionally, two separate TOCTOU race conditions exist due to concurrent
> ext4_page_mkwrite() execution:
> 1) A concurrent ext4_page_mkwrite() can execute ext4_convert_inline_data()
> between write_begin and write_end, clearing the inline flags. Since block
> buffers were not allocated in write_begin, this results in a NULL pointer
> dereference in the write_end fallback paths because folio_buffers(folio) is
> NULL.
> 2) If ext4_convert_inline_data() clears the flags exactly after the inline
> flags checks pass in write_end, but before ext4_write_inline_data_end()
> acquires the xattr semaphore, the subsequent check will hit a panic via
> BUG_ON(!ext4_has_inline_data(inode)).

Yes, locking of inline data writes is broken (and difficult to fix). Your
v1 patch was actually simple and obvious improvement of the situation.
These additional fixes belong into separate patches.

> Fix these issues completely by:
> 1) Having write_end functions (ext4_write_end(),
> ext4_journalled_write_end(), and ext4_da_do_write_end()) return 0
> (VFS retry) if they fall through to the block fallback path and detect
> that folio_buffers(folio) is NULL, after safely stopping any active
> journal handle (protecting against a NULL handle panic in
> ext4_put_nojournal()).
> 2) Replacing BUG_ON(!ext4_has_inline_data(inode)) inside
> ext4_write_inline_data_end() with a graceful error path. If the inline flag
> is cleared after locking the xattr, we unlock the xattr, release the iloc,
> unlock/put the folio, stop the journal, and return 0 to trigger a retry.
> 
> Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
> Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> ---
> v4:
>   - Address critical TOCTOU race condition (reported by Sashiko AI review):
>     * Scenario: A buffered write holds the folio lock and evaluates the inline
>       flags checks in write_end to true. Before it enters or locks the xattr_sem
>       in ext4_write_inline_data_end(), a concurrent memory-mapped page fault
>       (ext4_page_mkwrite()) converts the inline data to an extent. This page fault
>       bypasses the folio lock (since ext4_convert_inline_data() runs lockless),
>       acquires the xattr_sem, and clears the inline flags. When the buffered write
>       resumes and enters ext4_write_inline_data_end(), it acquires the xattr_sem
>       and immediately triggers BUG_ON(!ext4_has_inline_data(inode)) causing a
>       kernel panic.
>     * Fix: Replace the BUG_ON() with a graceful error-handling retry path that
>       releases all resources (locks/buffers/folios/journals) and returns 0.
> v3:
>   - Fix journal handle leak and NULL handle crash (reported by Sashiko AI review):
>     * Scenario 1 (leak): During a delayed allocation write (ext4_da_write_begin),
>       inline data was prepared and a transaction handle started. If a concurrent
>       page fault converts the inline data before write_end, ext4_da_write_end()
>       falls through to ext4_da_do_write_end(). If the fallback check for
>       !folio_buffers(folio) returns 0 to retry without calling ext4_journal_stop(),
>       the transaction handle is leaked open-ended, eventually hanging the filesystem.
>     * Scenario 2 (crash): If we blindly call ext4_journal_stop() on a NULL handle
>       (e.g., when no transaction was started because we never took the inline path),
>       __ext4_journal_stop() delegates to ext4_put_nojournal(NULL) which triggers
>       BUG_ON(ref_cnt == 0), panicking the kernel.
>     * Fix: Retrieve the active handle in ext4_da_do_write_end() and stop it
>       if non-NULL. Also explicitly check "if (handle)" before calling
>       ext4_journal_stop() in ext4_write_end() and ext4_journalled_write_end().
> v2:
>   - Address TOCTOU race condition (reported by Sashiko AI review):
>     * Scenario: A concurrent ext4_page_mkwrite() converts inline data to extents
>       and clears the flags between ext4_write_begin() and write_end(). The
>       write_end function falls through to the block fallback path. Since block
>       buffers were not allocated in write_begin (because it took the inline path),
>       folio_buffers(folio) is NULL, causing a NULL pointer dereference in
>       ext4_journalled_zero_new_buffers() or ext4_walk_page_buffers(), or silent
>       data loss in the standard write path.
>     * Fix: Have the write_end functions return 0 if folio_buffers(folio) is NULL,
>       triggering a safe VFS-level retry. On the next write attempt, the inline
>       flags will be detected as cleared, and blocks/buffers will be properly allocated.
>  fs/ext4/inline.c |  9 ++++++++-
>  fs/ext4/inode.c  | 24 ++++++++++++++++++++++--
>  2 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 8045e4ff270c..161136e84661 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -812,7 +812,14 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
>  			goto out;
>  		}
>  		ext4_write_lock_xattr(inode, &no_expand);
> -		BUG_ON(!ext4_has_inline_data(inode));
> +		if (unlikely(!ext4_has_inline_data(inode))) {
> +			ext4_write_unlock_xattr(inode, &no_expand);
> +			brelse(iloc.bh);
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			ext4_journal_stop(handle);
> +			return 0;
> +		}

This deserves a comment before the 'if' that we could have raced with
ext4_page_mkwrite() converting the inode and so we just retry the whole
write.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..bc2688e03c19 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1455,6 +1455,14 @@ static int ext4_write_end(const struct kiocb *iocb,
>  		return ext4_write_inline_data_end(inode, pos, len, copied,
>  						  folio);
>  
> +	if (unlikely(!folio_buffers(folio))) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		if (handle)
> +			ext4_journal_stop(handle);
> +		return 0;
> +	}
> +

Ouch, this is a crude hack. I think much cleaner solution would be for
ext4_write_begin() to set in fsdata in what state it prepared the inode
(inline, extent based) - we already use that mechanism to communicate some
state for delayed allocations. Then ->write_end handler will use fsdata
(not inode state) to determine what function to call. IMHO the code will be
much more obvious that way.

> @@ -3231,7 +3248,10 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>  	if (unlikely(!folio_buffers(folio))) {
>  		folio_unlock(folio);
>  		folio_put(folio);
> -		return -EIO;
> +		handle = ext4_journal_current_handle();
> +		if (handle)
> +			ext4_journal_stop(handle);
> +		return 0;
>  	}
>  	/*
>  	 * block_write_end() will mark the inode as dirty with I_DIRTY_PAGES

Huh, what is this about? It definitely looks very suspicious...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
