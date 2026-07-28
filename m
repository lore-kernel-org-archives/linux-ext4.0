Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA1F47254F
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 20:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785270382; cv=none; b=bxjx22Dw3dnTZqY9/V38cXxVokVDjqGU991Ss1Los/qorVvOBq7d7zPm79pXrAoIicdXna/FK6yqBXy7YSoAB6sxJluFCWbvnUggGzKtRHXOVqapGmpv66h4ojqoJhYA3z8GZchhN1ARs0YcGzRlMXZejbxs2eu0Q3y31P4qiQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785270382; c=relaxed/simple;
	bh=gXphHe1lrElAC/7Hmt2HwfiCx5jAeuT8G6Gqkw8MlT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XrJdxFIyvQ2IaL3egs6qSLj+jaaADU5IZwtFKX9wbCHci/NhJ4r2DP2R+f5GOhpLY0O3rKarH4pbzdJfP51wvZNUG1mg4a8IGHSfk7zPGcZp2KE9RO7b+rLdwg6w1IHrFGHICJnnb3UUi6Zkqp0q5lqVVxtkaMA3La4gJ7sZ9ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=f2Bi/Jx4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nv63GF9M; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bu3FanQB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=q7cjsJTB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="f2Bi/Jx4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nv63GF9M";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bu3FanQB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="q7cjsJTB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5C6C67C53F;
	Tue, 28 Jul 2026 20:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785270374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNNlkxojD0KJ1lFsuzYkC0Qz+jJRCZ1pOzU2r9YsMJ0=;
	b=f2Bi/Jx4XkDjk5iTUFEo6P6WBD1SGh500+gkz74Kn1CCVqvP5I8tzmE+KF6BPau0LSy9H/
	xhazA2qP28uojLO/o6GH0yLXxJ299YjKoJ8vcKsBHvDCufEohg3x2VUPhsBlykp9VdgjjM
	leV4QQ9aZJIbVVEh7Rbyf6mxBLjr6u8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785270374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNNlkxojD0KJ1lFsuzYkC0Qz+jJRCZ1pOzU2r9YsMJ0=;
	b=nv63GF9MB4hTMi2WYJUbyBgmpKcdLT6Sph1hR+NIVygpGYFWAfeJKzIcO3LvBJ13pKvXrO
	uWYIJH6n0t6kz0Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785270370; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNNlkxojD0KJ1lFsuzYkC0Qz+jJRCZ1pOzU2r9YsMJ0=;
	b=bu3FanQBO1EJ0J91ICktcZJDuTd1NVAg8SLR0HEbDHWyNagyPMX2tbp4jZ+nMVdESdh5/K
	hDFsrrMrWMrN3YjrHPI4zHqbaJvymU7eHR+lo8qc9xdpuGYQdVI6igqp3v9xWLpXl1wey+
	v/70MBsF0T1NLzRwHPeOvbAezA2hrio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785270370;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNNlkxojD0KJ1lFsuzYkC0Qz+jJRCZ1pOzU2r9YsMJ0=;
	b=q7cjsJTB2xzTl9Y/J7WrbaAf/MHii+cF0wgSf+vyspdGX6TyVrazinHbTorpwl4hG16vQM
	HG+vI6cSAYWHYtAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 51163779B1;
	Tue, 28 Jul 2026 20:26:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TLS+E2IQaWoNagAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Jul 2026 20:26:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EC8C3A10B6; Tue, 28 Jul 2026 22:25:54 +0200 (CEST)
