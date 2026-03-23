Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D9C38A707
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 10:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774260519; cv=none; b=fAQ4nes9nXW5zNVCWIwyhGUMn3uwry5e6WlxGEIZf+COaX9XyAeJ6BeJmDmyMcCzpbx9MwQI3It3UWFOcQzEXpSMKEdq/gM708p0Eal50Llu//3WHCOG/oFErT7dWhyTHU+uh4/xKbMAJDo9a0xP5iGT8qa8u6h2sA8Nf8pWaLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774260519; c=relaxed/simple;
	bh=wJBytfBydvHtQrF2rFcMT3pHUBq+BLpKeqD3d1qVzWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdN9TLHR0Phwb1jfYab1YzEsX/9zf5dVFNhcbdZIONETD48x/5zrjNZENVmw38N2B4pWKt+nKoCwcCH7Q6LQpgerLcZWj/k3oaVN8n//N7PG/Vakvw2x83hL8qpEZzVmgAZ9SEFcerESCqYjBZ6bvmndwNWUMy4902UWi7iXiJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=W/jI4AWu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=i3qemKyR; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=W/jI4AWu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=i3qemKyR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="W/jI4AWu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="i3qemKyR";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="W/jI4AWu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="i3qemKyR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0381B5BD63;
	Mon, 23 Mar 2026 10:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774260515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UifoR3lYP2aM7PFPwNofvy3iN43Gnv144p63RA+VeS4=;
	b=W/jI4AWukrJQiJUSlOXFswF+y3Bi1oAuO7RYqdyKntTHsbSEjVC7ucYHNL0T0TKAbW+FBm
	RLiON5cUoqDv2hitDTeCsPwbIAiIbYIvNjV0u7H7VUc8mMnUdYhB+6ak3DlRjTI0/OTA5p
	F6LCOXtH060X+rPO83DhmaJssGyJcD4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774260515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UifoR3lYP2aM7PFPwNofvy3iN43Gnv144p63RA+VeS4=;
	b=i3qemKyR5EEESovmEa7wyC+dRX4ztfd0GbiQT9S/QBJIGVr2LFJqY7eKHN3IRaYcuf3fGf
	MJEA/tTZceCKjNAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="W/jI4AWu";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i3qemKyR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774260515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UifoR3lYP2aM7PFPwNofvy3iN43Gnv144p63RA+VeS4=;
	b=W/jI4AWukrJQiJUSlOXFswF+y3Bi1oAuO7RYqdyKntTHsbSEjVC7ucYHNL0T0TKAbW+FBm
	RLiON5cUoqDv2hitDTeCsPwbIAiIbYIvNjV0u7H7VUc8mMnUdYhB+6ak3DlRjTI0/OTA5p
	F6LCOXtH060X+rPO83DhmaJssGyJcD4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774260515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UifoR3lYP2aM7PFPwNofvy3iN43Gnv144p63RA+VeS4=;
	b=i3qemKyR5EEESovmEa7wyC+dRX4ztfd0GbiQT9S/QBJIGVr2LFJqY7eKHN3IRaYcuf3fGf
	MJEA/tTZceCKjNAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EDE6043804;
	Mon, 23 Mar 2026 10:08:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Xe4ROiIRwWmCCwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 10:08:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B4271A0B2E; Mon, 23 Mar 2026 11:08:30 +0100 (CET)
Date: Mon, 23 Mar 2026 11:08:30 +0100
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH] ext4: fix iloc.bh leak in ext4_fc_replay_inode() error
 paths
Message-ID: <2erco6c5uqq3j4lgpg5nuvlx36lke7yb4adb7xngeyebnxnvsn@5duqrm7357e3>
References: <20260323060836.3452660-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323060836.3452660-1-libaokun@linux.alibaba.com>
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[iloc.bh:url,suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,alibaba.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com,linux.alibaba.com];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,alibaba.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0381B5BD63

On Mon 23-03-26 14:08:36, Baokun Li wrote:
> During code review, Joseph found that ext4_fc_replay_inode() calls
> ext4_get_fc_inode_loc() to get the inode location, which holds a
> reference to iloc.bh that must be released via brelse().
> 
> However, several error paths jump to the 'out' label without
> releasing iloc.bh:
> 
>  - ext4_handle_dirty_metadata() failure
>  - sync_dirty_buffer() failure
>  - ext4_mark_inode_used() failure
>  - ext4_iget() failure
> 
> Fix this by introducing an 'out_brelse' label placed just before
> the existing 'out' label to ensure iloc.bh is always released.
> 
> Additionally, make ext4_fc_replay_inode() propagate errors
> properly instead of always returning 0.
> 
> Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/fast_commit.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index f575751f1cae..f1df5581fa96 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -1613,19 +1613,21 @@ static int ext4_fc_replay_inode(struct super_block *sb,
>  	/* Immediately update the inode on disk. */
>  	ret = ext4_handle_dirty_metadata(NULL, NULL, iloc.bh);
>  	if (ret)
> -		goto out;
> +		goto out_brelse;
>  	ret = sync_dirty_buffer(iloc.bh);
>  	if (ret)
> -		goto out;
> +		goto out_brelse;
>  	ret = ext4_mark_inode_used(sb, ino);
>  	if (ret)
> -		goto out;
> +		goto out_brelse;
>  
>  	/* Given that we just wrote the inode on disk, this SHOULD succeed. */
>  	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
>  	if (IS_ERR(inode)) {
>  		ext4_debug("Inode not found.");
> -		return -EFSCORRUPTED;
> +		inode = NULL;
> +		ret = -EFSCORRUPTED;
> +		goto out_brelse;
>  	}
>  
>  	/*
> @@ -1642,13 +1644,14 @@ static int ext4_fc_replay_inode(struct super_block *sb,
>  	ext4_inode_csum_set(inode, ext4_raw_inode(&iloc), EXT4_I(inode));
>  	ret = ext4_handle_dirty_metadata(NULL, NULL, iloc.bh);
>  	sync_dirty_buffer(iloc.bh);
> +out_brelse:
>  	brelse(iloc.bh);
>  out:
>  	iput(inode);
>  	if (!ret)
>  		blkdev_issue_flush(sb->s_bdev);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  /*
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
