Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1494F48FF75;
	Thu,  8 Oct 2026 09:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791453321; cv=none; b=j6V6YzTHb2/yaY5fxn7SUBYU4NvhiiMsu9PEMLRZwFrDdRGSVDGCx3puJw4aib5Letf4rywuxKpNMG/z88Xup7fy9HqSH6CmTE7l/2GToKGsRuP3+J63cFlzxness5w/na9CUE6+ibNKyCyHUJuTXLzygsvHiT9XPZqY1uMEsfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791453321; c=relaxed/simple;
	bh=mZDyBo8FQCtep7Mhkbtb0RgIUmfn/Ya/iyKc9z+eEIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ki7fKUxmSDYc7JdP1HYSTJAF2kUBsvqN7UihxiJ4jG7ebYbl2CR9ffrsfsczMhxUwzZS8vLXLwpuo4bvH0sNQWycc6GsmHnIAbgzp5pdyPvzymqVfkgVP1wwIYw3nQD0VSk0ntoneLTAx78piP2noccBmIFVGRu0OtG4BlztOf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CwwMbOsm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0AP3yFfF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CwwMbOsm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0AP3yFfF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CwwMbOsm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0AP3yFfF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CwwMbOsm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0AP3yFfF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 810711F79D;
	Thu,  8 Oct 2026 09:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791453307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RMpi9V4AyzyUlf9ntsBo+iMxSTtSeMbhVMOp6qIaRA4=;
	b=CwwMbOsmoli794HkXcXK7dX2FlNUpph9hZPL3mbonxqzSEOw+Z1iD5Wy9lvpbAKYLpfTb+
	ExwmaE7pK40IRx9Ff2vK/FMRk1sMDh7iBGbN3s0+xsjq+zsPcT1COfMi/TtKiQ3eHkBugn
	7T9TFT1A3XWloaZbEHh4onWIDsSmWD4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791453307;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RMpi9V4AyzyUlf9ntsBo+iMxSTtSeMbhVMOp6qIaRA4=;
	b=0AP3yFfFJ456o1aOxKHtH8v+ERCXEdltma4NYv/bruIYpIsoqHc+oygauJu1w9f8PYfigM
	FfP1VhlQ6khuZtCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791453307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RMpi9V4AyzyUlf9ntsBo+iMxSTtSeMbhVMOp6qIaRA4=;
	b=CwwMbOsmoli794HkXcXK7dX2FlNUpph9hZPL3mbonxqzSEOw+Z1iD5Wy9lvpbAKYLpfTb+
	ExwmaE7pK40IRx9Ff2vK/FMRk1sMDh7iBGbN3s0+xsjq+zsPcT1COfMi/TtKiQ3eHkBugn
	7T9TFT1A3XWloaZbEHh4onWIDsSmWD4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791453307;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RMpi9V4AyzyUlf9ntsBo+iMxSTtSeMbhVMOp6qIaRA4=;
	b=0AP3yFfFJ456o1aOxKHtH8v+ERCXEdltma4NYv/bruIYpIsoqHc+oygauJu1w9f8PYfigM
	FfP1VhlQ6khuZtCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A91713354;
	Thu,  8 Oct 2026 09:55:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id s5g9Cntox2qbHQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Oct 2026 09:55:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CB324A13FC; Thu, 08 Oct 2026 11:55:02 +0200 (CEST)
Date: Thu, 8 Oct 2026 11:55:02 +0200
From: Jan Kara <jack@suse.cz>
To: daejun7.park@samsung.com
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Zhang Yi <yi.zhang@huaweicloud.com>, Harshad Shirwadkar <harshadshirwadkar@gmail.com>, 
	Li Chen <me@linux.beauty>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ext4: track zeroed out blocks of unwritten
 extents for fast commit
Message-ID: <2lgtlg7ydx4qeau2nvv5wkcuc2jkvwdcrav7gbxmxdieptkwl4@emgyfuxuskiu>
References: <20261008-ext4-fc-zeroout-v2-0-55cab1e24fa3@samsung.com>
 <20261008-ext4-fc-zeroout-v2-2-55cab1e24fa3@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008-ext4-fc-zeroout-v2-2-55cab1e24fa3@samsung.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 
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
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,suse.cz,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,linux.beauty];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,samsung.com:email]

