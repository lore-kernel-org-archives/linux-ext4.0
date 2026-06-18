Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFB13F1AC5
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 14:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792603; cv=none; b=AqZGz0DK6ij7FWee5tNDiraBZGWTfbNKcGYyFaJAuTrQjZJyYerW3pC61rPbccE4Ih1mSdTzr7I6x847w5Ut4bi8zl0QubWWI9G3CFJ9qTyIGStm0LZ2VQ918FFk4h/eUtddHFY6NohtkZFVvKuh+rHZc3rpnjBiqaC1WrkY8Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792603; c=relaxed/simple;
	bh=RkW8V9/AkBLhV7Qstendnrh3Cxozv/GQl0pkAbnT1i4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxZbbwSA5Y+LYhSY0035ppZJ3l/H1oGQemKyAhi5D+b7S/q5rXmiREJNACM61rOIuWxEtPYjDkpx0dPwyPdTbr6PiF+ydbBMFQJYdmXwzsUU/tgQr9XDl4fwvSS67/a4ZjbqFeluNCEVaagOQqVMESePzjYMW7Kq9iPK0UdUfEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zJwGtrVT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=e5EqIvdL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eb7ODAbg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HM2nldvB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zJwGtrVT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="e5EqIvdL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eb7ODAbg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HM2nldvB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 523EB6D3DF;
	Thu, 18 Jun 2026 14:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781792598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=II99zyyMurluio6pQ/cJFUShCMFkTNmTS/JuCle5RZw=;
	b=zJwGtrVTi8KLuYgSGym/dKVVbhFUMxS70msBo6nvbmoEwppD27wyVwEQxVtWve9a5eZv9X
	/hXXXgefnMv7osHB6vSgGSVTnPajEqyZDSwvRyf9hlxkBx1WQ8i1QUIBLSGDUEZPN1Mygk
	LuosnrjbRd1uXya8zZhIx3g4eu1ZowY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781792598;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=II99zyyMurluio6pQ/cJFUShCMFkTNmTS/JuCle5RZw=;
	b=e5EqIvdL8Nwxjj6V8tp7AA71Sria8lOd1W1n09W73GERGqaHZm7/EmiljlPRpVcgt1USa0
	a4W1Rkv+Byt1wsDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781792597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=II99zyyMurluio6pQ/cJFUShCMFkTNmTS/JuCle5RZw=;
	b=eb7ODAbgcQOHpsGA+LJsD+i9fc52lbfX1ihkKuI/PX5hMZUOSiqSt8HZPXbrNUZmQEpixE
	RHgvskLwH6stcAuHgSV+5tU6zNn7XgpjkxzNfNpYcRsJjUKhIITqXS4bh18ZQ7HVsZ44TC
	x/5O4ulyCDjIN2vxqa+kQeE6KaqboWI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781792597;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=II99zyyMurluio6pQ/cJFUShCMFkTNmTS/JuCle5RZw=;
	b=HM2nldvBpuolcZsYtiw32x4Z0/QwTu4mCRwucFXzIIthkYLuk49H4hiBgUuysb4cG6aYje
	NGUc5kVdC0UQ0GDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3AE61779AB;
	Thu, 18 Jun 2026 14:23:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fsZbDlX/M2ptFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 14:23:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D525DA12D9; Thu, 18 Jun 2026 16:23:16 +0200 (CEST)
Date: Thu, 18 Jun 2026 16:23:16 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, ebiggers@google.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ext4: drop s_writepages_rwsem around inline data
 handling in writepages
