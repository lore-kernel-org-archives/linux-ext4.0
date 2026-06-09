Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A63F3FE668
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 11:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781003857; cv=none; b=MHyGEH3QCdt7fjby7X4dw80xaq4amlPVXfR9b2Z9OMeNDmvyBuJ8MTb+56A+5bhpTQ2Ib5b41Vh8w8R8VuY6ouJ/SSlPa4Zw0jJ5zfSpJk3AtkGJXkhF8LYkO4evU+KhPNs9usXliD6jFDZ4FIHx3VZtaFhmZJnCDZ9d8OpKGEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781003857; c=relaxed/simple;
	bh=I6U7Jo/COmmpFaH2OS33EQ0+I5jA65+o66VaL32ql5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTMn1ls2q5onUEWMNbtvgfcylTnBXlAJCRSFSov8liGYIsSmInKmUytaThy1lZzZhDrcAincGtXgYehzk1QXqV2LIrjqEDU1F8VSXMe0S5lJ2IgzSgh5YWiHyRBLZvv+9aiMlpaHXZsfNrK4J+Wx9/Ui6o7g46gQbFlmRK6LYfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1bcVff8i; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=waAcmvvV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1bcVff8i; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=waAcmvvV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1bcVff8i";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="waAcmvvV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1bcVff8i";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="waAcmvvV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 254486AAAA;
	Tue,  9 Jun 2026 11:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781003853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MOpHjUmdNEgnAISdKbnMmtX1O1g6AoJGWPZiFiwoWu0=;
	b=1bcVff8iWNruaCAc3npKYqLBAW0jeAULM4GlSTWkqo3353LYeP9neraKALjltINm2qzUyg
	0RxhoYstMMkKSG++YHiud8bKrgq7KYPiQFo7GMOb85jpeHtc6SZo6mKjKHDYnbipDViGIg
	e0SrOhpKVRlIGBEnsfUvr15V4S5rn/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781003853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MOpHjUmdNEgnAISdKbnMmtX1O1g6AoJGWPZiFiwoWu0=;
	b=waAcmvvViq0mRWmmtGqQ0HiptHyCwTaogQxVX1tTV/6OvGeH1mLsyYgnriJ6LTwusdGqHd
	EY5FErQlNiHcwqAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1bcVff8i;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=waAcmvvV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781003853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MOpHjUmdNEgnAISdKbnMmtX1O1g6AoJGWPZiFiwoWu0=;
	b=1bcVff8iWNruaCAc3npKYqLBAW0jeAULM4GlSTWkqo3353LYeP9neraKALjltINm2qzUyg
	0RxhoYstMMkKSG++YHiud8bKrgq7KYPiQFo7GMOb85jpeHtc6SZo6mKjKHDYnbipDViGIg
	e0SrOhpKVRlIGBEnsfUvr15V4S5rn/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781003853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MOpHjUmdNEgnAISdKbnMmtX1O1g6AoJGWPZiFiwoWu0=;
	b=waAcmvvViq0mRWmmtGqQ0HiptHyCwTaogQxVX1tTV/6OvGeH1mLsyYgnriJ6LTwusdGqHd
	EY5FErQlNiHcwqAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1B8AC779A7;
	Tue,  9 Jun 2026 11:17:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LpC3Bk32J2oqEAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 11:17:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B4C4EA0A90; Tue, 09 Jun 2026 13:17:32 +0200 (CEST)
Date: Tue, 9 Jun 2026 13:17:32 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, dmonakhov@openvz.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: validate donor file superblock early in
 EXT4_IOC_MOVE_EXT
Message-ID: <gy575xpwrcyfm55tyrljna67j2cens63fdhmh5igrvqauiijp2@3r5uvdcgbqh7>
References: <20260608152521.1292656-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608152521.1292656-1-yun.zhou@windriver.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 254486AAAA
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,syzkaller.appspot.com:url,suse.cz:email,suse.cz:dkim,appspotmail.com:email];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,openvz.org,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,windriver.com:email,suse.com:email,appspotmail.com:email,suse.cz:email,suse.cz:dkim,syzkaller.appspot.com:url]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon 08-06-26 23:25:21, Yun Zhou wrote:
> Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
> belong to the same superblock as the original file.  Currently, this
> validation is performed inside ext4_move_extents() by
> mext_check_validity(), but only after lock_two_nondirectories() has
> already acquired the inode locks.  When the donor fd refers to a file
> on a different filesystem (e.g., overlayfs), this late validation
> creates a circular lock dependency:
> 
>   CPU0 (overlayfs write)            CPU1 (ext4 ioctl)
>   ----                              ----
>   inode_lock(ovl_inode)
>                                     mnt_want_write_file(filp)
>                                       sb_start_write(ext4_sb)   [sb_writers]
>     backing_file_write_iter()
>       vfs_iter_write(real_file)
>         file_start_write(real_file)
>           sb_start_write(ext4_sb)   [blocked by freeze]
>                                     lock_two_nondirectories()
>                                       inode_lock(ovl_inode)     [blocked]
> 
> With a concurrent freeze operation holding sb_writers write side, this
> forms a deadlock cycle: CPU0 waits for freeze to complete, freeze waits
> for CPU1's sb_writers reader to exit, CPU1 waits for CPU0's inode lock.
> 
> Since EXT4_IOC_MOVE_EXT exchanges physical extents between two files,
> it fundamentally requires both files to reside on the same ext4
> filesystem.  Moving the superblock check before any lock acquisition
> is both semantically correct and eliminates the circular dependency
> by ensuring that cross-filesystem donor fds are rejected before
> sb_writers or inode locks are taken.
> 
> Fixes: fcf6b1b729bc ("ext4: refactor ext4_move_extents code base")
> Reported-by: syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ad6118a7584b607c67f2
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Good catch. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 1d0c3d4bdf47..f7cd419a3218 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1650,6 +1650,9 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		if (!(fd_file(donor)->f_mode & FMODE_WRITE))
>  			return -EBADF;
>  
> +		if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb)
> +			return -EXDEV;
> +
>  		err = mnt_want_write_file(filp);
>  		if (err)
>  			return err;
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
