Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795176152;
	b=BR/LAHbZZ0WOROBJveLTT0ZXPRjhV7BtTHjhddA/ZCDzbqgSmPQb7WO6Qm8OS9HNCWXN
	 GuDCXIysvYLZ4lCzOUKlFGvgiGqlhHYD/hl+JlsNlhmSpc3GijTK8SPJ/dbVjH3xAmyg3
	 i8KZl1yN3C2z3RpZsVlK4qj7rP2uPtDU7qZkQKBdhikTHv/muFrPqn6mrfS328VRH078S
	 sd+vu3zxepo460O04BfIiYUWcJEcP55HxTUApcVuIWUrXK7r/8cBAH5VZvPEHUyFEbZpi
	 4FtYMNJbCtsA/8t2jKO9EmKFV2+GHqgHSY5xXgSgoMbtswi0S+OVTmg79V2dRTPLs5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795176152;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=5huJ7Tws924tDuhTO1u3kM+nUuh/jHx9kSK9JaKAGoM=;
	b=zaBL3tDchewtKoKTEXeBsWP0n/tfLUy7kDIR8/A9fu4rZfVobgA7JMM3r3Dzn+dx/KSy
	 i85r5i42yErwKfQam4NTssrMrVq1vGQ7FB23Z+9h+DFe9IABqgp9OdiradDGofkaQL0c8
	 pF+Wwx/s60ipBAh9KiFtwjW42PFXXPZflVukfGXP0X019juBjlO1xmITZcTsQHQ8AxGss
	 PxZuoKA8Gl0WFmoy0rFKaRyVRcCMqzw2KOiTDWkFuBrzuag5HiNGBtMYycyLpTTQDJoeY
	 23VUcp8lQFk2maAOR/WHDNSpwhaZu+OVEQx8zYFykREhA9VeUcDfW9YOxPTqFRfaaew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=n6xygOtt;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Yd9J0m1s;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=er9D4iFe;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Zo6dlV6B;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89CD606A331;
	Fri, 20 Nov 2026 12:02:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E89CD606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=n6xygOtt;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Yd9J0m1s;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=er9D4iFe;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Zo6dlV6B
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EC96D221E2;
	Fri, 20 Nov 2026 12:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795176150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5huJ7Tws924tDuhTO1u3kM+nUuh/jHx9kSK9JaKAGoM=;
	b=n6xygOttHH0bGFlyKpj0V4CrIs/GPqK+q1J/2JUTl4XylqnamtNBxACix3gbBisdQEmxnN
	XcAP/UA0l7alpFmXzJY0dRmPYFaKdDYUqE2AMSA9+vu8bZ5hxE89lpoWlEaPbLKsvFPU5n
	k27WPEJQ2OBsMGFyuHk6gxigg6mIzNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795176150;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5huJ7Tws924tDuhTO1u3kM+nUuh/jHx9kSK9JaKAGoM=;
	b=Yd9J0m1s7lkmP0CIjRrkyWIChzjtOZvc6h6o3yFaZKAGuQT6DI+O9EzgX/rIAx+rYLhaPS
	+ALm/nV/iEsrJ4Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795176148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5huJ7Tws924tDuhTO1u3kM+nUuh/jHx9kSK9JaKAGoM=;
	b=er9D4iFeUaAZ43HgDjfY0xS3FuRdmha5ZvYlIV9wwj/5EZtXjLXnlIfCFZeAjkCFInvhvA
	HqgAuuhD5aTY9i9ubZm9Yvm0FHd0Tp++RRjK/Q4PqG6hBPxmqUY81bXhkph+H3mqF9Ywos
	zLj8o4YmW8bgr6XFe3ShGbakQ76htug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795176148;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5huJ7Tws924tDuhTO1u3kM+nUuh/jHx9kSK9JaKAGoM=;
	b=Zo6dlV6BeFZhLpxrmlBlvIERxNoc0OC/heUJueE7vdQxYOkVwJ1VqGXw2F1fCjMCRVc7l8
	Zjk8gV7EyqHLkPCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDABB1348F;
	Fri, 20 Nov 2026 12:02:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JwI4JtQ2AGtSFgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Nov 2026 12:02:28 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 51F2625F42; Fri, 20 Nov 2026 13:02:24 +0100 (CET)
