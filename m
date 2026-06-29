Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514533FC5C3
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 11:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733717; cv=none; b=MQ4thvBWD5og73w8n6Hg9t7dFacpGvCkVBl8HyJKEuS5GdkYSZL7Gs/Thwnf/NV83jlCXCh0s0n4dttj9PhVOlJTOlnflAAuLI+IbC8uTAPRcG35tTGVmyy/QHh/vuv+g4I04EIhUE1eozbqNv2gaJ2WUPDkbj7cGy7z3si72xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733717; c=relaxed/simple;
	bh=P0l7CjalronLoohNVtyjO24b8eFTDO0xQHwTuQRzopk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mv722u1rVnlrdj2w4k0RnctqQwBuN4NqjS0YQyk4dQyadhDFBCx4d6fzNDiN/u/mvoVz18jYzen3oU+z8Qu+fPSsWOVYKGknSnBFnVfxAHvAfvZJcLEJA1Fvp4yQJfhGF2TtAcQTFjLB+yLm6sWCgCc059WvEKYmAqYsQqFfMso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0KimJM+g; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OLFOhlct; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=S3fBPmQh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nNjpheIe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0KimJM+g";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OLFOhlct";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="S3fBPmQh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nNjpheIe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 80A4E73073;
	Mon, 29 Jun 2026 11:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782733712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z2huI/uMOtLRqPb0rUA1HiNwHTU0kVKVonusPpIa+e8=;
	b=0KimJM+gu806IxE3Cty/Uin7t+Xady5U7g1sXaW5I0XD9gVO53gEHHo3OMV0tcMoDxZg9U
	oW2ZjLNnCsAnoggTbIA0pf/2Rw6tJRYrWUnmLB/c7g67tmf1OIWsQ9ZchUyN1LfgUtE3uH
	raH39vtZcEll34Kfc8R9YPsXusaDmPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782733712;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z2huI/uMOtLRqPb0rUA1HiNwHTU0kVKVonusPpIa+e8=;
	b=OLFOhlct7ZjKpAJoAAn41TI979Lwt8fDIc/A6rO56xKazEmNds0bdyA2fziwhXndAfzLpV
	JyusCs+3ZG7/ivCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782733711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z2huI/uMOtLRqPb0rUA1HiNwHTU0kVKVonusPpIa+e8=;
	b=S3fBPmQhQv+atA02utEGtL737R9v46uxBwyxReteSJUGL1ICWe0l/sywnw2u6hqiEFjxjr
	AaBUDUIuyMyXVKTTq0LQfVmTvKNEIYQHyYNBVrmavnhV4BbFPdKn1huyx2ejctAZ4BuXcm
	BXAjJ5843OuL/v6veqShDjv1M5+NnrM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782733711;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z2huI/uMOtLRqPb0rUA1HiNwHTU0kVKVonusPpIa+e8=;
	b=nNjpheIeKTndnG6PvUMEhlY7T0XEBWftLlNpMBK/JoeqGLMbcpWC65UiLqjNTC92kX1f/2
	5hl7bO1OkLu7PuAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 68327779A8;
	Mon, 29 Jun 2026 11:48:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T5FuGY9bQmrLbAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 29 Jun 2026 11:48:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0C243A10B5; Mon, 29 Jun 2026 13:48:27 +0200 (CEST)
Date: Mon, 29 Jun 2026 13:48:27 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	xiaowu.417@qq.com
Subject: Re: [PATCH v11 5/5] ext4: prevent deadlock from duplicate EA inode
 references on corrupted fs
Message-ID: <n56mvpkgksgfkh7aulfwlxz2cxmw6bi7vuy2vmycgmbjbmyfda@4t5hcmngakq4>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-6-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629110848.3085662-6-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org,qq.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qq.com:email,windriver.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 

On Mon 29-06-26 19:08:48, Yun Zhou wrote:
> On a corrupted filesystem, multiple xattr entries within the same block
> or ibody may reference the same EA inode.  When
> ext4_xattr_inode_dec_ref_all() processes such entries, it decrements the
> EA inode's refcount to zero (clearing nlink) and releases it via
> ext4_put_ea_inode().  If the deferred iput worker begins evicting this
> inode before the loop encounters the duplicate entry, the second iget()
> blocks on I_FREEING while the worker's eviction path waits for the
> caller's jbd2 transaction to commit -- ABBA deadlock.
> 
> Fix by keeping a small on-stack array of EA inode numbers whose nlink
> has dropped to zero within each dec_ref_all() invocation.  Duplicate
> entries referencing such inodes are skipped before iget, eliminating the
> deadlock window entirely.  The array starts at 32 entries (more than
> sufficient for any valid xattr block) and grows dynamically with
> GFP_NOFS | __GFP_NOFAIL for the pathological case.

