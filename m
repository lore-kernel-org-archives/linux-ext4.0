Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA23474247;
	Tue, 18 Aug 2026 14:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787062271; cv=none; b=RqnkHrM+8Wchf3oEredpCuxOkPSQFEBia2Pg6GYf44RSy07BwiMrMatq+pGLRJ98jfLqx0lv+El4pUu4qbFwL8qgseKJN+ZXaC06r0ecG1MxqmdmDjcCgntWFv3qpRTsCueS17FKfrTY4iEvlbu43RUwwD0ICQZ6ytGJFMTQwGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787062271; c=relaxed/simple;
	bh=wBahHeg+lDLO+AV3x7Z3I6jGYfvyAMcgBn6vJxK/uO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kkQyllbJaMksmASdaHmp72ydWkb6b6Bk3rz0bp27N7vP5hWkUCjfBDvc9sbVCIB9Ve3HhocXyr+Sf1WRuNF/jJedgxhcHeUGW8PUoHvFtWSatuGB+nMB+qAyOOWrp0owOoCZrbrHn7IZ1UimCusdRKyik1fhtuGNaE/wEx/CeVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Jn+mwgva; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DvSH/740; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Bigxi8r5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YDWhbXqV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jn+mwgva";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DvSH/740";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Bigxi8r5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YDWhbXqV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8D2EF845CB;
	Tue, 18 Aug 2026 14:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787062263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bBd8ZOyP4NMTDqED4J5h3OTsh0RMWI78apSdiwygb+4=;
	b=Jn+mwgvaUEGH2by31n4mWHnyS4y1+AwZbiei2R/QqbET2/F3bRXY0WwwkmlNB/h1QFbH8O
	GvFsMyZYpnxE5Q/6bh5ajo/0FoXE3ARkSfodOLCM2W6u6wQpT2Xsq0q1I5dkMCjesCEfqq
	IyW+u+tbT4A/k2TR+yvC1FTAywy8CwY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787062263;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bBd8ZOyP4NMTDqED4J5h3OTsh0RMWI78apSdiwygb+4=;
	b=DvSH/740Y68PaNk9orzIDMFSNoqAUsZFEveveeLb+Z0cNOD3SLUzEGR3R7sb8o4aeKfUC0
	y2rQU/pG7Qgi6JAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787062259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bBd8ZOyP4NMTDqED4J5h3OTsh0RMWI78apSdiwygb+4=;
	b=Bigxi8r5RGU6gWWnd8AeyLfYnYh+QFeqJIUJU0RNRWdAXv+R4F5O0kbMYzGCwx7IcKUtt0
	aUq3cy15IcmI/gVvsUxTv0tutP32gJcm61jPxGXX25NxBakBUWfCma2EjbmjdqW3mpUWql
	cKSVhWC7AtdeREHEVFYC7FDbWOIei7I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787062259;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bBd8ZOyP4NMTDqED4J5h3OTsh0RMWI78apSdiwygb+4=;
	b=YDWhbXqVTMrnRNU6GCl4yT3NiZ3U142u20H6qnUUgvFG2Z/zAfl3B7dA59Cjzyi87fuKZ7
	3YCpKTvRdpPXRDCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8488D339C;
	Tue, 18 Aug 2026 14:10:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7NRbIPNnhGqcbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 18 Aug 2026 14:10:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 49170A13AB; Tue, 18 Aug 2026 16:10:59 +0200 (CEST)