Date: Fri, 20 Nov 2026 13:02:24 +0100
From: Jan Kara <jack@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	guanwentao@uniontech.com, niecheng1@uniontech.com, 
	Morduan Zang <zhangdandan@uniontech.com>
Subject: Re: [PATCH] ext4: keep ordered data and i_disksize consistent on
 size changes
Message-ID: <f5fv5eyvkpeqtopmigq5q7cd6265ptu3jn4xqwglhhsrcxorop@z3buh3cwimvn>
References: <D7EEAE1F0CDD3029+20261118075044.3511841-1-chenyichong@uniontech.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D7EEAE1F0CDD3029+20261118075044.3511841-1-chenyichong@uniontech.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,uniontech.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,uniontech.com:email,suse.com:email]
X-Spam-Score: -11.30

On Wed 18-11-26 15:50:42, Yichong Chen wrote:
> From: Morduan Zang <zhangdandan@uniontech.com>
> 
> ext4 propagates i_size into i_disksize on three size-changing paths:
> ext4_truncate_up(), the shrink branch of ext4_truncate_down(), and
> ext4_truncate() reached from a size-preserving ftruncate().  In ordered
> data mode these paths can commit the new size while data below it is still
> delalloc-only.  Delalloc data has no JBD2 ordered-data registration before
> writeback; the registration done while allocating its blocks cannot
> retroactively protect an earlier size update.
> 
> A crash between the metadata commit and writeback can therefore bring the
> file back with a non-zero size, zero blocks and no extents - the classic
> NULL file that generic/044..046 check for.

Yes, and as the LLM probably told you these checks are failing on ext4 for
ages and no real user complained. Ted may have a different opinion but I
don't think we care about fixing them, in particular given the costs in
complexity of i_size updates and also performance of appending writes /
truncate.

								Honza

