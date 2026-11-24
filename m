Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795522950;
	b=H9UYXVjNly0rOhyrq7IaUmCswM8es/S0RbStYefMFia9GZOnytS0Wa/3W7N46O3tkgjH
	 7Q2CajwVnpEWgM+NQjBGtKsL/tZrTsJz2AGrKa+zMxSPhSCOu4GjPY5l/9KAGidEQZnZh
	 pIDQBeJ9UVASvy4c2y24y/WkWuyLa5k52qNipQ67LC9r2lncXI8VArPswsL2FjIS9bjPQ
	 prmLcRP0YU7Ql5kMotQICVvTAw/HftDABEbplFVsBT8TOM2UrlnTzKRTZEVUn6XqMn0DV
	 sqD4X5MrMZ0FyfqPBVb50x4hLaSPgcCVKyam5ze9d156dTO7y552DZSYFuhF7HpQl5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795522950;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=R6hT0sEXxq70qmJC4Ay3/znHoUhouxVeqlVmYke492c=;
	b=0CeRo0RdA7dN480mx4tQ7bVyD4rz46PMtgh7aZSYdnSaKqg5JMq5LBl11HoxQdBB3Xnz
	 kZVVyYWm3bW6FBi2X7gdOoH9xndVSm6XIB0G06IBw7A8005/wRzFJYcFsUBpon9FL2+H7
	 WeOlSNkGENA6WPxJZlUDlVp+VFSBnpSaxoYclf6yVwKyNY4vzZuJjtJDAw5+UVhWm3Hiu
	 FQgaZ7wsf6qd3yUKvIPPVwodfoNmKt+CwmrYyTqMIPi02tZ7xZfa4v21Esy4oJadYBdep
	 teSiwNwUD//6cJrdaFwqJJy/xD9k3K2RD6l4t7tm+FmtQAhY+pfDg4t3uogmZ4O0IFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=0dnsUMl8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BPl4Aroa;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=0dnsUMl8;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BPl4Aroa;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3346A606A321;
	Tue, 24 Nov 2026 12:22:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3346A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=0dnsUMl8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BPl4Aroa;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=0dnsUMl8;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BPl4Aroa
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 36DAF2227C;
	Tue, 24 Nov 2026 12:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795522948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R6hT0sEXxq70qmJC4Ay3/znHoUhouxVeqlVmYke492c=;
	b=0dnsUMl8mG9Wyx6WiAQQhsQ7piitGMUyX7Jt889opqYQJVkegwe89J1oHnTEPaNkZ9q4Al
	tnqIxeP5nMUc+uOD3Xm6xcb2MOekDgiCQqKTylK+3pyyeiCp3VPnw10a+8UVdQ5TxXG8HH
	8fhwmmHS6vSLmnXLRDNVf1sFF6RiWgs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795522948;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R6hT0sEXxq70qmJC4Ay3/znHoUhouxVeqlVmYke492c=;
	b=BPl4Aroa8mqJoBhh8QFLNhOSDsEjV7zTIJTqqOhEF2Ax8f3Ri05ZXI4pUblbFq9XtCF4JJ
	D8UiYT7e4pRFjKDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795522948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R6hT0sEXxq70qmJC4Ay3/znHoUhouxVeqlVmYke492c=;
	b=0dnsUMl8mG9Wyx6WiAQQhsQ7piitGMUyX7Jt889opqYQJVkegwe89J1oHnTEPaNkZ9q4Al
	tnqIxeP5nMUc+uOD3Xm6xcb2MOekDgiCQqKTylK+3pyyeiCp3VPnw10a+8UVdQ5TxXG8HH
	8fhwmmHS6vSLmnXLRDNVf1sFF6RiWgs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795522948;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R6hT0sEXxq70qmJC4Ay3/znHoUhouxVeqlVmYke492c=;
	b=BPl4Aroa8mqJoBhh8QFLNhOSDsEjV7zTIJTqqOhEF2Ax8f3Ri05ZXI4pUblbFq9XtCF4JJ
	D8UiYT7e4pRFjKDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 061561339F;
	Tue, 24 Nov 2026 12:22:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hdLKNIOBBWumfAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 12:22:28 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 86B4E27863; Tue, 24 Nov 2026 13:22:27 +0100 (CET)