Message-ID: <rvwzagttciesrgonspk37dm4sxkxxgd7marnwtz5c6cpag747e@wvnqduid6hv7>
References: <20260615061015.1523668-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615061015.1523668-1-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[windriver.com:email,syzkaller.appspot.com:url,appspotmail.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 15-06-26 14:10:15, Yun Zhou wrote:
> ext4_do_writepages() calls ext4_destroy_inline_data() which acquires
> xattr_sem while s_writepages_rwsem is held (read).  This creates a
> circular lock dependency:
> 
>   CPU0                               CPU1
>   ----                               ----
>   ext4_writepages()
>     ext4_writepages_down_read()
>       [holds s_writepages_rwsem]
>                                      ext4_evict_inode()
>                                        __ext4_mark_inode_dirty()
>                                          ext4_expand_extra_isize_ea()
>                                            ext4_xattr_block_set()
>                                              [holds xattr_sem]
>                                              iput(old_bh inode)
>                                                write_inode_now()
>                                                  ext4_writepages()
>                                                    ext4_writepages_down_read()
>                                                    [BLOCKED on s_writepages_rwsem]
>     ext4_do_writepages()
>       ext4_destroy_inline_data()
>         down_write(xattr_sem)
>         [BLOCKED on xattr_sem]

You have fixed this differently (not expanding extra isize from
ext4_evict_inode()) and furthermore this scenario is really impossible
because you cannot be inside ext4_writepages() on inode that's undergoing
eviction. SO let's discard this patch.

								Honza

> 
> Fix by temporarily dropping s_writepages_rwsem for the entire inline
> data handling block, including the journal handle start/stop.  The
> rwsem must be dropped before ext4_journal_start() -- not between
> journal_start and journal_stop -- to avoid a secondary deadlock with
> ext4_change_inode_journal_flag() which takes rwsem (write) and then
> calls jbd2_journal_lock_updates() waiting for active handles to stop.
> 
> This is safe because:
> 
>  - This code runs before any block mapping or IO submission, so no
>    writepages state depends on the rwsem being held at this point.
> 
>  - Inline data destruction is a one-way format transition (once cleared,
>    EXT4_INODE_INLINE_DATA is never set again).  The rwsem is
>    re-acquired after journal_stop, ensuring format stability for the
>    remainder of writepages.
> 
>  - The can_map flag identifies the ext4_writepages() path (holds rwsem)
>    vs ext4_normal_submit_inode_data_buffers() (does not), so the
>    drop/reacquire is skipped when the rwsem is not held.
> 
> Also check the return value of ext4_destroy_inline_data() to avoid
> proceeding with an inconsistent inode format on failure.
> 
> Reported-by: syzbot+bb2455d02bda0b5701e3@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bb2455d02bda0b5701e3
> Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
> v3: Drop s_writepages_rwsem before ext4_journal_start() and reacquire
>     after ext4_journal_stop(), instead of dropping between journal_start
>     and journal_stop as in v2.  This avoids two issues identified in v2
>     review:
>     - memalloc_nofs_restore() in ext4_writepages_up_read() would clear
>       PF_MEMALLOC_NOFS while the jbd2 handle is active.
>     - Reacquiring s_writepages_rwsem while holding a handle creates an
>       ABBA deadlock with ext4_change_inode_journal_flag() which takes
>       the rwsem (write) then calls jbd2_journal_lock_updates().
> 
> v2: Instead of moving inline data handling to ext4_writepages(),
>     temporarily drop s_writepages_rwsem around ext4_destroy_inline_data()
>     in ext4_do_writepages(). The move approach had a race where concurrent
>     writes could create dirty pages with inline data after the early check,
>     and unconditional destruction without dirty pages would lose data.
> 
> v1: Moved inline data cleanup from ext4_do_writepages() to
>       ext4_writepages() before acquiring s_writepages_rwsem.
> 
>  fs/ext4/inode.c | 31 ++++++++++++++++++++++++++-----
>  1 file changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..cd7588a3fa45 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1694,6 +1694,9 @@ struct mpage_da_data {
>  	struct writeback_control *wbc;
>  	unsigned int can_map:1;	/* Can writepages call map blocks? */
>  
> +	/* Saved memalloc context from ext4_writepages_down_read() */
> +	int alloc_ctx;
> +
>  	/* These are internal state of ext4_do_writepages() */
>  	loff_t start_pos;	/* The start pos to write */
>  	loff_t next_pos;	/* Current pos to examine */
> @@ -2816,16 +2819,35 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
>  	 * we'd better clear the inline data here.
>  	 */
>  	if (ext4_has_inline_data(inode)) {
> -		/* Just inode will be modified... */
> +		/*
> +		 * Temporarily drop s_writepages_rwsem because
> +		 * ext4_destroy_inline_data() acquires xattr_sem, which has
> +		 * a higher lock ordering rank.  Holding both would create a
> +		 * circular dependency with ext4_xattr_block_set() -> iput()
> +		 * -> ext4_writepages() -> s_writepages_rwsem.
> +		 *
> +		 * Drop the rwsem before starting the journal handle to also
> +		 * avoid a deadlock with ext4_change_inode_journal_flag(),
> +		 * which takes rwsem (write) then jbd2_journal_lock_updates().
> +		 */
> +		if (mpd->can_map)
> +			ext4_writepages_up_read(inode->i_sb, mpd->alloc_ctx);
>  		handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
>  		if (IS_ERR(handle)) {
> +			if (mpd->can_map)
> +				mpd->alloc_ctx =
> +					ext4_writepages_down_read(inode->i_sb);
>  			ret = PTR_ERR(handle);
>  			goto out_writepages;
>  		}
>  		BUG_ON(ext4_test_inode_state(inode,
>  				EXT4_STATE_MAY_INLINE_DATA));
> -		ext4_destroy_inline_data(handle, inode);
> +		ret = ext4_destroy_inline_data(handle, inode);
>  		ext4_journal_stop(handle);
> +		if (mpd->can_map)
> +			mpd->alloc_ctx = ext4_writepages_down_read(inode->i_sb);
> +		if (ret)
> +			goto out_writepages;
>  	}
>  
>  	/*
> @@ -3032,13 +3054,12 @@ static int ext4_writepages(struct address_space *mapping,
>  		.can_map = 1,
>  	};
>  	int ret;
> -	int alloc_ctx;
>  
>  	ret = ext4_emergency_state(sb);
>  	if (unlikely(ret))
>  		return ret;
>  
> -	alloc_ctx = ext4_writepages_down_read(sb);
> +	mpd.alloc_ctx = ext4_writepages_down_read(sb);
>  	ret = ext4_do_writepages(&mpd);
>  	/*
>  	 * For data=journal writeback we could have come across pages marked
> @@ -3047,7 +3068,7 @@ static int ext4_writepages(struct address_space *mapping,
>  	 */
>  	if (!ret && mpd.journalled_more_data)
>  		ret = ext4_do_writepages(&mpd);
> -	ext4_writepages_up_read(sb, alloc_ctx);
> +	ext4_writepages_up_read(sb, mpd.alloc_ctx);
>  
>  	return ret;
>  }
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