On Thu 08-10-26 10:25:37, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> When ext4_ext_convert_to_initialized() converts part of an unwritten
> extent, it may zero out the blocks before and after that range (a side
> only if it fits together with the range in s_extent_max_zeroout_kb,
> 32 KiB by default, and the extent ends within i_disksize or the write)
> and convert them to written together with it, instead of splitting them
> off. ext4_split_extent() zeroes out the rest of the extent and converts
> all of it when a split fails with -ENOSPC, -EDQUOT or -ENOMEM. In both
> cases ext4_map_blocks() reports only the mapped range to fast commit, so
> the other converted blocks are not tracked.
> 
> A later write to one of those blocks overwrites a written block in
> place. That changes no mapping and is not tracked either, so the next
> fsync is a fast commit that logs the inode but no range for the block.
> After a crash, replay starts from the last full commit, where the block
> is still part of an unwritten extent, and the fsynced data reads back
> as zeroes. Fast commit tracks one [min, max] range per inode, so this
> shows only when no other block beyond the zeroed ones was tracked in
> the same commit, which makes it easy to miss.
> 
> The first conversion runs when writes allocate through ext4_map_blocks()
> with EXT4_GET_BLOCKS_CREATE, for example with -o nodelalloc,
> -o dioread_lock or DAX. On a 4 KiB block file system made with
> -O fast_commit and mounted with -o nodelalloc,commit=60:
> 
>   fallocate -l 32k f; sync      # blocks 0-7 unwritten
>   write block 0; fsync f        # zeroes out 1-7, tracks only 0
>   write block 2; fsync f        # in place, nothing tracked
>   crash (kill the VM), mount    # fast commit replay
>   block 2 reads back as zeroes
> 
> Track the range in ext4_issue_zeroout(), where the zeroes are written,
> once the zeroout has succeeded. It takes the handle for that, and so
> does ext4_ext_zeroout(). The EXT4_GET_BLOCKS_CONVERT_UNWRITTEN zeroout
> in ext4_split_extent_zeroout() and the EXT4_GET_BLOCKS_ZERO one in
> ext4_map_create_blocks() zero out the mapped range, which
> ext4_map_blocks() tracks anyway.
> ext4_alloc_file_blocks() zeroes out without a handle and passes NULL:
> ext4_convert_unwritten_extents() right after it tracks the blocks it
> converts through ext4_map_blocks(), and blocks that were already
> written keep their mapping. The callers with a handle hold i_data_sem,
> as fast commit tracking already does when ext4_ext_dirty() changes an
> extent kept in the inode (through ext4_mark_inode_dirty()).
> 
> Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
> Cc: stable@vger.kernel.org
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just one note: I agree with you ext4_alloc_file_blocks() is actually handled
correctly. But OTOH tracking a range twice isn't really an issue (only tiny
performance overhead compared to the extent tree operations and zeroing
itself). So I just wouldn't special-case ext4_alloc_file_blocks() and
always pass a proper handle to ext4_issue_zeroout(). That keeps the logic
slightly simpler: kernel zeroes out blocks => kernel tracks the range. But
I don't really insist, it's just a suggestion.

								Honza

