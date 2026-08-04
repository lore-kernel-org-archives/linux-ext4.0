Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDDD42FCDE
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 08:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832250; cv=none; b=ewUyf6/DOvXMeasB+Bvrws0UwqM8qTsKMAgsGf+EgMvgIFVlIdrG43YK3xD24zmNi6197qNjETIU3YJOsJN7XPQfT3Qw/LRpNeK+OZN9RoZXTLdHzjJED4Ql3Vmq96/03VZqhyieTXwiBrjwq1CNZYPYWNX9ZNkb0bj1D0TogEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832250; c=relaxed/simple;
	bh=BZAodzxqGr8NT0DCaEPf5yCHI2d72I9rok0snJ9hm0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIshiFu1g0efa7wod1IBarUK/2hHjR/QOP+aLR1Ybch2TF9kYLKv+vql9BD0Qssg30VkMeHuYKFn1+caQqY8Yh2VJzJcQM67tLH+N/i4C0WsFXiXrq8wCexGaxyIlLWUpjIHK58MAwm0L++cWdclTTGz0rl8uPOBO5q96L6UOn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=t4am838D; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DuacT2RK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yLYRZlAr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0egbMVNS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="t4am838D";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DuacT2RK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yLYRZlAr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0egbMVNS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 63C013FCD;
	Tue,  4 Aug 2026 08:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NVJPcs7KfN8CcWtt6I3ugk75V7aQdGjmtftg23qGGII=;
	b=t4am838DiP+4Vs9jloCPrerdQullfvxJKEWaWKM9yrWp9BzUktEGzu9puCx/WdCnrw4J+0
	z9q1dshor3/5R9V5xKuB4c204U8DJbJJdf1K2eZ2rxbGu1wcu0xv7KWkbrwvvEvU+GuZba
	utl3GVGY2at4vGN7UEus1lEtNkdhg1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NVJPcs7KfN8CcWtt6I3ugk75V7aQdGjmtftg23qGGII=;
	b=DuacT2RKTekOTJdh9YBoPp3GGWiCWyJKoyP38WZil+nlbAaf5APpnKTu187C/K6zwebclB
	QlYXOjQIv9qOzJDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yLYRZlAr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0egbMVNS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832239; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NVJPcs7KfN8CcWtt6I3ugk75V7aQdGjmtftg23qGGII=;
	b=yLYRZlArkK1GD8nVl8dBYl8OechU1jYOjhiEdAM9hKN4VjVb1zW96PMiT+X7IIxagnfN2+
	csHw5/8jI/gK3EnPe1PE9HPDEX3xXqVycZGTk8mz3znALYqzi69Mn8rQ4NbRa04g/XZdsy
	fA9oKWukW5vqrSPnB6f5ilQ3dwgPEWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832239;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NVJPcs7KfN8CcWtt6I3ugk75V7aQdGjmtftg23qGGII=;
	b=0egbMVNSGVw6ndC14jFrN1XEpa4hK/Pw9C8S8Isc63Q/OT7nNeakOhdpYPLreUurjaLAd7
	SRPxZeKX6cRWOxCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A2FB779BB;
	Tue,  4 Aug 2026 08:30:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gz0OFi+jcWoIXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 08:30:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1ADB7A13A6; Tue, 04 Aug 2026 10:30:35 +0200 (CEST)
Date: Tue, 4 Aug 2026 10:30:35 +0200
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
Subject: Re: [PATCH 06/19] buffer: detect metadata write errors with
 buffer_write_io_error()
Message-ID: <dyhdveo63nn34lbburq5zpy5e3w2g5e7zecmbew6w6bh4vvlrc@kvwwrxpmmvwn>
References: <cover.1785621505.git.coshi036@gmail.com>
 <adebc1e3de48c3e997057d10cb78756dec03b800.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adebc1e3de48c3e997057d10cb78756dec03b800.1785621505.git.coshi036@gmail.com>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 63C013FCD
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:email,suse.cz:dkim];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[26];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLr6u35b1fsnb818ss3au1oekd)];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Sat 01-08-26 18:00:50, Chao Shi wrote:
> Both places in this file that report a metadata write error to a caller do
> it by testing !buffer_uptodate() after waiting for the write.  That works
> only because the write completion handlers clear BH_Uptodate when the write
> fails, which is what this series is removing: a buffer whose write failed
> still holds the correct data, and saying otherwise makes callers rewrite,
> re-read or WARN over a buffer that was never wrong.
> 
> BH_Write_EIO is the flag that actually means "the last write of this buffer
> failed", and both handlers already set it via mark_buffer_write_io_error().
> Test that instead.
> 
> No behaviour change: today a failed write through bh_end_write() or
> bh_end_async_write() sets BH_Write_EIO and clears BH_Uptodate together, so
> the two tests agree.  They stop agreeing at the end of the series, and this
> one stays right.
> 
> In __sync_dirty_buffer() the flag also refers unambiguously to the write we
> just issued, because __bh_submit() clears it when it resubmits a buffer for
> write.
> 
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 50a63d964815..ac978d9090c2 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -618,7 +618,7 @@ int mmb_sync(struct mapping_metadata_bhs *mmb)
>  		}
>  		spin_unlock(&mmb->lock);
>  		wait_on_buffer(bh);
> -		if (!buffer_uptodate(bh))
> +		if (buffer_write_io_error(bh))
>  			err = -EIO;
>  		brelse(bh);
>  		spin_lock(&mmb->lock);
> @@ -2743,7 +2743,7 @@ int __sync_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags)
>  
>  		bh_submit(bh, REQ_OP_WRITE | op_flags, bh_end_write);
>  		wait_on_buffer(bh);
> -		if (!buffer_uptodate(bh))
> +		if (buffer_write_io_error(bh))
>  			return -EIO;
>  	} else {
>  		unlock_buffer(bh);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
