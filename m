Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793955764;
	b=BepFDJh0nd5PPukHEzxHlUvuD8ic5UVycY+3K6ednqhF++pF89HPxz6UNQZMC+LuOFKJ
	 a6km06aNVkPFlSyGyrjL0EJ87i0ecyag2/ybOV2dvEDv9w5jo4eZcA+rBp6R8/yOxzHus
	 1OoFKpKvNCe0ef2CQGTEu8o4HicxDodzpcaR6ujXQk7kfE7TBqd0uJ8tv3lN17jDfdoHK
	 aDL0gkXt10pVtuwtqBQCQNSxY67h6IDbRwCxJRkvHwmmkS3UXepzA/GRDM5m1W4PHn/PU
	 2YCN5r/+kY8Auuw1ENbOUcWJt2slvoqNm1BuAF8cTCMd7xsV7+NuHaxWvs2SZe5dE6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793955764;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=ALdFdZ6+XY0jKUDGRwksVl7+1ksycMukEjQ+VH6YWbA=;
	b=LFn5ZAf2fbaWjGq0+vTw3isNmRvD/7HfVHNMEAoJyfdF47CCPi+YnWkYgUQrfNe+IjJ4
	 m0+jcf3lF8INEKojEPnVd1jdl8blhT+nAjFHH1ai73Yktsc2cyHqdUkuIwFmfkW5zIhmu
	 cyFJpHfTKM5dLCKiPNWjws8jCINfNUpt5at+s2mNqPqhn4DHfioqZ2PTl3/F51w2uDj52
	 6NhUBO52n3qFa4yuitdY5xXcOkgZkJtAEEOWycvjjmvLf+OJ5OU4fIuNdRO+s8j46M6qr
	 IiRwYCaX+ISbZ0nge+mKhg7K0b7etcYLruety40NSFJh12mO3m5ViqT4HS/laDWyDBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SX2fVyuV;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mJNxzkAN;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SX2fVyuV;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mJNxzkAN;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A52E606A326;
	Fri,  6 Nov 2026 09:02:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A52E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SX2fVyuV;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mJNxzkAN;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SX2fVyuV;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mJNxzkAN
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A059F1FB40;
	Fri,  6 Nov 2026 09:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793955760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ALdFdZ6+XY0jKUDGRwksVl7+1ksycMukEjQ+VH6YWbA=;
	b=SX2fVyuVtoPwxvPoZpu/rLyHzwwJxZelu9El9uXdguc0UGKOiRqyTWzf0HCsNw1U7Umtrv
	3/c9nMdXORO/szn6miFO71ct0uiZsP3VamPlqXnkbX+Tf7OlSpJR/kYN+ZVZzh2iycd/NA
	2FYUa2SrmHyVt5ELB3oRrjN1qpx9emY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793955760;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ALdFdZ6+XY0jKUDGRwksVl7+1ksycMukEjQ+VH6YWbA=;
	b=mJNxzkANideHlOtwSVxjkdcY6b6vnI+1eSB9+PDk2hJDrCB9NPf+YZ6T8gpYaxtkuUSv29
	9ULPxL4ZKG0dUMCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793955760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ALdFdZ6+XY0jKUDGRwksVl7+1ksycMukEjQ+VH6YWbA=;
	b=SX2fVyuVtoPwxvPoZpu/rLyHzwwJxZelu9El9uXdguc0UGKOiRqyTWzf0HCsNw1U7Umtrv
	3/c9nMdXORO/szn6miFO71ct0uiZsP3VamPlqXnkbX+Tf7OlSpJR/kYN+ZVZzh2iycd/NA
	2FYUa2SrmHyVt5ELB3oRrjN1qpx9emY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793955760;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ALdFdZ6+XY0jKUDGRwksVl7+1ksycMukEjQ+VH6YWbA=;
	b=mJNxzkANideHlOtwSVxjkdcY6b6vnI+1eSB9+PDk2hJDrCB9NPf+YZ6T8gpYaxtkuUSv29
	9ULPxL4ZKG0dUMCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 759F8134E9;
	Fri,  6 Nov 2026 09:02:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YLdKFLCX7WqWHQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 09:02:40 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 03D03BA38; Fri, 06 Nov 2026 10:02:39 +0100 (CET)
Date: Fri, 6 Nov 2026 10:02:39 +0100
From: Jan Kara <jack@suse.cz>
To: Shuai Liu <847807867@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-kernel@vger.kernel.org, 
	syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com, sashiko-bot@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v8] ext4: fix slab-use-after-free in do_split()
