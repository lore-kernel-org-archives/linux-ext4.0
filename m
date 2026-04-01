Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22F1175A8D
	for <linux-ext4@vger.kernel.org>; Wed,  1 Apr 2026 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775063229; cv=none; b=B88H2+mjRYK9Vum+9tvstM4F2LzH0Zenbq55x90OVT5Vc+wqPlvR5D4YhS82heTNx29NzIPxED6Oau3JyV9nJy0QWqFmWmFl1D5vcp/ndND8YNaMjbfpg8Fjx/pn67HTHKm7UmgVsZVVu6NhSQpDEOIyj+nKOZhT9mn2Nb73I0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775063229; c=relaxed/simple;
	bh=xRsKN8MrdETEILgWHpUGTvIUTJ3n7YLEUWqMJULpGEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtdV/nZI8rAq8QBUOLUWfiZ9/mdkiBLGwVN5hmmAfAFhch8w76qBXw1AGycj/Rw2ZLuyA2S1yb9as9IUDgpJum2lstxfP6kqr3rvTPM3YbsIaAQsU3TFMv4XMYZjhD0Y1uw8WrCUtYuh8EMQcg4WogIK2YXJiTxwqCENnbYhpik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nJTtVf3j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Qag/9aOP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nJTtVf3j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Qag/9aOP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nJTtVf3j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Qag/9aOP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nJTtVf3j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Qag/9aOP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2E4F44D2F2;
	Wed,  1 Apr 2026 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775063226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=62cpOEFcjibuBDALz/XAHBkgr56beA18PKbbvkuIyfc=;
	b=nJTtVf3jOx5wYjbvpOh9RPte7pQlfELYOoWH8In1g94DPSg0KgiRs5V5huw+W1P8b7pLen
	vTfdPsFdJ/VsEBQLZY8/OCqCLQkRvdZypHhKbrEmYLiYzWw9wWukqiBLaYR1WDyzKmDPrj
	Zf5ICwIzOxc7hVvY/XEaxDLlt7uhq0U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775063226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=62cpOEFcjibuBDALz/XAHBkgr56beA18PKbbvkuIyfc=;
	b=Qag/9aOPRrCU+DLCn73MbXhFy5xF95uF5OfGbUEFyobAsI0VpmNgck8EP2AAQvJdySMKYc
	NKj1mvkW1jbjYuDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nJTtVf3j;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Qag/9aOP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775063226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=62cpOEFcjibuBDALz/XAHBkgr56beA18PKbbvkuIyfc=;
	b=nJTtVf3jOx5wYjbvpOh9RPte7pQlfELYOoWH8In1g94DPSg0KgiRs5V5huw+W1P8b7pLen
	vTfdPsFdJ/VsEBQLZY8/OCqCLQkRvdZypHhKbrEmYLiYzWw9wWukqiBLaYR1WDyzKmDPrj
	Zf5ICwIzOxc7hVvY/XEaxDLlt7uhq0U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775063226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=62cpOEFcjibuBDALz/XAHBkgr56beA18PKbbvkuIyfc=;
	b=Qag/9aOPRrCU+DLCn73MbXhFy5xF95uF5OfGbUEFyobAsI0VpmNgck8EP2AAQvJdySMKYc
	NKj1mvkW1jbjYuDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 21E5B4A0B0;
	Wed,  1 Apr 2026 17:07:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zntECLpQzWnjJQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Apr 2026 17:07:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DD8B2A0B39; Wed,  1 Apr 2026 19:06:50 +0200 (CEST)
Date: Wed, 1 Apr 2026 19:06:50 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 10/13] ext4: unify SYNC mode checks in fallocate paths
Message-ID: <k3ql262rzl6zn4vgkdqz2h2y55etwo6fcvyupb4l45ydcqhsha@wu7w74sjd5wr>
References: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
 <20260327102939.1095257-11-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327102939.1095257-11-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2E4F44D2F2

On Fri 27-03-26 18:29:36, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In the ext4 fallocate call chain, SYNC mode handling is inconsistent:
> some places check the inode state, while others check the open file
> descriptor state. Unify these checks by evaluating both conditions
> to ensure consistent behavior across all fallocate operations.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Ah, OK, you unify it here :). Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 9 +++++----
>  fs/ext4/inode.c   | 2 +-
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 16386f499138..f4009544f762 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4753,7 +4753,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  		goto out_handle;
>  
>  	ext4_update_inode_fsync_trans(handle, inode, 1);
> -	if (file->f_flags & O_SYNC)
> +	if ((file->f_flags & O_SYNC) || IS_SYNC(inode))
>  		ext4_handle_sync(handle);
>  
>  out_handle:
> @@ -4791,7 +4791,8 @@ static long ext4_do_fallocate(struct file *file, loff_t offset,
>  	if (ret)
>  		goto out;
>  
> -	if (file->f_flags & O_SYNC && EXT4_SB(inode->i_sb)->s_journal) {
> +	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) &&
> +	    EXT4_SB(inode->i_sb)->s_journal) {
>  		ret = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
>  					EXT4_I(inode)->i_sync_tid);
>  	}
> @@ -5564,7 +5565,7 @@ static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
>  		goto out_handle;
>  
>  	ext4_update_inode_fsync_trans(handle, inode, 1);
> -	if (IS_SYNC(inode))
> +	if ((file->f_flags & O_SYNC) || IS_SYNC(inode))
>  		ext4_handle_sync(handle);
>  
>  out_handle:
> @@ -5688,7 +5689,7 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
>  		goto out_handle;
>  
>  	ext4_update_inode_fsync_trans(handle, inode, 1);
> -	if (IS_SYNC(inode))
> +	if ((file->f_flags & O_SYNC) || IS_SYNC(inode))
>  		ext4_handle_sync(handle);
>  
>  out_handle:
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b934ad86a96d..3b150e643ef5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4501,7 +4501,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>  		goto out_handle;
>  
>  	ext4_update_inode_fsync_trans(handle, inode, 1);
> -	if (IS_SYNC(inode))
> +	if ((file->f_flags & O_SYNC) || IS_SYNC(inode))
>  		ext4_handle_sync(handle);
>  out_handle:
>  	ext4_journal_stop(handle);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
