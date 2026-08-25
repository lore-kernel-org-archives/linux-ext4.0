Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED16B3B6C14;
	Wed, 26 Aug 2026 08:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731241; cv=none; b=JOXfIsGiJ3GJe7NTafA6ZuV6WZ3pzUuJAXaTwq0scU0dHc7NcB4cI80FeJH7EHP4Xlv6Ub1B5M72UevDI0uzlz4LfeNqRdhH3/ZDoPs8+adwf6316ucyyl9+qppUVoqM1zuXn3qq/kXhssNoGrAQBFMUaLCySOBCI8OMoOyiT6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731241; c=relaxed/simple;
	bh=Qp0Vj92odwdENK+fWpXmAERunFp8s2H7T1UtWppUOS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G5uj/O92BpJb0KoNejIhDijd3UJznn1wSyKQsbaXMQJyg7SXw4YEnSp2nOgeNRLXHVcSuXr/rd7cDPLDqFEjXsWM814o/9ow0T+9kWW2MGHuyig/gtiGm4utyNz2XE39psYZAe6KJN7n1raJ7nc+qktw43gCy6jgEkbsEj0GDpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hvERCVCM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jXsFWpW2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zrcBzr6J; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PJ57PYGm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hvERCVCM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jXsFWpW2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zrcBzr6J";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PJ57PYGm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C8D21F807;
	Wed, 26 Aug 2026 07:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ycaVSgnTbMJUGCPWb+mFMNRamCuOCZYnVBbyN312OMc=;
	b=hvERCVCMf6jcmO1skCEVkkMLjwY5u2sO3OknhmuQu+ZqSFA/EALLVdik7P0BDOJfuBruNO
	Xf8n69fTjf26Kr12iV9m0R+fS84K8v2JtHiF6D+mi5qtYoUm4CrQS5y6OgWTo0svIkTeij
	upIw3XL+ExOde8KbG5TaAJcKxXLNVyk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ycaVSgnTbMJUGCPWb+mFMNRamCuOCZYnVBbyN312OMc=;
	b=jXsFWpW294GA/l7MpT5ypqxhibNoT5ndV5CpoJ5KiKcsdey6BdSWLhMkNxJu3WYuSbhUOh
	GOUNGN5rq4lxDRAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zrcBzr6J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PJ57PYGm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ycaVSgnTbMJUGCPWb+mFMNRamCuOCZYnVBbyN312OMc=;
	b=zrcBzr6JLdsiYgF+TtwkqfJf62osZT8F/N1udFOmzismVLFNTFtOg10mvkyYRowp4k4vIx
	4i4JujAEF9OP0x9q2OH1HsOTq3tBTl/55UrzW0IYs4h1+qpv9B/aQ1dJyVcuaJXGmUjsZr
	cRe3oYR1vFSCMOBGhIx9Q2RxpN0qJKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ycaVSgnTbMJUGCPWb+mFMNRamCuOCZYnVBbyN312OMc=;
	b=PJ57PYGmfWAwkRjy+fZEPfu/WyooOr8iupB671ni18sW9hYfH7ghFxMFrBhcKGTJ15j9Bw
	XuEPqd/ukzepcfDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 970451368A;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1A7dJKOajmoKDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4B241A13B6; Tue, 25 Aug 2026 19:06:50 +0200 (CEST)
Date: Tue, 25 Aug 2026 19:06:50 +0200
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
Subject: Re: [PATCH v2 16/21] gfs2: check for a metadata write error with
 buffer_write_io_error()
Message-ID: <va2zqnkuvzoj3y4bqft2nj6ul2diw36huhhgna4hgxqqdwksvl@diz4rmm3nbz2>
References: <cover.1785951556.git.coshi036@gmail.com>
 <a09b6d08d31d24f69b833e4d855ed88875e87780.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a09b6d08d31d24f69b833e4d855ed88875e87780.1785951556.git.coshi036@gmail.com>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7C8D21F807
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
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,fiu.edu:email,suse.cz:email,suse.cz:dkim,suse.com:email];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Thu 06-08-26 12:58:39, Chao Shi wrote:
> gfs2_ail1_start_one() and gfs2_ail1_empty_one() decide whether a buffer on
> the ail reached the disk by looking at BH_Uptodate once it is no longer
> busy.  That relies on the write completion handler clearing BH_Uptodate on
> error, which this series removes: a buffer whose write failed still holds
> the data the filesystem asked to be written, so declaring it not up to date
> is wrong and makes callers re-read it.  Test BH_Write_EIO instead.  In
> gfs2_ail1_start_one() the test is the positive one, so the sense has to be
> inverted rather than the flag simply swapped.
> 
> This is not a pure conversion for gfs2, because gfs2 already has a private
> write completion handler that behaves the way this series is heading:
> gfs2_end_log_write_bh() calls mark_buffer_write_io_error() and leaves
> BH_Uptodate alone.  Buffers completed through it are therefore invisible to
> both tests today, and start being caught once they look at BH_Write_EIO.
> That is a real behaviour change, and it is the one gfs2 wanted: a failed
> log write now withdraws the filesystem instead of passing silently.
> 
> gfs2_pin() is a different case and gets a different treatment.  Its
> !buffer_uptodate() test is not only a proxy for a failed write - a buffer
> with no valid contents at all is equally a reason to withdraw before
> pinning it into a transaction - so the write error test is added to it
> rather than replacing it.
> 
> Left alone deliberately: the BUG_ON(!buffer_uptodate(bh)) in gfs2_unpin()
> and the two WARN_ON()s in fs/gfs2/rgrp.c.  After this series they simply
> stop firing for write errors, which is correct; turning them into
> BUG_ON(buffer_write_io_error(bh)) would newly panic on an I/O error.
> 
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

It would be good to get ack from GFS2 developers here but the changes look
good to me so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/gfs2/log.c  | 4 ++--
>  fs/gfs2/lops.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
> index 78bba8cc10b8..e3e0dcb1f567 100644
> --- a/fs/gfs2/log.c
> +++ b/fs/gfs2/log.c
> @@ -107,7 +107,7 @@ __acquires(&sdp->sd_ail_lock)
>  		gfs2_assert(sdp, bd->bd_tr == tr);
>  
>  		if (!buffer_busy(bh)) {
> -			if (buffer_uptodate(bh)) {
> +			if (!buffer_write_io_error(bh)) {
>  				list_move(&bd->bd_ail_st_list,
>  					  &tr->tr_ail2_list);
>  				continue;
> @@ -321,7 +321,7 @@ static int gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_trans *tr,
>  			active_count++;
>  			continue;
>  		}
> -		if (!buffer_uptodate(bh) &&
> +		if (buffer_write_io_error(bh) &&
>  		    !cmpxchg(&sdp->sd_log_error, 0, -EIO))
>  			gfs2_io_error_bh(sdp, bh);
>  		/*
> diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> index 6dabe73ad790..3df6e4b7e8b9 100644
> --- a/fs/gfs2/lops.c
> +++ b/fs/gfs2/lops.c
> @@ -48,7 +48,7 @@ void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
>  	clear_buffer_dirty(bh);
>  	if (test_set_buffer_pinned(bh))
>  		gfs2_assert_withdraw(sdp, 0);
> -	if (!buffer_uptodate(bh))
> +	if (!buffer_uptodate(bh) || buffer_write_io_error(bh))
>  		gfs2_io_error_bh(sdp, bh);
>  	bd = bh->b_private;
>  	/* If this buffer is in the AIL and it has already been written
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