Date: Tue, 18 Aug 2026 16:10:59 +0200
From: Jan Kara <jack@suse.cz>
To: Hsiu-Hsien Lee <swinds24@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, harshadshirwadkar@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix fast commit replay failing on a read-only mount
Message-ID: <nhu74zexptuaeywzhef3zs5wkfkrnllz4d2kcyebrgircwogm3@yqsm6h5kbdjl>
References: <20260812044353.1018268-1-swinds24@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812044353.1018268-1-swinds24@gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Wed 12-08-26 12:43:53, Hsiu-Hsien Lee wrote:
> A filesystem with fast_commit that needs recovery cannot be mounted
> read-only:
> 
>   EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
>   EXT4-fs (dm-0): write access will be enabled during recovery
>   WARNING: CPU: 22 PID: 5544 at fs/ext4/ext4_jbd2.c:73
>    ext4_journal_check_start
>    __ext4_journal_start_sb
>    __ext4_unlink
>    ext4_fc_replay
>    do_one_pass
>    jbd2_journal_recover
>    jbd2_journal_load
>    __ext4_fill_super
>   JBD2: journal recovery failed
>   EXT4-fs (dm-0): error loading journal
> 
> Fast commit replay runs ext4 metadata operations instead of writing
> blocks through the buffer cache: ext4_fc_replay_{unlink,link,create}()
> reach __ext4_unlink() and __ext4_link(), which start a handle.
> ext4_journal_check_start() returns -EROFS on a read-only sb, and as
> that is not -ENOENT it propagates out of jbd2_journal_recover() and
> kills the whole recovery.  The EXT4_FC_REPLAY check that would hand
> out a no-journal handle sits after the sb_rdonly() test, so replay can
> never complete read-only.
> 
> ext4_load_journal() has already promised that write access will be
> enabled during recovery, so make that true for the superblock as well:
> clear SB_RDONLY across jbd2_journal_load() when recovery is needed on a
> read-only mount and the devices are writable, as ext4_orphan_cleanup()
> does.  Unlike ext4_handle_error(), which avoids SB_RDONLY because it
> would need s_umount, the sb here is still inside ext4_fill_super() and
> not published, so nothing can observe it.
> 
> The failure is not clean either: the replay handlers passing a NULL
> handle (ext4_fc_replay_inode(), _add_range(), _del_range()) never hit
> ext4_journal_check_start() and do write, leaving a partially applied
> fast commit behind.
> 
> Reproducer, where the unlink only ever reaches the fast commit area:
> 
>   mke2fs -q -F -t ext4 -O fast_commit -b 4096 /dev/sdb3 262144
>   mount /dev/sdb3 /mnt
>   dd if=/dev/zero of=/mnt/victim bs=4k count=1 conv=fsync
>   sync                          # victim now in a full commit
>   rm /mnt/victim
>   dd if=/dev/zero of=/mnt/trigger bs=4k count=1 conv=fsync
>   <crash, or snapshot the device while mounted and write it back>
>   mount -o ro /dev/sdb3 /mnt
> 
> Without this patch that mount fails; with it recovery completes and
> victim is gone, i.e. the UNLINK record was really replayed.
> 
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>

Looks sensible to me and I'm surprised nobody tripped over this earlier.
Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 245f67d10ded..6c2b275a9cf3 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -6096,6 +6096,7 @@ static int ext4_load_journal(struct super_block *sb,
>  	int err = 0;
>  	int really_read_only;
>  	int journal_dev_ro;
> +	bool enable_write = false;
>  
>  	if (WARN_ON_ONCE(!ext4_has_feature_journal(sb)))
>  		return -EFSCORRUPTED;
> @@ -6152,6 +6153,7 @@ static int ext4_load_journal(struct super_block *sb,
>  			}
>  			ext4_msg(sb, KERN_INFO, "write access will "
>  			       "be enabled during recovery");
> +			enable_write = true;
>  		}
>  	}
>  
> @@ -6168,7 +6170,19 @@ static int ext4_load_journal(struct super_block *sb,
>  		if (save)
>  			memcpy(save, ((char *) es) +
>  			       EXT4_S_ERR_START, EXT4_S_ERR_LEN);
> +		/*
> +		 * Fast commit replay performs regular ext4 metadata updates
> +		 * (see ext4_fc_replay()) which refuse to run on a read-only
> +		 * superblock.  We promised write access above, so make that
> +		 * true for the duration of the recovery, the same way
> +		 * ext4_orphan_cleanup() does.  The superblock is not published
> +		 * yet, so nothing can observe the transient state.
> +		 */
> +		if (enable_write)
> +			sb->s_flags &= ~SB_RDONLY;
>  		err = jbd2_journal_load(journal);
> +		if (enable_write)
> +			sb->s_flags |= SB_RDONLY;
>  		if (save && memcmp(((char *) es) + EXT4_S_ERR_START,
>  				   save, EXT4_S_ERR_LEN)) {
>  			memcpy(((char *) es) + EXT4_S_ERR_START,
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
