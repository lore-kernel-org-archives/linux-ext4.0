Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FACF43BDB5
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 08:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832178; cv=none; b=XgmpVs3s0C9SQD0T2WYooYKdIIOfJ7s3yBG4yJ0+r23Aeow3Q2qwnqM+lZ5uexEBC7f841Cg9PmE2cHMF/gMaybINVGYquBhO7gryePR0K5dW4DQw2OWUccPx0tAwk/V5oqxOsyEm/CS3MFjPiriEL2/Y7xc+mWp/UWKhzNyAFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832178; c=relaxed/simple;
	bh=li0mPiP5jSel2smDxeP0/yhcndj28RB3VEVyqpPIp5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NbUHZ7NQXGYjF7+XwYqOb5SoMYs4/93ch45CJMszz3FnUwzWSz2rLeY1bxBGilhQ3r4fjRbSFKjOS0dmQRjlteo5ti4zAfnUpyvYtrSvaXFBP1DfXOYUjUi6ocjSosr8N+Bdx+zBJqTyzGsXy5OO2VPqWCVX1G/e0jguEykvN1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VrgVwMa+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=owb+lMAh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fQhssfzI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DN87QZvP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VrgVwMa+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="owb+lMAh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fQhssfzI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DN87QZvP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 68C893F9F;
	Tue,  4 Aug 2026 08:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4kW1ZbMZxaMBxrsgQYny6WFKFMCYMnwV8fM8XWySyb0=;
	b=VrgVwMa+LEIn0lbXa96WFl6PW/ahuGNOaTtnd74RodTgCnN7CEzaWNV3LAbBk6hQYBdQyW
	9+DoTWNT+WxH8MP4LXGOQlX1YUPT6XDLOACTE135R2gqH6RZQ976ht5MajmlzaYPMK/7l/
	B3fFX3EIUjqi+aTaJXyd5Ec6zCo71Ug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832170;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4kW1ZbMZxaMBxrsgQYny6WFKFMCYMnwV8fM8XWySyb0=;
	b=owb+lMAh4n7L89yeWUZKCni6S9PIrVzssYDmhX4iXyLa5yVxxar1aA3f603Zq2f7JyHkdW
	nlWeVea2ARQ9vpDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fQhssfzI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DN87QZvP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4kW1ZbMZxaMBxrsgQYny6WFKFMCYMnwV8fM8XWySyb0=;
	b=fQhssfzInhPOpXYs6INjuIWhklizCi6SJwIasTNEiU1Mrt/XnBiw6glnmhMTYrzqc+iYBg
	oJHWp02dSq3lkmQ2omhJBMaIaKiWO/Aa2Zcex4e7Y2MNY2fo1A7FUyn8n3FV0KB5xzfES9
	u6wYqJohdDUkxSQmTIJVovg/FKC4khM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832166;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4kW1ZbMZxaMBxrsgQYny6WFKFMCYMnwV8fM8XWySyb0=;
	b=DN87QZvP9V/DYE5jG1/g9MsescD9+OUtArB4NLFxH/SbwvH+p6Vf8cg5I2t2WjdQMSTDjU
	udlGimfSVhxLxKCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59951779BE;
	Tue,  4 Aug 2026 08:29:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wGLfFeaicWqTWwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 08:29:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 19599A13A6; Tue, 04 Aug 2026 10:29:26 +0200 (CEST)
Date: Tue, 4 Aug 2026 10:29:26 +0200
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
Subject: Re: [PATCH 05/19] buffer: discard BH_Write_EIO along with the rest
 of the buffer state
Message-ID: <pusqbam7lfjtfj7hmo7k5v2jclb3gk7wfi6miqrz2rzpesahsg@4ov6foxet3ez>
References: <cover.1785621505.git.coshi036@gmail.com>
 <cc452f95db52e33ec00270b7e3a3dab892261014.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc452f95db52e33ec00270b7e3a3dab892261014.1785621505.git.coshi036@gmail.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim];
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
	R_RATELIMIT(0.00)[to_ip_from(RLr6u35b1fsnb818ss3au1oekd)];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 68C893F9F
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Sat 01-08-26 18:00:49, Chao Shi wrote:
> discard_buffer() strips the state that describes where a buffer lives and
> what has happened to it, because after an invalidate none of it applies any
> more.  BH_Write_EIO belongs in that set for the same reason: it describes a
> write of the data that is being thrown away.
> 
> Leaving it set means a buffer_head reused for a different block starts life
> carrying somebody else's write error.  Like the bforget() change, this is
> mostly theoretical today and becomes load bearing once the rest of the
> series makes BH_Write_EIO the report of a failed metadata write.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 7889c30d8715..50a63d964815 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1518,7 +1518,7 @@ EXPORT_SYMBOL(folio_set_bh);
>  /* Bits that are cleared during an invalidate */
>  #define BUFFER_FLAGS_DISCARD \
>  	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
> -	 1 << BH_Delay | 1 << BH_Unwritten)
> +	 1 << BH_Delay | 1 << BH_Unwritten | 1 << BH_Write_EIO)
>  
>  static void discard_buffer(struct buffer_head * bh)
>  {
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
