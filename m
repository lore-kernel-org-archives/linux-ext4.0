Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA6640B11E;
	Thu, 27 Aug 2026 11:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787831336; cv=none; b=O6r5aF5IF/UZSVsPYfUSm2I2+1akmzZukE6GdgRRzibTQY5A0CzyyNjZPmKp/d8rSx45fWRIvbqO+S5sDJbeseWBUlyUdRGFnJ3KhBvz8jNEAyVHj6VgkJromfN1BeXaR6nQe58awVN7Pfrzs3t/1gg0MTt6Epp0VWgsvCpKnyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787831336; c=relaxed/simple;
	bh=AdQcGM3S+t5I4KU2qbCNFtCUsOreKBOPVxrJvmULGMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+ul8HP7dWU7fIhJBdWoublySTXRDUhj2kj4MCvFU2tzhwY24QkrgbcmHZMOCMJQJGDxWNXm+SyuXcadtXrrabgtKx/HAHio3/9zwZNvou5ciW551VqRp00CMFewM/vQ+/TEti++ukWSr/8X60V9anGIvDzMiAnDOz8CkgcYGH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3VsRe/Kp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tmi7rDqO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=W6eTn3Nu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7eOIHCQG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3VsRe/Kp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tmi7rDqO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="W6eTn3Nu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7eOIHCQG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F1D5A1FB11;
	Thu, 27 Aug 2026 11:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787831328; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osrzkWZLu8AblRfIJr3LueP7uGMdbqfo6oBHEUTSQRk=;
	b=3VsRe/KpL3s/ZZ8TDj/sHzWzXNloDAA3fvkeToJefCJNEeey3+SArjVxW/KjPqOEWSDm4S
	XCkis8HEq0Mq6z+SBiVfW3GoL2OLGRSvyIm14NWXtM3bEqxHS3y/3zynK0cxvOLLx7pHmE
	rSRyA1watbFfwVRuk+eh+DHBy23VGSQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787831328;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osrzkWZLu8AblRfIJr3LueP7uGMdbqfo6oBHEUTSQRk=;
	b=tmi7rDqOOiPyRzmnF/wl+5Cguaa6WeyNAZ/yBwW805t8EsTKOAtzf9+SZAZuQD4elvMWh0
	CkxurfgjhXdMo2AA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W6eTn3Nu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7eOIHCQG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787831323; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osrzkWZLu8AblRfIJr3LueP7uGMdbqfo6oBHEUTSQRk=;
	b=W6eTn3Nuiu/QDUcxhrA3Q3L7jFmQmTQv83SEprVdpu0vocVXtZy4rOxgKU+r/Vf4MVWxg2
	C3KOAXpFwCL4z78VjH7S5s2sOVSTwOLCxCgQimol06kyjjQlzgn4HhxqdyyTZx9hhaW7vD
	zixPvwy7w8b+N5NS6g8jXYJSSciU4Ro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787831323;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osrzkWZLu8AblRfIJr3LueP7uGMdbqfo6oBHEUTSQRk=;
	b=7eOIHCQGCWSoTMQFa6d27fDQpyhGjqOTy/28h4LbxgM1OPzzxMMp83LakJO18wZi0hQsa7
	07GRNR94vhkzAeAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E70711352C;
	Thu, 27 Aug 2026 11:48:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zR1oOBskkGrGBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 27 Aug 2026 11:48:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 95CB9A1324; Thu, 27 Aug 2026 13:48:43 +0200 (CEST)
Date: Thu, 27 Aug 2026 13:48:43 +0200
From: Jan Kara <jack@suse.cz>
To: Daejun Park <daejun7.park@samsung.com>
Cc: "tytso@mit.edu" <tytso@mit.edu>, 
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "jack@suse.cz" <jack@suse.cz>, 
	"yi.zhang@huawei.com" <yi.zhang@huawei.com>, "ritesh.list@gmail.com" <ritesh.list@gmail.com>, 
	"libaokun@linux.alibaba.com" <libaokun@linux.alibaba.com>, "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>, 
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"amonakov@ispras.ru" <amonakov@ispras.ru>
Subject: Re: [PATCH v3] ext4: don't report delalloc data as a hole on
 indirect-mapped inodes
Message-ID: <2pj4ryzduevi6lgbudtgufss4meuvakk5honwu54zy565uzqsd@yrctjtemlbc3>
References: <CGME20260827084829epcms2p6ecc0c39a71d0c3eebf9cb1ade77314f6@epcms2p6>
 <20260827084829epcms2p6ecc0c39a71d0c3eebf9cb1ade77314f6@epcms2p6>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827084829epcms2p6ecc0c39a71d0c3eebf9cb1ade77314f6@epcms2p6>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: F1D5A1FB11
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,ispras.ru:email,samsung.com:email];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,huawei.com,gmail.com,linux.alibaba.com,linux.ibm.com,vger.kernel.org,ispras.ru];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,samsung.com:email,suse.com:email,ispras.ru:email]
X-Spam-Flag: NO