Message-ID: <zlob4iplebmd7bqzh6iniyz3vrgzifrhg4cqy22uljraftrjxc@hr5rvleofcrx>
References: <sashiko-outbox-198398@kernel.org>
 <tencent_BA3A8C65555EB74908B7404C6562DC5D5705@qq.com>
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
In-Reply-To: <tencent_BA3A8C65555EB74908B7404C6562DC5D5705@qq.com>
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
	TAGGED_RCPT(0.00)[09bec78ee77613a3efdd];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[qq.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,syzkaller.appspotmail.com,kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qq.com:email,imap1.dmz-prg2.suse.org:helo,syzkaller.appspot.com:url,suse.com:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Thu 05-11-26 10:11:46, Shuai Liu wrote:
> do_split() allocates a new directory block with ext4_append() to hold
> the second half of the entries of the leaf block being split, then
> dx_move_dirents() copies entries from the old block (*bh) into the new
> one (bh2).  Nothing verifies that the newly allocated block differs
> from the block being split.
> 
> On a filesystem whose block bitmap is inconsistent with the directory
> tree, a block already referenced as a directory leaf or as an htree
> index block can still be marked free, so ext4_append() can return that
> same block.  With concurrent operations on such a filesystem (as
> exercised by the syzbot reproducer), the block can even be freed
> between allocations, resulting in bh2 aliasing *bh.  dx_move_dirents()
> then copies the block onto itself, corrupting directory entries
> mid-copy: a rec_len field can be overwritten with name bytes, so the
> subsequent wipe of the stale entry memset()s a bogus length, causing
> the slab-use-after-free reported by syzbot.
> 
> The same aliasing applies to the htree index blocks.  If the leaf
> block or a newly allocated block aliases an index frame, the index
> header can be overwritten before do_split() runs (add_dirent_to_buf()
> inserting into an aliased leaf, make_indexed_dir() moving the dirents
> into an aliased new block, the index split in ext4_dx_add_entry()
> copying entries into an aliased buffer), letting dx_insert_block()
> memmove() out of bounds with a corrupted count and dx_release() loop
> past the frames[] array (or leak frames) with a corrupted
> indirect_levels.
> 
> Fix this by checking for these aliases before any directory block
> contents are modified, and bailing out with -EFSCORRUPTED, reporting
> the corruption via ext4_error_inode_block():
> 
>   - make_indexed_dir(): after ext4_append(), before moving the
>     dirents out of the root block
>   - ext4_dx_add_entry(): after reading the leaf block and after
>     ext4_append() in the index split, before the entries are copied
>   - do_split(): for *bh and bh2 against all frames[0..level]

So you are at v8 in just two days without any human feedback. This isn't a
good investment of your time. Did you put actually more thought into
whether what AI is suggesting to do actually makes sense? Because I don't
think it does. There is a very large number of ways in which metadata on disk
can be corrupted and handling them gracefully was always declared as best
effort because some types of corruption are simply too expensive to protect
against. This is fixing one niche case with relatively complex code so
that's not really a win for long term code maintainability.

As I've outlined elsewhere this class of corruptions could likely be
addressed by attaching a tag to buffer head after verifying its contents
saying what metadata it holds and verifying the tag is the expected one
whenever we lookup metadata bh from buffer cache.

								Honza

> Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=09bec78ee77613a3efdd
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shuai Liu <847807867@qq.com>
> Changes in v8:
>   - Add an index-to-index alias check in dx_probe(). The existing tree cycle
>     check compares only logical block numbers, so on a corrupted filesystem
>     where two distinct logical index blocks map to the same physical block,
>     frames[] can be populated with identical buffer_heads (the same physical
>     block can pass the limit, count and checksum checks at both levels since
>     dx_root and dx_node entries live at different offsets). Writing a child
>     frame's dx_node entries in place then overwrites the root dx_root_info
>     (including indirect_levels) and the root dx_countlimit, and dx_release()
>     reading the corrupted indirect_levels can walk past the end of the
>     frames[] array and brelse() stack garbage. Check each newly read index
>     block against all ancestor frames' buffer_heads, which also removes a
>     double brelse() of an aliased buffer_head on the dx_probe() failure
>     path. (Sashiko)
> 
> ---
>  fs/ext4/namei.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 75 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 354fc2d22df1..fb1ea835cd20 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -914,6 +914,17 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
>  			goto fail;
>  		}
>  
> +		for (i = 0; i < level; i++) {
> +			if (frame_in[i].bh == frame->bh) {
> +				ext4_warning_inode(dir,
> +					"dx entry: index block %u aliases ancestor index block",
> +					block);
> +				brelse(frame->bh);
> +				frame->bh = NULL;
> +				goto fail;
> +			}
> +		}
> +
>  		entries = ((struct dx_node *) frame->bh->b_data)->entries;
>  
>  		if (dx_get_limit(entries) != dx_node_limit(dir)) {
> @@ -1903,13 +1914,14 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(struct inode *dir, char *base,
>   * Returns pointer to de in block into which the new entry will be inserted.
>   */
>  static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
> -			struct buffer_head **bh,struct dx_frame *frame,
> -			struct dx_hash_info *hinfo)
> +			struct buffer_head **bh, struct dx_frame *frames,
> +			struct dx_frame *frame, struct dx_hash_info *hinfo)
>  {
>  	unsigned blocksize = dir->i_sb->s_blocksize;
>  	unsigned continued;
>  	int count;
>  	struct buffer_head *bh2;
> +	struct dx_frame *f;
>  	ext4_lblk_t newblock;
>  	u32 hash2;
>  	struct dx_map_entry *map;
> @@ -1922,12 +1934,42 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>  	if (ext4_has_feature_metadata_csum(dir->i_sb))
>  		csum_size = sizeof(struct ext4_dir_entry_tail);
>  
> +	for (f = frames; f <= frame; f++) {
> +		if (*bh == f->bh) {
> +			ext4_error_inode_block(dir, (*bh)->b_blocknr,
> +					       EFSCORRUPTED,
> +					       "leaf block aliased with index block");
> +			brelse(*bh);
> +			*bh = NULL;
> +			return ERR_PTR(-EFSCORRUPTED);
> +		}
> +	}
> +
>  	bh2 = ext4_append(handle, dir, &newblock);
>  	if (IS_ERR(bh2)) {
>  		brelse(*bh);
>  		*bh = NULL;
>  		return ERR_CAST(bh2);
>  	}
> +	if (bh2 == *bh) {
> +		ext4_error_inode_block(dir, (*bh)->b_blocknr, EFSCORRUPTED,
> +				       "cannot split aliased directory block");
> +		brelse(bh2);
> +		brelse(*bh);
> +		*bh = NULL;
> +		return ERR_PTR(-EFSCORRUPTED);
> +	}
> +	for (f = frames; f <= frame; f++) {
> +		if (bh2 == f->bh) {
> +			ext4_error_inode_block(dir, bh2->b_blocknr,
> +					       EFSCORRUPTED,
> +					       "leaf block aliased with index block");
> +			brelse(bh2);
> +			brelse(*bh);
> +			*bh = NULL;
> +			return ERR_PTR(-EFSCORRUPTED);
> +		}
> +	}
>  
>  	BUFFER_TRACE(*bh, "get_write_access");
>  	err = ext4_journal_get_write_access(handle, dir->i_sb, *bh,
> @@ -2257,6 +2299,13 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
>  		brelse(bh);
>  		return PTR_ERR(bh2);
>  	}
> +	if (bh2 == bh) {
> +		ext4_error_inode_block(dir, bh->b_blocknr, EFSCORRUPTED,
> +				       "cannot index aliased directory block");
> +		brelse(bh2);
> +		brelse(bh);
> +		return -EFSCORRUPTED;
> +	}
>  	ext4_set_inode_flag(dir, EXT4_INODE_INDEX);
>  	data2 = bh2->b_data;
>  
> @@ -2325,7 +2374,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
>  	if (retval)
>  		goto out_frames;
>  
> -	de = do_split(handle,dir, &bh2, frame, &fname->hinfo);
> +	de = do_split(handle, dir, &bh2, frames, frame, &fname->hinfo);
>  	if (IS_ERR(de)) {
>  		retval = PTR_ERR(de);
>  		goto out_frames;
> @@ -2476,6 +2525,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
>  			     struct inode *dir, struct inode *inode)
>  {
>  	struct dx_frame frames[EXT4_HTREE_LEVEL], *frame;
> +	struct dx_frame *f;
>  	struct dx_entry *entries, *at;
>  	struct buffer_head *bh;
>  	struct super_block *sb = dir->i_sb;
> @@ -2496,6 +2546,15 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
>  		bh = NULL;
>  		goto cleanup;
>  	}
> +	for (f = frames; f <= frame; f++) {
> +		if (bh == f->bh) {
> +			ext4_error_inode_block(dir, bh->b_blocknr,
> +					       EFSCORRUPTED,
> +					       "leaf block aliased with index block");
> +			err = -EFSCORRUPTED;
> +			goto cleanup;
> +		}
> +	}
>  
>  	BUFFER_TRACE(bh, "get_write_access");
>  	err = ext4_journal_get_write_access(handle, sb, bh, EXT4_JTR_NONE);
> @@ -2549,6 +2608,18 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
>  			err = PTR_ERR(bh2);
>  			goto cleanup;
>  		}
> +		for (f = frames; f < frames + levels; f++) {
> +			if (bh2 == f->bh)
> +				break;
> +		}
> +		if (f < frames + levels || bh2 == bh) {
> +			ext4_error_inode_block(dir, bh2->b_blocknr,
> +					       EFSCORRUPTED,
> +					       "cannot split aliased index block");
> +			brelse(bh2);
> +			err = -EFSCORRUPTED;
> +			goto cleanup;
> +		}
>  		node2 = (struct dx_node *)(bh2->b_data);
>  		entries2 = node2->entries;
>  		memset(&node2->fake, 0, sizeof(struct fake_dirent));
> @@ -2631,7 +2702,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
>  			goto journal_error;
>  		}
>  	}
> -	de = do_split(handle, dir, &bh, frame, &fname->hinfo);
> +	de = do_split(handle, dir, &bh, frames, frame, &fname->hinfo);
>  	if (IS_ERR(de)) {
>  		err = PTR_ERR(de);
>  		goto cleanup;
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
