Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFC43812EF;
	Wed, 26 Aug 2026 07:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730785; cv=none; b=dWpYrvDGOqUtQJLejKeqSCePPMp1IQp/A58nuSUYyGgkzHzH+CzSrW1p7b1sDKbYKv52Qkstl87ssN9U5CS+eBGIoqqkE/DdtqdN2IOTkm0f55kyRgPbtIng3JmN0GN6KgT1d4v9tmisC4/QFEXDIdx4IzZtpexB2YsZEeR8vNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730785; c=relaxed/simple;
	bh=FjTYdRtQOVSZvP3k9mfbeF5VEB65MGTGOGo2paSeks4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJj07Pgx9GVHBdaU58MbJ1p0FdbfLisei2KAKnmVh8lwNzTJI+J+wyP876rkFY+vbrScEvEhiiYRMFLzErHJtyBa6kdTHNicr6B7DmMzIKUNNL2qc78l+DY7esKnBnoG6QOSO0BPQuieW3bhFkv8+b+TBlNoJCxAFRE57PkUp5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=F/p0BNO6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+Vd7DA/5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eiYfjHeH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DKIU3vZL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="F/p0BNO6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+Vd7DA/5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eiYfjHeH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DKIU3vZL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 61BE31F802;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730599; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7fUo7/vGLGSzCdGeo/VtVxYL2Lc47nS/M6ZtCOZw810=;
	b=F/p0BNO6BuGDhefKbpfu7tzJ3fqyIv4xeubPXgOYtfSYa6FtIvpL+7VeKEn3Xpo9N2Ed+z
	Sl707GCc2X9FU41O8Mu01LmcMZP+o18qldsipHvEX/4s8IAs13SLBtsEDpf5SAAHjs9Jnd
	ZmL3b7pMdHgxZKFTw1rISHyehFfWY9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730599;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7fUo7/vGLGSzCdGeo/VtVxYL2Lc47nS/M6ZtCOZw810=;
	b=+Vd7DA/5C8XLwwYeknWO5C1KytWoqZifhEfg/30q/D5tyd500gsFaLxeFjHlqwotmqb1wg
	LD4BotlsGzrsasDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eiYfjHeH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DKIU3vZL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7fUo7/vGLGSzCdGeo/VtVxYL2Lc47nS/M6ZtCOZw810=;
	b=eiYfjHeHHCFWV/6D+/OUdE7UeHrnqdfURMzbn4wc277IpR7JFbM0wtBlofRvnBLYmQCEvk
	koOPbxkMnAAGhnj4oULFeq0jrvPy91+MBfX6fRI2acQP+yHd+2NRzOqb4iiQIl3Na83I22
	Vdu6TOKU6bJBKC/5yybJe1+k3qqGoBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730595;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7fUo7/vGLGSzCdGeo/VtVxYL2Lc47nS/M6ZtCOZw810=;
	b=DKIU3vZLbApCAy9Ri8gGf1HX75G8zET0KKqUtKtw5MBwtzIBdhPuu+hwHRS1d66T2C3ALk
	ewOCiY4MZO72gOAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52FA113676;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nqo9FKOajmr0CwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7FEA2A13AB; Tue, 25 Aug 2026 18:12:51 +0200 (CEST)
Date: Tue, 25 Aug 2026 18:12:51 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
Subject: Re: [PATCH v2 10/21] omfs: check for an inode write error with
 buffer_write_io_error()
Message-ID: <aawz3yawp64cqwh6vtbkzpjausie2nfuscdqyd4cpstyua24aa@336cfkhw2v7d>
References: <cover.1785951556.git.coshi036@gmail.com>
 <b33ccb12c29ae743ccfa48cdf1e9140fbf2dabcc.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b33ccb12c29ae743ccfa48cdf1e9140fbf2dabcc.1785951556.git.coshi036@gmail.com>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 61BE31F802
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
	URIBL_BLOCKED(0.00)[fiu.edu:email,suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[27];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	R_RATELIMIT(0.00)[to_ip_from(RLr6u35b1fsnb818ss3au1oekd)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Thu 06-08-26 12:58:33, Chao Shi wrote:
> __omfs_write_inode() spots a failed synchronous write, on both the primary
> block and each mirror, by testing BH_Req together with !BH_Uptodate.  That
> relies on the write completion handler clearing BH_Uptodate on error, which
> this series removes: a buffer whose write failed still holds the data the
> filesystem asked to be written, so declaring it not up to date is wrong and
> makes callers re-read it.
> 
> BH_Write_EIO says exactly what this code wants to know, and it implies
> BH_Req, so each pair collapses into one test.
> 
> No behaviour change today - a failed write sets BH_Write_EIO and clears
> BH_Uptodate together.  It stops being a no-op at the end of the series,
> where the new test is the one that still works.
> 
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/omfs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
> index 1d915ef72119..bc37029a4afb 100644
> --- a/fs/omfs/inode.c
> +++ b/fs/omfs/inode.c
> @@ -145,7 +145,7 @@ static int __omfs_write_inode(struct inode *inode, int wait)
>  	mark_buffer_dirty(bh);
>  	if (wait) {
>  		sync_dirty_buffer(bh);
> -		if (buffer_req(bh) && !buffer_uptodate(bh))
> +		if (buffer_write_io_error(bh))
>  			sync_failed = 1;
>  	}
>  
> @@ -159,7 +159,7 @@ static int __omfs_write_inode(struct inode *inode, int wait)
>  		mark_buffer_dirty(bh2);
>  		if (wait) {
>  			sync_dirty_buffer(bh2);
> -			if (buffer_req(bh2) && !buffer_uptodate(bh2))
> +			if (buffer_write_io_error(bh2))
>  				sync_failed = 1;
>  		}
>  		brelse(bh2);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