Date: Tue, 28 Jul 2026 22:25:54 +0200
From: Jan Kara <jack@suse.cz>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3] ext4: cache full extents during mapping lookup
Message-ID: <f4prqhixlrwwz3oiphmzrzy6gzibbjtwhclef7muv3slcx2dam@fxv5rmyoaxsj>
References: <20260723124326.82446-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723124326.82446-1-changfengnan@bytedance.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Thu 23-07-26 20:43:26, Fengnan Chang wrote:
> The extent status (ES) tree and extent tree leaf buffers are reclaimed
> independently. An ES entry can be reclaimed while the leaf buffer remains
> cached with BH_Verified set.
> 
> When this happens, ext4_es_lookup_extent() misses.  Since the leaf buffer
> is already verified, __read_extent_tree_block() returns it without calling
> ext4_cache_extents(). ext4_ext_map_blocks() returns the part of the extent
> covered by the request, and ext4_map_query_blocks() caches only that range.
> Reads to other blocks in the same extent then keep missing the ES tree and
> walking the extent tree.
> 
> Cache the full extent in ext4_ext_map_blocks() before the returned mapping
> is limited to the requested range. Add an optional read-side lookup to
> ext4_es_cache_extent().
> 
> Do not do this when ext4_ext_map_blocks() is called with
> EXT4_GET_BLOCKS_CREATE or EXT4_EX_NOCACHE. NOCACHE paths can change extent
> mappings, so caching ranges outside the request can leave stale ES entries.
> Cache both written and unwritten extents, as ext4_cache_extents() does.
> 
> Tested with fio 4K random direct reads using libaio at iodepth 128 on a
> 128 GiB file with 208 on-disk extents. The results are averages of three
> 10-second runs:
> 
>                  before reclaim    after reclaim
>   unpatched        419.6k IOPS       274.6k IOPS
>   patched          426.1k IOPS       423.7k IOPS
> 
> Average completion latency went from 303.02 to 462.78 us without the patch,
> and from 298.36 to 300.07 us with the patch.
> 
> No latency regression was seen in A/B test.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Link: https://lore.kernel.org/r/20260714114358.93335-1-changfengnan@bytedance.com
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>

