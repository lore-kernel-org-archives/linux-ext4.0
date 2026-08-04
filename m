Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BD542AF88
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 08:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832917; cv=none; b=hf7StA56wftN+OAkg24nxpjerDbmTGAPauPiMzK125nR15xQzMA2G6JwJcby/NiRTdR/lMqj0frLyBFLF1IAE1POYzOx0za5fYwqJclua5p2Aq7TzB6t+fu4RD7huHRNKRENg5lrakOB18TRrX11zON0nSWSvv7IKTAt3fnolAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832917; c=relaxed/simple;
	bh=bFSAYy/oaifJtX7m4K+IeSWx7+WkZiaau1jo18/dbgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RTi+g8uiQyu/t8NFV/qC5T2CFUNfWrsiKhRZWlULGS8b0IpyFFfrDgnAAaqiwf5vyRbrrURjYNUWCYrw9XqYcVbcOHORh76bcbxkI3o7cgNkARGRWmfvbrtDBynHSOOH7Lrt/6tNEUYU1Gt+QtOiAuqgv2TtXDHIpSI7T6AvffQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oVuvEpDl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=G7AQY/iz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kFy6nv1l; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DPxK6l3y; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oVuvEpDl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="G7AQY/iz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kFy6nv1l";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DPxK6l3y"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 673283FDF;
	Tue,  4 Aug 2026 08:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LYKJ3oUuPGlRYDnnLsTq9ZIen3jJn66luBqyVQf2NWE=;
	b=oVuvEpDl6vd0Q3dxfHYWDAhKJqkBaFUaT24fvT0DsZBJMb431NI7Ga7I/n687i2n+q2sUl
	vyHB4VeOrG515xN82VDDrsLhQw6QXeCjiFNVod5WKKmrJZ36Mbz52hthPUk4YfDXy/M17u
	nf3TfFLxIEmr0fTFlcGd34QLfcgZmKc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832908;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LYKJ3oUuPGlRYDnnLsTq9ZIen3jJn66luBqyVQf2NWE=;
	b=G7AQY/iz6QfCRNGbDyZXXmNnpEHRGusO0ahkGZuZU+ShcjidavJJPN1VMVmIS5yEpUuySQ
	Cwriez8VlLqYWyCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kFy6nv1l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DPxK6l3y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LYKJ3oUuPGlRYDnnLsTq9ZIen3jJn66luBqyVQf2NWE=;
	b=kFy6nv1lGbUJsqS+BqSKpo+1tpbeCeZat/7w9EFMQVDbwANYze8B6TVbkx02Dw/NZk+G35
	D5JhFGMJMEYAn4uFvTdti9lOCyLVhx5LQ7W+zXO6tvd/44ovKLnxc9UANvrmGkFHfRqfvD
	xO9gABpUbmMJ2B4en94fX4s1GKrVgQo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LYKJ3oUuPGlRYDnnLsTq9ZIen3jJn66luBqyVQf2NWE=;
	b=DPxK6l3yR8GcNt+rk+dvUp/RW4oDTtAlwruhQCL03wfhkHV+CY7k5QvzJ4hizyGxcPq9eU
	ciDheKkIa78FICBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DA8D779BB;
	Tue,  4 Aug 2026 08:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vb/bFsilcWrVZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 08:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1FD76A13A6; Tue, 04 Aug 2026 10:41:40 +0200 (CEST)
Date: Tue, 4 Aug 2026 10:41:40 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/19] ext4: check for a metadata write error with
 buffer_write_io_error()
Message-ID: <qyfwaoic3qwf6275cp7pvoqlxl6ntxpao23pbaybaqkoi7btjy@drlqk7hxcjsy>
References: <cover.1785621505.git.coshi036@gmail.com>
 <844d01d43111830a299346d0f3c6fddd62f22cc4.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <844d01d43111830a299346d0f3c6fddd62f22cc4.1785621505.git.coshi036@gmail.com>
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
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 673283FDF
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Sat 01-08-26 18:00:56, Chao Shi wrote:
> Two places detect a failed metadata write by testing !buffer_uptodate()
> after waiting for it.  That relies on the write completion handler clearing
> BH_Uptodate on error, which this series removes: a buffer whose write
> failed still holds the data the filesystem asked to be written, so
> declaring it not up to date is wrong and makes callers re-read it.
> 
> ext4 already does this correctly for the superblock - see
> ext4_commit_super(), which tests buffer_write_io_error() - so this brings
> the other two into line.
> 
> In __ext4_handle_dirty_metadata() the old test also required BH_Req.
> BH_Write_EIO implies it, so the pair collapses into one test.  The new test
> is also strictly stronger than consuming sync_dirty_buffer()'s return
> value, because it still fires when the buffer was written by background
> writeback and that write hit an error, which sync_dirty_buffer() does not
> report.
> 
> Note that BH_Write_EIO stays set until the buffer is written again,
> forgotten or invalidated, so an unrepaired itable block now reports on
> every subsequent sync of that inode rather than only on the write that
> failed.  That is the intended behaviour and matches what ocfs2 has always
> done with this flag.
> 
> No behaviour change today - a failed write sets BH_Write_EIO and clears
> BH_Uptodate together.  It stops being a no-op at the end of the series,
> where the new test is the one that still works.
> 
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4_jbd2.c | 2 +-
>  fs/ext4/mmp.c       | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 02b066299164..f338d6e3c29f 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -413,7 +413,7 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
>  		}
>  		if (inode && inode_needs_sync(inode)) {
>  			sync_dirty_buffer(bh);
> -			if (buffer_req(bh) && !buffer_uptodate(bh)) {
> +			if (buffer_write_io_error(bh)) {
>  				ext4_error_inode_err(inode, where, line,
>  						     bh->b_blocknr, EIO,
>  					"IO error syncing itable block");
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index 7ce361484b38..4b18ddef468d 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -49,7 +49,7 @@ static int write_mmp_block_thawed(struct super_block *sb,
>  	bh_submit(bh, REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO,
>  			bh_end_write);
>  	wait_on_buffer(bh);
> -	if (unlikely(!buffer_uptodate(bh)))
> +	if (unlikely(buffer_write_io_error(bh)))
>  		return -EIO;
>  	return 0;
>  }
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