> 
> Measured on 7.4.0-rc3 (aebb7274, x86_64, ext4, default mount options) on
> a copy of the xfstests scratch image, 20 files per run, pwrite then
> truncate with no delay in between, sleep 10s, then simulated crash:
> 
>   write  truncate   result before the fix
>   64k    64k        size=65536 blocks=0 no extent    (generic/044)
>   64k    32k        size=32768 blocks=0 no extent    (generic/045)
>   32k    64k        size=65536 blocks=0 no extent    (generic/046)
> 
> Fix both directions:
> 
>  - A truncate that does not change i_size only has to discard preallocated
>    blocks past i_size.  It must not advance i_disksize, so route it to
>    __ext4_truncate(inode, false).  Every other caller (evict, orphan
>    cleanup, verity, real shrink) keeps advancing it, where the orphan list
>    makes the update safe.
> 
>  - When the size really changes, write out the still-delalloc range before
>    i_size/i_disksize are updated, via ext4_ordered_flush_to().  This runs
>    outside any journal handle so writeback can start its own transaction,
>    and before i_size is lowered so writeback still sees the old, larger
>    size.
> 
> Start the writeback at i_disksize, but also search the extent status tree
> for the first delayed extent in the surviving range and use the lower of
> the two.  DIO and fallocate can advance i_disksize over older buffered
> delalloc data, so i_disksize alone is not sufficient to prove that all
> blocks below it exist.  For example, a buffered write followed by an
> extending fallocate and a shrink can otherwise still leave a NULL file.
> 
> The inode and invalidate locks held by ext4_setattr() prevent new delalloc
> extents from appearing.  Concurrent writeback can only remove delayed
> extents or advance i_disksize, making the selected range more conservative.
> Take the i_disksize snapshot under i_data_sem to serialize with writeback
> and avoid a torn 64-bit read on 32-bit systems.  Drop the lock before
> waiting.
> 
> This avoids turning every size change into a whole-file sync point when
> there is no earlier delalloc data.  Inline data needs no separate flush
> because it is committed with the inode itself.
> 
> The new writeback is limited to data=ordered: data=journal already keeps
> data in the journal, and data=writeback never made this guarantee.  The
> size-preserving change applies to all modes and simply avoids advancing
> i_disksize past delalloc data.
> 
> Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
> ---
>  fs/ext4/ext4.h     |  6 ++--
>  fs/ext4/extents.c  | 18 +++++++----
>  fs/ext4/indirect.c |  8 +++--
>  fs/ext4/inode.c    | 75 +++++++++++++++++++++++++++++++++++++++++-----
>  4 files changed, 89 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index bf0325ecbec7..b948a5953760 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3263,7 +3263,8 @@ static inline bool is_special_ino(struct super_block *sb, unsigned long ino)
>  extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
>  				struct ext4_map_blocks *map, int flags);
>  extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks);
> -extern void ext4_ind_truncate(handle_t *, struct inode *inode);
> +extern void ext4_ind_truncate(handle_t *handle, struct inode *inode,
> +			      bool update_disksize);
>  extern int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  				 ext4_lblk_t start, ext4_lblk_t end);
>  
> @@ -3965,7 +3966,8 @@ extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  ext4_lblk_t ext4_determine_insert_hole(struct inode *inode, ext4_lblk_t lblk,
>  				       ext4_lblk_t hole_start,
>  				       ext4_lblk_t hole_len);
> -extern int ext4_ext_truncate(handle_t *, struct inode *);
> +extern int ext4_ext_truncate(handle_t *handle, struct inode *inode,
> +			     bool update_disksize);
>  extern int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
>  				 ext4_lblk_t end);
>  extern void ext4_ext_init(struct super_block *);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index cd35e88bc372..fb5a16e5b176 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4548,7 +4548,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  	return err ? err : allocated;
>  }
>  
> -int ext4_ext_truncate(handle_t *handle, struct inode *inode)
> +int ext4_ext_truncate(handle_t *handle, struct inode *inode,
> +		      bool update_disksize)
>  {
>  	struct super_block *sb = inode->i_sb;
>  	ext4_lblk_t last_block;
> @@ -4560,11 +4561,16 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
>  	 * because page truncation is enough.
>  	 */
>  
> -	/* we have to know where to truncate from in crash case */
> -	__ext4_set_i_disksize(inode, inode->i_size);
> -	err = ext4_mark_inode_dirty(handle, inode);
> -	if (err)
> -		return err;
> +	/*
> +	 * A size-preserving truncate must not expose delalloc-only data by
> +	 * advancing the on-disk size before writeback.
> +	 */
> +	if (update_disksize) {
> +		__ext4_set_i_disksize(inode, inode->i_size);
> +		err = ext4_mark_inode_dirty(handle, inode);
> +		if (err)
> +			return err;
> +	}
>  
>  	last_block = (inode->i_size + sb->s_blocksize - 1)
>  			>> EXT4_BLOCK_SIZE_BITS(sb);
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index a495080df710..d4de88c802b8 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -1126,7 +1126,8 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
>  	}
>  }
>  
> -void ext4_ind_truncate(handle_t *handle, struct inode *inode)
> +void ext4_ind_truncate(handle_t *handle, struct inode *inode,
> +		       bool update_disksize)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	__le32 *i_data = ei->i_data;
> @@ -1158,8 +1159,11 @@ void ext4_ind_truncate(handle_t *handle, struct inode *inode)
>  	 * the new, shorter inode size (held for now in i_size) into the
>  	 * on-disk inode. We do this via i_disksize, which is the value which
>  	 * ext4 *really* writes onto the disk inode.
> +	 *
> +	 * A size-preserving truncate must not advance it past delalloc data.
>  	 */
> -	ei->i_disksize = inode->i_size;
> +	if (update_disksize)
> +		ei->i_disksize = inode->i_size;
>  
>  	if (last_block == max_block) {
>  		/*
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e3129353d4ed..48de9716305f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5410,7 +5410,7 @@ int ext4_inode_attach_jinode(struct inode *inode)
>   * that's fine - as long as they are linked from the inode, the post-crash
>   * ext4_truncate() run will find them and release them.
>   */
> -int ext4_truncate(struct inode *inode)
> +static int __ext4_truncate(struct inode *inode, bool update_disksize)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	unsigned int credits;
> @@ -5483,9 +5483,9 @@ int ext4_truncate(struct inode *inode)
>  	ext4_discard_preallocations(inode);
>  
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> -		err = ext4_ext_truncate(handle, inode);
> +		err = ext4_ext_truncate(handle, inode, update_disksize);
>  	else
> -		ext4_ind_truncate(handle, inode);
> +		ext4_ind_truncate(handle, inode, update_disksize);
>  
>  	up_write(&ei->i_data_sem);
>  	if (err)
> @@ -5516,6 +5516,11 @@ int ext4_truncate(struct inode *inode)
>  	return err;
>  }
>  
> +int ext4_truncate(struct inode *inode)
> +{
> +	return __ext4_truncate(inode, true);
> +}
> +
>  static inline u64 ext4_inode_peek_iversion(const struct inode *inode)
>  {
>  	if (unlikely(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
> @@ -6881,6 +6886,48 @@ static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
>  	up_write(&EXT4_I(inode)->i_data_sem);
>  }
>  
> +/*
> + * Write back delalloc data before covering it with a new on-disk size.
> + *
> + * DIO and fallocate can advance i_disksize over older delalloc extents, so
> + * include the first delayed extent in the surviving range when choosing the
> + * start.  The inode and invalidate locks held by ext4_setattr() prevent new
> + * delalloc extents; concurrent writeback can only remove them and make the
> + * flush more conservative.
> + *
> + * Read i_disksize under i_data_sem to serialize with writeback and avoid a
> + * torn read on 32-bit systems.  Drop the lock before waiting because
> + * writeback needs it to advance i_disksize.
> + *
> + * Inline data is committed with the inode and needs no separate flush.
> + * Must be called without a journal handle and before i_size is lowered.
> + */
> +static int ext4_ordered_flush_to(struct inode *inode, loff_t newsize)
> +{
> +	struct extent_status es;
> +	ext4_lblk_t end_lblk;
> +	loff_t start;
> +
> +	if (!ext4_should_order_data(inode) || ext4_has_inline_data(inode) ||
> +	    newsize <= 0)
> +		return 0;
> +
> +	end_lblk = (newsize - 1) >> inode->i_blkbits;
> +	ext4_es_find_extent_range(inode, ext4_es_is_delayed, 0, end_lblk, &es);
> +
> +	down_read(&EXT4_I(inode)->i_data_sem);
> +	start = EXT4_I(inode)->i_disksize;
> +	up_read(&EXT4_I(inode)->i_data_sem);
> +
> +	if (es.es_len && es.es_lblk <= end_lblk)
> +		start = min(start, EXT4_LBLK_TO_B(inode, es.es_lblk));
> +	if (newsize <= start)
> +		return 0;
> +
> +	return filemap_write_and_wait_range(inode->i_mapping, start,
> +					    newsize - 1);
> +}
> +
>  static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t newsize)
>  {
>  	ext4_lblk_t old_lblk, new_lblk;
> @@ -6900,6 +6947,10 @@ static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t newsize)
>  			return ret;
>  	}
>  
> +	ret = ext4_ordered_flush_to(inode, newsize);
> +	if (ret)
> +		return ret;
> +
>  	handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
> @@ -6931,10 +6982,20 @@ static int ext4_truncate_down(struct inode *inode, loff_t oldsize,
>  	int ret;
>  
>  	/* Do not change i_size. */
> -	if (newsize == oldsize)
> -		goto truncate;
> +	if (newsize == oldsize) {
> +		/*
> +		 * Only blocks past i_size need to be discarded.  Do not advance
> +		 * i_disksize past data that may still be delalloc-only.
> +		 */
> +		truncate_pagecache(inode, newsize);
> +		return __ext4_truncate(inode, false);
> +	}
>  
>  	/* Shrink. */
> +	ret = ext4_ordered_flush_to(inode, newsize);
> +	if (ret)
> +		return ret;
> +
>  	handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
> @@ -6971,11 +7032,9 @@ static int ext4_truncate_down(struct inode *inode, loff_t oldsize,
>  
>  	if (ext4_should_journal_data(inode))
>  		ext4_wait_for_tail_page_commit(inode);
> -truncate:
>  	/*
>  	 * Truncate pagecache after we've waited for commit in data=journal
> -	 * mode to make pages freeable.  Call ext4_truncate() even if
> -	 * i_size didn't change to truncate possible preallocated blocks.
> +	 * mode to make pages freeable.
>  	 */
>  	truncate_pagecache(inode, newsize);
>  	return ext4_truncate(inode);
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
