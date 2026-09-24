Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF023BB685;
	Thu, 24 Sep 2026 16:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790266715; cv=none; b=VFqpoLSV+yH/COj7bv9hnfTr2fNnWgy/czKTN7rdfsD7dDcroFudjzZ+15Iqc7jgb1C8YmvjY6htfaRap6ZE22smMFZr1ZZBqJ61KQN4t7BuS/+uiDP0JJ7sBIAMqBun4DOIwejWBdQTac+TNZhSjqPhreAm8dLIoZe22h8HPo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790266715; c=relaxed/simple;
	bh=0UcMB9VHP182vjsKMkuvvKiqYUIhlYUMNjHLwepaFbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lr4I4wOSFqQE00d/j1efXaM7okftZ+a8VXTSIbsD43xpz2z8l6E1mIf+DYvi/Ef/h3urfL4pKXXw0h7oyfocf5C6CEt3XztyOVH5pF0E4XkV2/6Qxe/b9xp5ZI8CVV3i+1Q6RYveifMgnAbb++rpDFdY/DAdpr7OfjsJqfN8vX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OqRBrfgB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Py77iOzd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1LlfVSJM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3Q5EIbn2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OqRBrfgB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Py77iOzd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1LlfVSJM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3Q5EIbn2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D7BD92012E;
	Thu, 24 Sep 2026 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790266707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k6GENelRec11w7vFQTzFte6lp68OrJXDaRseQtXtvFk=;
	b=OqRBrfgBVvrlgsi9aZxfV/2BRDzFFKRxxr8cnVSlWdSeTIzr0rSW8Fo3J/Kl0pN81UrR+r
	P4o1PWL83bgMSYmnKlo8Lv1z8w0wKrgdOw+r+c6BLti6uLLBd/JwMGBEa/VeKMyZ3BM6cI
	XTy5lVYhV3vX+0F9f8xT+zXa2fXdTJA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790266707;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k6GENelRec11w7vFQTzFte6lp68OrJXDaRseQtXtvFk=;
	b=Py77iOzdAKjekEvTgUHJWccKVN1JfhgmSoF1s8eIzowDzI9w6jnKAvVcoD1hYUTMY07/mA
	uWrUQUAk79yd9wBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790266702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k6GENelRec11w7vFQTzFte6lp68OrJXDaRseQtXtvFk=;
	b=1LlfVSJMBBgTw4S3eip9ToKuVONzOUWprsk1aaf1zTSvnTD1e2AoBFZBnJdRKlmbEPrOby
	+dqzvm3JEeSZRj0JPI4K0Hkr/nBjrw8ZK2jnumGm4tQ5ADsMGGrEp5tdVMclb/PpwSHfsF
	eom1fQ81hF/fGsKS0G1OLQcIex+oVl4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790266702;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k6GENelRec11w7vFQTzFte6lp68OrJXDaRseQtXtvFk=;
	b=3Q5EIbn2MsUlTCkTv5LGQncz6AtSweLvPR1NJAOd1sLYp5rlhtjBoe4tf3dUAQio0p6LGI
	lFzTQv7JLWOYe3AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A228D13354;
	Thu, 24 Sep 2026 16:18:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AkPmHk5NtWonbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 16:18:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2D1DDA132E; Thu, 24 Sep 2026 18:18:18 +0200 (CEST)
Date: Thu, 24 Sep 2026 18:18:18 +0200
From: Jan Kara <jack@suse.cz>
To: Sandeep Dhavale <dhavale@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>, kernel-team@android.com, 
	stable@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix race between inline dir conversion and folio
 read
Message-ID: <2ednz67kpd2ikrnerrmnvol2mdfntgqhakuoiu7x4cnrlpiugm@ojqolvlfmpnj>
References: <20260918025416.604297-1-dhavale@google.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918025416.604297-1-dhavale@google.com>
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,android.com,vger.kernel.org,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]

On Thu 17-09-26 19:54:15, Sandeep Dhavale wrote:
> Commit 90f097b1403f ("ext4: refactor the inline directory conversion and
> new directory codepaths") moved directory block initialization in
> ext4_convert_inline_data_nolock() into ext4_init_dirblock(), unlocking
> data_bh before setting BH_Uptodate.
> 
> When block size is smaller than PAGE_SIZE, multiple buffer heads share a
> single block device folio. If a concurrent read on that folio runs via
> block_read_full_folio() while data_bh is unlocked and not uptodate, it
> locks data_bh and submits a disk read for the uninitialized block.
> 
> Because ext4_init_dirblock() initializes bh->b_data without holding the
> buffer lock, the disk read races with and overwrites the initialized
> directory entries and checksum tail, corrupting the directory block:
> 
>   EXT4-fs warning: ext4_dirblock_csum_verify:375: inode #...:
>     No space for directory leaf checksum. Please run e2fsck -D.
>   EXT4-fs error: __ext4_find_entry:1626: inode #...:
>     checksumming directory block 0
> 
> To fix this, mark data_bh uptodate before unlocking it in
> ext4_convert_inline_data_nolock(), just like the regular file path
> does. Additionally, hold lock_buffer(bh) in ext4_init_dirblock() while
> populating the directory entries and checksum tail so any buffer
> modifications are properly serialized.
> 
> Fixes: 90f097b1403f ("ext4: refactor the inline directory conversion and new directory codepaths")
> Cc: stable@vger.kernel.org
> Assisted-by: Antigravity:gemini-3.8-flash
> Signed-off-by: Sandeep Dhavale <dhavale@google.com>

Good catch! At least the first paragraph below would be also useful in the
commit changelog - the realworld impact is important information. But I
guess Ted can modify the changelog on commit if he wants. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Note:
> This issue was reported by an Android partner encountering kernel panics
> in ext4_dirblock_csum_verify() ("No space for directory leaf checksum")
> on 16KB page size kernels mounting a 4KB block size ext4 filesystem.
> 
> We verified with a standalone reproducer that the race reproduces
> deterministically on Iteration 0 (< 1s) on both ARM64 (16KB page size,
> 4KB ext4 blocks) and upstream ext4-tree/dev on x86_64 (4KB page size,
> 1KB ext4 blocks), and confirmed that this patch resolves the issue.
> 
>  fs/ext4/inline.c | 1 +
>  fs/ext4/namei.c  | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482..0aa14cee3310 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1167,6 +1167,7 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
>  		error = ext4_handle_dirty_metadata(handle,
>  						   inode, data_bh);
>  	} else {
> +		set_buffer_uptodate(data_bh);
>  		unlock_buffer(data_bh);
>  		inode->i_size = inode->i_sb->s_blocksize;
>  		i_size_write(inode, inode->i_sb->s_blocksize);
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 3b9740c1c16d..6550102fb56b 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2933,6 +2933,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
>  	if (ext4_has_feature_metadata_csum(inode->i_sb))
>  		csum_size = sizeof(struct ext4_dir_entry_tail);
>  
> +	lock_buffer(bh);
>  	de->inode = cpu_to_le32(inode->i_ino);
>  	de->name_len = 1;
>  	de->rec_len = ext4_rec_len_to_disk(ext4_dir_rec_len(de->name_len, NULL),
> @@ -2965,6 +2966,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
>  	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
>  	set_buffer_uptodate(bh);
>  	set_buffer_verified(bh);
> +	unlock_buffer(bh);
>  	return ext4_handle_dirty_dirblock(handle, inode, bh);
>  }
>  
> -- 
> 2.55.0.1082.g2b9226bbc0-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
