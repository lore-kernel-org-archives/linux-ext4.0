Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954A8367B68
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 12:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006733; cv=none; b=Y0/LBaQ2+YSTuW+dLh+34RDZBK7twuszUncVhSEh7zchcb2BZXtWNa6m+NVb//E8gRk+il9MiquMamj5rOX6N+ELzr2UQ3ihImRIJxdiUdZbaBFT3xqV7+W+7H0n3cVRyHfLR7Ek7AMMofrbi1qB2vup/QfkbLRA7/k5mPyx/sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006733; c=relaxed/simple;
	bh=NDMDECnEMHQJnwOn42pvFCuaLnZFAQBRUkCdxyMv2tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCbdB6zl4ZHNCFiL1zkU7Y75vwr/DZJB3DN9Y1k2Rkwo1SDKZp9bWU2kuLmCapZxYbYha2wQx7rxGLOojjlr/k+dok3RIp8xlgXEGhbE4YvnaiwXfd6N9quMEW2mZv7R7nQBCwj+7DBQ6AOEJKBimmFr+fDYmDd/um6MZvU64Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pSaEEy71; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AUgmz6J2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pSaEEy71; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AUgmz6J2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pSaEEy71";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AUgmz6J2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pSaEEy71";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AUgmz6J2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD0156A8E3;
	Tue,  9 Jun 2026 12:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781006728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vLRxjN95yQq7oZl/4ThURZwIi1IQrq1/4jsCLeZ5fi0=;
	b=pSaEEy717Q7mFTRSRZen5CWBbBvHRUluj7Fpzmu52m0SYqcxKdj6lZ/Tc65g9hvsOyz2gy
	lfKlmEnwgn4lUsou1ukk0mSbwwcAd/cU2QqJZ8hlELcHmdx5SHQVP64htokyA/l1SqMrWM
	4jANV5vL+xsJBTUFrxt4VzrjQszSk6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781006728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vLRxjN95yQq7oZl/4ThURZwIi1IQrq1/4jsCLeZ5fi0=;
	b=AUgmz6J2QnlPEDzMqweA4FZEcgy0AmEf5cIOGufmAa7VCue8MeQ9w7awKHNTdUzKeJ45H0
	y3zYGx1xAfHqQFBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pSaEEy71;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AUgmz6J2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781006728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vLRxjN95yQq7oZl/4ThURZwIi1IQrq1/4jsCLeZ5fi0=;
	b=pSaEEy717Q7mFTRSRZen5CWBbBvHRUluj7Fpzmu52m0SYqcxKdj6lZ/Tc65g9hvsOyz2gy
	lfKlmEnwgn4lUsou1ukk0mSbwwcAd/cU2QqJZ8hlELcHmdx5SHQVP64htokyA/l1SqMrWM
	4jANV5vL+xsJBTUFrxt4VzrjQszSk6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781006728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vLRxjN95yQq7oZl/4ThURZwIi1IQrq1/4jsCLeZ5fi0=;
	b=AUgmz6J2QnlPEDzMqweA4FZEcgy0AmEf5cIOGufmAa7VCue8MeQ9w7awKHNTdUzKeJ45H0
	y3zYGx1xAfHqQFBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE281779A7;
	Tue,  9 Jun 2026 12:05:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /Ql3KogBKGpYQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 12:05:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 19839A0A90; Tue, 09 Jun 2026 14:05:20 +0200 (CEST)
Date: Tue, 9 Jun 2026 14:05:20 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, ebiggers@google.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix circular lock dependency in ext4_ext_migrate
Message-ID: <lr2gyeoay4eai2nujk3siaq7wnqwg3t46an6sipqkmhxarvcrb@tqxhmnstmwnv>
References: <20260609084007.3432061-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609084007.3432061-1-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,syzkaller.appspot.com:url,suse.com:email];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,google.com,vger.kernel.org];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BD0156A8E3
X-Spam-Score: -2.51

On Tue 09-06-26 16:40:07, Yun Zhou wrote:
> Move iput(tmp_inode) after ext4_writepages_up_write() to avoid a
> circular lock dependency between s_writepages_rwsem and sb_internal
> (freeze protection).
> 
> The deadlock scenario:
> 
>   CPU0 (EXT4_IOC_MIGRATE)        CPU1 (orphan cleanup during mount)
>   ----                           ----
>   ext4_ext_migrate()
>     ext4_writepages_down_write()
>       s_writepages_rwsem (write)
>                                  ext4_evict_inode()
>                                    sb_start_intwrite()   [sb_internal]
>                                    ...
>                                      ext4_writepages()
>                                        s_writepages_rwsem (read) [BLOCKED]
>     iput(tmp_inode)
>       ext4_evict_inode()
>         sb_start_intwrite()         [BLOCKED]
> 
> The tmp_inode is a temporary inode with nlink=0 created solely for
> building the extent tree.  Its eviction does not require
> s_writepages_rwsem protection, so deferring iput() until after
> releasing the rwsem is safe.
> 
> Reported-by: syzbot+f0b58a1f5075a90dd9a5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f0b58a1f5075a90dd9a5
> Fixes: cb85f4d23f79 ("ext4: fix race between writepages and enabling EXT4_EXTENTS_FL")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just one nit below:

> @@ -591,9 +592,10 @@ int ext4_ext_migrate(struct inode *inode)
>  	ext4_journal_stop(handle);
>  out_tmp_inode:
>  	unlock_new_inode(tmp_inode);
> -	iput(tmp_inode);
>  out_unlock:
>  	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
> +	if (tmp_inode)
> +		iput(tmp_inode);

iput(NULL) is properly handled so you don't need the if (tmp_inode) check
here.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