On Thu 27-08-26 17:48:29, Daejun Park wrote:
> When a plain lookup finds no block, ext4_ind_map_blocks() sizes the hole
> it reports by counting the empty subtrees under 'partial' in the on-disk
> indirect tree.  That count knows nothing about delayed allocation, so a
> range holding delalloc data that has not been written back yet is
> reported as a plain hole.  The extent-mapped path does not have this
> problem: it trims the hole it found at the first delayed extent before
> returning it.
> 
> ext4_map_blocks() consults the extent status tree before it calls into
> the mapping layer, so a query that starts exactly on the delayed block
> still finds it.  A query that starts earlier does not, because the hole
> reported for the earlier block already spans the delayed one.  On a
> 4k-block filesystem, lseek(SEEK_DATA) from offset 0 on a file whose only
> data block is at logical block N and is still dirty returns:
> 
>   N = 0..11      direct blocks                 N << 12
>   N = 12         first single-indirect block   N << 12
>   N = 13..1035   inside that indirect block    -1 ENXIO
>   N = 1036       first double-indirect block   N << 12
> 
> Blocks 12 and 1036 survive because the query lands on the delayed block
> itself.  Blocks 13..1035 are swallowed by the 1024-block hole reported
> for block 12.  fiemap loses the same data for the same reason.
> 
> An ext3 filesystem mounted as ext4 hits this during ordinary use: ext3
> inodes stay indirect mapped, while mount -t ext4 turns on delayed
> allocation even though mounting ext3 with -o delalloc is explicitly
> rejected.  install(1) from coreutils uses SEEK_DATA to locate data in
> its source file, so installing a sparse file that has not been written
> back silently produces a destination of the right size holding none of
> the data:
> 
>   truncate -s 1G img && mkfs.ext3 -F img && mount -t ext4 img mnt
>   echo | dd of=mnt/src bs=1 count=1 seek=64K
>   install mnt/src mnt/dst
>   cmp mnt/src mnt/dst        # differ: char 65537
> 
> Reconciling a hole with the extent status tree does not depend on how
> the hole was found, so instead of open coding it a second time, split
> the delalloc handling out of ext4_ext_determine_insert_hole() into
> ext4_determine_insert_hole(), which takes the hole the caller located,
> and call that from ext4_ind_map_blocks() as well.  All the special cases
> and the comments explaining them stay in one place.
> 
> Two things change for indirect-mapped inodes.  They now cache the holes
> they report, as the extent-mapped path already does: ext4_punch_hole()
> already puts EXTENT_STATUS_HOLE on such inodes, ext4_map_blocks() and
> ext4_da_map_blocks() already handle a cached hole, the latter by
> replacing it with the delayed extent, and consecutive hole entries
> merge, so the tree does not grow with the length of a scan.  And when a
> delayed extent covers the queried block itself - a race, since
> ext4_map_blocks() found nothing in the tree just before - the hole is
> now reported only up to the end of that extent instead of in full.
> 
> The indirect path passes hole_start == lblk, so the "delalloc extent in
> front of the queried range" case cannot be reached there:
> __es_tree_search() never returns an extent ending before the block it
> was searched for.
> 
> With this the sweep above returns N << 12 for every N, while the
> nodelalloc and extent-mapped controls are unchanged.  generic/225,
> generic/285, generic/448 and generic/490 pass on ext4 made both with and
> without the extent feature.  generic/286 and generic/436 pass on
> extent-mapped ext4 and are skipped without it, since they need
> fallocate.
> 
> Fixes: facab4d9711e ("ext4: return hole from ext4_map_blocks()")
> Reported-by: Alexander Monakov <amonakov@ispras.ru>
> Closes: https://lore.kernel.org/linux-ext4/594c17d9-c00f-e485-96fb-cedf27ce3aa3@ispras.ru/
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Ok, good catch (from Sashiko I assume) about the error handling. The fix
still looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v1: https://lore.kernel.org/linux-ext4/20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5/
> v2: https://lore.kernel.org/linux-ext4/20260827043928epcms2p54597035aadd1eca0556ae9b0585694f9@epcms2p5/
> 
> v2: rather than open coding the delalloc trim in ext4_ind_map_blocks(),
>     split it out of ext4_ext_determine_insert_hole() into
>     ext4_determine_insert_hole() and call that from both paths, as Jan
>     suggested.
> 
> v3: only reconcile when the lookup really did find a hole.
>     ext4_get_branch() returns a non-NULL partial when it failed as
>     well, and ext4_ind_map_blocks() checks err only after this branch,
>     so v2 cached a hole for a range it could not read.  The error was
>     still returned, but every later read of that range was answered
>     from the cache as zeros instead of retrying the disk.  Reproduced
>     by pointing an inode's single-indirect block past the end of the
>     filesystem: v2 caches a hole for the whole 1024-block subtree and
>     reads succeed with zeros where they must return -EIO.
>     Also corrected the xfstests sentence: generic/286 and generic/436
>     need fallocate, so they are skipped rather than passing on a
>     filesystem made without the extent feature.
> 
>  fs/ext4/ext4.h     |  3 +++
>  fs/ext4/extents.c  | 26 +++++++++++++-------------
>  fs/ext4/indirect.c | 17 +++++++++++++++++
>  3 files changed, 33 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 7fd078de265d..f5eff74631a4 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3893,6 +3893,9 @@ extern void ext4_ext_tree_init(handle_t *handle, struct inode *inode);
>  extern int ext4_ext_index_trans_blocks(struct inode *inode, int extents);
>  extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  			       struct ext4_map_blocks *map, int flags);
> +ext4_lblk_t ext4_determine_insert_hole(struct inode *inode, ext4_lblk_t lblk,
> +				       ext4_lblk_t hole_start,
> +				       ext4_lblk_t hole_len);
>  extern int ext4_ext_truncate(handle_t *, struct inode *);
>  extern int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
>  				 ext4_lblk_t end);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 836396ea7912..e2b7565e2cb4 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4190,21 +4190,19 @@ static int get_implied_cluster_alloc(struct super_block *sb,
>  }
>  
>  /*
> - * Determine hole length around the given logical block, first try to
> - * locate and expand the hole from the given @path, and then adjust it
> - * if it's partially or completely converted to delayed extents, insert
> - * it into the extent cache tree if it's indeed a hole, finally return
> - * the length of the determined extent.
> + * Adjust the hole [@hole_start, @hole_start + @hole_len) the caller found
> + * around the queried block @lblk if it's partially or completely converted
> + * to delayed extents, insert it into the extent cache tree if it's indeed a
> + * hole, finally return the length of the determined extent starting at
> + * @lblk.  @hole_start must not be behind @lblk.
>   */
> -static ext4_lblk_t ext4_ext_determine_insert_hole(struct inode *inode,
> -						  struct ext4_ext_path *path,
> -						  ext4_lblk_t lblk)
> +ext4_lblk_t ext4_determine_insert_hole(struct inode *inode, ext4_lblk_t lblk,
> +				       ext4_lblk_t hole_start,
> +				       ext4_lblk_t hole_len)
>  {
> -	ext4_lblk_t hole_start, len;
> +	ext4_lblk_t len = hole_len;
>  	struct extent_status es;
>  
> -	hole_start = lblk;
> -	len = ext4_ext_find_hole(inode, path, &hole_start);
>  again:
>  	ext4_es_find_extent_range(inode, &ext4_es_is_delayed, hole_start,
>  				  hole_start + len - 1, &es);
> @@ -4371,9 +4369,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  	 * we couldn't try to create block if flags doesn't contain EXT4_GET_BLOCKS_CREATE
>  	 */
>  	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
> -		ext4_lblk_t len;
> +		ext4_lblk_t hole_start = map->m_lblk, len;
>  
> -		len = ext4_ext_determine_insert_hole(inode, path, map->m_lblk);
> +		len = ext4_ext_find_hole(inode, path, &hole_start);
> +		len = ext4_determine_insert_hole(inode, map->m_lblk,
> +						 hole_start, len);
>  
>  		map->m_pblk = 0;
>  		map->m_len = min_t(unsigned int, map->m_len, len);
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 5aec759eed70..a495080df710 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -586,6 +586,23 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
>  		for (i = partial - chain + 1; i < depth; i++)
>  			count = count * epb + (epb - offsets[i] - 1);
>  		count++;
> +
> +		/*
> +		 * The count knows nothing about delayed allocation, so let
> +		 * the common helper reconcile it with the extent status
> +		 * tree.  Only when the lookup really did find a hole:
> +		 * ext4_get_branch() also returns a non-NULL partial when it
> +		 * failed, and caching a hole for a range it could not read
> +		 * would answer every later read from that cache instead of
> +		 * retrying.  Clamp the count first, a subtree can be bigger
> +		 * than the logical block space when the block size is large.
> +		 */
> +		if (!err) {
> +			count = umin(count, EXT_MAX_BLOCKS - map->m_lblk);
> +			count = ext4_determine_insert_hole(inode, map->m_lblk,
> +							   map->m_lblk, count);
> +		}
> +
>  		/* Fill in size of a hole we found */
>  		map->m_pblk = 0;
>  		map->m_len = umin(map->m_len, count);
> 
> base-commit: 9091c97be34083587a75db174aab51551d8e8543
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