No, this seems like rather incomplete fix to the problem AFAICT. Any
ext4_iget() of EA inode while having a transaction started can deadlock
like this, not just ext4_xattr_inode_dec_ref_all(). Thus a fix also has to
be more complete, not just local to ext4_xattr_inode_dec_ref_all(). As I
wrote, just drop this patch from now. We can look at fixing this problem
later.

								Honza

> 
> For legitimate EA inode dedup (same ino appearing multiple times with
> ref_count > 1), dec_ref only clears nlink when ref_count reaches zero,
> so such entries are not added to the skip array and are still properly
> decremented on subsequent encounters.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Tested-by: Xiao Wu <xiaowu.417@qq.com>
> ---
>  fs/ext4/xattr.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 01b9aff0cd25..85ad2561474b 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1152,6 +1152,25 @@ static int ext4_xattr_restart_fn(handle_t *handle, struct inode *inode,
>  	return 0;
>  }
>  
> +/* Track an EA inode number in the dedup array, expanding if needed. */
> +static void ea_ino_array_add(unsigned int **ea_inos, unsigned int *nr,
> +			     unsigned int *size, unsigned int *inline_arr,
> +			     unsigned int ino)
> +{
> +	if (*nr == *size) {
> +		unsigned int new_size = *size * 2;
> +		unsigned int *p;
> +
> +		p = kmalloc_array(new_size, sizeof(*p), GFP_NOFS | __GFP_NOFAIL);
> +		memcpy(p, *ea_inos, *nr * sizeof(*p));
> +		if (*ea_inos != inline_arr)
> +			kfree(*ea_inos);
> +		*ea_inos = p;
> +		*size = new_size;
> +	}
> +	(*ea_inos)[(*nr)++] = ino;
> +}
> +
>  static void
>  ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  			     struct buffer_head *bh,
> @@ -1166,6 +1185,10 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  	int err;
>  	int credits;
>  	void *end;
> +	unsigned int ea_inos_inline[32];
> +	unsigned int *ea_inos = ea_inos_inline;
> +	unsigned int nr_ea_inos = 0;
> +	unsigned int ea_inos_size = ARRAY_SIZE(ea_inos_inline);
>  
>  	if (block_csum)
>  		end = (void *)bh->b_data + bh->b_size;
> @@ -1183,9 +1206,24 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  
>  	for (entry = first; (void *)entry < end && !IS_LAST_ENTRY(entry);
>  	     entry = EXT4_XATTR_NEXT(entry)) {
> +		unsigned int i;
> +
>  		if (!entry->e_value_inum)
>  			continue;
>  		ea_ino = le32_to_cpu(entry->e_value_inum);
> +
> +		/*
> +		 * Skip EA inodes we already processed.  On a corrupted fs,
> +		 * duplicate entries may point to the same EA inode; without
> +		 * this check, the second iget could deadlock on I_FREEING
> +		 * if the deferred worker already started evicting it.
> +		 */
> +		for (i = 0; i < nr_ea_inos; i++)
> +			if (ea_inos[i] == ea_ino)
> +				break;
> +		if (i < nr_ea_inos)
> +			continue;
> +
>  		err = ext4_xattr_inode_iget(parent, ea_ino,
>  					    le32_to_cpu(entry->e_hash),
>  					    &ea_inode);
> @@ -1218,6 +1256,11 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  		if (err) {
>  			ext4_warning_inode(ea_inode, "ea_inode dec ref err=%d",
>  					   err);
> +			/* Track if nlink==0 to skip duplicates (eviction risk) */
> +			if (!ea_inode->i_nlink)
> +				ea_ino_array_add(&ea_inos, &nr_ea_inos,
> +						 &ea_inos_size, ea_inos_inline, ea_ino);
> +
>  			ext4_put_ea_inode(parent->i_sb, ea_inode);
>  			continue;
>  		}
> @@ -1235,10 +1278,22 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  		entry->e_value_inum = 0;
>  		entry->e_value_size = 0;
>  
> +		/*
> +		 * Track nlink==0 EA inodes to skip duplicates later --
> +		 * they risk I_FREEING deadlock on re-iget.
> +		 * Check nlink before put since put releases our reference.
> +		 */
> +		if (!ea_inode->i_nlink)
> +			ea_ino_array_add(&ea_inos, &nr_ea_inos,
> +					 &ea_inos_size, ea_inos_inline, ea_ino);
> +
>  		ext4_put_ea_inode(parent->i_sb, ea_inode);
>  		dirty = true;
>  	}
>  
> +	if (ea_inos != ea_inos_inline)
> +		kfree(ea_inos);
> +
>  	if (dirty) {
>  		/*
>  		 * Note that we are deliberately skipping csum calculation for
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