Date: Tue, 24 Nov 2026 13:22:27 +0100
From: Jan Kara <jack@suse.cz>
To: Hsiu-Hsien Lee <swinds24@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: use unsigned int for inode numbers in fast commit
Message-ID: <dqqtowsnjvknlfh6qaycrl7oz7jg3cfpms5koymsywvimxlmxa@nk5prrb3e6g6>
References: <20261123022309.990044-1-swinds24@gmail.com>
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
In-Reply-To: <20261123022309.990044-1-swinds24@gmail.com>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 23-11-26 10:23:09, Hsiu-Hsien Lee wrote:
> The fast commit code keeps inode numbers in signed int: fcd_parent and
> fcd_ino in struct ext4_fc_dentry_update, the fc_modified_inodes array,
> struct dentry_info_args, the inode number in ext4_fc_replay_inode() and
> the argument of ext4_fc_record_modified_inode() and
> ext4_mark_inode_used().  On a file system with more than 2^31 inodes,
> inode numbers of 2^31 and above become negative.
> 
> In the commit path, fcd_ino is sign-extended when compared with i_ino,
> so the WARN_ON() in ext4_fc_commit_dentry_updates() fires on every
> fsync() of a newly created file with such an inode number.
> 
> In the replay path, the sign-extended value passed to ext4_iget() is
> larger than s_inodes_count, so ext4_iget() reports "iget: illegal
> inode #" and the dentry and inode tags of these inodes are not replayed
> after a crash.
> 
> The on-disk fields are __le32 and converted with cpu_to_le32() and
> le32_to_cpu(), so the journal format does not change.  Also print these
> inode numbers with %u, and print the parent inode number instead of the
> child's when the parent directory of a create is not found.
> 
> Reproducer:
> 
>   dd if=/dev/zero of=img bs=1M count=0 seek=9437184    # 9 TiB sparse
>   mkfs.ext4 -O fast_commit -i 4096 -E lazy_itable_init=1 img
>   mount -o loop,noinit_itable img /mnt
>   mkdir /mnt/d1 ... /mnt/d64    # Orlov spreads them over all groups
>   pick a directory with an inode number >= 2^31, then
>   dd if=/dev/zero of=/mnt/dN/f bs=4k count=1 conv=fsync
> 
> Without this patch every such fsync() triggers the WARN_ON().  With it
> there is no warning, and after EXT4_IOC_SHUTDOWN with
> EXT4_GOING_FLAGS_NOLOGFLUSH following creates, an unlink, a link and an
> append in that directory, all of them are replayed on the next mount and
> e2fsck -fn finds no errors.
> 
> Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Assisted-by: Claude Opus 5.5
> Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Testing: the reproducer and crash test above were run on a 6.6.y
> kernel with this patch backported (the same change apart from context).
> Without the patch, 10 of 10 fsync() calls in a directory with inode
> number 2343567361 triggered the warning; with it, 0 of 10 did in a
> directory with inode number 2313158657, while the fast commit stats
> showed 26 commits and 0 ineligible.  On this tree the
> patch is build-tested only (W=1, CONFIG_EXT4_DEBUG, ext4 KUnit tests).
> 
> The pending KUnit series for fast_commit.c [1] adds stubs and test
> helpers with "int ino" arguments that will need the same type change
> if it lands first.
> 
> [1] https://lore.kernel.org/linux-ext4/20261119155658.1940864-8-tytso@mit.edu/
> 
>  fs/ext4/ext4.h        |  2 +-
>  fs/ext4/fast_commit.c | 28 ++++++++++++++++------------
>  fs/ext4/fast_commit.h |  6 +++---
>  fs/ext4/ialloc.c      |  2 +-
>  4 files changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index aa0f23052..75039cf83 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3067,7 +3067,7 @@ extern int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
>  			  struct dx_hash_info *hinfo);
>  
>  /* ialloc.c */
> -extern int ext4_mark_inode_used(struct super_block *sb, int ino);
> +extern int ext4_mark_inode_used(struct super_block *sb, unsigned int ino);
>  extern struct inode *__ext4_new_inode(const struct mnt_idmap *, handle_t *,
>  				      struct inode *, umode_t,
>  				      const struct qstr *qstr, __u32 goal,
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 5f12449b9..4a066e43e 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -1763,7 +1763,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
>  
>  /* Helper struct for dentry replay routines */
>  struct dentry_info_args {
> -	int parent_ino, dname_len, ino, inode_len;
> +	unsigned int parent_ino, ino;
> +	int dname_len, inode_len;
>  	char *dname;
>  };
>  
> @@ -1814,14 +1815,14 @@ static int ext4_fc_replay_unlink(struct super_block *sb,
>  	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
>  
>  	if (IS_ERR(inode)) {
> -		ext4_debug("Inode %d not found", darg.ino);
> +		ext4_debug("Inode %u not found", darg.ino);
>  		return 0;
>  	}
>  
>  	old_parent = ext4_iget(sb, darg.parent_ino,
>  				EXT4_IGET_NORMAL);
>  	if (IS_ERR(old_parent)) {
> -		ext4_debug("Dir with inode %d not found", darg.parent_ino);
> +		ext4_debug("Dir with inode %u not found", darg.parent_ino);
>  		iput(inode);
>  		return 0;
>  	}
> @@ -1845,7 +1846,7 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
>  
>  	dir = ext4_iget(sb, darg->parent_ino, EXT4_IGET_NORMAL);
>  	if (IS_ERR(dir)) {
> -		ext4_debug("Dir with inode %d not found.", darg->parent_ino);
> +		ext4_debug("Dir with inode %u not found.", darg->parent_ino);
>  		dir = NULL;
>  		goto out;
>  	}
> @@ -1897,7 +1898,8 @@ static int ext4_fc_replay_link(struct super_block *sb,
>   * Record all the modified inodes during replay. We use this later to setup
>   * block bitmaps correctly.
>   */
> -static int ext4_fc_record_modified_inode(struct super_block *sb, int ino)
> +static int ext4_fc_record_modified_inode(struct super_block *sb,
> +					 unsigned int ino)
>  {
>  	struct ext4_fc_replay_state *state;
>  	int i;
> @@ -1907,10 +1909,11 @@ static int ext4_fc_record_modified_inode(struct super_block *sb, int ino)
>  		if (state->fc_modified_inodes[i] == ino)
>  			return 0;
>  	if (state->fc_modified_inodes_used == state->fc_modified_inodes_size) {
> -		int *fc_modified_inodes;
> +		unsigned int *fc_modified_inodes;
>  
>  		fc_modified_inodes = krealloc(state->fc_modified_inodes,
> -				sizeof(int) * (state->fc_modified_inodes_size +
> +				sizeof(*fc_modified_inodes) *
> +				(state->fc_modified_inodes_size +
>  				EXT4_FC_REPLAY_REALLOC_INCREMENT),
>  				GFP_KERNEL);
>  		if (!fc_modified_inodes)
> @@ -1934,7 +1937,8 @@ static int ext4_fc_replay_inode(struct super_block *sb,
>  	struct ext4_inode *raw_fc_inode;
>  	struct inode *inode = NULL;
>  	struct ext4_iloc iloc;
> -	int inode_len, ino, ret, tag = tl->fc_tag;
> +	int inode_len, ret, tag = tl->fc_tag;
> +	unsigned int ino;
>  	struct ext4_extent_header *eh;
>  	size_t off_gen = offsetof(struct ext4_inode, i_generation);
>  
> @@ -2058,7 +2062,7 @@ static int ext4_fc_replay_create(struct super_block *sb,
>  
>  	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
>  	if (IS_ERR(inode)) {
> -		ext4_debug("inode %d not found.", darg.ino);
> +		ext4_debug("inode %u not found.", darg.ino);
>  		inode = NULL;
>  		ret = -EINVAL;
>  		goto out;
> @@ -2071,7 +2075,7 @@ static int ext4_fc_replay_create(struct super_block *sb,
>  		 */
>  		dir = ext4_iget(sb, darg.parent_ino, EXT4_IGET_NORMAL);
>  		if (IS_ERR(dir)) {
> -			ext4_debug("Dir %d not found.", darg.ino);
> +			ext4_debug("Dir %u not found.", darg.parent_ino);
>  			ret = PTR_ERR(dir);
>  			goto out;
>  		}
> @@ -2280,7 +2284,7 @@ ext4_fc_replay_del_range(struct super_block *sb, u8 *val)
>  
>  	inode = ext4_iget(sb, le32_to_cpu(lrange.fc_ino), EXT4_IGET_NORMAL);
>  	if (IS_ERR(inode)) {
> -		ext4_debug("Inode %d not found", le32_to_cpu(lrange.fc_ino));
> +		ext4_debug("Inode %u not found", le32_to_cpu(lrange.fc_ino));
>  		return 0;
>  	}
>  
> @@ -2338,7 +2342,7 @@ static int ext4_fc_set_bitmaps_and_counters(struct super_block *sb)
>  		inode = ext4_iget(sb, state->fc_modified_inodes[i],
>  			EXT4_IGET_NORMAL);
>  		if (IS_ERR(inode)) {
> -			ext4_debug("Inode %d not found.",
> +			ext4_debug("Inode %u not found.",
>  				state->fc_modified_inodes[i]);
>  			continue;
>  		}
> diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
> index 2f77a37fb..446841c4b 100644
> --- a/fs/ext4/fast_commit.h
> +++ b/fs/ext4/fast_commit.h
> @@ -110,8 +110,8 @@ enum {
>   */
>  struct ext4_fc_dentry_update {
>  	int fcd_op;		/* Type of update create / unlink / link */
> -	int fcd_parent;		/* Parent inode number */
> -	int fcd_ino;		/* Inode number */
> +	unsigned int fcd_parent;	/* Parent inode number */
> +	unsigned int fcd_ino;		/* Inode number */
>  	struct name_snapshot fcd_name;	/* Dirent name */
>  	struct list_head fcd_list;
>  	struct list_head fcd_dilist;
> @@ -153,7 +153,7 @@ struct ext4_fc_replay_state {
>  	int fc_crc;
>  	struct ext4_fc_alloc_region *fc_regions;
>  	int fc_regions_size, fc_regions_used, fc_regions_valid;
> -	int *fc_modified_inodes;
> +	unsigned int *fc_modified_inodes;
>  	int fc_modified_inodes_used, fc_modified_inodes_size;
>  };
>  
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 92e2243b9..4ad7a1809 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -817,7 +817,7 @@ static int find_inode_bit(struct super_block *sb, ext4_group_t group,
>  	return 1;
>  }
>  
> -int ext4_mark_inode_used(struct super_block *sb, int ino)
> +int ext4_mark_inode_used(struct super_block *sb, unsigned int ino)
>  {
>  	unsigned long max_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count);
>  	struct buffer_head *inode_bitmap_bh = NULL, *group_desc_bh = NULL;
> 
> base-commit: 008aad6508e30cd1bb6d2c2cf65221ba1f16a065
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
