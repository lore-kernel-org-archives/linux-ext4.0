Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D69F4FECE8;
	Tue, 13 Oct 2026 12:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894608; cv=none; b=ivCFMJFa0luaeVXaQxZzxeCACj/xpDE8+NLsEb2ZiHHfuedhW9TdFMgy3xAXWRtADraGxOFMZijI83oIYbFhOb94IsACbJZJ1/I85dGRT3QChvf8lucZLr0w822Vib3pBynsVC4YkASJtunqdFCXT+yfs0KbUiLGjhScfv7D5m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894608; c=relaxed/simple;
	bh=Ayu+ZZlgY2on5YZW0cNyNphAR0yz/HXy7y7bN70sK7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DWq1PL61Iu+uBti04wlQlkwbI5B5aGc2jShmeOe7vcTXP7orKOA5qAPZ4TCpDVoqkoASEqPuc8hjPBzaDEjlD6UEIKlqVi9pb1I2t6S23Sy7SsWpUkIXLYXi8X/oTB+CgnqVI8Rm2EQj90662TY7XLzj66LT9p41nlQmStMhUtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EMbC6/Cv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xG6wX5Y7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EMbC6/Cv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xG6wX5Y7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EMbC6/Cv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xG6wX5Y7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EMbC6/Cv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xG6wX5Y7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 29A6B1F38E;
	Tue, 13 Oct 2026 12:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791894605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cFheiXYtfEekRBAhIA+Nz/nS7Q4aVob7Ow/4nCSrKgo=;
	b=EMbC6/CvMjxydx1OJbLFS2pv32Jll3CdsAaJJ86df97L9TisOUWOBOpfKdmLOkupI/GxBK
	ZC1vz8+xcJRUH2xdhX+WwZQBsHGALHr3dYLYgIN01PlK65DjGuJTvfD+yV3pUcoLZLKVjx
	cAaVU+peVCq+j0uxstliD1k/lj4Dkik=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791894605;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cFheiXYtfEekRBAhIA+Nz/nS7Q4aVob7Ow/4nCSrKgo=;
	b=xG6wX5Y7hYWa5XClLbYlcfvh2aLv73G1F1yiaAiFFl0BF/UCKzIDfVQtALe/s30AHFt+FI
	HQrwsDiLsXT6HSBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="EMbC6/Cv";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xG6wX5Y7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791894605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cFheiXYtfEekRBAhIA+Nz/nS7Q4aVob7Ow/4nCSrKgo=;
	b=EMbC6/CvMjxydx1OJbLFS2pv32Jll3CdsAaJJ86df97L9TisOUWOBOpfKdmLOkupI/GxBK
	ZC1vz8+xcJRUH2xdhX+WwZQBsHGALHr3dYLYgIN01PlK65DjGuJTvfD+yV3pUcoLZLKVjx
	cAaVU+peVCq+j0uxstliD1k/lj4Dkik=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791894605;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cFheiXYtfEekRBAhIA+Nz/nS7Q4aVob7Ow/4nCSrKgo=;
	b=xG6wX5Y7hYWa5XClLbYlcfvh2aLv73G1F1yiaAiFFl0BF/UCKzIDfVQtALe/s30AHFt+FI
	HQrwsDiLsXT6HSBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F214D13341;
	Tue, 13 Oct 2026 12:30:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sSKJMkwkzmpdMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 13 Oct 2026 12:30:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 900B9A1407; Tue, 13 Oct 2026 14:30:00 +0200 (CEST)
Date: Tue, 13 Oct 2026 14:30:00 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	John Garry <john.garry@linux.dev>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/3] ext4: don't advertise atomic writes for DAX
 inodes
Message-ID: <pycrveoklzarjr7lx7g34dpaijaoicud2qgv32xvhdqaboybnz@yafkgkmdyydl>
References: <20261012-ext4-atomic-no-fallback-v2-0-c4b30c60e500@columbia.edu>
 <20261012-ext4-atomic-no-fallback-v2-3-c4b30c60e500@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-ext4-atomic-no-fallback-v2-3-c4b30c60e500@columbia.edu>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 29A6B1F38E
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,lst.de,linux.dev,kernel.org,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:email,suse.cz:dkim,columbia.edu:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Flag: NO
X-Spam-Score: -2.51

On Mon 12-10-26 13:17:42, Tal Zussman wrote:
> ext4_file_write_iter() hands DAX inodes to ext4_dax_write_iter() before
> any of the atomic write handling, and the DAX path neither checks
> IOCB_ATOMIC nor provides torn-write protection.
> ext4_inode_can_atomic_write() doesn't exclude DAX inodes, so on a device
> that supported both DAX and atomic writes, statx() would advertise
> atomic writes for such an inode and the VFS would let an RWF_ATOMIC
> write through to a plain DAX write.
> 
> No DAX-capable block device advertises atomic write limits today, so
> this isn't reachable. When XFS gained its corresponding check, Ritesh
> Harjani suggested excluding DAX inodes in ext4 anyway [1], so that what
> is advertised matches what the write path can do. XFS does the same in
> xfs_inode_can_hw_atomic_write() and xfs_inode_can_sw_atomic_write().
> 
> Link: https://lore.kernel.org/linux-ext4/87a54e4cdn.fsf@gmail.com/ [1]
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 5115f067a9f5..1520baf581b6 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -4060,12 +4060,13 @@ static inline int ext4_buffer_uptodate(struct buffer_head *bh)
>  /*
>   * Atomic writes are only supported through direct I/O, so an inode that
>   * can't do direct I/O at all (journaled data, inline data, verity) can't do
> - * atomic writes either.
> + * atomic writes either. DAX inodes bypass the direct I/O path entirely.
>   */
>  static inline bool ext4_inode_can_atomic_write(struct inode *inode)
>  {
>  
>  	return S_ISREG(inode->i_mode) &&
> +		!IS_DAX(inode) &&
>  		ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
>  		EXT4_SB(inode->i_sb)->s_awu_min > 0 &&
>  		ext4_dio_alignment(inode) != 0;
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