Hum, you have taken an easy way out :) I was hoping to get rid of
ext4_es_cache_extent() calls in ext4_map_query_blocks_next_in_leaf(),
ext4_map_query_blocks(), and perhaps more places by a strategically placed
calls in ext4_ext_map_blocks() and ext4_ind_map_blocks(). But this patch
fixes your problem without adding too much technical debt so I'm fine with
that. We can cleanup the ext4_es_cache_extent() calls later. The patch
looks good to me so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c        | 17 +++++++++++++----
>  fs/ext4/extents_status.c | 17 ++++++++++++++++-
>  fs/ext4/extents_status.h |  2 +-
>  fs/ext4/inode.c          | 15 +++++++++++----
>  4 files changed, 41 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91c97af64b317..85e213761a18d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -537,12 +537,12 @@ static void ext4_cache_extents(struct inode *inode,
>  
>  		if (prev && (prev != lblk))
>  			ext4_es_cache_extent(inode, prev, lblk - prev, ~0,
> -					     EXTENT_STATUS_HOLE);
> +					     EXTENT_STATUS_HOLE, false);
>  
>  		if (ext4_ext_is_unwritten(ex))
>  			status = EXTENT_STATUS_UNWRITTEN;
>  		ext4_es_cache_extent(inode, lblk, len,
> -				     ext4_ext_pblock(ex), status);
> +				     ext4_ext_pblock(ex), status, false);
>  		prev = lblk + len;
>  	}
>  }
> @@ -4239,7 +4239,8 @@ static ext4_lblk_t ext4_ext_determine_insert_hole(struct inode *inode,
>  insert_hole:
>  	/* Put just found gap into cache to speed up subsequent requests */
>  	ext_debug(inode, " -> %u:%u\n", hole_start, len);
> -	ext4_es_cache_extent(inode, hole_start, len, ~0, EXTENT_STATUS_HOLE);
> +	ext4_es_cache_extent(inode, hole_start, len, ~0, EXTENT_STATUS_HOLE,
> +			     false);
>  
>  	/* Update hole_len to reflect hole size after lblk */
>  	if (hole_start != lblk)
> @@ -4310,13 +4311,15 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  		ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
>  		ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
>  		unsigned short ee_len;
> -
> +		unsigned int status;
>  
>  		/*
>  		 * unwritten extents are treated as holes, except that
>  		 * we split out initialized portions during a write.
>  		 */
>  		ee_len = ext4_ext_get_actual_len(ex);
> +		status = ext4_ext_is_unwritten(ex) ?
> +			 EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
>  
>  		trace_ext4_ext_show_extent(inode, ee_block, ee_start, ee_len);
>  
> @@ -4328,6 +4331,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  			ext_debug(inode, "%u fit into %u:%d -> %llu\n",
>  				  map->m_lblk, ee_block, ee_len, newblock);
>  
> +			if (!(flags & (EXT4_GET_BLOCKS_CREATE |
> +				       EXT4_EX_NOCACHE)))
> +				ext4_es_cache_extent(inode, ee_block, ee_len,
> +						     ee_start, status,
> +						     true);
> +
>  			/*
>  			 * If the extent is initialized check whether the
>  			 * caller wants to convert it to unwritten.
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 6e4a191e82191..5a03878b06160 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -1023,7 +1023,7 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>   */
>  void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>  			  ext4_lblk_t len, ext4_fsblk_t pblk,
> -			  unsigned int status)
> +			  unsigned int status, bool pre_search)
>  {
>  	struct extent_status *es;
>  	struct extent_status chkes, newes;
> @@ -1043,6 +1043,21 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>  
>  	BUG_ON(end < lblk);
>  
> +	/*
> +	 * Avoid taking i_es_lock for writing if the entire extent is already
> +	 * cached. The write-locked search below rechecks after a miss.
> +	 */
> +	if (pre_search) {
> +		read_lock(&EXT4_I(inode)->i_es_lock);
> +		es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
> +		if (es && es->es_lblk <= lblk && ext4_es_end(es) >= end &&
> +		    !__es_check_extent_status(es, status, NULL)) {
> +			read_unlock(&EXT4_I(inode)->i_es_lock);
> +			return;
> +		}
> +		read_unlock(&EXT4_I(inode)->i_es_lock);
> +	}
> +
>  	write_lock(&EXT4_I(inode)->i_es_lock);
>  	es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
>  	if (es && es->es_lblk <= end) {
> diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> index f3396cf32b446..c2da72e3c82ba 100644
> --- a/fs/ext4/extents_status.h
> +++ b/fs/ext4/extents_status.h
> @@ -139,7 +139,7 @@ extern void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>  				  bool delalloc_reserve_used);
>  extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>  				 ext4_lblk_t len, ext4_fsblk_t pblk,
> -				 unsigned int status);
> +				 unsigned int status, bool pre_search);
>  extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  				  ext4_lblk_t len);
>  extern void ext4_es_find_extent_range(struct inode *inode,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b2..d43266c489785 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -523,7 +523,7 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
>  
>  	if (retval <= 0) {
>  		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
> -				     map->m_pblk, status);
> +				     map->m_pblk, status, true);
>  		return map->m_len;
>  	}
>  
> @@ -546,11 +546,11 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
>  			status == status2) {
>  		ext4_es_cache_extent(inode, map->m_lblk,
>  				     map->m_len + map2.m_len, map->m_pblk,
> -				     status);
> +				     status, true);
>  		map->m_len += map2.m_len;
>  	} else {
>  		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
> -				     map->m_pblk, status);
> +				     map->m_pblk, status, true);
>  	}
>  
>  	return map->m_len;
> @@ -562,6 +562,13 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
>  	unsigned int status;
>  	int retval;
>  	unsigned int orig_mlen = map->m_len;
> +	/*
> +	 * ext4_ext_map_blocks() may have already cached the full extent, so
> +	 * search first to avoid taking i_es_lock for writing. The indirect
> +	 * path does not prepopulate the ES tree after the initial lookup miss.
> +	 */
> +	bool pre_search = ext4_test_inode_flag(inode,
> +					      EXT4_INODE_EXTENTS);
>  
>  	flags &= EXT4_EX_QUERY_FILTER;
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> @@ -593,7 +600,7 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
>  		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
>  				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
>  		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
> -				     map->m_pblk, status);
> +				     map->m_pblk, status, pre_search);
>  	} else {
>  		retval = ext4_map_query_blocks_next_in_leaf(handle, inode, map,
>  							    orig_mlen);
> -- 
> 2.39.5 (Apple Git-154)
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
