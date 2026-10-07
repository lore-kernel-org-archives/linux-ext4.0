Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3943C3432;
	Wed,  7 Oct 2026 13:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380490; cv=none; b=VimLP/NoJF1KimF6GvtqPsRd5w1IYBSxSlOk7y7xqhCJFLV3PFML6OL/OMQi+b2wIfrzeV3tdnwZSif4VOHFGP8ysFfpaO8CgFgpHG9dNheWDQHCcq8E0oFN2UH88KG5EhrXkwhpt5I4fz+00Y3COupSyMxRk5Jl+e343VTg8oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380490; c=relaxed/simple;
	bh=G6Cn4aWGu960jqpFJJDNbTLjUqGVyex7ECOOJUskyM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aqIMorBuMDsxQNeybecvJrQ8mcvpOyo/8O5ZhyQRl6so//elVwQyJj6/nstenFu/OjX4yOHufXVDq/AQA23ymeommVAWDQMzTr0kbY8xdjSqYfLAvtAy9llLPNXRSm7EWA+fNT3pJGRt5ioLDjNUbsnlHI5zZSl0TVFR1ClI3XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YCTu/eUA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CeCl9I8u; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YCTu/eUA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CeCl9I8u; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YCTu/eUA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CeCl9I8u";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YCTu/eUA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CeCl9I8u"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AFA5821BFC;
	Wed,  7 Oct 2026 13:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791380478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DN7h6EuSYm/tY0wAea1jrs+jdc5RroYMh9Q4rQrswQM=;
	b=YCTu/eUAAMuh03aun/r4HjJsU4q3/Dd5gp40ZDdKYF5Jq9VnPmJETnCi5wG4adTchga5y1
	wgyQQOFHcIY+/CGwbdrYRfxghkursfqb8p4HgkVBpB8o+NgTc6+5l9tax5baSyyb/BLJg/
	Q/r+WHJv4AZrMQnAWDTRmWYWico1jqc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791380478;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DN7h6EuSYm/tY0wAea1jrs+jdc5RroYMh9Q4rQrswQM=;
	b=CeCl9I8uuiE8AzdNjBWkV5a1NKOxpiRw4lka9ucnME5xe2tndC+KlCzXo2fgN5cPe7v9r9
	tNlgncLMVxl+mcDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="YCTu/eUA";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CeCl9I8u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791380478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DN7h6EuSYm/tY0wAea1jrs+jdc5RroYMh9Q4rQrswQM=;
	b=YCTu/eUAAMuh03aun/r4HjJsU4q3/Dd5gp40ZDdKYF5Jq9VnPmJETnCi5wG4adTchga5y1
	wgyQQOFHcIY+/CGwbdrYRfxghkursfqb8p4HgkVBpB8o+NgTc6+5l9tax5baSyyb/BLJg/
	Q/r+WHJv4AZrMQnAWDTRmWYWico1jqc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791380478;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DN7h6EuSYm/tY0wAea1jrs+jdc5RroYMh9Q4rQrswQM=;
	b=CeCl9I8uuiE8AzdNjBWkV5a1NKOxpiRw4lka9ucnME5xe2tndC+KlCzXo2fgN5cPe7v9r9
	tNlgncLMVxl+mcDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7215C13312;
	Wed,  7 Oct 2026 13:41:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gJT3E/5LxmrKGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 07 Oct 2026 13:41:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AE494A13FE; Wed, 07 Oct 2026 15:41:17 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:41:17 +0200
From: Jan Kara <jack@suse.cz>
To: daejun7.park@samsung.com
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Zhang Yi <yi.zhang@huaweicloud.com>, Harshad Shirwadkar <harshadshirwadkar@gmail.com>, 
	Li Chen <me@linux.beauty>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: track zeroed out blocks of unwritten extents
 for fast commit
Message-ID: <vxase3lkctmatpkj3p4vvhgyrvauqyilkfd5dcz47jjtgfdipx@imb4onyzk3bw>
References: <20261007-ext4-fc-zeroout-v1-0-b86de6439431@samsung.com>
 <20261007-ext4-fc-zeroout-v1-2-b86de6439431@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-ext4-fc-zeroout-v1-2-b86de6439431@samsung.com>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: AFA5821BFC
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.51
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
	RCPT_COUNT_TWELVE(0.00)[14];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,suse.cz,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,linux.beauty];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,samsung.com:email,suse.com:email]

On Wed 07-10-26 09:41:21, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> When ext4_ext_convert_to_initialized() converts part of an unwritten
> extent, it may zero out the blocks before and after that range (a side
> only if it fits together with the range in s_extent_max_zeroout_kb,
> 32 KiB by default, and the extent lies within i_size) and convert them
> to written together with it, instead of splitting them off.
> ext4_split_extent() zeroes out and converts the whole extent when a
> split fails with -ENOSPC, -EDQUOT or -ENOMEM. In both cases
> ext4_map_blocks() reports only the mapped range to fast commit, so the
> other converted blocks are not tracked.
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
> Track the zeroed out blocks in ext4_zeroout_es(), and the whole extent
> in ext4_split_extent_zeroout() when it converts one to written. Both run
> under i_data_sem, as fast commit tracking already does when
> ext4_ext_dirty() changes an extent kept in the inode (through
> ext4_mark_inode_dirty()).
> 
> Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
> Cc: stable@vger.kernel.org # 7.0.x
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Thanks for catching this. Some comments below.

> -static void ext4_zeroout_es(struct inode *inode, struct ext4_extent *ex)
> +static void ext4_zeroout_es(handle_t *handle, struct inode *inode,
> +			    struct ext4_extent *ex)
>  {
>  	ext4_lblk_t  ee_block;
>  	ext4_fsblk_t ee_pblock;
> @@ -3164,6 +3165,12 @@ static void ext4_zeroout_es(struct inode *inode, struct ext4_extent *ex)
>  
>  	ext4_es_insert_extent(inode, ee_block, ee_len, ee_pblock,
>  			      EXTENT_STATUS_WRITTEN, false);
> +	/*
> +	 * The zeroed out blocks became written together with the mapped
> +	 * range, but ext4_map_blocks() reports only the mapped range to fast
> +	 * commit.
> +	 */
> +	ext4_fc_track_range(handle, inode, ee_block, ee_block + ee_len - 1);
>  }

It looks a bit odd to hide ext4_fc_track_range() inside a function for
extent status tree tracking. Also see below.

> @@ -3400,6 +3407,14 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
>  	if (err)
>  		return err;
>  
> +	/*
> +	 * The whole extent is written now, not only the range in @map that
> +	 * ext4_map_blocks() reports to fast commit.
> +	 */
> +	if (flags & EXT4_GET_BLOCKS_CONVERT)
> +		ext4_fc_track_range(handle, inode, ee_block,
> +				    ee_block + ee_len - 1);
> +
>  	return 0;
>  }

Also putting this into ext4_split_extent_zeroout() looks a bit too easy to
miss. In fact I think placing ext4_fc_track_range() into
ext4_issue_zeroout() would make sense because that is where the writing of
"data" really happens. This will fix the use in
ext4_split_extent_zeroout() as well as ext4_ext_convert_to_initialized().
And it will also fix the same class of problem which I think we have in
ext4_alloc_file_blocks()...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
