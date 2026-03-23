Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3887A36E48C
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 20:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774297040; cv=none; b=t3gfMESywPQEAoubViIzxVSQ8BUHtcc0aVQE1zUpc6ruVSIsyAtg18Yh9xJulqKFIIPn7ZG2Q4AMdHSuY5fz7frgr+MkgITe5H9LO7UCPtNR1SyMJwm0ZfV+lb5UWkdVCbjCEkO09CiLicRSdb3Ts6VnG9w7/p6IQadI30xgnCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774297040; c=relaxed/simple;
	bh=O1WfgoKoWnW5maMpC3bTQRzcL+bjCm7WNU6Tq7gtwWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHPZA9r9od/01tCDawCTcLJMp/Du4wTk7E9b05PHmMcKsBBgEHNFGHXAgYxHsyCfd4+JdifmxXGrhqHgtZuSncNN0SOR6gM21FZCtPTqoAO3ThWDEZxLzRsbMbjFvyQWy9XYgkEZdrCr+hfahkVQjo+f8u6Gd1NhmvpM5HjSmNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BSumbq3Z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iQSaW5lW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KgX3jhlv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RYPSQ6Qi; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BSumbq3Z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iQSaW5lW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KgX3jhlv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RYPSQ6Qi"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 302324D378;
	Mon, 23 Mar 2026 20:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774297031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4SVOWVM0TULgyGv/HiffeJaNrMWBRTaXaja5z2eRA6U=;
	b=BSumbq3Z2rEM9k+hGYhKEVW0uHtI8GK0Jr6y4vkjSCG+luqcXXPlBq/qOA3dfp5etb8X9K
	VixdI9SxjXVdNoX+3n/jFPXJPugS5z3sQP79Y8lrQulY14apcxOxZu3kLGIwUt8zHA0Z1X
	rssOdCBDOOVP2NlviE0sFERFjHoS17A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774297031;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4SVOWVM0TULgyGv/HiffeJaNrMWBRTaXaja5z2eRA6U=;
	b=iQSaW5lWWD/QbpNzDNiX1OeNLuVDzDZKa6Ad6Tc7oqVYxGHwDd1cQBk8Eb1e1ukMuI8/lD
	C17WwgTkQcZ1fvBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774297030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4SVOWVM0TULgyGv/HiffeJaNrMWBRTaXaja5z2eRA6U=;
	b=KgX3jhlvUOYZZTPyKrQ1J/E56tg4fi9dUZSA8YQjaHU0AngK6a3xXVz0ib5M1/ItIg7Rr6
	fPRAvFEv4jPs8gukzMImd8a1ILmFnRNbBWp3ZvIeWgR/5/8DDioulL5/k/W4UKHM+uYGiI
	T8OhXinxTdOhmQOMrOye+IxIOrIpqqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774297030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4SVOWVM0TULgyGv/HiffeJaNrMWBRTaXaja5z2eRA6U=;
	b=RYPSQ6QiEXToI8MZdX37qQwpsKXg9zQw/NBdivnjhkINr5skH+nKHTGz4rNM3J2so7GRxs
	ZZE1cTdxPumpQKDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C53F43A65;
	Mon, 23 Mar 2026 20:17:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2R1tBsafwWllCwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 20:17:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C1BD7A0B32; Mon, 23 Mar 2026 21:17:09 +0100 (CET)
Date: Mon, 23 Mar 2026 21:17:09 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 09/10] ext4: move zero partial block range functions out
 of active handle
Message-ID: <irkaodowvqmpug3moetmd75vssj6czh67qzuxs4v5vxe56qxz7@opkvl3apdpuk>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-10-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310014101.4140698-10-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,huawei.com:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Tue 10-03-26 09:41:00, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Move ext4_block_zero_eof() and ext4_zero_partial_blocks() calls out of
> the active handle context, making them independent operations. This is
> safe because it still ensures data is updated before metadata for
> data=ordered mode and data=journal mode because we still zero data and
> ordering data before modifying the metadata.
> 
> This change is required for iomap infrastructure conversion because the
> iomap buffered I/O path does not use the same journal infrastructure for
> partial block zeroing. The lock ordering of folio lock and starting
> transactions is "folio lock -> transaction start", which is opposite of
> the current path. Therefore, zeroing partial blocks cannot be performed
> under the active handle.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

So in this patch you also move ext4_zero_partial_blocks() before the
transaction start in ext4_zero_range() and ext4_punch_hole(). However
cannot these operations in theory fail with error such as EDQUOT or ENOSPC
when they need to grow the extent tree as a result of the operation? In
that case we'd return such error but partial blocks are already zeroed out
which is a problem... OTOH in these cases we don't need to order the data
at all so in principle we shouldn't need to move the zeroing earlier
here. Am I missing something?

								Honza

> @@ -4722,25 +4724,18 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	if (IS_ALIGNED(offset | end, blocksize))
>  		return ret;
>  
> -	/*
> -	 * In worst case we have to writeout two nonadjacent unwritten
> -	 * blocks and update the inode
> -	 */
> -	credits = (2 * ext4_ext_index_trans_blocks(inode, 2)) + 1;
> -	if (ext4_should_journal_data(inode))
> -		credits += 2;
> -	handle = ext4_journal_start(inode, EXT4_HT_MISC, credits);
> +	/* Zero out partial block at the edges of the range */
> +	ret = ext4_zero_partial_blocks(inode, offset, len);
> +	if (ret)
> +		return ret;
> +
> +	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
>  		ext4_std_error(inode->i_sb, ret);
>  		return ret;
>  	}
>  
> -	/* Zero out partial block at the edges of the range */
> -	ret = ext4_zero_partial_blocks(inode, offset, len);
> -	if (ret)
> -		goto out_handle;
> -
>  	if (new_size)
>  		ext4_update_inode_size(inode, new_size);
>  	ret = ext4_mark_inode_dirty(handle, inode);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d5b783a7c814..5288d36b0f09 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4443,8 +4443,12 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	if (ret)
>  		return ret;
>  
> +	ret = ext4_zero_partial_blocks(inode, offset, length);
> +	if (ret)
> +		return ret;
> +
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> -		credits = ext4_chunk_trans_extent(inode, 2);
> +		credits = ext4_chunk_trans_extent(inode, 0);
>  	else
>  		credits = ext4_blocks_for_truncate(inode);
>  	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
> @@ -4454,10 +4458,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>  		return ret;
>  	}
>  
> -	ret = ext4_zero_partial_blocks(inode, offset, length);
> -	if (ret)
> -		goto out_handle;
> -
>  	/* If there are blocks to remove, do it */
>  	start_lblk = EXT4_B_TO_LBLK(inode, offset);
>  	end_lblk = end >> inode->i_blkbits;
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