> ---
>  fs/ext4/ext4.h         |  5 +++--
>  fs/ext4/ext4_extents.h |  3 ++-
>  fs/ext4/extents-test.c |  8 +++++---
>  fs/ext4/extents.c      | 31 ++++++++++++++++++++-----------
>  fs/ext4/inode.c        | 25 +++++++++++++++++--------
>  5 files changed, 47 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 7fd078de26..f469b3548b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3209,8 +3209,9 @@ extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
>  extern void ext4_da_release_space(struct inode *inode, int to_free);
>  extern void ext4_da_update_reserve_space(struct inode *inode,
>  					int used, int quota_claim);
> -extern int ext4_issue_zeroout(struct inode *inode, ext4_lblk_t lblk,
> -			      ext4_fsblk_t pblk, ext4_lblk_t len);
> +extern int ext4_issue_zeroout(handle_t *handle, struct inode *inode,
> +			      ext4_lblk_t lblk, ext4_fsblk_t pblk,
> +			      ext4_lblk_t len);
>  
>  static inline bool is_special_ino(struct super_block *sb, unsigned long ino)
>  {
> diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
> index ebaf7cc424..f4218ff084 100644
> --- a/fs/ext4/ext4_extents.h
> +++ b/fs/ext4/ext4_extents.h
> @@ -267,7 +267,8 @@ static inline void ext4_idx_store_pblock(struct ext4_extent_idx *ix,
>  extern int __ext4_ext_dirty(const char *where, unsigned int line,
>  			    handle_t *handle, struct inode *inode,
>  			    struct ext4_ext_path *path);
> -extern int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex);
> +extern int ext4_ext_zeroout(handle_t *handle, struct inode *inode,
> +			    struct ext4_extent *ex);
>  #if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
>  extern int ext4_ext_space_root_idx_test(struct inode *inode, int check);
>  extern struct ext4_ext_path *ext4_split_convert_extents_test(
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index bd7795a826..4e205de575 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -180,7 +180,8 @@ ext4_ext_insert_extent_stub(handle_t *handle, struct inode *inode,
>  /*
>   * We will zeroout the equivalent range in the data area
>   */
> -static int ext4_ext_zeroout_stub(struct inode *inode, struct ext4_extent *ex)
> +static int ext4_ext_zeroout_stub(handle_t *handle, struct inode *inode,
> +				 struct ext4_extent *ex)
>  {
>  	ext4_lblk_t ee_block, off_blk;
>  	loff_t ee_len;
> @@ -203,8 +204,9 @@ static int ext4_ext_zeroout_stub(struct inode *inode, struct ext4_extent *ex)
>  	return 0;
>  }
>  
> -static int ext4_issue_zeroout_stub(struct inode *inode, ext4_lblk_t lblk,
> -				   ext4_fsblk_t pblk, ext4_lblk_t len)
> +static int ext4_issue_zeroout_stub(handle_t *handle, struct inode *inode,
> +				   ext4_lblk_t lblk, ext4_fsblk_t pblk,
> +				   ext4_lblk_t len)
>  {
>  	ext4_lblk_t off_blk;
>  	loff_t off_bytes;
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index d65e30f3c1..aa55e7cf26 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3167,17 +3167,18 @@ static void ext4_zeroout_es(struct inode *inode, struct ext4_extent *ex)
>  }
>  
>  /* FIXME!! we need to try to merge to left or right after zero-out  */
> -int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
> +int ext4_ext_zeroout(handle_t *handle, struct inode *inode,
> +		     struct ext4_extent *ex)
>  {
>  	ext4_fsblk_t ee_pblock;
>  	unsigned int ee_len;
>  
> -	KUNIT_STATIC_STUB_REDIRECT(ext4_ext_zeroout, inode, ex);
> +	KUNIT_STATIC_STUB_REDIRECT(ext4_ext_zeroout, handle, inode, ex);
>  
>  	ee_len    = ext4_ext_get_actual_len(ex);
>  	ee_pblock = ext4_ext_pblock(ex);
> -	return ext4_issue_zeroout(inode, le32_to_cpu(ex->ee_block), ee_pblock,
> -				  ee_len);
> +	return ext4_issue_zeroout(handle, inode, le32_to_cpu(ex->ee_block),
> +				  ee_pblock, ee_len);
>  }
>  
>  /*
> @@ -3347,7 +3348,8 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
>  			lblk = ee_block;
>  			len = map->m_lblk - ee_block;
>  			pblk = ext4_ext_pblock(ex);
> -			err = ext4_issue_zeroout(inode, lblk, pblk, len);
> +			err = ext4_issue_zeroout(handle, inode, lblk, pblk,
> +						 len);
>  			if (err)
>  				/* ZEROOUT failed, just return original error */
>  				return err;
> @@ -3358,7 +3360,8 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
>  			lblk = map_end;
>  			len = ex_end - map_end;
>  			pblk = ext4_ext_pblock(ex) + (map_end - ee_block);
> -			err = ext4_issue_zeroout(inode, lblk, pblk, len);
> +			err = ext4_issue_zeroout(handle, inode, lblk, pblk,
> +						 len);
>  			if (err)
>  				/* ZEROOUT failed, just return original error */
>  				return err;
> @@ -3377,7 +3380,7 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
>  		lblk = map->m_lblk;
>  		len = map->m_len;
>  		pblk = ext4_ext_pblock(ex) + (map->m_lblk - ee_block);
> -		err = ext4_issue_zeroout(inode, lblk, pblk, len);
> +		err = ext4_issue_zeroout(handle, inode, lblk, pblk, len);
>  		if (err)
>  			/* ZEROOUT failed, just return original error */
>  			return err;
> @@ -3754,7 +3757,7 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
>  			ext4_ext_store_pblock(&zero_ex1,
>  				ext4_ext_pblock(ex) + split_map.m_lblk +
>  				split_map.m_len - ee_block);
> -			err = ext4_ext_zeroout(inode, &zero_ex1);
> +			err = ext4_ext_zeroout(handle, inode, &zero_ex1);
>  			if (err) {
>  				zero_ex1.ee_len = 0;
>  				goto fallback;
> @@ -3770,7 +3773,7 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
>  							ee_block);
>  				ext4_ext_store_pblock(&zero_ex2,
>  						      ext4_ext_pblock(ex));
> -				err = ext4_ext_zeroout(inode, &zero_ex2);
> +				err = ext4_ext_zeroout(handle, inode, &zero_ex2);
>  				if (err) {
>  					zero_ex2.ee_len = 0;
>  					goto fallback;
> @@ -4693,8 +4696,14 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  			WARN_ON_ONCE(map.m_lblk + map.m_len >
>  				EXT4_B_TO_LBLK(inode, new_size ?: old_size));
>  
> -			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
> -						 map.m_len);
> +			/*
> +			 * Zeroed out without a handle, see the comment
> +			 * on EXT4_GET_BLOCKS_ZERO above. The conversion
> +			 * below tracks the blocks it converts for fast
> +			 * commit, and written blocks keep their mapping.
> +			 */
> +			ret = ext4_issue_zeroout(NULL, inode, map.m_lblk,
> +						 map.m_pblk, map.m_len);
>  			if (unlikely(ret))
>  				break;
>  
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 48ef9bb387..618ce271ba 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -406,23 +406,32 @@ static int __check_block_validity(struct inode *inode, const char *func,
>  	return 0;
>  }
>  
> -int ext4_issue_zeroout(struct inode *inode, ext4_lblk_t lblk, ext4_fsblk_t pblk,
> -		       ext4_lblk_t len)
> +/*
> + * The zeroes written here are file data. With a @handle the range is tracked
> + * for fast commit, because some callers zero out blocks outside the range that
> + * ext4_map_blocks() tracks and convert them to written. A caller without a
> + * handle must make sure that the conversion tracks the range.
> + */
> +int ext4_issue_zeroout(handle_t *handle, struct inode *inode, ext4_lblk_t lblk,
> +		       ext4_fsblk_t pblk, ext4_lblk_t len)
>  {
>  	int ret;
>  
> -	KUNIT_STATIC_STUB_REDIRECT(ext4_issue_zeroout, inode, lblk, pblk, len);
> +	KUNIT_STATIC_STUB_REDIRECT(ext4_issue_zeroout, handle, inode, lblk, pblk,
> +				   len);
>  
>  	if (IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode))
> -		return fscrypt_zeroout_range(inode,
> +		ret = fscrypt_zeroout_range(inode,
>  				(loff_t)lblk << inode->i_blkbits,
>  				pblk << (inode->i_blkbits - SECTOR_SHIFT),
>  				(u64)len << inode->i_blkbits);
> -
> -	ret = sb_issue_zeroout(inode->i_sb, pblk, len, GFP_NOFS);
> +	else
> +		ret = sb_issue_zeroout(inode->i_sb, pblk, len, GFP_NOFS);
>  	if (ret > 0)
>  		ret = 0;
>  
> +	if (!ret && handle)
> +		ext4_fc_track_range(handle, inode, lblk, lblk + len - 1);
>  	return ret;
>  }
>  
> @@ -657,8 +666,8 @@ int ext4_map_create_blocks(handle_t *handle, struct inode *inode,
>  	 */
>  	if (flags & EXT4_GET_BLOCKS_ZERO &&
>  	    map->m_flags & EXT4_MAP_MAPPED && map->m_flags & EXT4_MAP_NEW) {
> -		err = ext4_issue_zeroout(inode, map->m_lblk, map->m_pblk,
> -					 map->m_len);
> +		err = ext4_issue_zeroout(handle, inode, map->m_lblk,
> +					 map->m_pblk, map->m_len);
>  		if (err)
>  			return err;
>  	}
> 
> -- 
> 2.43.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
