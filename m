Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F0243D50E;
	Thu, 27 Aug 2026 11:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787829652; cv=none; b=ssqMBRKeAFiJ0uGylD3R5cC4wvIVrBRDdr3+Lo61UF/Ft+YM1/c0e6qcRxEK8keeCO+BYqOEe2Q6ruy2FKRyXUd3iDa1EfDv4KDyDEBYS7pOZ5CbnMX77tc4VaZkROKQFcLAqByiX9cxCKKd3STqBw9t6nA2zFsb2qDxGmnhG64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787829652; c=relaxed/simple;
	bh=Wber3bnyeO/WLJGl+TnpDoSJlq5H/7CAjvIo4l6TYWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jf+5/uA6nzspaIQGzvLQWEdCV1lBiLRuuM2tq1QDY5O2yTMAyvnMXEDqPbIEk5cVmF1CK64SpE1W/lP4b3dKxk+KYassQLDtnShS/aJnJBM6kUi1mDKSnWpVi8KLtm5i/NHS8iYynDvw4hfSAhyZQMEPa0EkrxgyHabE3TYd2OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ylr9FtV/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ffbAqJv4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SoBff06W; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qUjkNteo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ylr9FtV/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ffbAqJv4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SoBff06W";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qUjkNteo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE37B211E6;
	Thu, 27 Aug 2026 11:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787829642; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yOYrpWqAIRgjj7E+XPSTVGEGrqkv9suRuJFfRYWOfI=;
	b=ylr9FtV/bOEvLxL/tD/thznjAj16ZopkqQ1VLilFZHVmNJTOUHv+jwFnqcKJ8k04WuvfWj
	6TSKIDOFxsY4jHlYZn+u1doDmogAjhyrcNAinHpK199/GD3Q1OKcjqK94RBMKhIWcRJgN3
	kZ63kdeH9cJdi17jqrzPbpbhKoPKBMw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787829642;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yOYrpWqAIRgjj7E+XPSTVGEGrqkv9suRuJFfRYWOfI=;
	b=ffbAqJv4fPIz0d5KpaefMoz46S3bvLBFB0vXXeFgdbwZ+07I0RqlYTDYqIiAnlU5dDmD4x
	spS4RNOZ3fE8H9AQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SoBff06W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qUjkNteo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787829637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yOYrpWqAIRgjj7E+XPSTVGEGrqkv9suRuJFfRYWOfI=;
	b=SoBff06W/0aiz5tL95B5eITIP19RC/CXIyv7QDI1SXY/6GZRV3qQ7uILK45JFOQNsYFmFa
	u0NrSO/wemosVX9yvM8kLKrOPYutk42F50l0LpLTYlKIXTd1Fkwndn79+nYNKxvq4hmA4x
	+6I1YtsfjbgDnpzg9dw7Un7xo8MZErw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787829637;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yOYrpWqAIRgjj7E+XPSTVGEGrqkv9suRuJFfRYWOfI=;
	b=qUjkNteoI0D3Li/+7IL/1lYoGPBHRbdErB7FM6lj7wHRC/4QCL+aR5GiDIeBJ8alIDZOZi
	iwSOnyBQOZv7djAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D341013354;
	Thu, 27 Aug 2026 11:20:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KMeVM4UdkGoiaQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 27 Aug 2026 11:20:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7F903A1324; Thu, 27 Aug 2026 13:20:37 +0200 (CEST)
Date: Thu, 27 Aug 2026 13:20:37 +0200
From: Jan Kara <jack@suse.cz>
To: Daejun Park <daejun7.park@samsung.com>
Cc: "tytso@mit.edu" <tytso@mit.edu>, 
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "jack@suse.cz" <jack@suse.cz>, 
	"yi.zhang@huawei.com" <yi.zhang@huawei.com>, "ritesh.list@gmail.com" <ritesh.list@gmail.com>, 
	"libaokun@linux.alibaba.com" <libaokun@linux.alibaba.com>, "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>, 
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"amonakov@ispras.ru" <amonakov@ispras.ru>
Subject: Re: [PATCH v2] ext4: don't report delalloc data as a hole on
 indirect-mapped inodes
Message-ID: <x4bn3jk2prxj2sxznqevnpke6rxvm3izbirkad4t4q4mg7blvn@t3dgv76gqrcu>
References: <CGME20260827043928epcms2p54597035aadd1eca0556ae9b0585694f9@epcms2p5>
 <20260827043928epcms2p54597035aadd1eca0556ae9b0585694f9@epcms2p5>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827043928epcms2p54597035aadd1eca0556ae9b0585694f9@epcms2p5>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: DE37B211E6
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
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,huawei.com,gmail.com,linux.alibaba.com,linux.ibm.com,vger.kernel.org,ispras.ru];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO

On Thu 27-08-26 13:39:28, Daejun Park wrote:
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
> generic/285, generic/286, generic/436, generic/448 and generic/490 pass
> on ext4 made both with and without the extent feature.
> 
> Fixes: facab4d9711e ("ext4: return hole from ext4_map_blocks()")
> Reported-by: Alexander Monakov <amonakov@ispras.ru>
> Closes: https://lore.kernel.org/linux-ext4/594c17d9-c00f-e485-96fb-cedf27ce3aa3@ispras.ru/
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v1: https://lore.kernel.org/linux-ext4/20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5/
> 
> v2: rather than open coding the delalloc trim in ext4_ind_map_blocks(),
>     split it out of ext4_ext_determine_insert_hole() into
>     ext4_determine_insert_hole() and call that from both paths, as Jan
>     suggested.  Two things follow from sharing the whole function, both
>     noted in the commit message: indirect-mapped inodes now cache the
>     holes they report, and a delalloc extent covering the queried block
>     now shortens the reported hole instead of leaving it whole.
> 
>  fs/ext4/ext4.h     |  3 +++
>  fs/ext4/extents.c  | 26 +++++++++++++-------------
>  fs/ext4/indirect.c | 11 +++++++++++
>  3 files changed, 27 insertions(+), 13 deletions(-)
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
> index 5aec759eed70..9dc0759c88ef 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -586,6 +586,17 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
>  		for (i = partial - chain + 1; i < depth; i++)
>  			count = count * epb + (epb - offsets[i] - 1);
>  		count++;
> +
> +		/*
> +		 * The count knows nothing about delayed allocation, so let
> +		 * the common helper reconcile it with the extent status
> +		 * tree.  Clamp it first: with a large block size a subtree
> +		 * can be bigger than the logical block space.
> +		 */
> +		count = umin(count, EXT_MAX_BLOCKS - map->m_lblk);
> +		count = ext4_determine_insert_hole(inode, map->m_lblk,
> +						   map->m_lblk, count);
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
